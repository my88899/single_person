clc;clear;close all;
ts=0.000001;%采样间隔
Fs=1/ts;
% delay=0.12;
d_ed=[];
e_a=[];
for delay=0.0001:0.0001:0.2
    lenB=floor(delay/ts)+2;
    sim('base_01.mdl')
    Ds=VCO.data(lenB:end);
    Ts=VCO.time(lenB:end);
    Dd=VCO_del.Data(lenB:end);
    jd=400;

    N=floor(length(Ds)/jd);
    ff=[];ff_d=[];t=[];
    s=[];
    for i=1:jd;
        if i==1
            P=Ds(1:i*N);
            P_d=Dd(1:i*N);
            t=mean(Ts(1:i*N));
            s=sum(abs(P-P_d));
        else
            P=Ds((i-1)*N+1:i*N);
            P_d=Dd((i-1)*N+1:i*N);
            t=[t,mean(Ts((i-1)*N+1:i*N))];
            s=[s,sum(abs(P-P_d))];
        end
        X_k=abs(fft(P));
        X_k_d=abs(fft(P_d));
        [ma,I]=max(X_k);
        [ma_d,I_d]=max(X_k_d);
        ff=[ff,I/(N-1)*Fs];
        ff_d=[ff_d,I_d/(N-1)*Fs];
    end
    ff=ff';
    ff_d=ff_d';
%     plot(t,ff);
%     hold on
%     % figure
%     plot(t,ff_d);

    dt=ff-ff_d;
    dt(dt<0)=[];%去除由于周期尾端落差产生的错误数据
    dt_m=mean(dt);
    dtt=abs(dt-dt_m);
    dtt_m=mean(abs(dt-dt_m));
    % ts=dt-dtt;
    % max(ts)
    % min(ts)
    % mean(ts)
    dt_t=find((dtt-3*dtt_m)>0);
    dt(dt_t)=[];
    d_c=mean(dt)/(1000/0.1);
    d_ed=[d_ed,[delay;d_c;abs(delay-d_c)/delay*100]];
    save conclusion d_ed
end