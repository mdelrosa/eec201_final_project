function [exc]=excitation_generator(n_f,R,pitch)
    % generate impulse train based on # frames, frame offset, calculatec
    % periods
    
    % Inputs:
    % -> n_f = number of frames
    % -> R_frame = frame offset [ms]
    % -> p1m = calculated periods from cepstrum
    
    % Output:
    % -> exc = excitation train
    
    p_last=0;
    exc=[];
    
    for i=1:n_f
       p=pitch(i);
       if p==0
          % Gaussian noise for unvoiced sound
          exc=[exc randn(R,1)];
       else
          if p_last == 0
              % start new sequence of impulses
              e_temp=zeros(R,1);
              j=1;
              while p+j < R
                 e_temp(p+j)=1; 
                 j=j+p;
              end
          else
              % accounting for frame offset, R, for adjacent impulse trains
              j=j-R;
              if (j+p<1)
                  j=1-p;
              end
              while(j+p < R)
                  e_temp(j+p)=1;
                  j=j+p;
              end
          end
          exc=[exc e_temp];
       end
       p_last=p;
    end
    
    % zero pad excitation train
    for i=1:3
        exc=[exc zeros(R,1)];
    end
    
end