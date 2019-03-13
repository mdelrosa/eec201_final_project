# eec201_final_project
## Background
Repository for EEC 201 Winter 2019 **Final Project B**. The goal is to design and implement an LPC vocoder and synthesizer in Matlab with a GUI.
## Team
  - Abhinav Kamath - agkamath(at)ucdavis.edu
  - Mason del Rosario - mdelrosa(at)ucdavis.edu
# Methods

### Analysis: Autocorrelation Method

For a given windowed portion of a speech sample, the sample can be modeled as an LTI system excited by a periodic impulse train. 
> ![sample_eq](https://latex.codecogs.com/gif.latex?y%5Bn%5D%26%3De%5Bn%5D%5Ccircledast%20a_k%5Bn%5D "Decomposition of audio sample portion, y[n], into excitation pulse train, e[n], and LTI system, a_k[n].")

Thus, the main goal in analyzing speech is to determine the transfer function of the LTI system for each windowed sample. The discrete-time transfer function can be modeled as an all-pole IIR filter with the general form seen below.

> ![all_pole](https://latex.codecogs.com/gif.latex?A_k%28z%29%3D%5Cfrac%7B1%7D%7Ba_nz%5En&plus;a_%7Bn-1%7Dz%5E%7Bn-1%7D&plus;%5Cdots&plus;a_1z&plus;a_0%7D "All-pole transfer function used to characterize human speech samples.")

### Synthesis: Cepstrum Method

### Synthesis: Autocorrelation Method

# Results
>![Image of the LPC Synthesizer GUI.](/images/gui.PNG)

<!--For generating inline latex: https://www.codecogs.com/latex/eqneditor.php-->
<!--For checking markdown files: https://dillinger.io/-->