
function p_smoothed=pitch_smooth(period1,period2,level1,level2,p_thresh)
	% generate smooth pitch profile based on highest/second highest pitch periods/levels

    % Inputs:
    % -> period1 = most likely pitch period
    % -> period2 = second most likely pitch period
    % -> level1 = most likely pitch level
    % -> level2 = second most likely pitch level
    % -> pitch_thresh = threshold of pitch level

    % Output:
    % -> p_smoothed = final pitch profile for excitations

    % Generate pitch vector based on pitch ratio exceeding threshold
    p_len=length(period1);
    p_rat=level1./level2;
    p_smoothed=[0 ones(1,p_len-2) 0];
    p_smoothed(find(p_rat<p_thresh))=0;

    % demarcate beginning/ending of each pitch region with 1/-1, respectively
    p_smoothed(2:p_len)=p_smoothed(2:p_len)-p_smoothed(1:p_len-1);
    p_smoothed(1)=0;
    fprintf('p_smoothed:\n');
    disp(p_smoothed);

    % get # of intervals
    n_int=0;
    i_start=[];
    i_end=[];
    for frame=2:p_len
    	if p_smoothed(frame) == 1
    		% start of new interval
    		i_start=[i_start frame];
    		n_int=n_int+1;
    	elseif p_smoothed(frame) == -1
    		% end of interval
    		i_end=[i_end frame-1];
    	end
    end

    % search through intervals to see if they need extending
    thresh=0.1;
    [period1,period2,i_start,i_end]=search_interval(period1,period2,i_start,i_end,n_int,p_len,thresh,1);
    [period1,period2,i_start,i_end]=search_interval(period1,period2,i_start,i_end,n_int,p_len,thresh,2);
    [period1,period2,i_start,i_end]=search_interval(period1,period2,i_start,i_end,n_int,p_len,thresh,3);
    [period1,period2,i_start,i_end]=search_interval(period1,period2,i_start,i_end,n_int,p_len,thresh,4);

    % zero out pitch periods between intervals
    % f->frame,i->interval
    for f=1:i_start(1)-1
    	period1(f)=0;
    end
    for i=1:n_int-1
    	for f=i_end(i)+1:i_start(i+1)-1
    		period1(f)=0;
    	end
    end
    for f=i_end(n_int)+1:p_len
    	period1(f)=0;
    end
    p_smoothed=period1;
end

%% Helper function: search for extension of interval
function [period1,period2,i_start,i_end]=search_interval(period1,period2,i_start,i_end,n_int,p_len,thresh,phase)
    % Check rate-of-change of period based on best-/second-best pitch
    % estimates from pitch_detect_candidates
    % Inputs:
    % -> period1 = most likely pitch period
    % -> period2 = second most likely pitch period
    % -> i_start = start indices
    % ->   i_end = end indices
    % -> n_int = number of intervals
    % -> phase = interval search phase

    % Output:
    % -> p_smoothed = final pitch profile for excitations
	switch phase
    	case 1
            % phase 1 = start at 1st start index of first detected period 
            % search backwards
    		intervals=1;
    		frame=@(i) i_start(1)-1:-1:2;
    		if_cond=@(f,thresh) abs((period1(f)-period1(f+1))/period1(f+1)) <= thresh;
    		elseif_cond=@(f,thresh) abs((period2(f)-period1(f))/period1(f+1)) <= thresh;
    		p_change=i_start;
    		p_mod=-1;
    	case 2
            % phase 2 = start at each start index after first period
            % search backwards
    		intervals=2:n_int;
    		frame=@(i)i_start(i)-1:-1:i_end(i-1)+1;
    		if_cond=@(f,thresh) abs((period1(f)-period1(f+1))/period1(f+1)) <= thresh;
    		elseif_cond=@(f,thresh) abs((period2(f)-period1(f))/period1(f+1)) <= thresh;
    		p_change=i_start;
    		p_mod=-1;
    	case 3
            % phase 3 = start at 1st end index of first detected period 
            % search forwards
    		intervals=1:n_int-1;
    		frame=@(i)i_end(i)+1:i_start(i+1)-1;
    		if_cond=@(f,thresh) abs((period1(f)-period1(f-1))/period1(f)) <= thresh;
    		elseif_cond=@(f,thresh) abs((period2(f)-period1(f))/period1(f+1)) <= thresh;
    		p_change=i_end;
    		p_mod=1;
		case 4
            % phase 4 = start at each end index after first period
            % search forwards
    		intervals=n_int;
    		frame=@(i)i_end(n_int)+1:p_len-1;
    		if_cond=@(f,thresh) abs((period1(f)-period1(f-1))/period1(f)) <= thresh;
    		elseif_cond=@(f,thresh) abs((period2(f)-period1(f))/period1(f+1)) <= thresh;
    		p_change=i_end;
    		p_mod=1;
	end
	for i=intervals
		for f=frame(i)
			if if_cond(f,thresh)
				p_change(i)=p_change(i)+p_mod;
			elseif elseif_cond(f,thresh)
				p_change(i)=p_change(i)+p_mod;
				period1(f)=period2(f);
			else
				break
			end
        end
	end
	if (phase == 1 || phase == 2)
		i_start=p_change;
	elseif (phase == 3 || phase == 4)
		i_end=p_change;
	end
end