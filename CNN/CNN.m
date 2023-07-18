clc
clear
close all

% 读取数据
load('notMNIST_small.mat')

% 选取部分数据可视化
for i=1:1:32
    subplot(4,8,i);
    imshow(images(:,:,555*i)/255)
end

% 
X = reshape(images, [28,28,1,length(images)]); % 灰度图片的作为输入的要求为h*w**c*s,
                                               % 其中h为图片的长度，w为宽度，c为通道数，s就是数据的个数
size(X)                                        % 可以看到我们的数据集尺寸为：28*28*1*18724
Y = categorical(labels);                       % 标签的数据类型为categorical

idx = randperm(length(images));   % 产生一个和数据个数一致的随机数序列
num_train = round(0.5*length(X)); % 训练集个数，0.5表示全部数据中随机选取50%作为训练集
num_val = round(0.3*length(X));   % 验证集个数，0.3表示全部数据中随机选取30%作为验证集，故测试集自动变为剩下的20%

% 训练集，验证集和测试集数据
X_train = X(:,:,:,idx(1:num_train));
X_val = X(:,:,:,idx(num_train+1:num_train+num_val));
X_test = X(:,:,:,idx(num_train+num_val+1:end));  %这里假设，全部数据中除了

% 训练集，验证集和测试集标签
Y_train = Y(idx(1:num_train),:);
Y_val = Y(idx(num_train+1:num_train+num_val),:);
Y_test = Y(idx(num_train+num_val+1:end),:);

layers = [...
          imageInputLayer([28,28,1]); % 输入层，要正确输入图片的height, width 和 number of channels of the images
          batchNormalizationLayer();  % 批量归一化
          convolution2dLayer(5,20);   % 卷积层
          batchNormalizationLayer();
          reluLayer()                 % Relu激活函数 
          maxPooling2dLayer(2,'Stride',2); % 池化层
          fullyConnectedLayer(10);       % 全连接层
          softmaxLayer();                % softmax层
          classificationLayer(),...
    ];

%没有验证集
% 参数
% options = trainingOptions('sgdm',...   % 也可以用adam、rmsprop等方法
%     'MaxEpochs',50,...                 % 最大迭代次数
%     'Plots','training-progress');
% net_cnn = trainNetwork(X_train,Y_train,layers,options);

%有验证集
options = trainingOptions('sgdm',...                         % 也可以用adam、rmsprop等方法
                          'MiniBatchSize',128, ...
                          'MaxEpochs',50,...                 % 最大迭代次数
                          'ValidationData',{X_val,Y_val},... % 显示验证集误差
                          'Verbose',true, ...                % 命令窗口显示训练过程的各种指标
                          'Shuffle','every-epoch', ...
                          'InitialLearnRate',1e-2,...
                          'Plots','training-progress');
%  le=gpuArray(0.0001);
net_cnn = trainNetwork(X_train,Y_train,layers,options);
% save(net_cnn.mat, 'net_cnn');
testLabel = classify(net_cnn,X_test);
precision = sum(testLabel==Y_test)/numel(testLabel);
disp(['测试集分类准确率为',num2str(precision*100),'%'])