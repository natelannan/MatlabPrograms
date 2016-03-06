%ece5793Project3_2.m
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
duck=imread('duck_blur.jpg');
duck_orig=imread('duck.jpg');
info=imfinfo('duck_blur.jpg');


L=2^(info.BitDepth/3);
dduck=im2double(duck);
padSizeH=info.Height;
padSizeW=info.Width;
dduck=padarray(dduck,[padSizeH padSizeW]);
figure(90)
imshow(dduck)

% FFTDUCK=fftshift(fft2(dduck));
% DUCK = log(abs(FFTDUCK)+1);
% DUCK_R = log(abs(FFTDUCK(:,:,1))+1);
% DUCK_G = log(abs(FFTDUCK(:,:,2))+1);
% DUCK_B = log(abs(FFTDUCK(:,:,3))+1);

FFTDUCK_R=fftshift(fft2(dduck(:,:,1)));
FFTDUCK_G=fftshift(fft2(dduck(:,:,2)));
FFTDUCK_B=fftshift(fft2(dduck(:,:,3)));
DUCK_R=log(abs(FFTDUCK_R)+1);
DUCK_G=log(abs(FFTDUCK_G)+1);
DUCK_B=log(abs(FFTDUCK_B)+1);




%-------Display Original---------------------------------------------------
figure(1)
imshow(dduck)

figure(2)
imshow(duck_orig)

% figure(3)
% subplot(1,2,1)
% imshow(DUCK_R,[])
% subplot(1,2,2)
% imshow(DUCK_R2,[])
% 
% figure(4)
% subplot(1,2,1)
% imshow(DUCK_G,[])
% subplot(1,2,2)
% imshow(DUCK_G2,[])
% 
% figure(5)
% subplot(1,2,1)
% imshow(DUCK_B,[])
% subplot(1,2,2)
% imshow(DUCK_B2,[])

% diffr=DUCK_R-DUCK_R2;
% diffg=DUCK_G-DUCK_G2;
% diffb=DUCK_B-DUCK_B2;
% figure(6)
% subplot(1,3,1)
% imshow(abs(diffr),[])
% subplot(1,3,2)
% imshow(abs(diffg),[])
% subplot(1,3,3)
% imshow(abs(diffb),[])

HPF=zeros(info.Height*3,info.Width*3);
Butt=zeros(info.Height*3,info.Width*3);
Gauss=zeros(info.Height*3,info.Width*3);
D0Butt=6;
D0Gauss=6;
n=2;
u=1:info.Height*3; v=1:info.Width*3;
[XI, YI] = ndgrid(u,v);
D=sqrt((XI-(info.Height*3/2 +1)).^2+(YI-(info.Width*3/2 +1)).^2);
HPF(D<=3)=0;
HPF(D>3)=1;
Butt=1./(1+(D0Butt./D).^(2*n));
Gauss=1-exp(-D.^2./(2*D0Gauss.^2));
figure(7)
imshow(Gauss)
A=2;
a=0.5;
b=2;
HBF=(A-1)+HPF;
HFE=a+b*HPF;

HBFButt=(A-1)+Butt;
HFEButt=a+b*Butt;

HBFGauss=(A-1)+Gauss;
HFEGauss=a+b*Gauss;

BFiltered(:,:,1) = FFTDUCK_R.*HBF;
BFiltered(:,:,2) = FFTDUCK_G.*HBF;
BFiltered(:,:,3) = FFTDUCK_B.*HBF;

EFiltered(:,:,1) = FFTDUCK_R.*HFE;
EFiltered(:,:,2) = FFTDUCK_G.*HFE;
EFiltered(:,:,3) = FFTDUCK_B.*HFE;

BFilteredButt(:,:,1) = FFTDUCK_R.*HBFButt;
BFilteredButt(:,:,2) = FFTDUCK_G.*HBFButt;
BFilteredButt(:,:,3) = FFTDUCK_B.*HBFButt;

EFilteredButt(:,:,1) = FFTDUCK_R.*HFEButt;
EFilteredButt(:,:,2) = FFTDUCK_G.*HFEButt;
EFilteredButt(:,:,3) = FFTDUCK_B.*HFEButt;

BFilteredButt(:,:,1) = FFTDUCK_R.*HBFGauss;
BFilteredButt(:,:,2) = FFTDUCK_G.*HBFGauss;
BFilteredButt(:,:,3) = FFTDUCK_B.*HBFGauss;

EFilteredButt(:,:,1) = FFTDUCK_R.*HFEGauss;
EFilteredButt(:,:,2) = FFTDUCK_G.*HFEGauss;
EFilteredButt(:,:,3) = FFTDUCK_B.*HFEGauss;
for i=1:3
    BRecovered(:,:,i)=abs(ifft2(ifftshift(BFiltered(:,:,i))));
    ERecovered(:,:,i)=abs(ifft2(ifftshift(EFiltered(:,:,i))));
    BRecoveredButt(:,:,i)=abs(ifft2(ifftshift(BFilteredButt(:,:,i))));
    ERecoveredButt(:,:,i)=abs(ifft2(ifftshift(EFilteredButt(:,:,i))));
    BRecoveredGauss(:,:,i)=abs(ifft2(ifftshift(BFilteredButt(:,:,i))));
    ERecoveredGauss(:,:,i)=abs(ifft2(ifftshift(EFilteredButt(:,:,i))));
end
figure(8)
subplot(1,2,1)
imshow(BRecovered)
subplot(1,2,2)
imshow(ERecovered)

figure(9)
subplot(1,2,1)
imshow(BRecoveredButt)
subplot(1,2,2)
imshow(ERecoveredButt)

figure(10)
subplot(1,2,1)
imshow(BRecoveredGauss)
subplot(1,2,2)
imshow(ERecoveredGauss)
