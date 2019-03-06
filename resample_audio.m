function [y_new,Fs_new]=resample_audio(file,ts,tf,p,q)
    % resample an audio sample for use with lpc vocoder
    % Inputs:
    % -> filename = file to load and alter
    % -> p = numerator to use in resample
    % -> q = denominator to use in resample
    % Outputs:
    % -> y = samples at new rate
    % -> Fs = new rate
    i=strfind(file,'.');
    filename=file(1:i-1);
    filetype=file(i:end);
    [~,Fs]=audioread(file);
    [y,Fs]=audioread(file,[ts*Fs tf*Fs]);
    y_new=resample(y,p,q);
    Fs_new=Fs*p/q;
    filename_new=strcat(filename,'_',int2str(Fs_new),'.wav');
    audiowrite(filename_new,y_new,Fs_new);
end