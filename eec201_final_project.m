% eec201_final_project.m
% Authors: Abhinav Kamath, Mason del Rosario
% Winter 2019

%% Setup env
clear;clc;
%% params
gam=0.1;
%% main loop
len=12;
fprintf(import_data);
foofoo=@(x,n)x+n;
n=2*rand(1,len).*(randi(3,1,len)-2);
foo=(1:1:len);
bar=foofoo(foo,n);
%% plot
figure(1);clf;hold on;
plot(foo,bar);
xlabel('Week [#]');
ylabel('Stress [kPa]');
title('Mental State Over Winter Quarter');
%% helper method
function data=import_data()
	data="Someday, we'll import some voice data.\n";
end