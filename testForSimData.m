dt=ff-ff_d;
dt(dt<0)=[];%ȥ����������β���������Ĵ�������
dt_m=mean(dt)
dtt=abs(dt-dt_m)
dtt_m=mean(abs(dt-dt_m))
% ts=dt-dtt;
% max(ts)
% min(ts)
% mean(ts)
dt_t=find((dtt-3*dtt_m)>0);
dt(dt_t)=[]
d_c=mean(dt)/(1000/0.1)