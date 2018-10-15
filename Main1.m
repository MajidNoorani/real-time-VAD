close all
clear all

[statement,fs] = audioread('sp06_eddited.wav');
[noise,fs] = audioread('babble.wav');

statement_size=size(statement);
noise=noise(1:statement_size(1,1));
%% signal making with different SNRs :0 5 10

[snr,ratio]=SNR(statement,noise);
if snr~=0
    noise0=noise*sqrt(ratio);
end

noise5 = noise0 * 1/sqrt(sqrt(10));
noise10 = noise0 * 1/sqrt(10);
noise20 = noise0 *1/10;

audio0 = statement + noise0;  % noisy audio with snr = 0
audio5 = statement + noise5;
audio10 = statement + noise10;
audio20 = statement + noise20;


[HR0_0,HR1_0] = decision2(audio0,fs);
[HR0_5,HR1_5] = decision2(audio5,fs);
[HR0_10,HR1_10] = decision2(audio10,fs);
[HR0_20,HR1_20] = decision2(audio20,fs);


figure
v = 1:4;
plot(v,[HR0_20,HR0_10,HR0_5,HR0_0])
hold on
plot(v,[HR1_20,HR1_10,HR1_5,HR1_0],'r')
set(gca, 'XTick',1:5, 'XTickLabel',{'15db','10db','5db','0db'})
title('HR1(red) and HR0(blue)')
grid on
%plot(label)

    

