%% lpc_wrapper.m
% Script for testing lpc vocoder synthesis
% Author: Mason del Rosario
% Winter 2019

function [sout,fs]=lpc_wrapper(filename,lpc_ord,window,L_frame,R_frame,over_frame)

    % Inputs:
    % -> filename
    % -> fs = signal sampling rate (max 16kbit/s)
    % -> ss = starting sample
    % -> es = ending sample
    % -> L_frame = frame width in range of 1-100ms [20ms typical]
    % -> R_frame = frame offset in range of 1-100ms [10ms typical]
    % -> p = LPC model order
    % -> over_frame = # overlapping frames in synthesis (keep as 1 for now)
    % -> fsd = intermediate sampling frequency (might be redundant)

	[xin,fs]=audioread(filename);
	% p = 20;
	% window = 1; % hamming
	es=length(xin(:,1));
	x_s=find(xin(:,1) ~= 0);
	es=min(es,x_s(end)+1);
	ss=1;
	% L_frame=20; % frame width in range of 1-100ms
	% R_frame=10; % frame offset in range of 1-100ms
	over_frame=1; % # overlapping frames in range of 0-3; dummy val for now
	fsd=16000;

	%% lpc analysis+synthesis 
	[sout]=lpc(xin,fs,ss,es,L_frame,R_frame,lpc_ord,over_frame,window,fsd);

end

