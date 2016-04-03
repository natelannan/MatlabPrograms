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

load normed_speech.mat
speechVector=sh4_7;
fs=8000;
oTime=(1:length(speechVector))/fs;
%speechVector=padarray(speechVector,53,'post');
%pitch=pitchEstimator2('normed_speech.mat','sh4_2');
[pitch2,newFs2]=pitchEstimator3(sh4_7);
[pitch,newFs]=pitchEstimator2(sh4_7);
nTime=(1:length(pitch))/newFs;
nTime2=(1:length(pitch2))/newFs2;

% upsampled=upsample(pitch,floor(length(speechVector)/length(pitch)));
% resampled=resample(pitch,length(speechVector),length(pitch));
figure(1)
%plot(oTime,speechVector,nTime,pitch)
speechVector=speechVector/max(abs(speechVector));
[hAx,hLine1,hLine2]=plotyy(oTime,speechVector,nTime, pitch);
legend('Normalized Data', 'Pitch')
title('Pitch Detection for sh4\_7 Using STAC, LPF, and Classification Mask')
xlabel('Time (seconds)')
ylabel(hAx(1),'Normalized Amplitude') % left y-axis
ylabel(hAx(2),'Detected Pitch (Hz)') % right y-axis
set(hAx,{'ycolor'},{'r';'k'})
set(hLine1,'color','r')
set(hLine2,'color','k')

figure(2)
[hAx,hLine1,hLine2]=plotyy(oTime,speechVector,nTime2, pitch2);
legend('Normalized Data', 'Pitch')
title('Pitch Detection for sh4\_7 Using STAC, LPF, and Classification Mask')
xlabel('Time (seconds)')
ylabel(hAx(1),'Normalized Amplitude') % left y-axis
ylabel(hAx(2),'Detected Pitch (Hz)') % right y-axis
set(hAx,{'ycolor'},{'r';'k'})
set(hLine1,'color','r')
set(hLine2,'color','k')


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

