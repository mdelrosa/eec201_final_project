function [p1m,pitch] = pitch_detector(xin,ss,es,fs,imf,L,R,n_f,window)
   % wrapper function for pitch generation
   
    % Inputs:
    % -> xin = input signal
    % -> ss = starting sample
    % -> es = ending sample
    % -> fs = original sampling freq
    % -> L = length of sample [#]
    % -> R = frame offset [#]
    % -> p = LPC model order
    % -> window = frame window
    
    % Outputs:
    % -> p1m = pitch period at original Fs; use to generate impulses
    % -> pitch = pitch period contour at fsd=8kbit/s
   
    len_fft=4000;
    cept_file='cepstral.mat';
    
    % ceptsrum-based pitch detector
    debug=0;
    [period1,period2,level1,level2]=pitch_detect_candidates(xin,fs,imf,...
                                        len_fft,L,R,cept_file,window,debug);
    debug=0;
    if (debug)
       figure(2);clf;hold on;
       scatter((1:length(level1)),level1);
       scatter((1:length(level2)),level2);
       legend('Level 1', 'Level2');
    end
    % smooth pitch
    pitch_thresh=2.5;
    p_smoothed=pitch_smooth(period1,period2,level1,level2,pitch_thresh);
    p_smoothed_len=length(p_smoothed);
    
    % median pitch
    Lmed=5;
    p1m=med_filt(p_smoothed,Lmed,length(period1));
    debug=1;
    if (debug)
       fprintf('p1m:\n');
       disp(p1m);
    end
    % pitch normalization
    fsd=8000;
    pitch=round(p1m*fsd/fs);
    % zero pad pitch to lpc length
    if (p_smoothed_len < n_f)
       p1m(p_smoothed_len+1:n_f)=0;
    end
end