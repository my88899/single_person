clear;clc;close all;
L=1000;
Fs=80000;%采样频率
sim('mSingalStable01.mdl');
os = ScopeData.signals(2).values;
ls = ScopeData.signals(3).values;
sL=length(os)-1;
n=floor(sL/L);
off=[];sff=[];
for i=0:n-1
    ox=fft(os(((i*L)+1):((i+1)*L)));
    sx=fft(ls(((i*L)+1):((i+1)*L)));
    [ma,oI]=max(ox);
    [sma,sI]=max(sx);
    off=[off,oI/(L-1)*Fs];
    sff=[sff,sI/(L-1)*Fs];
end
et=abs(off(400:end)-sff(400:end));
et(find(et>1000))=[];
en=mean(et)/2000

% l=1:L;
% X=fft(s);
% X=X(1:L/2);
% Xabs=abs(X)/(L/2);
% % Xabs=abs(X);
% 
% Xabs(1) = 0; %直流分量置0
% h=max(Xabs);
% F=([1:L]-1)*Fs/L; %换算成实际的频率值
% plot(F(1:L/2),Xabs);  
% % plot(F,Xabs(2:));  


