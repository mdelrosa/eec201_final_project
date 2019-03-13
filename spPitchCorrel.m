% NAME
%   spPitchCorr - Pitch Estimation via Auto-correlation Method
% SYNOPSIS
%   [f0] = spPitchCorr(r, fs)
%   r  - Correlation coefficients
%   f0 - the estimated pitch

% global r;
% global f0;
% global audioObject;
% fs = audioObject.SampleRate;

function [f0] = spPitchCorrel(r, fs)
 % search for maximum  between 2ms (=500Hz) and 20ms (=50Hz)
 ms2=floor(fs/500); % 2ms
 ms20=floor(fs/50); % 20ms
 % half is just mirror for real signal
 r = r(floor(length(r)/2):end);
 [maxi,idx]=max(r(ms2:ms20));
 f0 = fs/(ms2+idx-1);
end
