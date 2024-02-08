
clear

clc

data_hand=load('feature_hand_VMD.txt');
data_paper=load('feature_paper_VMD.txt');
data_iron=load('feature_iron_VMD.txt');
data_rubber=load('feature_rubber_VMD.txt');
% data_hand_total = zeros(779,24);
% data_paper_total = zeros(800,24);
% data_iron_total = zeros(804,24);
% data_rubber_total = zeros(824,24);
% for i=1:length(data_hand)
% data_hand1 = data_hand(i,1:12)/(1/data_hand(i,25));
% data_hand2 = data_hand(i,13:24)/(1/data_hand(i,26));
% data_hand_total(i,:) = cat(2,data_hand1,data_hand2);
% end
% for i=1:length(data_paper)
% data_paper1 = data_paper(i,1:12)/(1/data_paper(i,25));
% data_paper2 = data_paper(i,13:24)/(1/data_paper(i,26));
% data_paper_total(i,:) = cat(2,data_paper1,data_paper2);
% end
% for i=1:length(data_iron)
% data_iron1 = data_iron(i,1:12)/(1/data_iron(i,25));
% data_iron2 = data_iron(i,13:24)/(1/data_iron(i,26));
% data_iron_total(i,:) = cat(2,data_iron1,data_iron2);
% end
% for i=1:length(data_rubber)
% data_rubber1 = data_rubber(i,1:12)/(1/data_rubber(i,25));
% data_rubber2 = data_rubber(i,13:24)/(1/data_rubber(i,26));
% data_rubber_total(i,:) = cat(2,data_rubber1,data_rubber2);
% end
data_hand=[ones(length(data_hand),1),data_hand];
data_paper=[2*ones(length(data_paper),1),data_paper];
data_rubber=[3*ones(length(data_rubber),1),data_rubber];
data_iron=[4*ones(length(data_iron),1),data_iron];

handnum=length(data_hand);
papernum=length(data_paper);
rubbernum=length(data_rubber);
ironnum=length(data_iron);
handnum_test=ceil(length(data_hand)*0.2);
papernum_test=ceil(length(data_paper)*0.2);
rubbernum_test=ceil(length(data_rubber)*0.2);
ironnum_test=ceil(length(data_iron)*0.2);


r1 = randperm(handnum,handnum_test);
r2 = randperm(papernum,papernum_test);
r3 = randperm(rubbernum,rubbernum_test);
r4 = randperm(ironnum,ironnum_test);
t1 = zeros(handnum_test,1);
t2 = zeros(papernum_test,1);
t3 = zeros(rubbernum_test,1);
t4 = zeros(ironnum_test,1);

testnum = ceil(length(data_iron)*0.2)+ceil(length(data_hand)*0.2)+ceil(length(data_paper)*0.2)+ceil(length(data_rubber)*0.2);
trainnum = length(data_hand)+length(data_paper)+length(data_rubber)+length(data_iron)-testnum;

feature_test = zeros(testnum,39);
feature_train = zeros(trainnum,39);

% 每组取20%作为测试集，最后全塞在一起
for i=1:ceil(length(data_hand)*0.2)
feature_test(i,:) = data_hand(r1(i),1:end);
end


for i=1:ceil(length(data_paper)*0.2)
feature_test(i+ceil(length(data_hand)*0.2),:) = data_paper(r2(i),1:end);
end


for i=1:ceil(length(data_rubber)*0.2)
feature_test(i+ceil(length(data_hand)*0.2)+ceil(length(data_paper)*0.2),:) = data_rubber(r3(i),1:end);
end

for i=1:ceil(length(data_iron)*0.2)
feature_test(i+ceil(length(data_hand)*0.2)+ceil(length(data_paper)*0.2)+ceil(length(data_rubber)*0.2),:) = data_iron(r4(i),1:end);
end

%剩下的全部作为训练集

for i=1:handnum
    t1(i)=i;
end
for i=1:papernum
    t2(i)=i;
end
for i=1:rubbernum
    t3(i)=i;
end
for i=1:ironnum
    t4(i)=i;
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
for i=1:rubbernum
   for j=1:rubbernum_test
    if  t3(i) ==r3(j)
        t3(i) = 0;
    end
   end
end

for i=1:ironnum
   for j=1:ironnum_test
    if  t4(i) ==r4(j)
        t4(i) = 0;
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
for i=1:rubbernum
       if t3(i)~=0
          feature_train(j,1:end) = data_rubber(i,1:end);
          j=j+1;
       else 
          continue;
       end
end
for i=1:ironnum
       if t4(i)~=0
          feature_train(j,1:end) = data_iron(i,1:end);
          j=j+1;
       else 
          continue;
       end
end

% % 
save('feature_test.txt','feature_test','-ascii', '-append');
save('feature_train.txt','feature_train','-ascii', '-append');

