%ece5793Project4_3.m
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/15/16

%-------Clean workspace----------------------------------------------------
close all
clear all
clc


%-------Read in images and initialize--------------------------------------
face=imread('face.jpg');
info=imfinfo('face.jpg');
faceR=face(:,:,1);
faceG=face(:,:,2);
faceB=face(:,:,3);
faceHSI=rgb2hsv(face);
faceH=faceHSI(:,:,1);
faceS=faceHSI(:,:,2);
faceI=faceHSI(:,:,3);


dface=im2double(face);
figure(1)
subplot(1,3,1)
imshow(faceR)
title('Red Face')
subplot(1,3,2)
imshow(faceG)
title('Green Face')
subplot(1,3,3)
imshow(faceB)
title('Blue Face')

figure(2)
subplot(1,3,1)
imshow(faceH)
title('Hue Face')
subplot(1,3,2)
imshow(faceS)
title('Saturation Face')
subplot(1,3,3)
imshow(faceI)
title('Intensity Face')

hueThresh1=.97;
hueThresh2=.05;
satThresh=.3;
intThresh=.2;
mask=zeros(info.Height, info.Width);
mask(find(faceH>hueThresh1 | faceH<hueThresh2))=1;

figure(3)
imshow(mask)

mask(find(faceS<satThresh))=0;
figure(4)
imshow(mask)

mask(find(faceI<intThresh))=0;
figure(5)
imshow(mask)

%==========================================================================
xStart=202;
xStop=313;
yStart=231;
yStop=398;

trainer=dface(xStart:xStop,yStart:yStop,:);
figure(6)
imshow(trainer)

dimsTrainer=size(trainer);
avg=sum(sum(trainer))/(dimsTrainer(1)*dimsTrainer(2));

avgMat=repmat(avg,info.Height, info.Width);
diff=dface-avgMat;
%euclidD=sqrt(diff*diff');  how to do this?

euclidD=zeros(info.Height,info.Width);
mask2=zeros(info.Height,info.Width);
for i=1:info.Height
    for j=1:info.Width
        temp=permute(diff(i,j,:), [2 3 1]);
        euclidD(i,j)=sqrt(temp*temp');
    end
end

distThresh=.1;
mask2(find(euclidD<distThresh))=1;

figure(7)
imshow(mask2)

distThresh=.15;
mask2(find(euclidD<distThresh))=1;

figure(8)
imshow(mask2)

distThresh=.2;
mask2(find(euclidD<distThresh))=1;

figure(9)
imshow(mask2)

%==========================================================================

