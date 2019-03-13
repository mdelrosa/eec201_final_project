% %[x, fs] = wavread('bee.wav'); x = x(1000:1480);
% r = spCorrel(x, fs, [], 'plot');
% 
% %[x, fs] = wavread('bee.wav'); x = x(1000:1480);
% global f0;
  global sout;
%  global audioObject;
%  fs = audioObject.SampleRate;
% global r;




fs = 8000;
x = sout;
%x = x(1000:1480);
[r] = spCorrelum(x, fs, []);
f0 = spPitchCorrel(r, fs);

%plot(r);
f0

