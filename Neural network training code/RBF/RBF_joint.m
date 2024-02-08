clc;
clear all;
close all;

%% 网络的构建和训练
% 训练数据，输入为9*3的矩阵，9个输入，带有3个特征

codenum = 0;
for w=1:10
data_class();
% 从输出目标可以看到输入分为3类
test_data = load('feature_test.txt');
train_data = load('feature_train.txt');
train_feature = train_data(:,2:end-2)';
test_feature = test_data(:,2:end-2)';
train_labels = train_data(:,1)';
test_labels = test_data(:,1)';
method=@mapminmax;
[train_feature,train_ps]=method(train_feature);
test_feature=method('apply',test_feature,train_ps);
[train_labels,output_ps]=method(train_labels);
test_labels=method('apply',test_labels,output_ps);

% % 利用数据构建RBF神经网络并训练
net = newrb(train_feature,train_labels,0.24);  % 注意矩阵的转置
%  save('net_test.mat','net');       % 将网络net保存为.mat文件，后面可直接调用

% 查看效果
% y = sim(net,data');  % 网络对输入进行运算得到输出y
% y=round(y);          % 将输出y的近似值作为分类结果
% performance = sum(target==y')/size(target,1)  % 计算网络输出和实际输出的对应程度

%% 测试训练后的模型
%  load('RBF_net.mat');     % 导入之前保存的网络
% acc=0;
YPred = sim(net,test_feature);
% 结果
YPred=double(YPred');%输出是n*1的single型数据，要转换为1*n的double是数据形式
% accuracy = sum(YPred == targetD_test)/numel(targetD_test)
% 反归一化
predict_value=method('reverse',YPred,output_ps);predict_value=double(predict_value);
true_value=method('reverse',test_labels,output_ps);true_value=double(true_value)';


% predict_value = zeros(length(test_feature),1);
% for i=1:length(test_feature)
%     YPred = sim(net,test_feature(i,:)'); % 利用训练后的网络对新数据进行分类
%     % 反归一化
%     predict_value=method('reverse',YPred,output_ps);
%     true_value=method('reverse',test_labels,output_ps);
% %    predict_value(i) = y; 
%     if test_labels(i) == round(y)
%         acc=acc+1;
%         predict_value(i) = y; 
%     end
% end
% j=0;
% for i=1:length(true_value)
%     if predict_value(i)<true_value(i)+0.5&&predict_value(i)>true_value(i)-0.5
%         j=j+1;
%     end
% end
% figure(2)
% plot(true_value);hold on;
% plot(predict_value);hold on;
% accuracy = j/length(true_value)
% performance = acc/length(test_feature)


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
str1='\RBF.mat';str2='\train_ps.mat';str3='\output_ps.mat';str4='\acc.txt';
f_str1=strcat(codenum,str1);
f_str2=strcat(codenum,str2);
f_str3=strcat(codenum,str3);
f_str4=strcat(codenum,str4);

save(['F:\外力碰撞代码\在线实验数据与程序\RBF\统计图VMD\',f_str1],'net');
save(['F:\外力碰撞代码\在线实验数据与程序\RBF\统计图VMD\',f_str2],'train_ps');
save(['F:\外力碰撞代码\在线实验数据与程序\RBF\统计图VMD\',f_str3],'output_ps');
save(['F:\外力碰撞代码\在线实验数据与程序\RBF\统计图VMD\',f_str4],'accuracy','-ascii');
codenum = str2double(codenum);
end
