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
% ButtLPF=ones(256);
% u=1:256; v=1:256;
% [XI, YI] = ndgrid(u,v);
% D1=sqrt((XI-centerL(2)+12).^2+(YI-centerL(1)+12).^2);
% D2=sqrt((XI-centerL(2)-12).^2+(YI-centerL(1)-12).^2);
% % D=sqrt((XI-centerL(2)).^2+(YI-centerL(1)).^2);
% n=2;
% D0=6;
% ButtLPF=1./(1+((D0.^2)./(D1.*D2)).^(2*n));
% figure(4)
% imshow(ButtLPF)
% 
% filtered = FFTLENA.*ButtLPF;
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
pts=[128 112 96 80 64 48 32 16];
pts=fliplr(pts);
D0=12;
D0_2=3;
Gauss=ones([lenaInfo.Height lenaInfo.Width 8]);
Gauss2=ones([lenaInfo.Height lenaInfo.Width 17]);
% foo=zeros(lenaInfo.Height);
for i=1:length(pts)
    D1=sqrt((XI-centerL(2)+pts(i)).^2+(YI-centerL(1)+pts(i)).^2);
    D2=sqrt((XI-centerL(2)-pts(i)).^2+(YI-centerL(1)-pts(i)).^2);
    Gauss(:,:,i)=1-exp(-.5*((D1.*D2)./(D0.^2)));
%     foo=(1-ButtNotch)+foo;
end
GaussNotch=Gauss(:,:,1).*Gauss(:,:,2).*Gauss(:,:,3).*Gauss(:,:,4).* ...
    Gauss(:,:,5).*Gauss(:,:,6).*Gauss(:,:,7).*Gauss(:,:,8);

for i=1:16:lenaInfo.Height+1
    if i~=129
        D=sqrt((XI-i).^2+(YI-i).^2);
        Gauss2(:,:,floor(i/16)+1)=1-exp(-D.^2./(2*D0_2.^2));
    end
end
GaussNotch2 = Gauss2(:,:,1).*Gauss2(:,:,2).*Gauss2(:,:,3).*Gauss2(:,:,4).* ...
    Gauss2(:,:,5).*Gauss2(:,:,6).*Gauss2(:,:,7).*Gauss2(:,:,8).*Gauss2(:,:,9).* ...
    Gauss2(:,:,10).*Gauss2(:,:,11).*Gauss2(:,:,12).*Gauss2(:,:,13).*Gauss2(:,:,14).* ...
    Gauss2(:,:,15).*Gauss2(:,:,16).*Gauss2(:,:,17);
% foo=1-foo;
% D1=sqrt((XI-center(2)-1).^2+(YI-center(1)-1).^2);
% D2=sqrt((XI-center(2)+15).^2+(YI-center(1)+15).^2);

% notch(D2<1)=0;
figure(5)
imshow(GaussNotch2)
figure(6)
imshow(GaussNotch)

filtered = FFTLENA.*GaussNotch;
filtered2=FFTLENA.*GaussNotch2;
figure(7)
subplot(2,1,1)
imshow(log(abs(filtered)+1),[])
subplot(2,1,2)
imshow(log(abs(filtered2)+1),[])

reversed=abs(ifft2(ifftshift(filtered)));
reversed2=abs(ifft2(ifftshift(filtered2)));
figure(8)
imshow(reversed)
figure(9)
imshow(reversed2)

u=1:clownInfo.Height+2*padSize; v=1:clownInfo.Width+2*padSize;
[XI, YI] = ndgrid(u,v);
D1=sqrt((XI-centerC(2)+(centerC(2)-405)).^2+(YI-centerC(1)+(centerC(1)-378)).^2);
D2=sqrt((XI-centerC(2)+(centerC(2)-368)).^2+(YI-centerC(1)+(centerC(1)-570)).^2);
D3=sqrt((XI-centerC(2)+(centerC(2)-516)).^2+(YI-centerC(1)+(centerC(1)-314)).^2);
D4=sqrt((XI-centerC(2)+(centerC(2)-479)).^2+(YI-centerC(1)+(centerC(1)-506)).^2);
D5=abs(XI-405); D6=abs(YI-378);D7=abs(XI-368); D8=abs(YI-570);
D9=abs(XI-516); D10=abs(YI-314);D11=abs(XI-479); D12=abs(YI-506);
% notch2(D1<=24)=0; notch2(D4<=24)=0;
% notch2(D2<=36)=0; notch2(D3<=36)=0;
D0clown1=28;
D0clown2=68;
notch2=(1-exp(-.5*((D1.*D4)./(D0clown1.^2)))).*(1-exp(-.5*((D2.*D3)./(D0clown2.^2))));
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