%ece5793Project2_1.m
% MATLAB script written to enhance 4 low contrast images (2 grayscale and
% 2 color).  The images are enhanced using power-law transformation and are   
% displayed along with their respective historgrams.  The original images 
% with histograms are also displayed for comparison purposes.
% 
% Preconditions:  MATLAB function displayHist.m is in the same directory as
% this script.
% Post conditions:  Displayed original and enhanced images along with their
% respective histograms.
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/15/16

%-------Clean workspace----------------------------------------------------
clear all 
close all
clc

%-------Read in images and initialize--------------------------------------
spine=imread('Figure1.tif');
arial=imread('Figure2.tif');
balloons=imread('color3.jpg');
face=imread('color5.jpg');
spine=im2double(spine);
arial=im2double(arial);
balloons=im2double(balloons);
face=im2double(face);

%------Display originals and histograms------------------------------------
figure(1)
subplot(1,2,1)
imshow(spine)
subplot(1,2,2)
displayHist(spine)
figure(2)
subplot(1,2,1)
imshow(arial)
subplot(1,2,2)
displayHist(arial)
figure(3)
imshow(balloons)
figure(4)
displayHist(balloons)
figure(5)
imshow(face)
figure(6)
displayHist(face)

%------Power-Law Constants-------------------------------------------------
cSpine=1;
gammaSpine=0.5;
cArial = 1;
gammaArial=2.5;
cFace=1;
gammaFace=.7;
cBallons = 1;
gammaBallons=2.4;

%------Power-Law Calculations----------------------------------------------
adjSpine = cSpine*(spine).^gammaSpine;
adjArial = cArial*(arial).^gammaArial;
adjBalloons = cBallons*(balloons).^gammaBallons;
adjFace = cFace*(face).^gammaFace;

%------Display enhanced images and histograms------------------------------
figure(7)
subplot(1,2,1)
imshow(adjSpine)
subplot(1,2,2)
displayHist(adjSpine)
figure(8)
subplot(1,2,1)
imshow(adjArial)
subplot(1,2,2)
displayHist(adjArial)
figure(9)
imshow(adjBalloons)
figure(10)
displayHist(adjBalloons)
figure(11)
imshow(adjFace)
figure(12)
displayHist(adjFace)