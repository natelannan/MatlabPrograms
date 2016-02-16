close all
clear all
clc

high=imread('Figure3.tif');
mid=imread('Figure4.tif');
low=imread('Figure5.tif');
[N,M,Z]=size(high);
L=256;


figure(1)
subplot(1,2,1)
imshow(low)
subplot(1,2,2)
imhist(low)
figure(2)
subplot(1,2,1)
imshow(mid)
subplot(1,2,2)
imhist(mid)
figure(3)
subplot(1,2,1)
imshow(high)
subplot(1,2,2)
imhist(high)

[n,edges]=histcounts(high, L, 'BinMethod', 'integer');
forePad=zeros(1,ceil(edges(1)));
aftPad=zeros(1,(L-1)-floor(edges(end)));
nk=cat(2,forePad,n,aftPad);

sk=zeros(1,L);
corrected=zeros(N,M);
for i=1:L
    sk(i)=(L-1)/(M*N)*sum(nk(1:i));
    sk(i)=round(sk(i));
    corrected(find(high==i))=sk(i);
end
corrected = cast(corrected,'uint8');
figure(4)
subplot(1,2,1)
imshow(corrected)
subplot(1,2,2)
imhist(corrected)



