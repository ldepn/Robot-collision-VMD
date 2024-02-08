function [] = data_classs()

clear

clc

data_hand=load('feature_joint1_VMD.txt');
data_paper=load('feature_joint2_VMD.txt');

handnum=length(data_hand);
papernum=length(data_paper);

handnum_test=ceil(length(data_hand)*0.2);
papernum_test=ceil(length(data_paper)*0.2);

r1 = randperm(handnum,handnum_test);
r2 = randperm(papernum,papernum_test);

t1 = zeros(handnum_test,1);
t2 = zeros(papernum_test,1);

testnum = ceil(length(data_hand)*0.2)+ceil(length(data_paper)*0.2);
trainnum = length(data_hand)+length(data_paper)-testnum;

feature_test = zeros(testnum,39);
feature_train = zeros(trainnum,39);

% 每组取20%作为测试集，最后全塞在一起
for i=1:ceil(length(data_hand)*0.2)
feature_test(i,:) = data_hand(r1(i),1:end);
end


for i=1:ceil(length(data_paper)*0.2)
feature_test(i+ceil(length(data_hand)*0.2),:) = data_paper(r2(i),1:end);
end


%剩下的全部作为训练集

for i=1:handnum
    t1(i)=i;
end
for i=1:papernum
    t2(i)=i;
end


for i=1:handnum
   for j=1:handnum_test
    if  t1(i) ==r1(j)
        t1(i) = 0;
    end
   end
end
for i=1:papernum
   for j=1:papernum_test
    if  t2(i) ==r2(j)
        t2(i) = 0;
    end
   end
end

j=1;
for i=1:handnum
       if t1(i)~=0
          feature_train(j,1:end) = data_hand(i,1:end);
          j=j+1;
       else 
          continue;
       end
end

for i=1:papernum
       if t2(i)~=0
          feature_train(j,1:end) = data_paper(i,1:end);
          j=j+1;
       else 
          continue;
       end
end


% % 
save('feature_test.txt','feature_test','-ascii');
save('feature_train.txt','feature_train','-ascii');
end

