function [f,output] = FFFFT(y)
  fs=4096;%采样率
  T=0.1;
  N=round(T*fs)+1;
  Y = abs(fft(y)/N);%双边频谱
  Y = Y(1:floor(N/2+1));%单边取一半
  Y(2:end-1) = 2*Y(2:end-1);%非0频幅值要乘2
  f = fs*(0:(N/2))/N;%频率刻度
  output = abs(Y);
end

