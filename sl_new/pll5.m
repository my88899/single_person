clc;clear;close all;

Gu=0.04;
% delay_t1=0.2;   Gain1=Gu/delay_t1;
% delay_t2=0.16;  Gain2=Gu/delay_t2;
% delay_t3=0.13;  Gain3=Gu/delay_t3;
sim_t=100;
% sim('pll01.mdl')%无噪声干扰
% sim('pll05.mdl')%有噪声干扰

%锯齿波：电压变化频率1V/s，压控振荡器100Hz/V,基础频率100Hz
Fs=1/0.0001;
jd=5*sim_t;

% ff=t_f(Ts,jd,Fs);
% delay_t=0.1:0.01:0.99;
% delay_t=0.1:0.01:0.21;
delay_t=0.1:0.05:0.65;
% figure(3)
delay_t_e=[];
for i=1:3:10
    delay_t1=delay_t(i);    Gain1=Gu/delay_t1;
    delay_t2=delay_t(i+1);  Gain2=Gu/delay_t2;
    delay_t3=delay_t(i+2);  Gain3=Gu/delay_t3;
    sim('pll06.mdl')%有噪声干扰
    if i==1
        ff=t_f(Ts,jd,Fs);
    end
    ffe=t_f(Tse,jd,Fs);
    ffe2=t_f(Tse2,jd,Fs);
    ffe3=t_f(Tse3,jd,Fs);
    hold on;
    [dffe,dely_t]=d_f(ff,ffe,sim_t,jd,delay_t1,'b');
    [dffe2,dely_t2]=d_f(ff,ffe2,sim_t,jd,delay_t2,'r');
    [dffe3,dely_t3]=d_f(ff,ffe3,sim_t,jd,delay_t3,'g');
    delay_t_e=[delay_t_e,[dely_t,dely_t2,dely_t3;delay_t1,delay_t2,delay_t3]];
end
hold off
% ffe=t_f(Tse,jd,Fs);
% ffe2=t_f(Tse2,jd,Fs);
% ffe3=t_f(Tse3,jd,Fs);
% figure;hold on;
% %锯齿波改变频率为5V/s，压控振荡器100Hz/V，故为500Hz、s
% dffe=d_f(ff,ffe,sim_t,jd,delay_t1,'b');
% dffe2=d_f(ff,ffe2,sim_t,jd,delay_t2,'r');
% dffe3=d_f(ff,ffe3,sim_t,jd,delay_t3,'g');
% hold off;

% ttt=0:lt:sim_t-lt;
% plot(ttt,ff,'k-');
% figure
% hold on;grid on;
% plot(ttt,ffe,'r-',ttt,ffe2,'g-',ttt,ffe3,'-b');
% xlabel({'时间',sprintf('\n'),'精度',lt,'s'});ylabel('频率Hz')
% legend('原始信号频率',strcat('通过',num2str(delay_t1),'延迟信道后信号频率'),strcat('通过',num2str(delay_t2),'延迟信道后信号频率'),strcat('通过',num2str(delay_t3),'延迟信道后信号频率'))

