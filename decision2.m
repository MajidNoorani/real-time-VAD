function [HR0,HR1] = decision2(audio,fs)

%% framming
[frames] = framming_no_overlap(audio,fs);


%% energy calc
[E0] = energy(frames);

%% FFT
[frames_FFT,frq]= FFT_of_Frames(frames,fs);
frames_FFT1 = frames_FFT(:,1:256);
frames_FFT = frames_FFT1;

%% SFM
[SFM]= SFM_calc(frames_FFT);

%% F
[F] = F_calc(frames_FFT);

%% initializasion
Energy_primThresh = 0.15;
SFM_PrimThresh = 4;
F_PrimThresh = 10;

Emin = 0;
n = 20;
for frame= 1:n
    Emin = E0(frame)+Emin; 
end

Energy_Thresh = Energy_primThresh*log10(Emin);

Fmin = min(F(1:30));

SFMmin = min(SFM(1:30));

%% decision

label = zeros(size(frames_FFT,1),1);

for frame = 1: size(frames_FFT,1)
    counter = 0;
    if E0(frame)-Emin > Energy_Thresh
        counter = counter +1;
    end
    if F(frame)-Fmin > F_PrimThresh
        counter = counter +1;
    end
    if SFM(frame)-SFMmin > SFM_PrimThresh
        counter = counter +1;
    end
    
    if counter > 1
        label(frame) = 1;
    else
        Emin = (Emin*n + E0(frame))/(n+1);
        n = n+1;
        %Energy_Thresh = Emin;
        Energy_Thresh = Energy_primThresh *log10(Emin);
    end
    
end

% t=1:size(audio,1);
% k=1:size(frames,1);
% figure
% plot(t/fs,audio)
% hold on
% plot(k/100,label)
%% label editing

% for speech labels

N1(1:size(label,1))=0;
pre_label=0;
for i=1:size(label,1)
    if label(i)==1
       if pre_label==1
           N1(s)=N1(s)+1;
           pre_label=1;
       else
           s=i;
           N1(s)=N1(s)+1;
           pre_label=1;
       end
    else
        pre_label=0;
    end
end

for i=1:size(N1,2)
    if N1(i)<11 && N1(i)~=0
        label(i:(N1(i)+i-1))=0;
    end
end


Num0(1:size(label,1))=0;
pre_label=1;
for i=1:size(label,1)
    if label(i)==0
       if pre_label==0
           Num0(s)=Num0(s)+1;
           pre_label=0;
       else
           s=i;
           Num0(s)=Num0(s)+1;
           pre_label=0;
       end
    else
        pre_label=1;
    end
end

for i=1:size(Num0,2)
    if Num0(i)<20 && Num0(i)~=0
        label(i:(Num0(i)+i-1))=1;
    end
end






t=1:size(audio,1);
k=1:size(frames,1);
figure
plot(t/fs,audio)
hold on
plot(k/100,label)


label_supervised = zeros(size(label));
label_supervised(59:142)= 1;
label_supervised(181:290)= 1;

%% HR0
N0 = 0;
N1 = 0;
N00 = 0;
N11 = 0;

for i = 1: size(label,1)
    if label_supervised(i) == 0
        N0 = N0+1;
        if label(i) == label_supervised(i)
            N00 = N00 +1;
        end
    elseif label_supervised(i) == 1
        N1 = N1+1;
        if label(i) == label_supervised(i)
            N11 = N11 +1;
        end
    end
end

HR0 = N00/N0;
HR1 = N11/N1;