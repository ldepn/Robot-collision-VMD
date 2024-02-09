clc;
clear;
load('f.mat');
namelist = dir('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\*.mat');
% name = ('F:\外力碰撞实验的样本数据\1_20_18.07\K=4和K=6\1thcollsion\*.mat');
U11_K4 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(1).name)).U11;
U11_K6 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(2).name)).U11;
U12_K4 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(3).name)).U12;
U12_K6 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(4).name)).U12;
U13_K4 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(5).name)).U13;
U13_K6 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(6).name)).U13;
U14_K6 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(7).name)).U14;
U15_K6 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(8).name)).U15;
U31_K4 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(9).name)).U31;
U31_K6 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(10).name)).U31;
U32_K4 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(11).name)).U32;
U32_K6 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(12).name)).U32;
U33_K4 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(13).name)).U33;
U33_K6 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(14).name)).U33;
U34_K6 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(15).name)).U34;
U35_K6 = load(strcat(('F:\TIM论文展示所需\Sample simulation comparison\1stcollsion\'),namelist(16).name)).U35;
figure(1)
subplot(5,2,1)
plot(f,U11_K4);hold on;
plot(f,U31_K4);
legend('senor of link1','senor of link2');

subplot(5,2,3)
plot(f,U12_K4);hold on;
plot(f,U32_K4);
legend('senor of link1','senor of link2');

subplot(5,2,5)
plot(f,U13_K4);hold on;
plot(f,U33_K4);
legend('senor of link1','senor of link2');

subplot(5,2,2)
plot(f,U11_K6);hold on;
plot(f,U31_K6);
legend('senor of link1','senor of link2');

subplot(5,2,4)
plot(f,U12_K6);hold on;
plot(f,U32_K6);
legend('senor of link1','senor of link2');

subplot(5,2,6)
plot(f,U13_K6);hold on;
plot(f,U33_K6);
legend('senor of link1','senor of link2');

subplot(5,2,8)
plot(f,U14_K6);hold on;
plot(f,U34_K6);
legend('senor of link1','senor of link2');

subplot(5,2,10)
plot(f,U15_K6);hold on;
plot(f,U35_K6);
legend('senor of link1','senor of link2');


