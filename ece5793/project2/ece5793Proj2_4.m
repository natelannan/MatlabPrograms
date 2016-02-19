close all
clear all
clc

I=imread('Figure7.tif');
[N,M,Z]=size(I);
L=256;
avN=5;
figure(1)
imshow(I)

II=im2double(I);
lapK = [-1 -1 -1; -1 8 -1; -1 -1 -1];
lapK2 = [1 1 1; 1 -8 1; 1 1 1];
sobelx = [-1 -2 -1; 0 0 0; 1 2 1];
sobely = [-1 0 1; -2 0 2; -1 0 1];
stdAv = ones(avN);
wtAv = [1 4 6 4 1; 4 16 24 16 4; 6 24 36 24 6; 4 16 24 16 4; 1 4 6 4 1;];

padded = padarray(II,[1 1]);
laplacian = zeros(N,M);
sobel = zeros(N,M);
for i=2:N+1
    for j=2:M+1
        laplacian(i-1,j-1) = sum(sum(lapK.*padded(i-1:i+1,j-1:j+1)));
        gx=sum(sum(sobelx.*padded(i-1:i+1,j-1:j+1)));
        gy=sum(sum(sobelx.*padded(i-1:i+1,j-1:j+1)));
        sobel(i-1,j-1) = abs(gx)+abs(gy);
    end
end
figure(2)
imshow(laplacian+abs(min(laplacian(:))))

sharpened=II+laplacian;
figure(3)
imshow(sharpened)

figure(4)
imshow(sobel)
padSobel = padarray(sobel, [2 2]);
avSobel=zeros(N,M);
for i=3:N+2
    for j=3:M+2
        avSobel(i-2,j-2) = sum(sum(stdAv.*padSobel(i-2:i+2,j-2:j+2)));
    end
end
avSobel = avSobel/9;
figure(5)
imshow(avSobel)

final1= laplacian.*avSobel+II;
c=1;  gamma=.5;
final2=c*(final1).^gamma;

figure(6)
imshow(final1)
figure(7)
imshow(final2)
