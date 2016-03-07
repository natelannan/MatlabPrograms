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


% for i=1:3
%     normDuck(:,:,i)=dduck(:,:,i)-min(min(dduck(:,:,i)));
%     normDuck(:,:,i)=dduck(:,:,i)/max(max(dduck(:,:,i)));
% end
normDuck=(dduck-min(min(min(dduck))))/(max(max(max(dduck))));
% normDuck=padarray(normDuck,[info.Height info.Width],'post');
% dduck=padarray(dduck,[info.Height info.Width],'post');

% figure(90)
% imshow(dduck)

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

NORMFFTDUCK_R=fftshift(fft2(normDuck(:,:,1)));
NORMFFTDUCK_G=fftshift(fft2(normDuck(:,:,2)));
NORMFFTDUCK_B=fftshift(fft2(normDuck(:,:,3)));
% NORMDUCK_R=log(abs(NORMFFTDUCK_R)+1);
% NORMDUCK_G=log(abs(NORMFFTDUCK_G)+1);
% NORMDUCK_B=log(abs(NORMFFTDUCK_B)+1);




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

HPF=zeros(info.Height,info.Width);
% Butt=zeros(info.Height,info.Width);
% Gauss=zeros(info.Height,info.Width);
% Laplace=zeros(info.Height,info.Width);
D0Butt=6;
D0Gauss=6;
n=2;
u=1:info.Height; v=1:info.Width;
[XI, YI] = ndgrid(u,v);
D=sqrt((XI-((info.Height)/2 +1)).^2+(YI-((info.Width)/2 +1)).^2);
HPF(D<=3)=0;
HPF(D>3)=1;
Butt=1./(1+(D0Butt./D).^(2*n));
Gauss=1-exp(-D.^2./(2*D0Gauss.^2));
Laplace=-4*pi^2*D.^2;
shiftLaplace=Laplace-min(min(Laplace));
normLaplace=shiftLaplace/max(max(shiftLaplace));

figure(18)
imshow(normLaplace)
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

LaplacianF(:,:,1)= NORMFFTDUCK_R.*Laplace;
LaplacianF(:,:,2)= NORMFFTDUCK_G.*Laplace;
LaplacianF(:,:,3)= NORMFFTDUCK_B.*Laplace;

LaplacianFthing(:,:,1)= NORMFFTDUCK_R.*normLaplace;
LaplacianFthing(:,:,2)= NORMFFTDUCK_G.*normLaplace;
LaplacianFthing(:,:,3)= NORMFFTDUCK_B.*normLaplace;

for i=1:3
    BRecovered(:,:,i)=abs(ifft2(ifftshift(BFiltered(:,:,i))));
    ERecovered(:,:,i)=abs(ifft2(ifftshift(EFiltered(:,:,i))));
    BRecoveredButt(:,:,i)=abs(ifft2(ifftshift(BFilteredButt(:,:,i))));
    ERecoveredButt(:,:,i)=abs(ifft2(ifftshift(EFilteredButt(:,:,i))));
    BRecoveredGauss(:,:,i)=abs(ifft2(ifftshift(BFilteredButt(:,:,i))));
    ERecoveredGauss(:,:,i)=abs(ifft2(ifftshift(EFilteredButt(:,:,i))));
    Laplacian(:,:,i)=ifft2(ifftshift(LaplacianF(:,:,i)));
%     hmm(:,:,i)=ifft2(ifftshift(LaplacianFthing(:,:,i)));
    %normLaplacian(:,:,i)=Laplacian(:,:,i)/max(max(Laplacian(:,:,i)));
end
% Laplacian(1,:,:)=0;
normLaplacian=Laplacian/max(max(max(Laplacian(:,:,i))));
% BRecovered=imcrop(BRecovered,[1 1 info.Width-1 info.Height-1]);
% ERecovered=imcrop(ERecovered,[1 1 info.Width-1 info.Height-1]);
% BRecoveredButt=imcrop(BRecoveredButt,[1 1 info.Width-1 info.Height-1]);
% BRecoveredGauss=imcrop(BRecoveredGauss,[1 1 info.Width-1 info.Height-1]);
% ERecoveredButt=imcrop(ERecoveredButt,[1 1 info.Width-1 info.Height-1]);
% ERecoveredGauss=imcrop(ERecoveredGauss,[1 1 info.Width-1 info.Height-1]);

c=1;  gamma=.8;
Bfinal=c*(BRecovered).^gamma;
Efinal=c*(ERecovered).^gamma;
% scaled=linspace(min(BRecovered(:)),max(BRecovered(:)),256);
% BRecoveredINT=uint8(arrayfun(@(x) find(abs(scaled(:)-x)==min(abs(scaled(:)-x))),BRecovered));
% Beqd=equalize(BRecoveredINT);

figure(3)
imshow(BRecovered)
figure(4)
imshow(ERecovered)
figure(5)
imshow(Bfinal)
figure(6)
imshow(Efinal)
% 
% figure(13)
% imshow(Beqd)


c=1;  gamma=.8;
BfinalButt=c*(BRecoveredButt).^gamma;
EfinalButt=c*(ERecoveredButt).^gamma;


figure(7)
imshow(BRecoveredButt)
figure(8)
imshow(ERecoveredButt)
figure(9)
imshow(BfinalButt)
figure(10)
imshow(EfinalButt)

c=1;  gamma=.8;
BfinalGauss=c*(BRecoveredGauss).^gamma;
EfinalGauss=c*(ERecoveredGauss).^gamma;

figure(11)
imshow(BRecoveredGauss)
figure(12)
imshow(ERecoveredGauss)
figure(13)
imshow(BfinalGauss)
figure(14)
imshow(EfinalGauss)

% figure(15)
% imshow(hmm)

enhanced=normDuck-normLaplacian;
% enhanced=imcrop(enhanced,[1 1 info.Width-1 info.Height-1]);
figure(16)
imshow(enhanced)

enhancedPower=c*(enhanced).^gamma;

figure(17)
imshow(enhancedPower)

