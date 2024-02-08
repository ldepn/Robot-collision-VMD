function [filter_bs_s] = butt(x,low,high)
%设计一个带阻滤波器,要求把50Hz和400Hz的频率分量保留,其他分量滤掉
fs = 4096;
wp = [low high ] / (fs/2);  %通带截止频率?,50~100、200~400中间各取一个值,并对其归一化
ws = [low+50 high-50 ] / (fs/2);  %阻带截止频率?,50~100、200~400中间各取一个值,并对其归一化
alpha_p = 3; %通带允许最大衰减为  db
alpha_s = 20;%阻带允许最小衰减为  db
%获取阶数和截止频率
[ N4, wn ] = buttord( wp , ws , alpha_p , alpha_s);
%获得转移函数系数
[ b, a ] = butter(N4,wn,'stop');
%滤波
filter_bs_s = filter(b,a,x);
% X_bs_s = fftshift(abs(fft(filter_bs_s)))/N;
% X_bs_s_angle = fftshift(angle(fft(filter_bs_s)));
end

