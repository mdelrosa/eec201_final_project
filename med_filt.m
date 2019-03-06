function xout=med_filt(xin,L,N)
	% median filter on x
	% Inputs:
	% -> xin = input sequence
	% -> L = median window
	% -> N = length of period vector
	% Outputs:
	% -> xout = filtered sequence
	xout=ones(1,N);
	xint=[ones(1,(L-1)/2).*xin(1) xin ones(1,(L-1)/2).*xin(N)];
	for i=1:N
		xout(i)=median(xint(i:i+L-1));
	end
end