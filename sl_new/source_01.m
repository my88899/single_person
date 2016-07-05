clc;clear;close all;
L=10;%仿真时长
tL=20;
Fs=2;
dt=1/Fs;
dV=0.2;
t=0:dt:(L-dt);%采样时间为0.01s，仿真时长L
tri=0;
for i=0:length(t)-1
    tp=tri(end)+dV;
    if(tp>1)tp=0;end
    tri=[tri,tp];
end
tri=tri(2:end);
plot(t,tri,' -')
axis([0 10 -1 2])
y=[];
for i=1:length(tri)-1
    for j=1:tL
        ty=sin(2*pi*10*tri(i)*(t/2));
        y=[y,ty];
    end
end
tt=1:length(y);
figure
plot(tt,y,'r-')



