%ece5793Project2_2.m
% MATLAB script written to enhance 5 low contrast images (3 grayscale and
% 2 color).  The images are enhanced using histogram equalization and are   
% displayed along with their respective historgrams.  The original images 
% with histograms are also displayed for comparison purposes.
% 
% Preconditions:  MATLAB functions displayHist.m and equalize.m are in the 
% same directory as this script.
% Post conditions:  Displayed original and enhanced images along with their
% respective histograms.
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/15/16

%-------Clean workspace----------------------------------------------------

close all
clear all
clc
%-------Read in images and initialize--------------------------------------
high=imread('Figure3.tif');
mid=imread('Figure4.tif');
low=imread('Figure5.tif');
child=imread('color2.jpg');
farm=imread('color1.jpg');

%------Display originals and histograms------------------------------------
figure(1)
subplot(1,2,1)
imshow(low)
subplot(1,2,2)
displayHist(low)
figure(2)
subplot(1,2,1)
imshow(mid)
subplot(1,2,2)
displayHist(mid)
figure(3)
subplot(1,2,1)
imshow(high)
subplot(1,2,2)
displayHist(high)
figure(4)
imshow(child)
figure(5)
displayHist(child)
figure(6)
imshow(farm)
figure(7)
displayHist(farm)

%------Equalize and display with histograms--------------------------------
lowEQ=equalize(low); %Equalize
figure(8)
subplot(1,2,1)
imshow(lowEQ)
subplot(1,2,2)
displayHist(lowEQ)

midEQ=equalize(mid); %Equalize
figure(9)
subplot(1,2,1)
imshow(midEQ)
subplot(1,2,2)
displayHist(midEQ)

highEQ=equalize(high); %Equalize
figure(10)
subplot(1,2,1)
imshow(highEQ)
subplot(1,2,2)
displayHist(highEQ)

childEQ=equalize(child); %Equalize
figure(11)
imshow(childEQ)
figure(12)
displayHist(childEQ)

farmEQ=equalize(farm); %Equalize
figure(13)
imshow(farmEQ)
figure(14)
displayHist(farmEQ)


