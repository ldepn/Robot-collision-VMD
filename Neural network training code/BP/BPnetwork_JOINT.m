%% 清空环境变量
clc
clear
codenum = 0;
for w=1:10
%% 训练数据预测数据提取及归一化
%下载输入输出数据，这里你可以改成自己想要训练的数据
data_train=load('feature_train.txt');
data_test=load('feature_test.txt');
%找出训练数据和预测数据
input_train=data_train(:,2:end-2)'; %对输入数据进行转置
output_train=data_train(:,1)';
input_test=data_test(:,2:end-2)';
output_test=data_test(:,1)';
true_value = output_test;

%选连样本输入输出数据归一化
[inputn,minp,maxp,outputn,mint,maxt]=premnmx(input_train,output_train);%归一化处理

%% BP网络训练
% %初始化网络结构
net=newff(minmax(input_train),[4,6,1],{'tansig','tansig','purelin'},'trainlm');%创建网络，表示有输入层4层，隐层6层，输出层1层
% 变学习率梯度下降算法  
%net.trainFcn='traingda';
%net.trainFcn='traingda';
net.trainParam.epochs=2000;%设置最大收敛次数
net.trainParam.lr=0.0001;%设置学习速率
net.trainParam.goal=0.00000001;%设置收敛误差
net.trainParam.showWindow = false;
% net.trainParam.mc=0.9;
% net.trainParam.show=50;
% net.trainParam.min_grad=1e-6;%设置最小性能梯度，一般取1e-6
% net.trainParam.min_fail=10;%设置最大确认失败次数

%网络训练
net=train(net,inputn,outputn);

%% BP网络预测
%预测数据归一化

[input_n,minp,maxp]=premnmx(input_test);%归一化处理

%网络预测输出
an=sim(net,input_n);

%网络输出反归一化
BPoutput=postmnmx(an,mint,maxt);
predict_value = BPoutput;
%% 结果分析
% figure(1)
% plot(BPoutput,':o')
% hold on
% plot(output_test,'-*');
% legend('预测输出','期望输出')
% title('BP网络预测输出','fontsize',12)
% ylabel('函数输出','fontsize',12)
% xlabel('样本','fontsize',12)

%预测误差
error1=(abs(BPoutput)-output_test)./output_test;
%标准


% figure(2)
% plot(error1,'-*')
% title('BP网络预测相对误差','fontsize',12)
% ylabel('相对误差','fontsize',12)
% xlabel('样本','fontsize',12)
% 
% figure(3)
% plot((output_test-BPoutput)./BPoutput,'-*');
% title('神经网络预测误差百分比')

error = BPoutput-output_test;
%errorsum=sqrt(sum(error.^2)/48);

mape=sum(abs(error./output_test))*(100/48);

acc_hand=0;
acc_nohand=0;

j=0;
for i=1:1284
    j=j+1;
    if predict_value(i)<true_value(i)+0.5&&predict_value(i)>true_value(i)-0.5
        acc_hand=acc_hand+1;
    end
end
accuracy_hand = acc_hand/j;

j=0;
for i=1285:2567
    j=j+1;
    if predict_value(i)<true_value(i)+0.5&&predict_value(i)>true_value(i)-0.5
        acc_nohand=acc_nohand+1;
    end
end
accuracy_nohand = acc_nohand/j;

accuracy_total = (acc_hand+acc_nohand)/length(true_value);
accuracy = [accuracy_hand accuracy_nohand accuracy_total];

codenum=codenum+1;
codenum = num2str(codenum);
str1='\BP.mat';str2='\maxp.mat';str3='\maxt.mat';str4='\minp.mat';str5='\mint.mat';str6='\acc.txt';
f_str1=strcat(codenum,str1);
f_str2=strcat(codenum,str2);
f_str3=strcat(codenum,str3);
f_str4=strcat(codenum,str4);
f_str5=strcat(codenum,str5);
f_str6=strcat(codenum,str6);

save(['F:\外力碰撞代码\在线实验数据与程序\BP\统计图滤波组\',f_str1],'net');
save(['F:\外力碰撞代码\在线实验数据与程序\BP\统计图滤波组\',f_str2],'maxp');
save(['F:\外力碰撞代码\在线实验数据与程序\BP\统计图滤波组\',f_str3],'maxt');
save(['F:\外力碰撞代码\在线实验数据与程序\BP\统计图滤波组\',f_str4],'minp');
save(['F:\外力碰撞代码\在线实验数据与程序\BP\统计图滤波组\',f_str5],'mint');
save(['F:\外力碰撞代码\在线实验数据与程序\BP\统计图滤波组\',f_str6],'accuracy','-ascii', '-append');
codenum = str2double(codenum);
end
% j=0;
% for i=1:length(output_test)
%     if BPoutput(i)<output_test(i)+0.5&&BPoutput(i)>output_test(i)-0.5
%         j=j+1;
%     end
% %     if output_test(i)==1
% %         j=j+1;
% %     end
% %     if output_test(i)==2
% %         j=j+1;
% %     end
% %     if output_test(i)==3
% %         j=j+1;
% %     end
% end
% accuracy = j/length(output_test)
%errorsum=sum((abs(error))*(abs(error))')
%errorsum2=errorsum/11
%errorsum3=sqrt(errorsum2)
%avg=mean(B)
% save my_BP net;%保存训练好的BP神经网络net于my_BP中
% save my_mint mint;%保存训练好的BP神经网络归一化后的最小值于my_mint中
% save my_maxt maxt;%保存训练好的BP神经网络归一化后的最大值于my_maxt中
