%ece5793Project3_1.m
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
face=imread('face.jpg');
face_enhanced=imread('face_enhanced.jpg');
info=imfinfo('face.jpg');


L=2^(info.BitDepth/3);
fface=im2double(face);

for i=1:3
    FFTFACE(:,:,i)=fftshift(fft2(fface(:,:,i)));
    FACE(:,:,i)=log(abs(FFTFACE(:,:,i))+1);
end

figure(1)
imshow(face)
figure(2)
imshow(face_enhanced)

LPF=ones(info.Height,info.Width);
u=1:info.Height; v=1:info.Width;
[XI, YI] = ndgrid(u,v);
D=sqrt((XI-(info.Height/2+1)).^2+(YI-(info.Width/2+1)).^2);
LPF(D<=30)=1;
LPF(D>30)=0;


for i=1:3
    filtered(:,:,i) = FFTFACE(:,:,i).*LPF;
    recovered(:,:,i)=abs(ifft2(ifftshift(filtered(:,:,i))));
end
%foo=ifftshift(filtered);

figure(3)
imshow(recovered)

slice=recovered(154:174,281:323,:);
edited=fface;
edited(154:174,281:323,:)=slice;
figure(4)
imshow(edited)