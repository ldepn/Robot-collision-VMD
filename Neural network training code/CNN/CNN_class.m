%% By_nanj2021.1.14

clear

clc

X=load('feature_train.txt');
XX=load('feature_test.txt');

train_x = X(:,2:end-2)';
test_x = XX(:,2:end-2)';
train_y= X(:,1)';
test_y = XX(:,1)';
true_value = XX(:,1)';
%1-624 625-1264 1265-1924
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
[train_x,train_ps]=method(train_x);
test_x=method('apply',test_x,train_ps);
[train_y,output_ps]=method(train_y);
test_y=method('apply',test_y,output_ps);

% 
% trainD=reshape(train_x,[28,1,1,2565]);%训练集输入
% testD=reshape(test_x,[28,1,1,642]);%测试集输入
trainD=reshape(train_x,[36,1,1,10260]);%训练集输入
testD=reshape(test_x,[36,1,1,2568]);%测试集输入
% trainD=reshape(train_x,[36,1,1,4355]);%训练集输入
% testD=reshape(test_x,[36,1,1,1092]);%测试集输入

% targetD = train_y;%训练集输出
% targetD_test  = test_y;%测试集输出
targetD = categorical(train_y);%训练集输出
targetD_test  = categorical(test_y);%测试集输出
% CNN模型建立

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
    imageInputLayer([36 1 1],"Name","imageinput")
    convolution2dLayer([3 1],12,"Name","conv","Padding","same")
    reluLayer("Name","relu_1")
    maxPooling2dLayer([2 1],"Name","maxpool","Padding","same",'Stride',2)
    batchNormalizationLayer("Name","batchnorm")
    fullyConnectedLayer(384,"Name","fc_1")
    reluLayer("Name","relu_2")
    fullyConnectedLayer(384,"Name","fc_2")
    fullyConnectedLayer(4,"Name","fc_3")%输出种类
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
% codenum = 1;
% for w=1:16
% 训练
net = trainNetwork(trainD,targetD',layers,options);
% 预测
YPred = predict(net,testD);
% [m predict_value] = max(YPred);
% 结果
% YPred=double(YPred');%输出是n*1的single型数据，要转换为1*n的double是数据形式
% accuracy = sum(YPred == targetD_test)/numel(targetD_test)


% 反归一化
% inputn_test= mapminmax('apply',input_test,inputps);   %测试输入数据归一化
% BPoutput= mapminmax('reverse',an,outputps);   %网络预测数据反归一化
% true_value = postmnmx(YPred,1,2);
% predict_value=postmnmx(YPred,1,2);
% predict_value=method('reverse',YPred,output_ps);predict_value=double(predict_value);
% true_value=method('reverse',targetD_test,output_ps);true_value=double(true_value);

% figure
% plot(true_value,'-*','linewidth',3)
% hold on
% plot(predict_value,'-s','linewidth',3)
% legend('实际值','预测值')
% grid on

acc_hand=0;
acc_paper=0;
acc_rubber=0;
acc_iron=0;

j=0;
for i=1:624
    j=j+1;
     [m predict_value] = max(YPred(i,:));
    if predict_value == true_value(i)
        acc_hand=acc_hand+1;
    end
end
accuracy_hand = acc_hand/j;

j=0;
for i=625:1264
    j=j+1;
     [m predict_value] = max(YPred(i,:));
    if predict_value == true_value(i)
        acc_paper=acc_paper+1;
    end
end
accuracy_paper = acc_paper/j;

j=0;
for i=1265:1924
        j=j+1;
     [m predict_value] = max(YPred(i,:));
    if predict_value == true_value(i)
        acc_rubber=acc_rubber+1;
    end
end
accuracy_rubber = acc_rubber/j;

j=0;
for i=1925:2568
    j=j+1;
     [m predict_value] = max(YPred(i,:));
    if predict_value == true_value(i)
        acc_iron=acc_iron+1;
    end
end
accuracy_iron = acc_iron/j;
accuracy_total = (acc_hand+acc_paper+acc_rubber+acc_iron)/length(true_value);
accuracy = [accuracy_hand accuracy_paper accuracy_rubber accuracy_iron accuracy_total];

% codenum=codenum+1;
% codenum = num2str(codenum);
% str1='\CNN.mat';str2='\train_ps.mat';str3='\output_ps.mat';str4='\acc.txt';
% f_str1=strcat(codenum,str1);
% f_str2=strcat(codenum,str2);
% f_str3=strcat(codenum,str3);
% f_str4=strcat(codenum,str4);
% 
% save(['F:\外力碰撞代码\在线实验数据与程序\CNN\统计图滤波组\',f_str1],'net');
% save(['F:\外力碰撞代码\在线实验数据与程序\CNN\统计图滤波组\',f_str2],'train_ps');
% save(['F:\外力碰撞代码\在线实验数据与程序\CNN\统计图滤波组\',f_str3],'output_ps');
% save(['F:\外力碰撞代码\在线实验数据与程序\CNN\统计图滤波组\',f_str4],'accuracy','-ascii', '-append');
% codenum = str2double(codenum);
% end
figure(2)
% save('feature_rubber_VMD.txt','data','-ascii', '-append');
% rmse=sqrt(mean((true_value-predict_value).^2));
% disp(['根均方差(RMSE)：',num2str(rmse)])
% mae=mean(abs(true_value-predict_value));
% disp(['平均绝对误差（MAE）：',num2str(mae)])
% mape=mean(abs((true_value-predict_value)./true_value));
% disp(['平均相对百分误差（MAPE）：',num2str(mape*100),'%'])





