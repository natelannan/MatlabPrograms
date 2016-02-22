%ece5793Project2_3.m
% MATLAB script written to enhance 3 images (1 grayscale and
% 2 color).  The images are enhanced using histogram matching and are   
% displayed along with their respective historgrams.  The original images 
% with histograms are also displayed for comparison purposes.
% 
% Preconditions:  MATLAB functions displayHist.m matchHist.m, and 
% equalize.m (used by matchHist.m) are in the same directory as this 
% script.  
% Post conditions:  Displayed original and enhanced images along with their
% respective histograms.
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/15/16

%-------Clean workspace----------------------------------------------------

close all
clear all
clc

%-------Read in images and initialize--------------------------------------
I=imread('Figure6.tif');
castle1=imread('HistogramWarpColor1.jpeg');
castle2=imread('HistogramWarpColor2.jpeg');
% castle1=imread('color6.jpg');
% castle2=imread('color7.jpg');
[N,M,Z]=size(I);
[N1,M1,Z1] = size(castle1);
[N2, M2, Z2] = size(castle2);
L=256;

%-------Original plots-----------------------------------------------------
figure(1)
subplot(1,2,1)
imshow(I)
subplot(1,2,2)
imhist(I)

figure(2)
imshow(castle2)
figure(3)
displayHist(castle2)

%-------Create target histograms-------------------------------------------
yscale=10^4; %peicewise function from Digital Image Processing 3rd ed
x=0:255;
y(x<=8)=yscale*0.875*x(x<=8);
y(8<x&x<=16)=yscale*(-0.8021*x(8<x&x<=16)+13.417);
y(16<x&x<=176)=yscale*(-0.00364*x(16<x&x<=176)+.64166);
y(176<x&x<=202)=yscale*(0.0168*x(176<x&x<=202)-2.962);
y(202<x)=yscale*(-0.00825*x(202<x)+2.105);
target=round(y)/sum(y);  %let y = probabilities rather than pixel numbers


% original images source:  
%http://www.cl.cam.ac.uk/~mg290/Portfolio/ColorHistogramWarp.html
castle1Hist=zeros(L,Z1); 
castle2Hist=zeros(L,Z1);
for i=1:Z1
    castle1Hist(:,i)=imhist(castle1(:,:,i));
    castle1Hist(:,i)=castle1Hist(:,i)/sum(castle1Hist(:,i));
    castle2Hist(:,i)=imhist(castle2(:,:,i));
    castle2Hist(:,i)=castle2Hist(:,i)/sum(castle2Hist(:,i));
end

%-------Plot target histograms---------------------------------------------
figure(4)
plot(x,round(y));

figure(5)
imshow(castle1)
figure(6)
displayHist(castle1)

%-----------Match Histograms and plot--------------------------------------
corrected=matchHist(I,target');
castle2Corrected=matchHist(castle2,castle1Hist);
castle1Corrected=matchHist(castle1,castle2Hist);
figure(7)
subplot(1,2,1)
imshow(corrected);
subplot(1,2,2)
imhist(corrected)
figure(8)
imshow(castle1Corrected)
figure(9)
imshow(castle2Corrected)
figure(10)
displayHist(castle1Corrected)
figure(11)
displayHist(castle2Corrected)


