function [f,dt]=t_f(ff,ffe,sim_t,jd,delay_t,color)


%计算有多少个样点是无效点
lt=sim_t/jd;
rp=ceil(delay_t/lt)+3;

ff=ff(rp:end);ffe=ffe(rp:end);
f=[];ft=rp*lt:lt:sim_t;
rf=[];
for i=1:length(ff)-1
    if(ff(i)<ff(i+1))
        tf=ff(i)-ffe(i);
    else
        tf=[];rf=[rf,i];
    end
    f=[f,tf];
end
rf=[rf,length(ff)];
ft(rf)=[];
ft(find(f<0))=[];
f(find(f<0))=[];
% 
figure(1)
plot(ft,f/500,color)
axis([0,40,0,2]);grid;
% figure(2)
% smooth(ft,f/500);
delay_t
% plot(f/500)
dt=mean(f)/500