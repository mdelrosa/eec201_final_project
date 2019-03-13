%% Pitch Estimation Via Autocorrelation

function [period1, period2, level1, level2] = pitch_via_auto(xin, fs, L, R, window, debug)
% per frame, find top two most likely pitches and their respective
% levels using cepstrum

% Inputs:
% -> xin = input signal
% -> fs = original sampling frequency
% -> imf = choice between male/female speakers
% -> L = frame length
% -> R = frame offset
% -> window = window type
% -> debug = high if we want to plot

% Outputs:
% -> period1 = most likely pitch period
% -> period2 = second most likely pitch period
% -> level1 = most likely pitch level
% -> level2 = second most likely pitch level

% define range of allowable frequencies
period_hi = round(fs/50); 
period_lo = round(fs/500);
% L = 2*period_hi;
    period1=[];
    period2=[];
    level1=[];
    level2=[];

% window and zero-pad
switch window
    case 0
        % uniform window
        frame_win=ones(1,frame_len);
    case 1
        % hamming window
        frame_win=hamming(1,frame_len);
end

n = numel(xin);
for k = 1 : R : n - 1;
    frame_edge=0;
% while (frame_center+L/2 <= x_len)
    range = (k-1)*L + 1 : k*L;
    frame = xin(range);
    
    auto = xcorr(frame, frame);
    
    auto(find(auto < 0)) = 0; % set any negative autocorrelation values to zero
    
    center_peak_width = find(auto(L:end) == 0 ,1); % find the first zero after the center
    
    auto(L - center_peak_width : L + center_peak_width) = min(auto); % suppress the central peak
    
    [max_auto, location] = max(auto); % 2nd peak and its location
    
    period1 = [period1 abs(location - length(frame) + 1)]; 
    
    level1 = [level1 max_auto];
end