%% Pitch Estimation Via Autocorrelation

function [period1, period2, level1, level2] = pitch_via_auto(xin, fs)

period_hi = round(fs/50); 
period_lo = round(fs/500);
frame_len = 2*period_hi;
    period1=[];
    period2=[];
    level1=[];
    level2=[];

n = numel(xin);
for k = 1 : n/frame_len - 1;
    range = (k-1)*frame_len + 1 : k*frame_len;
    frame = xin(range);
    
    auto = xcorr(frame, frame);
    
    auto(find(auto < 0)) = 0; % set any negative autocorrelation values to zero
    
    center_peak_width = find(auto(frame_len:end) == 0 ,1); % find the first zero after the center
    
    auto(frame_len - center_peak_width : frame_len + center_peak_width) = min(auto); % suppress the central peak
    
    [max_auto, location] = max(auto); % 2nd peak and its location
    
    period1 = [period1 abs(location - length(frame) + 1)]; 
    
    level1 = [level1 max_auto];
end