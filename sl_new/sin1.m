clc;
clear;
close all;
% 5.56GHz-7.25GHz ¹²1.69GHz

% hz=500;
% dt=1;
% hz=5.56e3:dt:7.25e3;
hz=100
Fs=max(hz)*2;
T=1/Fs;
L=1;
t=0:T:L;
x_t=sin(2*pi*hz*t);

X_k=abs(fft(x_t));
[ma, I]=max(X_k);
ff=I/length(X_k)*Fs
f=hz
