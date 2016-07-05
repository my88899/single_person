clc;clear;close all;

delay_t=0.3;
% sim('pll01.mdl')%无噪声干扰
sim('pll03.mdl')%有噪声干扰

Fs=1/0.0001;%锯齿波：电压变化频率1V/s，压控振荡器100Hz/V,基础频率100Hz
jd=50;

%计算有多少个样点是无效点
lt=10/jd;
rp=ceil(delay_t/lt);

N=length(Ts.data)/2/jd;
ff=[];
ffe=[];
for i=1:jd;
    if i==1
        P=Ts.data(2:i*N);
        Pe=Tse.data(2:i*N);
    else
        P=Ts.data((i-1)*N+1:i*N);
        Pe=Tse.data((i-1)*N+1:i*N);
    end
    X_ke=abs(fft(Pe));
    [mae,Ie]=max(X_ke);
    ffe=[ffe,Ie/(N-1)*Fs];
    X_k=abs(fft(P));
    [ma,I]=max(X_k);
    ff=[ff,I/(N-1)*Fs];
end
ff=ff';ffe=ffe';
ttt=0:lt:10-lt;
plot(ttt,ff,'b-');
% figure
hold on;grid on;
plot(ttt,ffe,'r-');
xlabel({'时间',sprintf('\n'),'精度',lt,'s'});ylabel('频率Hz')
legend('原始信号频率','通过信道后信号频率')
f=ff-ffe;
f=f(rp:end);
f(find(f<0))=[];
clc
delay_t
dt=mean(f)/500   %锯齿波改变频率为5V/s，压控振荡器100Hz/V，故为500Hz、s
