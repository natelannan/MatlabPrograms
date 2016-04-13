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
%
%==================debugging===============================================
%==================just test one specific component========================
% figure(4)
% [numClusters, Ccomps,subC]=displayClusters(original,55); %31, 80,40, 47, 55?, 66, 73
% % [numLoners, Lcomps,subL]=displayLoners(original,4);
% [numDisks, dots]=countDiscs(subC);
% ringplot=imdilate(dots,ring);
% figure(7)
% imshow(ringplot)
%=================loop through all components of a type====================
% number=0;
% for i=1:numLoners
%     figure(6)
%     [numClusters, Ccomps, subC]=displayClusters(original,Ccomps(i));
% %     [numLoners, Lcomps, subL]=displayLoners(original,Lcomps(i));
%     [numDisks, dots] =countDiscs(subC);
%     number=number+numDisks;
%     disp(numDisks)
% %     disp(number)
%     ringplot=imdilate(dots,ring);
%     figure(7)
%     imshow(ringplot)
% end
%==========================================================================
%
%==================final algorithm=========================================
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

figure(5);
imshow(rings);
% imwrite(rings,'finalRings.bmp');


