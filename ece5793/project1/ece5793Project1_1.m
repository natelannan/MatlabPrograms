clear all
close all
clc

p=1.3718;  %scaling factor
%I = [1 0 1 0; 0 0 0 1; 1 1 0 1; 0 1 0 1;];
% I=imread('lena256.bmp');
I=imread('cow.bmp');
% I=ones(256);
A=resize(I,p,1);
B=resize(I,p,2);
C=resize(I,p,3);
figure(1)
imshow(A)
title('Nearest Neighbor')
figure(2)
imshow(B)
title('Bilinear')
figure(3)
imshow(C)
title('Bicubic')