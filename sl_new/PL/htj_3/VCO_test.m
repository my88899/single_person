clear all
clc
t_delay1=rand(1);t_delay2=rand(1);t_delay3=rand(1);
for k=1:50
t_delay1=t_delay1-0.1+0.2*rand(1);
t_delay2=t_delay2-0.1+0.2*rand(1);
t_delay3=t_delay3-0.1+0.2*rand(1);

T=[t_delay1,t_delay2,t_delay3];
for u= 1:1:3
if T(u)<=0
    T(u)=0.000000001;
end
end
t_delay1=T(1);
t_delay2=T(2);
t_delay3=T(3);


T_min(k)=min(T);
sim('vco_test.mdl');
x = ScopeData2.signals.values;
fs=100000; % 采样频率，自己根据实际情况设置
N=length(x)-1; % x 是待分析的数据量
n=1:N;%1-FFT
X=fft(x); % FFT
X=X(1:N/2);
Xabs=abs(X)/(N/2);

Xabs(1) = 0; %直流分量置0
h=max(Xabs);
F=([1:N]-1)*fs/N; %换算成实际的频率值
plot(F(1:N/2),Xabs);  
freq=[];
orignal_freq_shift=[];
for i=1:1:N/2;
    if Xabs(i)>h/2
        orignal_freq_shift=[freq,F(i)];
        freq=orignal_freq_shift;
    end
end
freq_shift(k)=min(orignal_freq_shift);
end
plot(freq_shift)
true_freq_shift=T_min*2500
Error=(freq_shift-T_min*2500)./(T_min*2500)*100