%ece5793Project3_3.m
% MATLAB script written to enhance a bone scan image.  The image is 
% enhanced using the laplacian operator, filtered sobel gradient, and 
% power-law transformation. All stages of enhancement are displayed as well 
% as the original image for comparison purposes.
% 
% Preconditions:  none  
% Post conditions:  Displayed original and enhanced images.
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/15/16

%-------Clean workspace----------------------------------------------------
close all
clear all
clc


%-------Read in images and initialize--------------------------------------
original=imread('circuit.bmp');
noisy=imread('noisy_circuit.bmp'); %gaussian noise:  mean=0;  sigma^2=1000;
noisyInfo=imfinfo('noisy_circuit.bmp');
Levels=2^(noisyInfo.BitDepth);

dnoisy=im2double(noisy);

NOISY = log(abs(fftshift(fft2(dnoisy)))+1);

figure(1)
imshow(dnoisy)
figure(2)
imshow(original);

arithMean=arithMean(dnoisy,3);
% arithMean=arithMean(noisy,9);
psnr=myPSNR(original, arithMean);
disp(psnr)
geoMean=geoMean2(dnoisy,3);
% geoMean=geoMean(noisy,9);
psnr=myPSNR(original, geoMean);
disp(psnr)


figure(3)
imshow(arithMean,[])
figure(4)
imshow(geoMean,[])