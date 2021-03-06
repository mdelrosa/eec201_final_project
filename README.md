<!--# eec201_final_project-->
## Presentation
[![Link to final presentation](https://img.youtube.com/vi/_7KegbahrVY/0.jpg)](https://www.youtube.com/watch?v=_7KegbahrVY)

## Final Report
[Link to Final Report](https://github.com/mdelrosa/eec201_final_project/blob/master/Final%20Report%20-%20Kamath%2C%20del%20Rosario.pdf)

## Background
Repository for EEC 201 Winter 2019 **Final Project B**. The goal is to design and implement an LPC vocoder and synthesizer in Matlab with a GUI.
## Team
  - Abhinav Kamath - agkamath(at)ucdavis.edu
  - Mason del Rosario - mdelrosa(at)ucdavis.edu

## Methods

### Analysis: Autocorrelation Method

For a given windowed portion of a speech sample, the sample can be modeled as an LTI system excited by a periodic impulse train. 
> ![sample_eq](https://latex.codecogs.com/gif.latex?y%5Bn%5D%26%3De%5Bn%5D%5Ccircledast%20a_k%5Bn%5D "Decomposition of audio sample portion, y[n], into excitation pulse train, e[n], and LTI system, a_k[n].")

Thus, the main goal in analyzing speech is to determine the transfer function of the LTI system for each windowed sample. The discrete-time transfer function can be modeled as an all-pole IIR filter with the general form seen below.

> ![all_pole](https://latex.codecogs.com/gif.latex?A_k%28z%29%3D%5Cfrac%7B1%7D%7Ba_nz%5En&plus;a_%7Bn-1%7Dz%5E%7Bn-1%7D&plus;%5Cdots&plus;a_1z&plus;a_0%7D "All-pole transfer function used to characterize human speech samples.")

The autocorrelation method fixes the coefficients of the all-pole transfer function's denominator by implementing the the following equation:

> ![autocor_analysis](https://latex.codecogs.com/gif.latex?%5Cbegin%7Balign*%7D%20%5Cmathbf%7Br%7D%28j%29%26%3D%5Csum_%7Bk%3D1%7D%5E%7Bn%7D%5Cmathbf%7Br%7D%28j-k%29a_k%5C%5C%20R%5Cmathbf%7Ba%7D%26%3D%5Cmathbf%7Br%7D%5C%5C%20%5Cmathbf%7Ba%7D%26%3DR%5E%7B-1%7D%5Cmathbf%7Br%7D%20%5Cend%7Balign*%7D "Summary of autocorrelation method of finding coefficients, a_k, for the all-pole transfer function.")

The relevant code which performs this analysis can be found in [`lpc_analysis.m`](https://github.com/mdelrosa/eec201_final_project/blob/master/lpc_analysis.m).

### Synthesis: Excitation Pulse Train

Given the all-pole transfer function above, the main goal in synthesizing an approximation of the original speech sample is to determine the instantaneous pitch of the **excitation pulse train**. In this work, we take two approaches to estimating  pitch: the **cepstrum-based method** and the **autocorrelation method**.

#### Method #1: Cepstrum Pitch Detection

Taking the cepstrum of a sequence allows for determining the period of fundamentals in the sequence. The cepstrum is defined below:

> ![all_pole](https://latex.codecogs.com/gif.latex?%5Ctilde%7Bx%7D%5Bn%5D%3D%5Ctext%7BIFFT%7D%5Cleft%5C%7B%5Clog%7B%5Cleft%28%5Ctext%7BFFT%7D%5Cleft%5C%7Bx%5Bn%5D%5Cright%5C%7D%5Cright%29%7D%5Cright%5C%7D "All-pole transfer function used to characterize human speech samples.")

The relevant code which performs the cepstrum-based pitch detection can be found in [`pitch_detect_candidates.m`](https://github.com/mdelrosa/eec201_final_project/blob/master/pitch_detect_candidates.m).

#### Method #2: Autocorrelation Pitch Detection

The autocorrelation is computed frame-by-frame. For the ACF of a frame, the number of samples between the center peak and the next highest peak is its pitch-period estimate. In order to find the second peak, the central peak is suppressed, as are all negative autocorrelation values. The fundamental-frequency estimate or the pitch estimate is simply the sampling frequency of the audio signal divided by the pitch-period estimate.

> ![autocor_analysis](https://latex.codecogs.com/gif.latex?r_%7Bt%7D%5Cleft%28%20%5Ctau%20%5Cright%29%20%3D%5Csum%20%5E%7Bw-%5Ctau%20%7D_%7Bj%3D1%7Dx_%7Bj%7Dx_%7Bj&plus;%5Ctau%20%7D "Autocorrelation method for pitch detection.")

## Results

>![Comparison between original audio signal, cepstrum-based estimate, and autocorrelation-based estimate.](https://github.com/mdelrosa/eec201_final_project/blob/master/images/pitch_comparison.png)

>![Image of the LPC Synthesizer GUI.](https://github.com/mdelrosa/eec201_final_project/blob/master/images/gui.PNG)

<!--For generating inline latex: https://www.codecogs.com/latex/eqneditor.php-->
<!--For checking markdown files: https://dillinger.io/-->

