
clear

clc

data_paper=load('feature_paper.txt');
data_iron=load('feature_iron.txt');
data_rubber=load('feature_rubber.txt');
r1 = randperm(160,48);
r2 = randperm(160,48);
r3 = randperm(160,48);
t1 = zeros(160,1);
t2 = zeros(160,1);
t3 = zeros(160,1);

feature_test = zeros(144,16);
feature_train = zeros(336,16);

% 每组取30%作为测试集，最后全塞在一起
for i=1:48
feature_test(i,:) = data_paper(r1(i),1:end);
end


for i=1:48
feature_test(i+48,:) = data_iron(r2(i),1:end);
end


for i=1:48
feature_test(i+96,:) = data_rubber(r3(i),1:end);
end

%剩下的全部作为训练集

for i=1:160
    t1(i)=i;t2(i)=i;t3(i)=i;
end

for i=1:160
   for j=1:48
    if  t1(i) ==r1(j)
        t1(i) = 0;
    end
   end
end
for i=1:160
   for j=1:48
    if  t2(i) ==r2(j)
        t2(i) = 0;
    end
   end
end
for i=1:160
   for j=1:48
    if  t3(i) ==r3(j)
        t3(i) = 0;
    end
   end
end


j=1;
for i=1:160
       if t1(i)~=0
          feature_train(j,1:end) = data_paper(i,1:end);
          j=j+1;
       else 
          continue;
       end
end

for i=1:160
       if t1(i)~=0
          feature_train(j,1:end) = data_iron(i,1:end);
          j=j+1;
       else 
          continue;
       end
end

for i=1:160
       if t1(i)~=0
          feature_train(j,1:end) = data_rubber(i,1:end);
          j=j+1;
       else 
          continue;
       end
end

save('feature_test.txt','feature_test','-ascii', '-append');
save('feature_train.txt','feature_train','-ascii', '-append');

