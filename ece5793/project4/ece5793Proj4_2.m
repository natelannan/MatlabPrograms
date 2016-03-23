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

center=[info1.Height/2+1 info1.Width/2+1];
dblur1=im2double(blur1);
doriginal=im2double(original);
% dblur2=im2double(blur2);
% dblur3=im2double(blur3);

BLUR1=fftshift(fft2(dblur1));
ORIGINAL=fftshift(fft2(original));
% BLUR2=fft2(dblur2);
% BLUR3=fft2(dblur3);
k=.00002;
u=(1:info1.Height)-center(1);
v=(1:info1.Width)-center(2);
[XI, YI] = ndgrid(u,v);
weight=XI*.1+YI*.1;
weight(find(weight==0))=.00000001;
H = 1./(pi*weight) .* sin(pi.*weight) .* exp(-1i*pi*weight);
Hstar = conj(H);
wiener = (Hstar./(Hstar.*H+k));
% for i=1:info1.Height
%     for j=1:info1.Width
%         wiener(i,j)=motionWiener(i,j,k);
% %         FILTERED1(i,j) = BLUR1(i,j)*motionWiener(i,j,k);
% %         FILTERED2(i,j) = BLUR2(i,j)*motionWiener(i,j,k);
% %         FILTERED3(i,j) = BLUR3(i,j)*motionWiener(i,j,k);
%     end
% end

% LPF=ones(info1.Width);
% D=sqrt((XI).^2+(YI).^2);
% LPF(D<=5)=1;
% LPF(D>5)=0;
% figure(10)
% imshow(LPF)

BLURRED=ORIGINAL.*H;
FILTERED1=BLUR1.*(wiener);
recovered1=abs(ifft2(ifftshift(FILTERED1)));
blurred=abs(ifft2(ifftshift(BLURRED)));
% recovered1=uint8(round(recovered1));
% recovered2=abs(ifft2(FILTERED2));
% recovered3=abs(ifft2(FILTERED3));

peaksnr=myPSNR(original, recovered1);
% peaksnr2=psnr(recovered1,original);
disp('blur1')
disp(peaksnr)
% disp(peaksnr2)
% psnr=myPSNR(original, recovered2);
% disp('blur2')
% disp(psnr)
% psnr=myPSNR(original, recovered3);
% disp('blur3')
% disp(psnr)

figure(1)
imshow(recovered1)
% figure(2)
% imshow(recovered2)
% figure(3)
% imshow(recovered3)
figure(4)
imshow(uint8(round(blurred)))