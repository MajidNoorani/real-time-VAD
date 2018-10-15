function [c,delta]= MFCC(audiofile)

[frames,Fs,N,FrameNo]=framming(audiofile);  
[pframes]=preemphasis(frames);
[Hframes]=Hamming(pframes,N,FrameNo);
[STFf,frq,points]=FFT_of_Frames(Hframes,Fs);
[mj,melNo]= Melfilterbank(STFf,frq,FrameNo,points);
[c]= Cepstral_12(FrameNo,mj,melNo);

