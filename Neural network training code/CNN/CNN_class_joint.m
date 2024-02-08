%% By_nanj2021.1.14

clear

clc

X=load('feature_train.txt');
XX=load('feature_test.txt');
codenum=0;
train_x = X(:,2:end-2)';
test_x = XX(:,2:end-2)';
train_y= X(:,1)';
test_y = XX(:,1)';
true_value = test_y;
% train_y= X(:,4)';
% test_y = XX(:,4)';

% method=@mapminmax;
% % method=@mapstd;
% [train_x,train_ps]=method(train_x);
% test_x=method('apply',test_x,train_ps);
% [train_y,output_ps]=method(train_y);
% test_y=method('apply',test_y,output_ps);


% 归一化处理
% [train_x,train_xps]=mapminmax(train_x);
% [train_y,train_yps]=mapminmax(train_y);
% [test_x,test_xps]=mapminmax(test_x);
% [test_y,test_yps]=mapminmax(test_y);
method=@mapminmax;
% method=@mapstd;
[train_x,train_ps_joint]=method(train_x);
test_x=method('apply',test_x,train_ps_joint);
[train_y,output_ps_joint]=method(train_y);
test_y=method('apply',test_y,output_ps_joint);


trainD=reshape(train_x,[20,1,1,10261]);%训练集输入
testD=reshape(test_x,[20,1,1,2567]);%测试集输入
% targetD = train_y;%训练集输出
% targetD_test  = test_y;%测试集输出
targetD = categorical(train_y);%训练集输出
targetD_test  = categorical(test_y);%测试集输出
% CNN模型建立
for w=1:10
% layers = [
%     imageInputLayer([32 1 1]) %输入层参数设置
%     convolution2dLayer([3,1],16,'Padding','same')%卷积层的核大小[3 1],因为我们的输入是[336 1],是一维的数据，所以卷积核第二个参数为1就行了，这样就是1d卷积
% %、数量，填充方式
%     reluLayer%relu激活函数
%     maxPooling2dLayer([2 1],'Stride',2)% 2x1 kernel stride=2
%     fullyConnectedLayer(384) % 384 全连接层神经元
%     reluLayer%relu激活函数
%     fullyConnectedLayer(384) % 384 全连接层神经元
%     fullyConnectedLayer(1) % 输出层神经元
%     regressionLayer];%添加回归层，用于计算损失值

layers = [
    imageInputLayer([20 1 1],"Name","imageinput")
    convolution2dLayer([3 1],12,"Name","conv","Padding","same")
    reluLayer("Name","relu_1")
    maxPooling2dLayer([2 1],"Name","maxpool","Padding","same",'Stride',2)
    batchNormalizationLayer("Name","batchnorm")
    fullyConnectedLayer(384,"Name","fc_1")
    reluLayer("Name","relu_2")
    fullyConnectedLayer(384,"Name","fc_2")
    fullyConnectedLayer(2,"Name","fc_3")
    softmaxLayer("Name","softmax")
    classificationLayer("Name","classoutput")];

options = trainingOptions('sgdm', ...
    'MaxEpochs',20, ...
    'MiniBatchSize',32, ...
    'InitialLearnRate',0.005, ...
    'GradientThreshold',1, ...
    'Verbose',false,...
    'Plots','training-progress',...
    'ValidationData',{testD,targetD_test'});
%这里要吐槽一下，输入数据都是最后一维为样本数，偏偏输出要第一维为样本数，所以targetD和targetD_test都取了转置

% 训练
net_joint = trainNetwork(trainD,targetD',layers,options);
% 预测
YPred = predict(net_joint,testD);
% [m predict_value] = max(YPred(1,:))

acc_hand=0;
acc_nohand=0;

j=0;
for i=1:1284
    j=j+1;
     [m predict_value] = max(YPred(i,:));
    if predict_value == true_value(i)
        acc_hand=acc_hand+1;
    end
end
accuracy_hand = acc_hand/j;

j=0;
for i=1285:2567
    j=j+1;
     [m predict_value] = max(YPred(i,:));
    if predict_value == true_value(i)
        acc_nohand=acc_nohand+1;
    end
end
accuracy_nohand = acc_nohand/j;

accuracy_total = (acc_hand+acc_nohand)/length(true_value);
accuracy = [accuracy_hand accuracy_nohand accuracy_total];

codenum=codenum+1;
codenum = num2str(codenum);
str1='\CNN.mat';str2='\train_ps.mat';str3='\output_ps.mat';str4='\acc.txt';
f_str1=strcat(codenum,str1);
f_str2=strcat(codenum,str2);
f_str3=strcat(codenum,str3);
f_str4=strcat(codenum,str4);

save(['F:\外力碰撞代码\在线实验数据与程序\CNN\统计图滤波组\',f_str1],'net_joint');
save(['F:\外力碰撞代码\在线实验数据与程序\CNN\统计图滤波组\',f_str2],'train_ps_joint');
save(['F:\外力碰撞代码\在线实验数据与程序\CNN\统计图滤波组\',f_str3],'output_ps_joint');
save(['F:\外力碰撞代码\在线实验数据与程序\CNN\统计图滤波组\',f_str4],'accuracy','-ascii');
codenum = str2double(codenum);
end




