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
xind=[277;292;336;341;356;382;407;420;415;403;408;408;401;361;313;262;242;232; ...
    238;255;288;335;338;278;234;216;222;245;251;313;340;335;306;274;249;244; ...
    249;260;276;297;321;331;349;344;349;357;360;345;325;319;318;336;356;378; ...
    401;396;396;375;333;319;310;287;279;256;233;224;219;210;210;211;263;293; ...
    284;278;277];
yind=[121;99;94;120;135;141;155;199;219;238;257;291;317;352;381;394;396;394; ...
    333;348;355;343;323;317;315;275;252;260;277;285;275;262;251;249;254;246; ...
    231;231;238;239;232;231;258;276;280;268;253;228;210;193;184;188;194;194; ...
    197;190;168;152;149;164;171;171;189;184;181;175;164;188;221;243;204;187; ...
    155;134;121];
mask=roipoly(face,xind,yind);
figure(90)
imshow(mask);

FFTMASK=fftshift(fft2(mask));
for i=1:3
    FFTFACE(:,:,i)=fftshift(fft2(fface(:,:,i)));
    FACE(:,:,i)=log(abs(FFTFACE(:,:,i))+1);
end

figure(1)
imshow(face)
figure(2)
imshow(face_enhanced)
D0=36;
D0Butt=36;
D02=30;
n=2;
LPF=ones(info.Height,info.Width);
u=1:info.Height; v=1:info.Width;
[XI, YI] = ndgrid(u,v);
D=sqrt((XI-(info.Height/2+1)).^2+(YI-(info.Width/2+1)).^2);
LPF(D<=100)=1;
LPF(D>100)=0;
Gauss=exp(-D.^2./(2*D0.^2));
Butt=1./(1+(D./D0Butt).^(2*n));
maskFilter=exp(-D.^2./(2*D02.^2));

maskFilt=FFTMASK.*maskFilter;
maskR=abs(ifft2(ifftshift(maskFilt)));
figure(91)
imshow(maskR);
for i=1:3
    filtered(:,:,i) = FFTFACE(:,:,i).*LPF;
    gaussFilt(:,:,i)=FFTFACE(:,:,i).*Gauss;
    buttFilt(:,:,i)=FFTFACE(:,:,i).*Butt;
    recovered(:,:,i)=abs(ifft2(ifftshift(filtered(:,:,i))));
    recoveredG(:,:,i)=abs(ifft2(ifftshift(gaussFilt(:,:,i))));
    recoveredB(:,:,i)=abs(ifft2(ifftshift(buttFilt(:,:,i))));
    slice(:,:,i)=recovered(:,:,i).*mask;
    sliceG(:,:,i)=recoveredG(:,:,i).*mask;
    sliceB(:,:,i)=recoveredB(:,:,i).*mask;
    sliceFinal(:,:,i)=recoveredG(:,:,i).*maskR;
end
%foo=ifftshift(filtered);

figure(3)
imshow(sliceFinal)
R=sliceFinal(:,:,1);
G=sliceFinal(:,:,1);
B=sliceFinal(:,:,1);
sliceFinal(sliceFinal<.2)=0;

edited=fface;
editedG=fface;
editedB=fface;
editedFinal=fface;
edited(find(slice~=0))=slice(find(slice~=0));
editedG(find(sliceG~=0))=sliceG(find(sliceG~=0));
editedB(find(sliceB~=0))=sliceB(find(sliceB~=0));
%editedFinal(find(sliceFinal~=0))=sliceFinal(find(sliceFinal~=0));
for z=1:3
    for i=2:info.Height-1
        for j=2:info.Width-1
            if sliceFinal(i-1,j-1,z)<.1*sliceFinal(i,j,z)
                
                editedFinal(i,j,z)=sqrt(editedFinal(i,j,z).^2+sliceFinal(i,j,z).^2);
%                 editedFinal(i,j,z)=editedFinal(i,j,z);
            elseif sliceFinal(i-1,j,z)<.1*sliceFinal(i,j,z)
                editedFinal(i,j,z)=sqrt(editedFinal(i,j,z).^2+sliceFinal(i,j,z).^2);
            elseif sliceFinal(i,j-1,z)<.1*sliceFinal(i,j,z)
                 editedFinal(i,j,z)=sqrt(editedFinal(i,j,z).^2+sliceFinal(i,j,z).^2);
            else
                if sliceFinal(i,j,z)>.2
                    editedFinal(i,j,z)=sliceFinal(i,j,z);
                else
                    editedFinal(i,j,z)=editedFinal(i,j,z);
                end
            end
        end
    end
end
figure(4)
imshow(edited)
figure(5)
imshow(editedG)
figure(6)
imshow(editedB)
figure(7)
imshow(editedFinal)