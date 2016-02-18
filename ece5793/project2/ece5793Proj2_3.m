close all
clear all
clc

I=imread('Figure6.tif');
[N,M,Z]=size(I);
L=256;
figure(1)
subplot(1,2,1)
imshow(I)
subplot(1,2,2)
imhist(I)

yscale=10^4;
x=0:255;
y(x<=8)=yscale*0.875*x(x<=8);
y(8<x&x<=16)=yscale*(-0.8021*x(8<x&x<=16)+13.417);
y(16<x&x<=176)=yscale*(-0.00364*x(16<x&x<=176)+.64166);
y(176<x&x<=202)=yscale*(0.0168*x(176<x&x<=202)-2.962);
y(202<x)=yscale*(-0.00825*x(202<x)+2.105);
y=round(y)/sum(y);

figure(2)
plot(x,y);

Gzq=zeros(1,L);
for i=1:L
    Gzq(i)=(L-1)*sum(y(1:i));
    Gzq(i)=round(Gzq(i));
end


[n,edges]=histcounts(I, L, 'BinMethod', 'integer');
forePad=zeros(1,ceil(edges(1)));
aftPad=zeros(1,(L-1)-floor(edges(end)));
nk=cat(2,forePad,n,aftPad);

sk=zeros(1,L);
corrected=zeros(N,M);
for i=1:L
    sk(i)=(L-1)/(M*N)*sum(nk(1:i));
    sk(i)=round(sk(i));
    corrected(find(I==(i-1)))=sk(i);
end
corrected = cast(corrected,'uint8');

figure(3)
subplot(1,2,1)
imshow(corrected);
subplot(1,2,2)
imhist(corrected)