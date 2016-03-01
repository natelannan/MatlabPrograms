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
lena=imread('leangray.bmp');
[Nlena,Mlena,Z]=size(lena);
L=256;
llena=im2double(lena);

clown=imread('clowngray.bmp');
[Nclown,Mclown,Z]=size(clown);
L=256;
cclown=im2double(clown);

CLOWN = log(abs(fftshift(fft2(cclown)))+1);
FFTCLOWN=fftshift(fft2(cclown));
FFTLENA=fftshift(fft2(llena));
LENA = log(abs(fftshift(fft2(llena)))+1);

%-------Display Original---------------------------------------------------
figure(1)
subplot(2,2,1)
imshow(lena)
subplot(2,2,2)
imshow(clown)
subplot(2,2,3)
imshow(LENA,[])
subplot(2,2,4)
imshow(CLOWN,[])

figure(2)
imshow(LENA,[])
figure(3)
imshow(CLOWN,[])

% ========================LPF POC==========================================
% LPF=ones(256);
% u=1:256; v=1:256;
% [XI, YI] = ndgrid(u,v);
% D=sqrt((XI-128).^2+(YI-128).^2);
% LPF(D<=20)=1;
% LPF(D>20)=0;
% figure(4)
% imshow(LPF)
% 
% filtered = FFTLENA.*LPF;
% %foo=ifftshift(filtered);
% bar=abs(ifft2(ifftshift(filtered)));
% figure(5)
% imshow(bar)
centerL=[Nlena/2 Mlena/2];
centerC=[Nclown/2 Mclown/2];
notch=ones(Mlena);
notch2=ones(Mclown);
u=1:256; v=1:256;
[XI, YI] = ndgrid(u,v);
% D=sqrt((XI-128).^2+(YI-128).^2);
pts=[127 111 95 79 63 47 31 15 -17 -33 -49 -65 -81 -97 -113];
for i=1:length(pts)
    D=sqrt((XI-centerL(2)+pts(i)).^2+(YI-centerL(1)+pts(i)).^2);
    notch(D<1)=0;
end
% D1=sqrt((XI-center(2)-1).^2+(YI-center(1)-1).^2);
% D2=sqrt((XI-center(2)+15).^2+(YI-center(1)+15).^2);

% notch(D2<1)=0;
figure(6)
imshow(notch)
filtered = FFTLENA.*notch;
figure(7)
imshow(log(abs(filtered)+1),[])

reversed=abs(ifft2(ifftshift(filtered)));
figure(8)
imshow(reversed)
figure(9)
imshow(lena)

u=1:294; v=1:294;
[XI, YI] = ndgrid(u,v);
D1=sqrt((XI-centerC(2)+(centerC(2)-123)).^2+(YI-centerC(1)+(centerC(1)-191)).^2);
D2=sqrt((XI-centerC(2)+(centerC(2)-136)).^2+(YI-centerC(1)+(centerC(1)-127)).^2);
D3=sqrt((XI-centerC(2)+(centerC(2)-173)).^2+(YI-centerC(1)+(centerC(1)-105)).^2);
D4=sqrt((XI-centerC(2)+(centerC(2)-160)).^2+(YI-centerC(1)+(centerC(1)-169)).^2);
notch2(D1<=4)=0; notch2(D3<=4)=0;
notch2(D2<=3)=0; notch2(D4<=3)=0;
figure(10)
imshow(notch2)
filtered=FFTCLOWN.*notch2;
figure(11)
imshow(log(abs(filtered)+1),[])
reversed=abs(ifft2(ifftshift(filtered)));
figure(12)
imshow(reversed)
figure(13)
imshow(clown)