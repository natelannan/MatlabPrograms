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
[labels numComp]=bwlabel(original);
se=strel('disk',1);
bar=imerode(template,se);
ring=template-bar;


s=regionprops(logical(original), 'BoundingBox');

figure(1)
imshow(original);
% figure(2)
% [numLoners, Lcomps,subL]=displayLoners(original,4);
% figure(3)
% [numEdge, Ecomps,subE]=displayEdges(original,49);
figure(4)
[numClusters, Ccomps,subC]=displayClusters(original,72); %fails on edges -> out of bounds, found extra on #22
[numDisks, ringplot] =countDiscs(subC);
disp(numDisks)
figure(5)
imshow(ringplot)

