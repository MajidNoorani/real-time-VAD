function [mj,melNo]= Melfilterbank(STFf,frq,frameNo,points)

melNo=25; %number of mel filters
syms mel(freq)
mel(freq)=1127*log(1+freq/700);             % mel scale
center=zeros(1,(melNo+2));
freq1=7000;
freq0=50;
center(1)=mel(freq0);



hbandwidth=(mel(freq1)-mel(freq0))/(melNo+1);% half of bandwidth of each mel filter in mel scale
for i=2:melNo+2
    center(i)=center(i-1)+hbandwidth;  % center of each filter in mel scale
end



%{
for i=1:melNo
melfreq=center(i):0.1:center(i+1);
melfilter1=(1/(center(i+1)-center(i)))*(melfreq-center(i));
melfreq=center(i+1)+0.1:0.1:center(i+2);
melfilter2=(-1/(center(i+2)-center(i+1)))*(melfreq-center(i+2));
melfreq=center(i):0.1:center(i+2);
melfilter=[melfilter1 melfilter2];
figure(2)
hold on
title('mel filters')
xlabel('mel scale')
ylabel('amplitude')
plot(melfreq,melfilter)
end
hold off
%}
for i=1:melNo+2
    center(i)=(exp(center(i)/1127)-1)*700; %moving centers to normal frequency scale
end
mj=zeros(frameNo,melNo);
for i=1:melNo
    for j=1:frameNo
        for k=1:(points/2)+1
            if frq(k)>center(i) && frq(k)<center(i+1)
                melresult=STFf(j,k)*((1/(center(i+1)-center(i)))*(frq(k)-center(i)));
            elseif frq(k)>center(i+1) && frq(k)<center(i+2)
                melresult=STFf(j,k)*((-1/(center(i+2)-center(i+1)))*(frq(k)-center(i+2)));
            else
                melresult=0;
            end
            mj(j,i)=melresult^2+mj(j,i);
        end
    end
end
mj=log10(mj);
