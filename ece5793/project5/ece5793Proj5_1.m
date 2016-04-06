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
locator=zeros(size(original));
se=strel('disk',1);
bar=imerode(template,se);
ring=template-bar;


foo=regionprops(logical(original), 'BoundingBox');
locator(find(labels==60))=1;

for i=1:numComp
    subImage{i} = {imcrop(original, foo(i).BoundingBox)};
end
figure(1)
imshow(subImage{1,1}{1,1})
figure(2)
imshow(original)
figure(3)
imshow(locator)

