%ece5793Project4_2.m
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/15/16

%-------Clean workspace----------------------------------------------------
close all
clear all
clc


%-------Read in images and initialize--------------------------------------
blur1=imread('blur1.bmp');
blur2=imread('blur2.bmp');
blur3=imread('blur3.bmp');
original=imread('original.bmp');
info1=imfinfo('blur1.bmp');
info2=imfinfo('blur2.bmp');
info3=imfinfo('blur3.bmp');

dblur1=im2double(blur1);
dblur2=im2double(blur2);
dblur3=im2double(blur3);

BLUR1=fftshift(fft2(dblur1));
BLUR2=fftshift(fft2(dblur2));
BLUR3=fftshift(fft2(dblur3));
k=.0005;
for i=1:info1.Width
    for j=1:info1.Height
        FILTERED1(i,j) = BLUR1(i,j)*motionWiener(i,j,k);
        FILTERED2(i,j) = BLUR2(i,j)*motionWiener(i,j,k);
        FILTERED3(i,j) = BLUR3(i,j)*motionWiener(i,j,k);
    end
end

recovered1=abs(ifft2(ifftshift(FILTERED1)));
recovered2=abs(ifft2(ifftshift(FILTERED2)));
recovered3=abs(ifft2(ifftshift(FILTERED3)));

psnr=myPSNR(original, recovered1);
disp('blur1')
disp(psnr)
psnr=myPSNR(original, recovered2);
disp('blur2')
disp(psnr)
psnr=myPSNR(original, recovered3);
disp('blur3')
disp(psnr)

figure(1)
imshow(recovered1)
figure(2)
imshow(recovered2)
figure(3)
imshow(recovered3)