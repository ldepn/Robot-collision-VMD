%% By_nanj2021.1.14

clear

clc

X=load('feature_train.txt');
XX=load('feature_test.txt');

train_x = X(:,5:end)';
test_x = XX(:,5:end)';
train_y= X(:,4)';
test_y = XX(:,4)';

% method=@mapminmax;
% % method=@mapstd;
% [train_x,train_ps]=method(train_x);
% test_x=method('apply',test_x,train_ps);
% [train_y,output_ps]=method(train_y);
% test_y=method('apply',test_y,output_ps);


% 归一化处理
method=@mapminmax;
% method=@mapstd;
[train_x,train_ps]=method(train_x);
test_x=method('apply',test_x,train_ps);
[train_y,output_ps]=method(train_y);
test_y=method('apply',test_y,output_ps);


trainD=reshape(train_x,[12,1,1,336]);%训练集输入
testD=reshape(test_x,[12,1,1,144]);%测试集输入
targetD = train_y;%训练集输出
targetD_test  = test_y;%测试集输出
% CNN模型建立

layers = [
    imageInputLayer([12 1 1]) %输入层参数设置
    convolution2dLayer([3,1],16,'Padding','same')%卷积层的核大小[3 1],因为我们的输入是[336 1],是一维的数据，所以卷积核第二个参数为1就行了，这样就是1d卷积
%、数量，填充方式
    reluLayer%relu激活函数
    maxPooling2dLayer([2 1],'Stride',2)% 2x1 kernel stride=2
    fullyConnectedLayer(384) % 384 全连接层神经元
    reluLayer%relu激活函数
    fullyConnectedLayer(384) % 384 全连接层神经元
    fullyConnectedLayer(1) % 输出层神经元
    regressionLayer];%添加回归层，用于计算损失值

options = trainingOptions('adam', ...
    'MaxEpochs',70, ...
    'MiniBatchSize',16, ...
    'InitialLearnRate',0.005, ...
    'GradientThreshold',1, ...
    'Verbose',false,...
    'Plots','training-progress',...
    'ValidationData',{testD,targetD_test'});
%这里要吐槽一下，输入数据都是最后一维为样本数，偏偏输出要第一维为样本数，所以targetD和targetD_test都取了转置

% 训练
net = trainNetwork(trainD,targetD',layers,options);
% 预测
YPred = predict(net,testD);
 
% 结果
YPred=double(YPred');%输出是n*1的single型数据，要转换为1*n的double是数据形式
% accuracy = sum(YPred == targetD_test)/numel(targetD_test)


% 反归一化
predict_value=method('reverse',YPred,output_ps);predict_value=double(predict_value);
true_value=method('reverse',targetD_test,output_ps);true_value=double(true_value);

figure
plot(true_value,'-*','linewidth',3)
hold on
plot(predict_value,'-s','linewidth',3)
legend('实际值','预测值')
grid on

j=0;
for i=1:length(true_value)
    if predict_value(i)<true_value(i)+0.5&&predict_value(i)>true_value(i)-0.5
        j=j+1;
    end
end
accuracy = j/length(true_value)
 
rmse=sqrt(mean((true_value-predict_value).^2));
disp(['根均方差(RMSE)：',num2str(rmse)])
mae=mean(abs(true_value-predict_value));
disp(['平均绝对误差（MAE）：',num2str(mae)])
mape=mean(abs((true_value-predict_value)./true_value));
disp(['平均相对百分误差（MAPE）：',num2str(mape*100),'%'])





