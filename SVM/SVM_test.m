
clc;
clear;
close all;
tic
fprintf('-----已开始请等待-----\n\n');
%% 造数据不用关心，直接跳过
% 造数据 20*2
data = [0.4,0.3;-0.5,0.1;-0.2,-0.3;0.5,-0.3;
        2.1,1.9;1.8,2.2;1.7,2.5;2.3,1.6;
        -2.2,1.6;-1.9,2.1;-1.7,2.6;-2.3,2.5;
        -3.1,-1.9;-2.8,-2.1;-1.9,-2.5;-2.3,-3.2;
        3.9,-3.5;2.8,-2.2;1.7,-3.1;2.5,-3.4];
data1 = data + 2.5*rand(20,2);
data2 = data + 2.5*rand(20,2);
data3 = data + 2.5*rand(20,2); data1(17:20,:);
% 训练数据
train_data = [data1(1:4,:);data2(1:4,:);data3(1:4,:);
              data1(5:8,:);data2(5:8,:);data3(5:8,:);
              data1(9:12,:);data2(9:12,:);data3(9:12,:);
              data1(13:16,:);data2(13:16,:);data3(13:16,:);
              data1(17:20,:);data2(17:20,:);data3(17:20,:)];
                  
% 画图显示
figure;
% gscatter函数可以按分类或者分组画离散点
% group为分组向量，对应每一个坐标的类别
group_train = [1;1;1;1;1;1;1;1;1;1;1;1;
         2;2;2;2;2;2;2;2;2;2;2;2;
         3;3;3;3;3;3;3;3;3;3;3;3;
         4;4;4;4;4;4;4;4;4;4;4;4;
         5;5;5;5;5;5;5;5;5;5;5;5];
gscatter(train_data(:,1),train_data(:,2),group_train);

title('训练数据样本分布');
xlabel('样本特征1');
ylabel('样本特征2');
legend('Location','Northwest');
grid on;

%%
% 测试数据
test_data = data + 3.0*rand(20,2);
test_features = test_data;
% 测试数据的真实标签
test_labels = [1;1;1;1;2;2;2;2;3;3;3;3;4;4;4;4;5;5;5;5];

%%
% 训练数据分为5类
% 类别i的 正样本 选择类别i的全部，负样本 从其余类别中随机选择（个数与正样本相同）
% 类别1
class1_p = train_data(1:12,:);
% randperm(n,k)是从1到n的序号中随机返回k个
index1 = randperm(48,12);
% 从其余样本中随机选择k个
train_data_c = train_data;
train_data_c(1:12,:) = [];
class1_n = train_data_c(index1,:);

train_features1 = [class1_p;class1_n];
% 正类表示为1，负类表示为-1
train_labels1 = [ones(12,1);-1*ones(12,1)];

% 类别2
class2_p = train_data(13:24,:);
% randperm(n,k)是从1到n的序号中随机返回k个
index1 = randperm(48,12);
% 从其余样本中随机选择k个
train_data_c = train_data;
train_data_c(13:24,:) = [];
class2_n = train_data_c(index1,:);

train_features2 = [class2_p;class2_n];
% 正类表示为1，负类表示为-1
train_labels2 = [ones(12,1);-1*ones(12,1)];

% 类别3
class3_p = train_data(25:36,:);
% randperm(n,k)是从1到n的序号中随机返回k个
index1 = randperm(48,12);
% 从其余样本中随机选择k个
train_data_c = train_data;
train_data_c(25:36,:) = [];
class3_n = train_data_c(index1,:);

train_features3 = [class3_p;class3_n];
% 正类表示为1，负类表示为-1
train_labels3 = [ones(12,1);-1*ones(12,1)];

% 类别4
class4_p = train_data(37:48,:);
% randperm(n,k)是从1到n的序号中随机返回k个
index1 = randperm(48,12);
% 从其余样本中随机选择k个
train_data_c = train_data;
train_data_c(37:48,:) = [];
class4_n = train_data_c(index1,:);

train_features4 = [class4_p;class4_n];
% 正类表示为1，负类表示为-1
train_labels4 = [ones(12,1);-1*ones(12,1)];

% 类别5
class5_p = train_data(49:60,:);
% randperm(n,k)是从1到n的序号中随机返回k个
index1 = randperm(48,12);
% 从其余样本中随机选择k个
train_data_c = train_data;
train_data_c(49:60,:) = [];
class5_n = train_data_c(index1,:);

train_features5 = [class5_p;class5_n];
% 正类表示为1，负类表示为-1
train_labels5 = [ones(12,1);-1*ones(12,1)];

%%
% 分别训练5个类别的SVM模型
model1 = fitcsvm(train_features1,train_labels1,'ClassNames',{'-1','1'});
model2 = fitcsvm(train_features2,train_labels2,'ClassNames',{'-1','1'});
model3 = fitcsvm(train_features3,train_labels3,'ClassNames',{'-1','1'});
model4 = fitcsvm(train_features4,train_labels4,'ClassNames',{'-1','1'});
model5 = fitcsvm(train_features5,train_labels5,'ClassNames',{'-1','1'});
fprintf('-----模型训练完毕-----\n\n');
%%
% label是n*1的矩阵，每一行是对应测试样本的预测标签；
% score是n*2的矩阵，第一列为预测为“负”的得分，第二列为预测为“正”的得分。
% 用训练好的5个SVM模型分别对测试样本进行预测分类，得到5个预测标签
[label1,score1] = predict(model1,test_features);
[label2,score2] = predict(model2,test_features);
[label3,score3] = predict(model3,test_features);
[label4,score4] = predict(model4,test_features);
[label5,score5] = predict(model5,test_features);
% 求出测试样本在5个模型中预测为“正”得分的最大值，作为该测试样本的最终预测标签
score = [score1(:,2),score2(:,2),score3(:,2),score4(:,2),score5(:,2)];
% 最终预测标签为k*1矩阵,k为预测样本的个数
final_labels = zeros(20,1);
for i = 1:size(final_labels,1)
    % 返回每一行的最大值和其位置
    [m,p] = max(score(i,:));
    % 位置即为标签
    final_labels(i,:) = p;
end
fprintf('-----样本预测完毕-----\n\n');
% 分类评价指标

group = test_labels; % 真实标签
grouphat = final_labels; % 预测标签
[C,order] = confusionmat(group,grouphat,'Order',[1;2;3;4;5]); % 'Order'指定类别的顺序
c1_p = C(1,1) / sum(C(:,1));
c1_r = C(1,1) / sum(C(1,:));
c1_F = 2*c1_p*c1_r / (c1_p + c1_r);
fprintf('c1类的查准率为%f,查全率为%f,F测度为%f\n\n',c1_p,c1_r,c1_F);

c2_p = C(2,2) / sum(C(:,2));
c2_r = C(2,2) / sum(C(2,:));
c2_F = 2*c2_p*c2_r / (c2_p + c2_r);
fprintf('c2类的查准率为%f,查全率为%f,F测度为%f\n\n',c2_p,c2_r,c2_F);

c3_p = C(3,3) / sum(C(:,3));
c3_r = C(3,3) / sum(C(3,:));
c3_F = 2*c3_p*c3_r / (c3_p + c3_r);
fprintf('c3类的查准率为%f,查全率为%f,F测度为%f\n\n',c3_p,c3_r,c3_F);

c4_p = C(4,4) / sum(C(:,4));
c4_r = C(4,4) / sum(C(4,:));
c4_F = 2*c4_p*c4_r / (c4_p + c4_r);
fprintf('c4类的查准率为%f,查全率为%f,F测度为%f\n\n',c4_p,c4_r,c4_F);

c5_p = C(5,5) / sum(C(:,5));
c5_r = C(5,5) / sum(C(5,:));
c5_F = 2*c5_p*c5_r / (c5_p + c5_r);
fprintf('c5类的查准率为%f,查全率为%f,F测度为%f\n\n',c5_p,c5_r,c5_F);  
            
            
figure;
subplot(121);
% gscatter函数可以按分类或者分组画离散点
% group为分组向量，对应每一个坐标的类别
group_test = test_labels;
gscatter(test_data(:,1),test_data(:,2),group_test);

title('测试数据样本真实分布');
xlabel('样本特征1');
ylabel('样本特征2');
legend('Location','Northwest');
grid on;

subplot(122);
% gscatter函数可以按分类或者分组画离散点
% group为分组向量，对应每一个坐标的类别
group_test = final_labels;
gscatter(test_data(:,1),test_data(:,2),group_test);

title('测试数据样本预测分布');
xlabel('样本特征1');
ylabel('样本特征2');
legend('Location','Northwest');
grid on;

