% %[x, fs] = wavread('bee.wav'); x = x(1000:1480);
% r = spCorrel(x, fs, [], 'plot');
% 
% %[x, fs] = wavread('bee.wav'); x = x(1000:1480);
% global f0;
  global y_rec;
%  global audioObject;
%  fs = audioObject.SampleRate;
% global r;




fs = audioObject.SampleRate;
x = y_rec;
x = x(1000:1480);
[r] = spCorrelum(x, fs, []);
f0 = spPitchCorrel(r, fs);

plot(r);
f0

