function [s_out]=lpc(xin,fs,ss,es,L_frame,R_frame,p,over_frame,window,fsd)
    % analyze sample and generate synthesized version based on lpc coeff
    
    % Inputs:
    % -> xin = input signal
    % -> fs = signal sampling rate (max 16kbit/s)
    % -> ss = starting sample
    % -> es = ending sample
    % -> L_frame = length of sample [ms]
    % -> R_frame = frame offset [ms]
    % -> p = LPC model order
    % -> over_frame = # overlapping frames in synthesis
    % -> fsd = intermediate sampling frequency (might be redundant)
    
    % convert from time [ms] to samples
    L=floor(L_frame*fs/1000);
    R=floor(R_frame*fs/1000);
    
    %% lpc analysis
    [A_all,G_all,n_f,excite_t]=lpc_analysis(xin,ss,es,fs,L,R,p,window);
    %% Plot original signal
    debug=0;
    if debug
        figure(1);clf;hold on;
        subplot(2,1,1);
        title('Channel 1')
        plot(ss:es,xin(ss:es,1));
        subplot(2,1,2);
        title('Channel 2')
        plot(ss:es,xin(ss:es,2));
    end
    %% generate pitch
    imf=0; % male voice
    imf=1; % female voice
    [p1m,pitch]=pitch_detector(xin(:,1),ss,es,fs,imf,L,R,n_f,window,fsd);
    
    %% plot pitch period contour
    debug=0;
    if debug
        figure(1);clf;hold on;
        plot(1:n_f,p1m(1:n_f),'r');
        xlabel('Frame');
        ylabel('Pitch Period');
    end
    
    %% generate and normalize exciation signal based on pitch
    [exc]=excitation_generator(n_f,R,p1m);
    [exc_b,exc_n,G_n]=excitation_normalizer(exc,R,n_f,G_all);
    debug=0;
    if debug
        figure(1);clf;hold on;
        plot(exc_n,'r');
        xlabel('Sample');
        ylabel('Mag');
    end
    
    %% Synthesize audio
    [s_out]=synthesize_audio(ss,es,L,R,n_f,exc_n,G_all,A_all,p,over_frame,window);
    s_out=normalize_audio(s_out);
    debug=0;
    if debug
        figure(1);clf;hold on;
        subplot(2,1,1);
        plot(xin);
        subplot(2,1,2);
        plot(s_out,'r');
        xlabel('Sample');
        ylabel('Mag');
    end
end
