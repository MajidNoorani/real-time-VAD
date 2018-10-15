function [F] = F_calc(frames_FFT)
F = zeros(size(frames_FFT,1),1);
for frame = 1: size(frames_FFT,1)
    [value,F(frame)] = max(frames_FFT(frame,:));
end