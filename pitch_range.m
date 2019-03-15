function [lo,hi]=pitch_range(p_case,fs,detect_method)
    % cepstral ranges for male vs female speakers
    min_val=0;
    max_val=2;
    assert((p_case>=min_val) && (p_case<=max_val),'Pitch range case should be in range %d to %d',min_val,max_val);
    switch p_case
        % denominators indicate range of harmonics for male/female speakers
        case 0 % male
            lo_freq=250;
            hi_freq=60;
        case 1 % female
            lo_freq=350;
            hi_freq=150;
        case 2 % composite/wide range
            lo_freq=500;
            hi_freq=50;
        otherwise % go crazy
            lo_freq=1000;
            hi_freq=10;
    end
    switch detect_method
        case 0 % cepstrum
            [lo,hi]=cep_pitches(lo_freq,hi_freq,fs);
        case 1 % autocor
            [lo,hi]=auto_pitches(lo_freq,hi_freq,fs);
    end
end

function [lo,hi]=cep_pitches(lo_freq,hi_freq,fs)
    % cepstrum is using fft (i.e. normalized freq)
    lo=round(fs/lo_freq);
    hi=round(fs/hi_freq);
end

function [lo,hi]=auto_pitches(lo_freq,hi_freq,fs)
    % autocor is using period (i.e., inverse of freq)
    lo=1/lo_freq;
    hi=1/hi_freq;
end