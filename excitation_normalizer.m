function [exc,exc_n,G_n]=excitation_normalizer(ein,R,n_f,G_all)
	% transpose and normalize excitation signal based on lpc analyzer's gain values
	% Inputs:
	% -> exc = un-normalized excitation signal
	% -> R = frame offset
	% -> n_f = number of frames
	% -> G_all = gains from lpc analyzer
	% Outputs:
	% -> exc = R-segmented excitation signal
	% -> exc_n = normalized excitation signal
	% -> G_n = normalized gains
	exc=[];
	exc_n=[];
	G_n=[];
	% n_f=length(G_file); % possibly redundant; ignore for now
	for i=1:n_f
		e_temp=ein(1:R,i);
		exc=[exc e_temp'];
		G_temp=G_all(i)/sqrt(sum(e_temp.^2)); % in ref, add 0.01. Ignoring this.
		G_n=[G_n G_temp];
		exc_n=[exc_n G_temp*e_temp'];
	end
end