%ece5793Project5_1.m
% MATLAB script written to 
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
original=imread('cells.bmp');
template=imread('disc.bmp');
se=strel('disk',1);
innerC=imerode(template,se);
ring=template-innerC;

figure(1)
imshow(original);
% figure(2)
% [numLoners, Lcomps,subL]=displayLoners(original,4);
% figure(3)
% [numEdge, Ecomps,subE]=displayEdges(original,49);
% figure(4)
% [numClusters, Ccomps,subC]=displayClusters(original,73); %55?, 73?
% number=0;
% for i=1:129
%     [numClusters, Ccomps, subC]=displayClusters(original,i);
%     [numDisks, ringplot] =countDiscs(subC);
%     number=number+numDisks;
%     imshow(ringplot)
% end
% disp(number)
countedImage=zeros(size(original));
number=0;
[subImages,origins,numComp]=allSubimage(original);
for i=1:numComp
    [numDisks, dots] =countDiscs(subImages{1,i}{1,1});
    [x,y]=ind2sub(size(dots),find(dots==1));
    originalx=x+origins(i,1);
    originaly=y+origins(i,2);
    countedImage(sub2ind(size(original),originalx,originaly))=1;
    number=number+numDisks;
end
rings=imdilate(countedImage,ring);
display(number)
figure(5)
imshow(rings)

