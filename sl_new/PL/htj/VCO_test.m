clear all
clc
t_delay1=rand(1);
t_delay2=rand(1);
t_delay3=rand(1);
for k=1:2
t_delay1=t_delay1-0.1+0.2*rand(1);
t_delay2=t_delay2-0.1+0.2*rand(1);
t_delay3=t_delay3-0.1+0.2*rand(1);

T=[t_delay1,t_delay2,t_delay3];
for u= 1:1:3
if T(u)<=0
    T(u)=0.000000001;
end
end
D(k)=min(T);
sim('vco_test.mdl');
x = ScopeData2.signals.values;
fs=100000; % 采样频率，自己根据实际情况设置
N=length(x)-1; % x 是待分析的数据
n=1:N;%1-FFT
X=fft(x); % FFT
X=X(1:N/2);
Xabs=abs(X)/(N/2);
h=max(Xabs);
Xabs(1) = 0; %直流分量置0
F=([1:N]-1)*fs/N; %换算成实际的频率值
plot(F(1:N/2),Xabs);  
freq=[];
B=[];
for i=1:1:N/2;
    if Xabs(i)>h/2
        B=[freq,F(i)];
        freq=B;
    end
end
C(k)=min(B);
end
stem(C)
Y=D*25000;
E=(C-D*25000)./(D*25000)*100;