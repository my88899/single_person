clear;clc;close all;
sim('pll_now01.mdl');
% s=Tsm.data;
s = ScopeData.signals.values;
Fs=80000;%采样频率
L=length(s)-1;
l=1:L;
X=fft(s);
X=X(1:L/2);
Xabs=abs(X)/(L/2);
% Xabs=abs(X);

Xabs(1) = 0; %直流分量置0
h=max(Xabs);
F=([1:L]-1)*Fs/L; %换算成实际的频率值
plot(F(1:L/2),Xabs);  
% plot(F,Xabs(2:));  


