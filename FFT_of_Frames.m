function [STFf,frq]= FFT_of_Frames(frames,Fs)
Tf=frames.'; %transpose f to be able to compute FFT of the matrix- FFT computes vectors in colomns
points=512;   %ponits for FFT
STFf1=fft(Tf,points);    %short time frequency spectrum of f
STFf=abs(STFf1.');
frq=Fs*(0:points/2)/points;

