function [A,G,a,r]=lpc_autocor(x_in,p)
    % Inputs:
    % -> x_in = input signal to be analyzed
    % ->    p = denominator order
    % Outputs:
    % ->    A = vector all-pole lpc model coeff
    % ->    G = all-pole lpc model (unit rmse)
    L=length(x_in);
    r=[];
    for i=0:p
       r=[r;autocor_term(x_in,L,i)]; 
    end
    % solve for a=R^(-1)*r
    R=toeplitz(r(1:p));
    a=inv(R)*r(2:p+1);
    A=[1; -a]; % pole coefficients for lpc model
    G=sqrt(sum(A.*r)); % gain 
end

function r=autocor_term(x,L,i)
    % Generate single autocorrelation term
    % Inputs:
    % -> x=input signal
    % -> L=length of signal
    % -> i=index of current autocor term to calculate
    r=sum(x(1:L-i).*x(1+i:L));
end