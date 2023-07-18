clc
clear
load my_BP.mat net;%加载训练好的网络模型net
load my_maxt;%加载训练好的网络模型的归一化最大值
load my_mint;%加载训练好的网络模型的归一化最小值
P=load('feature_test.txt');
input=P';
input_1=premnmx(input);%对待预测数据进行归一化处理
an=sim(net,input_1);
BPoutput_new=postmnmx(an,mint,maxt); %对预测数据结果进行反归一化处理
O=BPoutput_new';

