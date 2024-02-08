clc
clear
output_K4 = load('outputK=4.txt');
output_K6 = load('outputK=6.txt');
output_true = load('output_true.txt');

% output_true(14,2) = 0;
% output_true(14,5) = 0;
% output_K6(14,2) = 0;
% output_K6(14,6) = 0;

figure(1)
subplot(3,2,1)
plot(output_K4(:,1),'-o');hold on;
plot(output_K6(:,1),'-o');hold on;
plot(output_true(:,1));
legend('K=4','K=6','truevalue');
title('Hand collsion');
subplot(3,2,2)
plot(output_K4(:,2),'-o');hold on;
plot(output_K6(:,2),'-o');hold on;
plot(output_true(:,2));
legend('K=4','K=6','truevalue');
title('Cotton collsion');
subplot(3,2,3)
plot(output_K4(:,3),'-o');hold on;
plot(output_K6(:,3),'-o');hold on;
plot(output_true(:,3));
legend('K=4','K=6','truevalue');
title('Rubber collsion');
subplot(3,2,4)
plot(output_K4(:,4),'-o');hold on;
plot(output_K6(:,4),'-o');hold on;
plot(output_true(:,4));
legend('K=4','K=6','truevalue');
title('Iron collsion');
subplot(3,2,5)
plot(output_K4(:,5),'-o');hold on;
plot(output_K6(:,5),'-o');hold on;
plot(output_true(:,5));
legend('K=4','K=6','truevalue');
title('Link 1 collsion');
subplot(3,2,6)
plot(output_K4(:,6),'-o');hold on;
plot(output_K6(:,6),'-o');hold on;
plot(output_true(:,6));
legend('K=4','K=6','truevalue');
title('Link 2 collsion');