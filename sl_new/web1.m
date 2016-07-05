clear; close all; clc;  
Fs = 10000;           %采样率  
T = 1/Fs;                       
L = 50000;           % 信号持续的时间  
t = (0:L-1)*T;                  
x = 0.7*sin(2*pi*500*t) + sin(2*pi*1200*t); % 产生一个信号  
y = x + 2*randn(size(t));     % 叠加上噪声  
% plot(Fs*t(1:50),y(1:50))  
% title('Signal Corrupted with Zero-Mean Random Noise')  
% xlabel('time (milliseconds)')  
Y = fft(y);  
Z=abs(Y);  
plot(Z)   
[ma, I]=max(Z); %ma为数组的最大值，I为下标值  
fprintf(1, '信号频率最强处的频率值=%f\n', I/length(Z)*Fs);  