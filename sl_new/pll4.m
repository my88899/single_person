clc;clear;close all;

Gu=0.04;
delay_t1=0.2;   Gain1=Gu/delay_t1;
delay_t2=0.16;  Gain2=Gu/delay_t2;
delay_t3=0.13;  Gain3=Gu/delay_t3;
sim_t=100;
% sim('pll01.mdl')%无噪声干扰
sim('pll04.mdl')%有噪声干扰

Fs=1/0.0001;%锯齿波：电压变化频率1V/s，压控振荡器100Hz/V,基础频率100Hz
jd=5*sim_t;

%计算有多少个样点是无效点
% lt=sim_t/jd;
% rp=ceil(delay_t1/lt)+1;

ff=t_f(Ts,jd,Fs);
ffe=t_f(Tse,jd,Fs);
ffe2=t_f(Tse2,jd,Fs);
ffe3=t_f(Tse3,jd,Fs);
figure;hold on;
dffe=d_f(ff,ffe,sim_t,jd,delay_t1,'b');
dffe2=d_f(ff,ffe2,sim_t,jd,delay_t2,'r');
dffe3=d_f(ff,ffe3,sim_t,jd,delay_t3,'g');
hold off;
% N=length(Ts.data)/2/jd;
% ff=[];
% ffe=[];
% for i=1:jd;
%     if i==1
%         P=Ts.data(2:i*N);
%         Pe=Tse.data(2:i*N);
%     else
%         P=Ts.data((i-1)*N+1:i*N);
%         Pe=Tse.data((i-1)*N+1:i*N);
%     end
%     X_ke=abs(fft(Pe));
%     [mae,Ie]=max(X_ke);
%     ffe=[ffe,Ie/(N-1)*Fs];
%     X_k=abs(fft(P));
%     [ma,I]=max(X_k);
%     ff=[ff,I/(N-1)*Fs];
% end
% ff=ff';ffe=ffe';
ttt=0:lt:sim_t-lt;
plot(ttt,ff,'k-');
figure
hold on;grid on;
plot(ttt,ffe,'r-',ttt,ffe2,'g-',ttt,ffe3,'-b');
xlabel({'时间',sprintf('\n'),'精度',lt,'s'});ylabel('频率Hz')
legend('原始信号频率',strcat('通过',num2str(delay_t1),'延迟信道后信号频率'),strcat('通过',num2str(delay_t2),'延迟信道后信号频率'),strcat('通过',num2str(delay_t3),'延迟信道后信号频率'))

% ff=ff(rp:end);ffe=ffe(rp:end);
% f=[];ft=(rp+1)*lt:lt:sim_t;
% for i=1:length(ff)-1
%     if(ff(i)<ff(i+1))
%         tf=ff(i)-ffe(i);
%     else
%         tf=[];ft(i)=[];
%     end
%     f=[f,tf];
% end
% f(find(f<0))=[];ft(find(f<0))=[];
% 
% figure
% plot(f/500)
% axis([0,40,0,2]);grid;
% % f=ff-ffe;
% 
% % f(find(f<0))=[];
% clc
% delay_t1
% % plot(f/500)
% dt=mean(f)/500   %锯齿波改变频率为5V/s，压控振荡器100Hz/V，故为500Hz、s
