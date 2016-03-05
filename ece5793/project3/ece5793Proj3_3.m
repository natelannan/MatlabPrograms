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
lenaInfo=imfinfo('leangray.bmp');

llena=im2double(lena);

clown=imread('clowngray.bmp');
clownInfo=imfinfo('clowngray.bmp');

L=256;
padSize=294;
cclown=im2double(clown);
cclown=padarray(cclown,[padSize padSize]);


CLOWN = log(abs(fftshift(fft2(cclown)))+1);
FFTCLOWN=fftshift(fft2(cclown));
FFTLENA=fftshift(fft2(llena));
LENA = log(abs(fftshift(fft2(llena)))+1);

%-------Display Original---------------------------------------------------
figure(1)
subplot(2,2,1)
imshow(lena)
subplot(2,2,2)
imshow(cclown)
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
centerL=[lenaInfo.Height/2+1 lenaInfo.Width/2+1];
centerC=[(clownInfo.Height+2*padSize)/2+1 (clownInfo.Width+2*padSize)/2+1];
notch=ones(lenaInfo.Height);
notch2=ones(clownInfo.Height+2*padSize);
u=1:lenaInfo.Height; v=1:lenaInfo.Width;
[XI, YI] = ndgrid(u,v);
% D=sqrt((XI-128).^2+(YI-128).^2);
pts=[128 112 96 80 64 48 32 16 -16 -32 -48 -64 -80 -96 -112 -128];
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

u=1:clownInfo.Height+2*padSize; v=1:clownInfo.Width+2*padSize;
[XI, YI] = ndgrid(u,v);
D1=sqrt((XI-centerC(2)+(centerC(2)-405)).^2+(YI-centerC(1)+(centerC(1)-378)).^2);
D2=sqrt((XI-centerC(2)+(centerC(2)-368)).^2+(YI-centerC(1)+(centerC(1)-570)).^2);
D3=sqrt((XI-centerC(2)+(centerC(2)-516)).^2+(YI-centerC(1)+(centerC(1)-314)).^2);
D4=sqrt((XI-centerC(2)+(centerC(2)-479)).^2+(YI-centerC(1)+(centerC(1)-506)).^2);
D5=abs(XI-405); D6=abs(YI-378);D7=abs(XI-368); D8=abs(YI-570);
D9=abs(XI-516); D10=abs(YI-314);D11=abs(XI-479); D12=abs(YI-506);
notch2(D1<=24)=0; notch2(D4<=24)=0;
notch2(D2<=36)=0; notch2(D3<=36)=0;
notch2((D5<1|D6<1)&(abs(YI-centerC(1))>4)&(abs(XI-centerC(2))>4))=0;
notch2((D7<1|D8<1)&(abs(YI-centerC(1))>4)&(abs(XI-centerC(2))>4))=0;
notch2((D9<1|D10<1)&(abs(YI-centerC(1))>4)&(abs(XI-centerC(2))>4))=0;
notch2((D11<1|D12<1)&(abs(YI-centerC(1))>4)&(abs(XI-centerC(2))>4))=0;
figure(10)
imshow(notch2)
filtered=FFTCLOWN.*notch2;
figure(11)
imshow(log(abs(filtered)+1),[])
reversed=abs(ifft2(ifftshift(filtered)));
reversed=imcrop(reversed,[padSize+1 padSize+1 padSize-1 padSize-1]);
figure(12)
imshow(reversed)
figure(13)
imshow(clown)