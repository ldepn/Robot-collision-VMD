%% By_nanj2021.1.14

clear

clc

X=load('feature_train.txt');

Xtrain1 = X(:,5:end)';


Xtrain=reshape(Xtrain1,[12,1,1,336]);

ytrain1=X(:,4)';

ytrain=categorical(ytrain1); % 函数包要求标签类型是categorical



layers = [ ...
imageInputLayer([1 12 1])%%2D-CNN
convolution2dLayer([6,1],4)
reluLayer
maxPooling2dLayer([6 1],'Stride',6)
convolution2dLayer([6,1],4)
reluLayer
maxPooling2dLayer([6 1],'Stride',6)
fullyConnectedLayer(6)
softmaxLayer
classificationLayer];



options = trainingOptions('adam', ...
'ExecutionEnvironment','cpu', ...
'MaxEpochs',100,...
'MiniBatchSize',27, ...
'GradientThreshold',1, ...
'Verbose',false, ...
'Plots','training-progress');

net = trainNetwork(Xtrain,ytrain,layers,options); % 网络训练

XX=load('feature_test.txt');

Xtest1=XX(:,5:end)';

Xtest=reshape(Xtest1,[12,1,1,144]);

ytest1=XX(:,4)';

ytest=categorical(ytest1); %函数包要求标签类型是categorical

YPred = classify(net,Xtest); %网络测试

YPred1 =double(YPred); %转化为可显示的标签

accuracy = sum(YPred == ytest)/numel(ytest)