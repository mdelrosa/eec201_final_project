function [A_out,G_out,n_f,excite_t] = lpc_analysis(xin,ss,es,fs,L,R,p,window)
    % determine lpc model coeff and gains for each frame
    
    % Inputs:
    % -> xin = input signal
    % -> ss = starting sample
    % -> es = ending sample
    % -> L = length of sample [#]
    % -> R = frame offset [#]
    % -> p = LPC model order
    % -> window = frame window
    
    % Outputs:
    % -> A_out = vector of coeff for lpc model
    % -> G_out = vector of gains for lpc model
    % -> nframes = number of frames
    % -> excite_t = error signal frame
    
    % dc gain of filter
    g_dc = R/sum(window);
    
    %% determine window to be used
    switch window
        case 0
            % uniform window
            window=ones(1,L);
        case 1
            % hamming window
            window=hamming(1,L);
    end
    
    % process file in frames between first and last sample
    A_out=[];
    G_out=[];
    excite_t=[];
    n_f=0;
    n=ss;
    
    while (n+L-1<=es)
        x=xin(n:n+L-1);
        xw=x.*window;
        [A,G,a,r]=lpc_autocor(x,p);
        A_out=[A_out A];
        G_out=[G_out G];
        n=n+R;
        n_f=n_f+1;
        excite_x=filter(A,1,x);
        excite_t=[ excite_t; excite_x(1:R) ];
    end
    
end