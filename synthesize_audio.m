function [s_out] = synthesize_audio(ss,es,L,R,n_f,exc,G_all,A_all,p,over_frame,window)
    % Inputs:
    % -> ss = starting sample
    % -> es = ending sample
    % -> L = length of sample [#]
    % -> R = frame offset [#]
    % -> n_f = frame offset [#]
    % -> exc = normalized excitation vector
    % -> G_all = gain vector from lpc analysis
    % -> A_all = coeff vector from lpc analysis
    % -> p = LPC model order
    % -> win = window for synthesis
    % Output:
    % -> Synthesized audio signal

    s_out=zeros((es-ss+1+L),1);
    for i=1:n_f
    	e_temp=[exc(1:R,i);zeros(over_frame*R,1)]; % extend filter response by # overlapping frames
    	G=G_all(i)/sqrt(sum(e_temp.^2)); % ref adds 0.01; ignoring
    	s_filt=filter(G,A_all(1:p+1,i),e_temp);
    	if (i==1)
    		s_out(1:(over_frame+1)*R)=s_filt(1:(over_frame+1)*R);
    		s_e=(over_frame+1)*R;
    	else
    		s_out(s_e-over_frame*R+1:s_e+R)=s_out(s_e-over_frame*R+1:s_e+R)+s_filt(1:(over_frame+1)*R);
            s_e=s_e+R;
    	end
    end
end