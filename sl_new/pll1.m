clc;clear;close all;
Fq=1000*2*pi;
spp=2000;st=0.5e-5;
% sim('pll01.mdl')%����������
sim('pll02.mdl')%����������
% Fs=1/(Ts.time(2)-Ts.time(1))
% Fs=1/(10/length(Ts.time));
Fs=1/0.0001;%��ݲ�����ѹ�仯Ƶ��1V/s��ѹ������200Hz/V,����Ƶ��100Hz
% size(Ts.time)
jd=50
N=length(Ts.data)/2/jd;
ff=[];
for i=1:jd;
    if i==1
        P=Ts.data(2:i*N);
    else
        P=Ts.data((i-1)*N+1:i*N);
    end
    X_k=abs(fft(P));
    [ma,I]=max(X_k);
    ff=[ff,I/(N-1)*Fs];
end
ff=ff';
plot(ff);
% P=Ts.data(2:N);
% X_k=abs(fft(P));
% [ma,I]=max(X_k)
% ff=I/(N-1)*Fs