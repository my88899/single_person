clear; close all; clc;  
Fs = 10000;           %������  
T = 1/Fs;                       
L = 50000;           % �źų�����ʱ��  
t = (0:L-1)*T;                  
x = 0.7*sin(2*pi*500*t) + sin(2*pi*1200*t); % ����һ���ź�  
y = x + 2*randn(size(t));     % ����������  
% plot(Fs*t(1:50),y(1:50))  
% title('Signal Corrupted with Zero-Mean Random Noise')  
% xlabel('time (milliseconds)')  
Y = fft(y);  
Z=abs(Y);  
plot(Z)   
[ma, I]=max(Z); %maΪ��������ֵ��IΪ�±�ֵ  
fprintf(1, '�ź�Ƶ����ǿ����Ƶ��ֵ=%f\n', I/length(Z)*Fs);  