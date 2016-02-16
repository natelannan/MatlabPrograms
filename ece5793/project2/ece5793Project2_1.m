clear all 
close all
clc

spine=imread('Figure1.tif');
arial=imread('Figure2.tif');
spine=im2double(spine);
arial=im2double(arial);

figure(1)
subplot(1,2,1)
imshow(spine)
subplot(1,2,2)
imhist(spine)
figure(2)
subplot(1,2,1)
imshow(arial)
subplot(1,2,2)
imhist(arial)

cSpine=1;
gammaSpine=.5;
cArial = 1;
gammaArial=1.5;

adjSpine = cSpine*(spine).^gammaSpine;
adjArial = cArial*(arial).^gammaArial;

figure(3)
subplot(1,2,1)
imshow(adjSpine)
subplot(1,2,2)
imhist(adjSpine)
figure(4)
subplot(1,2,1)
imshow(adjArial)
subplot(1,2,2)
imhist(adjArial)