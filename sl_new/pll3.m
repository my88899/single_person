clc;clear;close all;

delay_t=0.3;
% sim('pll01.mdl')%����������
sim('pll03.mdl')%����������

Fs=1/0.0001;%��ݲ�����ѹ�仯Ƶ��1V/s��ѹ������100Hz/V,����Ƶ��100Hz
jd=50;

%�����ж��ٸ���������Ч��
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
xlabel({'ʱ��',sprintf('\n'),'����',lt,'s'});ylabel('Ƶ��Hz')
legend('ԭʼ�ź�Ƶ��','ͨ���ŵ����ź�Ƶ��')
f=ff-ffe;
f=f(rp:end);
f(find(f<0))=[];
clc
delay_t
dt=mean(f)/500   %��ݲ��ı�Ƶ��Ϊ5V/s��ѹ������100Hz/V����Ϊ500Hz��s
