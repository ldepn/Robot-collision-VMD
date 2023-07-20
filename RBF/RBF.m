clc;
clear all;
close all;

%% 网络的构建和训练
% 训练数据，输入为9*3的矩阵，9个输入，带有3个特征

% 从输出目标可以看到输入分为3类
test_data = load('feature_test.txt');
train_data = load('feature_train.txt');
train_feature = train_data(:,2:end)';
test_feature = test_data(:,2:end)';
train_labels = train_data(:,1)';
test_labels = test_data(:,1)';
method=@mapminmax;
[train_feature,train_ps]=method(train_feature);
test_feature=method('apply',test_feature,train_ps);
[train_labels,output_ps]=method(train_labels);
test_labels=method('apply',test_labels,output_ps);

% % 利用数据构建RBF神经网络并训练
net = newrb(train_feature,train_labels,0.05 );  % 注意矩阵的转置
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
% acc_h=0;
% acc_p=0;
% acc_i=0;
% acc_r=0;
% for i=1:length(true_value)
%     if true_value(i) == 1
%        if predict_value(i)<true_value(i)+0.5&&predict_value(i)>true_value(i)-0.5
%           acc_h=acc_h+1;
%        end
%     elseif true_value(i) == 2
%        if predict_value(i)<true_value(i)+0.5&&predict_value(i)>true_value(i)-0.5
%           acc_p=acc_p+1;
%        end
%     elseif true_value(i) == 3
%        if predict_value(i)<true_value(i)+0.5&&predict_value(i)>true_value(i)-0.5
%           acc_r=acc_r+1;
%        end
%     elseif true_value(i) == 4
%        if predict_value(i)<true_value(i)+0.5&&predict_value(i)>true_value(i)-0.5
%           acc_i=acc_i+1;
%        end
%     end
% end
% accuracy_h = acc_h/156;
% accuracy_p = acc_p/162;
% accuracy_i = acc_i/161;
% accuracy_r = acc_r/165;
% acc_total = (acc_h+acc_p+acc_i+acc_r)/644;
% acc_cnn = [accuracy_h accuracy_p accuracy_i accuracy_r acc_total];
% save('acc.txt','acc_cnn','-ascii', '-append');
% acc_1=0;
% acc_2=0;
% for i=1:length(true_value)
%     if true_value(i) == 1
%        if predict_value(i)<true_value(i)+0.5&&predict_value(i)>true_value(i)-0.5
%           acc_1=acc_1+1;
%        end
%     elseif true_value(i) == 2
%        if predict_value(i)<true_value(i)+0.5&&predict_value(i)>true_value(i)-0.5
%           acc_2=acc_2+1;
%        end
%     end
% end
% accuracy_1 = acc_1/323;
% accuracy_2 = acc_2/321;
% 
% acc_total = (acc_1+acc_2)/644;
% acc_cnn = [accuracy_1 accuracy_2 acc_total];
% save('acc_cnn.txt','acc_cnn','-ascii', '-append');
rmse=sqrt(mean((true_value-predict_value).^2));
disp(['根均方差(RMSE)：',num2str(rmse)])
mae=mean(abs(true_value-predict_value));
disp(['平均绝对误差（MAE）：',num2str(mae)])
mape=mean(abs((true_value-predict_value)./true_value));
disp(['平均相对百分误差（MAPE）：',num2str(mape*100),'%'])
m=[rmse mae mape];
save('RMSE_MAE_MAPE.txt','m','-ascii', '-append');
save('RBF.mat','net');
save('output_ps.mat','output_ps');
save('train_ps.mat','train_ps');
figure(2)
plot(predict_value);hold on;
plot(true_value);legend('预测值','实际值');
% performance = acc/length(test_feature)
