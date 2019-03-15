%% Pitch Estimation Via Autocorrelation

function [period1, period2, level1, level2] = pitch_via_auto(xin, fs, imf, L, R, window, debug)
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
% period_hi = round(fs/50); 
% period_lo = round(fs/500);
[period_lo,period_hi]=pitch_range(imf,fs,1);
% L = 2*period_hi;
    period1=[];
    period2=[];
    level1=[];
    level2=[];

% window and zero-pad
switch window
    case 0
        % uniform window
        frame_win=ones(1,L);
    case 1
        % hamming window
        frame_win=hamming(1,L);
end

n = numel(xin);
for k = 1 : R : n - L;
    frame_edge=0;
    range = k:k+L;
    frame = xin(range);
    
    auto = xcorr(frame, frame);
    
    auto(find(auto < 0)) = 0; % set any negative autocorrelation values to zero
    
    center_peak_width = find(auto(L:end) == 0 ,1); % find the first zero after the center
    
    auto(L - center_peak_width : L + center_peak_width) = min(auto); % suppress the central peak
    
    [level_temp, location] = max(auto); % 1st peak and its location
    
    period_temp=abs(location - length(frame) + 1);
    period1 = [period1 period_temp]; 
    
    level1 = [level1 level_temp];
    % parse autocor for second peak
    pos_autocor=auto(L:end); % positive portion of autocorrelation
    p1_offset=8;
    ignore_s=max(1,period_temp-p1_offset);
    ignore_e=min(period_temp+p1_offset,length(pos_autocor));
    sub_pos_autocor=pos_autocor;
    sub_pos_autocor(ignore_s:ignore_e)=0;
    [level2_temp, period2_temp] = max(sub_pos_autocor); % 2nd peak and its location
    
    period_temp=abs(location - length(frame) + 1);
    period2 = [period2 period2_temp]; 
    level2 = [level2 level2_temp];
    if debug
        figure(1);clf;hold on;
        plot((0:length(auto(L:end))-1),auto(L:end));
        stem(period_temp+1,level_temp);
        stem(period2_temp+1,level2_temp);
        plot((period_lo:period_hi),auto(L+period_lo:L+period_hi));
        title_str=strcat('Autocorr at Frame #',int2str(k),' - Period=',int2str(period_temp),' - Level=',num2str(level_temp));
        title(title_str);
        xlabel('Time [s]');
    end
end