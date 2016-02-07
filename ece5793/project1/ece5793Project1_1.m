%ece5793Project1_1.m
% MATLAB script written to resize and interpolate image greyscale image
% 'lena256.bmp' and color image 'cow.bmp' based on scaling factor p.  
% The resized image is interpolated using three techniques: nearest 
% neighbor, bilinear, and bicubic.  The resultant resized images are 
% displayed.
% 
% Preconditions:  MATLAB functions sombrero.m and resize.m are in the same 
% directory as this script.
% Post conditions:  Images displaying resized images.
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/5/16

%-------Clean workspace----------------------------------------------------
clear all
close all
clc

%-------Initializations----------------------------------------------------
p=1.3718;  %scaling factor
% p=2;
I=imread('lena256.bmp');
% I=imread('cow.bmp');

%-------Resize and Interpolate---------------------------------------------
A=resize(I,p,1);
B=resize(I,p,2);
C=resize(I,p,3);

%-------Display results----------------------------------------------------
figure(1)
imshow(A)
title('Nearest Neighbor')
figure(2)
imshow(B)
title('Bilinear')
figure(3)
imshow(C)
title('Bicubic')