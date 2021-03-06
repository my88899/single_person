clc
clear
% close all
fc  =  77e9;
c  =  3e8;
lambda = c/fc;
range_max = 200;
tm = 5.5*range2time(range_max,c);
range_res = 1;
bw = range2bw(range_res,c);
sweep_slope = bw/tm;
fr_max = range2beat(range_max,sweep_slope,c);
v_max = 230*1000/3600;
fd_max = speed2dop(2*v_max,lambda);
fb_max = fr_max+fd_max;
fs = max(2*fb_max,bw);
hwav  =  phased.FMCWWaveform('SweepTime',tm,'SweepBandwidth',bw,'SampleRate',fs);
s = step(hwav);
figure
subplot(211);plot(0:1/fs:tm-1/fs,real(s));
xlabel('Time(s)');ylabel('Amplitude(v)');
title('FMCW signal');axis tight;
subplot(212);
% spectrogram(s,32,16,32,fs,'yaxis');
spectrogram(s,kaiser(32,2),16,32,fs,'yaxis');
title('FMCW signal spectrogram');

car_dist = 43;
car_speed = 96*1000/3600;
car_rcs = db2pow(min(10*log10(car_dist)+5,20));

hcar = phased.RadarTarget('MeanRCS',car_rcs,'PropagationSpeed',c,'OperatingFrequency',fc);
hcarplatform = phased.Platform('InitialPosition',[car_dist;0;0.5],'Velocity',[car_speed;0;0]);
hchannel = phased.FreeSpace('PropagationSpeed',c,'OperatingFrequency',fc,'SampleRate',fs,'TwoWayPropagation',true);

ant_aperture = 6.06e-4;                         % in square meter
ant_gain = aperture2gain(ant_aperture,lambda);  % in dB

tx_ppower = db2pow(5)*1e-3;                     % in watts
tx_gain = 9+ant_gain;                           % in dB

rx_gain = 15+ant_gain;                          % in dB
rx_nf = 4.5;                                    % in dB

htx = phased.Transmitter('PeakPower',tx_ppower,'Gain',tx_gain);
hrx = phased.ReceiverPreamp('Gain',rx_gain,'NoiseFigure',rx_nf,'SampleRate',fs);

radar_speed = 100*1000/3600;
hradarplatform = phased.Platform('InitialPosition',[0;0;0.5],'Velocity',[radar_speed;0;0]);

hspec = dsp.SpectrumAnalyzer('SampleRate',fs,'PlotAsTwoSidedSpectrum',true,...
    'Title','Spectrum for received and dechirped signal','ShowLegend',true);

Nsweep = 64;
xr = complex(zeros(hwav.SampleRate*hwav.SweepTime,Nsweep));

%simulation loop
for m = 1:Nsweep
    [radar_pos,radar_vel] = step(...
        hradarplatform,hwav.SweepTime);       % Radar moves during sweep
    [tgt_pos,tgt_vel] = step(hcarplatform,...
        hwav.SweepTime);                      % Car moves during sweep
    x = step(hwav);                           % Generate the FMCW signal
    xt = step(htx,x);                         % Transmit the signal
    xt = step(hchannel,xt,radar_pos,tgt_pos,...
        radar_vel,tgt_vel);                   % Propagate the signal
    xt = step(hcar,xt);                       % Reflect the signal
    xt = step(hrx,xt);                        % Receive the signal
    xd = dechirp(xt,x);                       % Dechirp the signal

    step(hspec,[xt xd]);                      % Visualize the spectrum

    xr(:,m) = xd;                             % Buffer the dechirped signal
end

hrdresp = phased.RangeDopplerResponse('PropagationSpeed',c,...
    'DopplerOutput','Speed','OperatingFrequency',fc,'SampleRate',fs,...
    'RangeMethod','FFT','SweepSlope',sweep_slope,...
    'RangeFFTLengthSource','Property','RangeFFTLength',2048,...
    'DopplerFFTLengthSource','Property','DopplerFFTLength',256);

clf;
plotResponse(hrdresp,xr);                     % Plot range Doppler map
axis([-v_max v_max 0 range_max])
clim = caxis;

Dn = fix(fs/(2*fb_max));
for m = size(xr,2):-1:1
    xr_d(:,m) = decimate(xr(:,m),Dn,'FIR');
end
fs_d = fs/Dn;

fb_rng = rootmusic(pulsint(xr_d,'coherent'),1,fs_d);
rng_est = beat2range(fb_rng,sweep_slope,c)      %output rng_est

peak_loc = val2ind(rng_est,c/(fs_d*2));
fd = -rootmusic(xr_d(peak_loc,:),1,1/tm);
v_est = dop2speed(fd,lambda)/2                  %output v_est

deltaR = rdcoupling(fd,sweep_slope,c)           %output deltaR

hwavtr = clone(hwav);
release(hwavtr);
tm = 2e-3;
hwavtr.SweepTime = tm;
sweep_slope = bw/tm;

deltaR = rdcoupling(fd,sweep_slope,c)           %output deltaR

v_unambiguous = dop2speed(1/(2*tm),lambda)/2    %output v_unambiguous

hwavtr.SweepDirection = 'Triangle';

Nsweep = 16;
xr = helperFMCWSimulate(Nsweep,hwavtr,hradarplatform,hcarplatform,...
    htx,hchannel,hcar,hrx);

fbu_rng = rootmusic(pulsint(xr(:,1:2:end),'coherent'),1,fs);
fbd_rng = rootmusic(pulsint(xr(:,2:2:end),'coherent'),1,fs);

rng_est = beat2range([fbu_rng fbd_rng],sweep_slope,c)       %output rng_est

fd = -(fbu_rng+fbd_rng)/2;
v_est = dop2speed(fd,lambda)/2                  %output v_est

chant = phased.TwoRayChannel('PropagationSpeed',c,...
    'OperatingFrequency',fc,'SampleRate',fs);
chanr = phased.TwoRayChannel('PropagationSpeed',c,...
    'OperatingFrequency',fc,'SampleRate',fs);
Nsweep = 64;
xr = helperFMCWTwoRaySimulate(Nsweep,hwav,hradarplatform,hcarplatform,...
    htx,chant,chanr,hcar,hrx);
plotResponse(hrdresp,xr);                     % Plot range Doppler map
axis([-v_max v_max 0 range_max]);
caxis(clim);