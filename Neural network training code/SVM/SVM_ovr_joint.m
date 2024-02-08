
clc;
clear;
close all;
tic
% fprintf('-----已开始请等待-----\n\n');
%% 造数据不用关心，直接跳过
codenum = 0;
for w=1:10
% 训练数据
fprintf('-----已开始请等待-----\n\n');
data = load('feature_train.txt');
train_data = data(:,2:end-2);          
group_train = data(:,1);

%%
% 测试数据
test_data = load('feature_test.txt');
test_features = test_data(:,2:end-2);
% 测试数据的真实标签
test_labels = test_data(:,1);
true_value = test_labels;

%%
% 训练数据分为5类
% 类别i的 正样本 选择类别i的全部，负样本 从其余类别中随机选择（个数与正样本相同）
% 类别1
class1num = 5130;
class1_p = train_data(1:class1num,:);%623
% randperm(n,k)是从1到n的序号中随机返回k个
index1 = randperm(length(train_data)-class1num,class1num);
% 从其余样本中随机选择k个
train_data_c = train_data;
train_data_c(1:class1num,:) = [];
class1_n = train_data_c(index1,:);

train_features1 = [class1_p;class1_n];
% 正类表示为1，负类表示为-1
train_labels1 = [ones(class1num,1);-1*ones(class1num,1)];

% 类别2
class2num = 5130;
class2_p = train_data(class1num+1:class1num+class2num,:);
% randperm(n,k)是从1到n的序号中随机返回k个
index1 = randperm(length(train_data)-class2num,class2num);
% 从其余样本中随机选择k个
train_data_c = train_data;
train_data_c(class1num+1:class1num+class2num,:) = [];
class2_n = train_data_c(index1,:);

train_features2 = [class2_p;class2_n];
% 正类表示为1，负类表示为-1
train_labels2 = [ones(class2num,1);-1*ones(class2num,1)];


%%
% 分别训练5个类别的SVM模型
model1 = fitcsvm(train_features1,train_labels1,'ClassNames',{'-1','1'});
model2 = fitcsvm(train_features2,train_labels2,'ClassNames',{'-1','1'});
% model5 = fitcsvm(train_features5,train_labels5,'ClassNames',{'-1','1'});
fprintf('-----模型训练完毕-----\n\n');
%%
% label是n*1的矩阵，每一行是对应测试样本的预测标签；
% score是n*2的矩阵，第一列为预测为“负”的得分，第二列为预测为“正”的得分。
% 用训练好的5个SVM模型分别对测试样本进行预测分类，得到5个预测标签
[label1,score1] = predict(model1,test_features);
[label2,score2] = predict(model2,test_features);
% [label5,score5] = predict(model5,test_features);
% 求出测试样本在5个模型中预测为“正”得分的最大值，作为该测试样本的最终预测标签
score = [score1(:,2),score2(:,2)];
% score1 = score(:,1);
% 最终预测标签为k*1矩阵,k为预测样本的个数
final_labels = zeros(2567,1);
for i = 1:size(final_labels,1)
    % 返回每一行的最大值和其位置
    [m,p] = max(score(i,:));
    % 位置即为标签
    final_labels(i,:) = p;
end
predict_value = final_labels;
test_labels_type1 = zeros(2568,1);

acc_hand=0;
acc_nohand=0;

j=0;
for i=1:1284
    j=j+1;
%      [m predict_value] = max(YPred(i,:));
    if predict_value(i) == true_value(i)
        acc_hand=acc_hand+1;
    end
end
accuracy_hand = acc_hand/j;

j=0;
for i=1285:2567
    j=j+1;
%      [m predict_value] = max(YPred(i,:));
    if predict_value(i) == true_value(i)
        acc_nohand=acc_nohand+1;
    end
end
accuracy_nohand = acc_nohand/j;

accuracy_total = (acc_hand+acc_nohand)/length(true_value);
accuracy = [accuracy_hand accuracy_nohand accuracy_total];
codenum=codenum+1;
codenum = num2str(codenum);
str1='\model1.mat';str2='\model2.mat';str3='\acc.txt';
f_str1=strcat(codenum,str1);
f_str2=strcat(codenum,str2);
f_str3=strcat(codenum,str3);

save(['F:\外力碰撞代码\在线实验数据与程序\SVM\统计图滤波组\',f_str1],'model1');
save(['F:\外力碰撞代码\在线实验数据与程序\SVM\统计图滤波组\',f_str2],'model2');
save(['F:\外力碰撞代码\在线实验数据与程序\SVM\统计图滤波组\',f_str3],'accuracy','-ascii');
codenum = str2double(codenum);
end


