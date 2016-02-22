%ece5793Project2_4.m
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
I=imread('Figure7.tif');
[N,M,Z]=size(I);
L=256;
II=im2double(I);
avN=5; %size of moving average filter

%-------Display Original---------------------------------------------------
figure(1)
imshow(I)

%-------Create kernels-----------------------------------------------------
lapK = [-1 -1 -1; -1 8 -1; -1 -1 -1];
sobelx = [-1 -2 -1; 0 0 0; 1 2 1];
sobely = [-1 0 1; -2 0 2; -1 0 1];
stdAv = ones(avN);

%-------Calculate Laplacian------------------------------------------------
laplacian=conv2(II,lapK);
laplacian=imcrop(laplacian,[2 2 size(II,2)-1 size(II,1)-1]);

%-------Calculate Gradient-------------------------------------------------
gx=conv2(II,sobelx);
gy=conv2(II,sobely);
sobel=abs(gx)+abs(gy);
sobel=imcrop(sobel,[2 2 size(II,2)-1 size(II,1)-1]);

%-------Display magnitude corrected Laplacian------------------------------
figure(2)
imshow(laplacian+abs(min(laplacian(:))))

%-------Display Laplacian sharpened image----------------------------------
sharpened=II+laplacian;
figure(3)
imshow(sharpened)

%-------Display Gradient---------------------------------------------------
figure(4)
imshow(sobel)

%-------Smooth Gradient with moving average--------------------------------
avSobel = conv2(sobel,stdAv);
avSobel=imcrop(avSobel,[3 3 size(II,2)-1 size(II,1)-1]);
avSobel = avSobel/9;

%-------Display smoothed average gradient----------------------------------
figure(5)
imshow(avSobel)

%-------Calculate final sharpened image------------------------------------
final1= laplacian.*avSobel+II;

%-------Increase contrast with power-law-----------------------------------
c=1;  gamma=.5;
final2=c*(final1).^gamma;

%-------Display final images-----------------------------------------------
figure(6)
imshow(final1)
figure(7)
imshow(final2)
