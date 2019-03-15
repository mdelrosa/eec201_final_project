%% Using Autocorrelation to track the local period of a signal

%% speech analysis example
global sout; 
ip = sout;
fs = 8000;
max_expected_period = round(1/50*fs);
min_expected_period = round(1/500*fs);
frame_len = 2*max_expected_period;
debug = 0;
 
for k = 1 : length(ip)/frame_len -1;
    range = (k-1)*frame_len + 1:k*frame_len;
    frame = ip(range);
     
    %show the input in blue and the selected frame in red
    
    if(debug)
    plot(ip);
    set(gca, 'xtick',[],'position',[ 0.05  0.82   0.91  0.13])
    hold on;
    end
    temp_sig = ones(size(ip))*NaN;
    temp_sig(range) = frame;
    if(debug)
    plot(temp_sig,'r');
    hold off
    end
     
    %use xcorr to determine the local period of the frame
    [rxx lag] = xcorr(frame, frame);
    if(debug)
    subplot(3,1,3)
    plot(lag, rxx,'r')
    end
    rxx(find(rxx < 0)) = 0; %set any negative correlation values to zero
    center_peak_width = find(rxx(frame_len:end) == 0 ,1); %find first zero after center
    %center of rxx is located at length(frame)+1
    rxx(frame_len-center_peak_width : frame_len+center_peak_width  ) = min(rxx);
    if(debug)
    hold on
    plot(lag, rxx,'g');
    hold off
    end
    [max_val loc] = max(rxx);
    period = abs(loc - length(frame)+1); 
     
    if(debug)
    title(['Period estimate = ' num2str(period) 'samples (' num2str(fs/period) 'Hz)']);
    set(gca, 'position', [ 0.05  0.07    0.91  0.25])
    end
     
    [max_val max_loc] = max(frame);
    num_cycles_in_frame = ceil(frame_len/period);
    test_start_positions = max_loc-(period*[-num_cycles_in_frame:num_cycles_in_frame]);
    index = find(test_start_positions > 0,1, 'last');
    start_position = test_start_positions(index);
    colours = 'rg';
     
    if(debug)
    subplot(3,1,2)
    plot(frame);
     
    set(gca, 'position',[ 0.05 0.47 0.91 0.33])
    pause
    end
    
    for g = 1 : num_cycles_in_frame
        if(start_position+period*(g) <= frame_len && period > min_expected_period)
            cycle_seg = ones(1, frame_len)*NaN;
            cycle_seg(start_position+period*(g-1):start_position+period*(g))  =...
                            frame(start_position+period*(g-1):start_position+period*(g));
                        if(debug)
            hold on
             
            plot(cycle_seg,colours(mod(g, length(colours))+1)) %plot one of the available colors
            hold off
                        end
        end
    end
    if(debug)
    pause
    end
end
 

 
%% Determine the autocorrelation function
if(debug)
[rxx lags] = xcorr(x,x);
figure
plot(lags, rxx)
xlabel('Lag')
ylabel('Correlation Measure')
title('Auto-correlation Function')
end
 


 