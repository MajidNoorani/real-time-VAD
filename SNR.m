%signal and noise need to be in the same range

function [r,r1]=SNR(Signal,Noise)
e1=0;e2=0;
for i=1:size(Signal)
    e1=Signal(i)^2+e1;
    e2=Noise(i)^2+e2;
end

r=10*log10(e1/e2);
r1=e1/e2;