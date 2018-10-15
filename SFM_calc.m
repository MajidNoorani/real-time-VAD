function [SFM]= SFM_calc(frames_FFT)
SFM = zeros(size(frames_FFT,1),1);
geo_mean = zeros(size(frames_FFT,1),1);
arith_mean = zeros(size(frames_FFT,1),1);
for frame = 1:size(frames_FFT,1)
    nth = zeros(size(frames_FFT,2),1);
    for i = 1: size(frames_FFT,2)
        nth(i) = nthroot(frames_FFT(frame,i),size(frames_FFT,2));
        
    end
    geo_mean(frame) = prod(nth);
    arith_mean(frame) = sum(frames_FFT(frame,:))/size(frames_FFT,2);
    SFM(frame) = abs(10*log10(geo_mean(frame)/arith_mean(frame)));
end
