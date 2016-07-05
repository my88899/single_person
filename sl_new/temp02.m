clc;clear;close all;
Fq=1000*2*pi;
spp=2000;st=0.5e-5;
sim('tm02.mdl')
Fs=1/(Ts.time(2)-Ts.time(1))
% size(Ts.time)
t=spp*st
f=1/t
N=length(Ts.data);
P=Ts.data(2:N);
X_k=abs(fft(P));
[ma,I]=max(X_k)
ff=I/(N-1)*Fs