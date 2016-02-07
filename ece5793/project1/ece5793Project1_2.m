%ece5793Project1_2.m
% MATLAB script written to register image 'lean256B.bmp' to target image
% 'lena256.bmp'.  The registered image is interpolated using three 
% techniques: nearest neighbor, bilinear, and bicubic.  The difference 
% of the resultant registered images and the target are found and displayed 
% to view registration errors.
% 
% Preconditions:  MATLAB function sombrero.m is in the same directory as
% this script.
% Post conditions:  Images displaying original image, target image, 
% registered images and difference images are displayed.
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/5/16


%-------Clean the workspace------------------------------------------------
clear all
close all
clc

%-------Read in image files and create normalized versions-----------------
I=imread('lean256B.bmp');
target=imread('lena256.bmp');
II=im2double(I);
normalized = im2double(target);

%highlight pixels used for registration for viewing
highlight=II;
highlight2=normalized;
highlight(3,69)=1; highlight2(1,1)=1;
highlight(69,315)=1; highlight2(1,size(highlight2,2))=1;
highlight(315,249)=1; highlight2(size(highlight2,1),size(highlight2,2))=1;
highlight(249,3)=1; highlight2(size(highlight2,1),1)=1;
highlight(95,273)=1; highlight2(37,222)=1;

%-------Display original image and target image----------------------------
figure(1)
subplot(1,2,1)
imshow(highlight);
title('Original Image')
subplot(1,2,2)
imshow(highlight2)
title('Target Image')

%-------Build A matrix for system of linear eqs.---------------------------
%5 points used.  The 4 corners and point at [95 273]
A=[3 69 1 0 0 0; ... 
   0 0 0 3 69 1; ...
   69 315 1 0 0 0; ...
   0 0 0 69 315 1; ...
   315 249 1 0 0 0; ...
   0 0 0 315 249 1; ...
   249 3 1 0 0 0; ...
   0 0 0 249 3 1; ...
   95 273 1 0 0 0; ...
   0 0 0 95 273 1];

%-------Build vector B and solve for T matrix------------------------------
%Points are points in target that correspond to points chosen for matrix A
B=[1;1;1;size(target,2); size(target,1);size(target,2);size(target,1);1;37;222];
t=linsolve(A,B);
T=[t(1) t(4) 0; t(2) t(5) 0; t(3) t(6) 1];
invT=inv(T);

%-------Preallocating space for registered images--------------------------
temp = uint8(0);
NN(256,256) = temp;
BL=zeros(256);
BC=zeros(256);

%-------Use inverse of T to map original pixels to registered image point--
%interpolate for each pixel while mapping to save calculations
for i=1:size(target,1)  %x loop
    for j=1:size(target,2)  %y loop
        coord=[i j 1]*invT;  %get point to be mapped to (x,y)
        u=coord(1); v=coord(2);
        %-------Interpolate result to pick a point on grid-----------------
        %-------Nearest Neighbor-------------------------------------------
        U=round(u); V=round(v);
        NN(i,j) = I(U,V);
        
        %----------Bilinear------------------------------------------------
        UI=u-floor(u); VI=v-floor(v);  %Calculate distance to grid points
        %Calculate intensity values at grid points
        I1=II(floor(u),floor(v)); I2=II(floor(u),ceil(v)); 
        I3=II(ceil(u),floor(v)); I4=II(ceil(u),ceil(v));
        %Calculate weights
        c1=(1-UI)*(1-VI); c2=(1-UI)*VI; c3=UI*(1-VI); c4=UI*VI;
        %Calculate intensity value based on weighting
        BL(i,j)=c1.*I1+c2.*I2+c3.*I3+c4.*I4;
        
        %----------Bicubic-------------------------------------------------
        %Calculate grid point indicies 
        X1 = floor(u)-1; X2 = floor(u); X3 = floor(u)+1; X4 = floor(u)+2;
        Y1 = floor(v)-1; Y2 = floor(v); Y3 = floor(v)+1; Y4 = floor(v)+2;
        
        %Mexican hat calculations for weighting
        H11 = sombrero(X1-u)*sombrero(Y1-v); 
        H12 = sombrero(X1-u)*sombrero(Y2-v);
        H13 = sombrero(X1-u)*sombrero(Y3-v); 
        H14 = sombrero(X1-u)*sombrero(Y4-v);

        H21 = sombrero(X2-u)*sombrero(Y1-v); 
        H22 = sombrero(X2-u)*sombrero(Y2-v);
        H23 = sombrero(X2-u)*sombrero(Y3-v); 
        H24 = sombrero(X2-u)*sombrero(Y4-v);

        H31 = sombrero(X3-u)*sombrero(Y1-v); 
        H32 = sombrero(X3-u)*sombrero(Y2-v);
        H33 = sombrero(X3-u)*sombrero(Y3-v); 
        H34 = sombrero(X3-u)*sombrero(Y4-v);

        H41 = sombrero(X4-u)*sombrero(Y1-v); 
        H42 = sombrero(X4-u)*sombrero(Y2-v);
        H43 = sombrero(X4-u)*sombrero(Y3-v); 
        H44 = sombrero(X4-u)*sombrero(Y4-v);
        
        %Calculate intensity at grid points
        I11 = II(X1, Y1); I12 = II(X1, Y2);
        I13 = II(X1, Y3); I14 = II(X1, Y4);

        I21 = II(X2, Y1); I22 = II(X2, Y2);
        I23 = II(X2, Y3); I24 = II(X2, Y4);

        I31 = II(X3, Y1); I32 = II(X3, Y2);
        I33 = II(X3, Y3); I34 = II(X3, Y4);

        I41 = II(X4, Y1); I42 = II(X4, Y2);
        I43 = II(X4, Y3); I44 = II(X4, Y4);
        
        %Calculate intensity value based on weighting
        BC(i,j) = H11*I11 + H12*I12 + H13*I13 + H14*I14 + ...
               H21*I21 + H22*I22 + H23*I23 + H24*I24 + ...
               H31*I31 + H32*I32 + H33*I33 + H34*I34 + ...
               H41*I41 + H42*I42 + H43*I43 + H44*I44;
    end
end

%-------Calculate the differences in target with each registered image-----
NNdiff = abs(target-NN);
BLdiff = abs(normalized-BL);
BCdiff = abs(normalized-BC);

%-------Display each registered image with difference image----------------
figure(2)
subplot(1,2,1)
imshow(NN)
title('Nearest Neighbor')
subplot(1,2,2)
imshow(NNdiff)
title('Difference From Target')
figure(3)
subplot(1,2,1)
imshow(BL)
title('Bilinear')
subplot(1,2,2)
imshow(BLdiff)
title('Difference From Target')
figure(4)
subplot(1,2,1)
imshow(BC)
title('Bicubic')
subplot(1,2,2)
imshow(BCdiff)
title('Difference From Target')