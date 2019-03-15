global y_rec;
function [pitch] = pitch_detect(y_rec);
%PITCH_DETECT   Performs pitch detection on a speech waveform
%
%       p = pitch_detect(x);
%   x is vector containing frame of speech data
%       p is scalar containing pitch of frame in Hz or 0 if unvoiced
 
Fs = 8000;
 
%  First, remove the dc value of the frame by subtracting the mean . . .
 
y_rec = y_rec-mean(y_rec);
 
%  Then find the minimum and maximum samples and center clip to 
%  75% of those values (`cclip') . . .
l = length(y_rec);
max = 0;
min = 0;

for i = 1:l;
    if(y_rec(i)>max)
        max = y_rec(i);
    end
    if(y_rec(i)<min)
        min = y_rec(i);
    end
end %end for loop
 
cmax = 0.75*max;
cmin = 0.75*min;
 
clipped = cclip(y_rec,cmin,cmax);
 
%  Compute the autocorrelation of the frame . . .
 
[c,lags] = xcorr(clipped,l,'coeff');
 
% Find the maximum peak following Rx[0] (`peak') . . .
peak = 0;
peakindex = 0;
for i = (l+2):(2*l-1);
    if(c(i) > c(i-1) && c(i) > c(i+1)) %% this is a peak
        if(c(i)>peak)
            peak = c(i);
            peakindex = i;
        end
    end
end %end for loop
 
%[peak2,peakindex]=peak(c(l+1:2*l+1));
 
% Determine if the segment is unvoiced based on the 'voicing strength' 
% (the ratio of the autocorrelation function at the peak pitch lag 
% to the autocorrelation function lag=0) . . .
 
% If voicing strength is less than 0.25, call it unvoiced and set pitch = 0,
% otherwise compute the pitch from the % index of the peak . . .
 
if(peak < 0.25) %then unvoiced
    pitch = 0;
else %voiced
   pitch = Fs/(peakindex-l);
end
end