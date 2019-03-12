function s_out = normalize_audio(s_in)
    % Inputs:
    % -> s_in: audio signal to be normalized
    % Outputs:
    % -> s_out: resultant normalized audio signal
    
    s_out=s_in/(max(max(s_in),-min(s_in)));
    
end

