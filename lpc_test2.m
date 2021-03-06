
%% lpc_test2.m
% Script for testing lpc vocoder synthesis
% Author: Mason del Rosario
% Winter 2019

%% setup rec
clear; clc;
file='recorded_audio.wav';
[xin,Fs]=audioread(file);
p = 20;
window = 1; % hamming
es=length(xin(:,1));
x_s=find(xin(:,1) ~= 0);
es=min(es,x_s(end)+1);
ss=1;
L_frame=20; % frame width in range of 1-100ms
R_frame=10; % frame offset in range of 1-100ms
over_frame=1; % # overlapping frames in range of 0-3; dummy val for now
fsd = 16000;

%% lpc analysis+synthesis 
global sout2;
[sout2]=lpc(xin,Fs,ss,es,L_frame,R_frame,p,over_frame,window,fsd);

%% save audio
i=strfind(file,'.');
filename=file(1:i-1);
filetype=file(i:end);
Fsd=8000*2;
filename_new=strcat(filename,'_synth_',int2str(Fsd),'.wav');
audiowrite(filename_new,sout2/2,Fsd);