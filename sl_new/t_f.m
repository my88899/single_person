function ff=t_f(Ts,jd,Fs)
N=length(Ts.data)/2/jd;
ff=[];
for i=1:jd;
    if i==1
        P=Ts.data(2:i*N);
    else
        P=Ts.data(((i-1)*N+1):i*N);
    end
    X_k=abs(fft(P));
    [ma,I]=max(X_k);
    ff=[ff,I/(N-1)*Fs];
end
ff=ff';

