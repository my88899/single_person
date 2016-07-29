clc
clear
% close all
fc=77e9;
c=3e8;
lambda=c/fc;
range_max=200;
tm=5.5*range2time(range_max,c);
range_res=1;
bw=range2bw(range_res,c);
sweep_slope=bw/tm;
fr_max=range2beat(range_max,sweep_slope,c);
v_max=230*1000/3600;
fd_max=speed2dop(2*v_max,lambda);
fb_max=fr_max+fd_max;
fs=max(2*fb_max,bw);
hwav = phased.FMCWWaveform('SweepTime',tm,'SweepBandwidth',bw,'SampleRate',fs);
s=step(hwav);
figure
subplot(211);plot(0:1/fs:tm-1/fs,real(s));
xlabel('Time(s)');ylabel('Amplitude(v)');
title('FMCW signal');axis tight;
subplot(212);
% spectrogram(s,32,16,32,fs,'yaxis');
spectrogram(s,kaiser(32,2),16,32,fs,'yaxis');
title('FMCW signal spectrogram');
