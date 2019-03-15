function [period1,period2,level1,level2]=pitch_detect_candidates(xin,fs,imf,len_fft,L,R,cept_file,window,debug_flag)
    % per frame, find top two most likely pitches and their respective
    % levels using cepstrum
    
    % Inputs:
    % -> xin = input signal
    % -> fs = original sampling frequency
    % -> imf = choice between male/female speakers
    % -> len_fft = length of fft to be used in cepstrum
    % -> L = frame length
    % -> R = frame length
    % -> cept_file = file name for writing cepstrum data 
    % -> window = window type
    % -> debug_flag = high if we want to plot cepstrum
    
    % Outputs:
    % -> period1 = most likely pitch period
    % -> period2 = second most likely pitch period
    % -> level1 = most likely pitch level
    % -> level2 = second most likely pitch level
    
    % threshold for noise
    noise_thresh=0;
    
    % cepstral ranges for male vs female speakers
    [period_lo,period_hi]=pitch_range(imf,fs,0);
    
    % partition input signal based on L and R
    x_len = length(xin);
    frame_center = floor(L/2);
    
    % init candidate vectors
    period1=[];
    period2=[];
    level1=[];
    level2=[];
%     n=period_lo:period_hi;
    while (frame_center+L/2 <= x_len)
       % init frame
       frame=xin(max(frame_center-floor(L/2),1):frame_center+floor(L/2));
       frame_len=length(frame);
       % white noise if frame is 0 
       if max(frame)<=noise_thresh
          frame=randn(frame_len,1)*noise_thresh; 
       end
       % window and zero-pad
       switch window
            case 0
                % uniform window
                frame_win=ones(1,frame_len);
            case 1
                % hamming window
                frame_win=hamming(1,frame_len);
       end
       frame=frame.*frame_win;
       frame(frame_len+1:len_fft)=0;
       % compute real cepstrum
       frame_cep=ifft(log(abs(fft(frame,len_fft))),len_fft);
       % parse cepstrum for peak vals based on period_lo/hi
       subframe_cep=frame_cep(period_lo+1:period_hi+1);
       l1=max(subframe_cep);
       p1_ind=find(subframe_cep==l1,1);
       p1=p1_ind+period_lo-1;
       period1=[period1 p1];
       level1=[level1 l1];
       % parse cepstrum for second peak
       p1_offset=4;
       ignore_s=max(1,p1_ind-p1_offset);
       ignore_e=min(p1_ind+p1_offset,length(subframe_cep));
       subframe_cep2=subframe_cep;
       subframe_cep2(ignore_s:ignore_e)=0;
       l2=max(subframe_cep2);
       p2_ind=find(subframe_cep2==l2,1);
       p2=p2_ind+period_lo-1;
       period2=[period2 p2];
       level2=[level2 l2];
       % shift center of frame
       frame_center=frame_center+R;
       % plot cepstrum
       if debug_flag
        font_size=16;
        title_size=20;
        figure(1);clf;hold on;
        subplot(2,1,1);
        temp=(1:frame_len);
        plot(temp,frame(temp));
        title('Windowed Sample','FontSize',title_size);
        xlabel('Sample #','FontSize',font_size);
        ylabel('w[n]','Interpreter','latex','FontSize',font_size);
        subplot(2,1,2);hold on;
        plot((0:len_fft-1),frame_cep);
        plot((period_lo:period_hi),subframe_cep);
        stem(p1,l1);
        stem(p2,l2);
        title('Cepstrum','FontSize',title_size);
        xlim([period_lo-p1_offset*4 period_hi+p1_offset*4]);
        ylim([-l1*2 l1*2]);
        legend('Cepstrum of Window','Speaker Cepstrum Range','Peak 1','Peak 2');
        xlabel('n','FontSize',font_size);
        ylabel('$$\tilde{x}[n]$$','Interpreter','latex','FontSize',font_size);
      end
    end

end