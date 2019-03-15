global y_rec;
global audioObject;
y = y_rec; 
Fs = audioObject.SampleRate;
y=y(:,1);
auto_corr_y=xcorr(y); 
subplot(2,1,1),plot(y) 
subplot(2,1,2),plot(auto_corr_y)
[pks,locs] = findpeaks(auto_corr_y);
[mm,peak1_ind]=max(pks);
period=locs(peak1_ind+1)-locs(peak1_ind);
pitch_Hz=Fs/period;