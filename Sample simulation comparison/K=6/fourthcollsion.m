clc;
clear;

senor = load('senor.txt');
figure(1)
plot(senor(:,3));
%88106 101317 113179 127067 139526 152829 166307 179037 189908
%61146 74408  87645  120091
x=87645;

aplusn_1= senor(x-205:x+205,1);
aplusn_2= senor(x-205:x+205,2);
aplusn_3= senor(x-205:x+205,3);
aplusn_4= senor(x-205:x+205,4);
% to1 = load('to1.txt');
% to2 = load('to2.txt');


K=4;
    [u1, u_hat1, omega1] = VMD(aplusn_1, 2000, 0, K, 0, 1, 1e-7);
    [u2, u_hat2, omega2] = VMD(aplusn_2, 2000, 0, K, 0, 1, 1e-7);
    [u3, u_hat3, omega3] = VMD(aplusn_3, 2000, 0, K, 0, 1, 1e-7);
    [u4, u_hat4, omega4] = VMD(aplusn_4, 2000, 0, K, 0, 1, 1e-7);


% FFFFT

figure(2)
subplot(3,2,1)
plot(u1(2,:));hold on;
plot(u3(2,:));
legend('senor of link1','senor of link2');

subplot(3,2,3)
plot(u1(3,:));hold on;
plot(u3(3,:));
legend('senor of link1','senor of link2');

subplot(3,2,5)
plot(u1(4,:));hold on;
plot(u3(4,:));
legend('senor of link1','senor of link2');

subplot(3,2,2)
[f U11]=FFFFT(u1(2,:));
[f U31]=FFFFT(u3(2,:));
plot(f,U11);hold on;
plot(f,U31);
legend('senor of link1','senor of link2');

subplot(3,2,4)
[f U12]=FFFFT(u1(3,:));
[f U32]=FFFFT(u3(3,:));
plot(f,U12);hold on;
plot(f,U32);
legend('senor of link1','senor of link2');

subplot(3,2,6)
[f U13]=FFFFT(u1(4,:));
[f U33]=FFFFT(u3(4,:));
plot(f,U13);hold on;
plot(f,U33);
legend('senor of link1','senor of link2');


