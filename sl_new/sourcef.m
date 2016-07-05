clc;
clear;
close all;
s=sim('tm01.mdl');
% periodogram(s)
y=fft(s);
[ma,I]=max(y)