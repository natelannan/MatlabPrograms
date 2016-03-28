%ece5753Project3_1.m
% MATLAB script written to 
% 
% Preconditions:  none  
% Post conditions:  Displayed original and enhanced images.
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 

%-------Clean workspace----------------------------------------------------
close all
clear all
clc

temp=pitchEstimator('normed_speech.mat','sh4');

%sanity check for filter algorithm
% fs=8000;
% rp = 0.001;           % Passband ripple
% rs = 30;          % Stopband ripple
% f = [800 1200];    % Cutoff frequencies
% A = [1 0];        % Desired amplitudes
% dev = [(10^(rp/20)-1)/(10^(rp/20)+1)  10^(-rs/20)];
% [n,fo,ao,w] = firpmord(f,A,dev,fs);
% b = firpm(n,fo,ao,w);
% figure(1)
% freqz(b,1,10000,fs);
% filtered=filter(b,1,temp);
% FILTERED=fft(filtered);
% FILTERED=20*log10(abs(FILTERED)/max(abs(FILTERED)));
% TEMP=fft(temp)/length(temp);
% TEMP=20*log10(abs(TEMP)/max(abs(TEMP)));
% filteredAxis=(0:(length(filtered)-1))*8000/(length(filtered)-1);
% tempAxis=(0:(length(temp)-1))*8000/(length(temp)-1);
% figure(2)
% subplot(1,2,1)
% plot(filteredAxis,FILTERED)
% subplot(1,2,2)
% plot(tempAxis,TEMP)

