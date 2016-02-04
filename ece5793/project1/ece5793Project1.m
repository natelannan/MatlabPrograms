clear all
close all
clc


% foo = -2.5:.01:2.5;
% for i=1:size(foo,2)
%     poo(i)=sombrero(foo(i));
% end
% figure(5)
% plot(foo,poo)

%nearest neighbor
p=1.3718;  %scaling factor
%I = [1 0 1 0; 0 0 0 1; 1 1 0 1; 0 1 0 1;];
% I=imread('lena256.bmp');
% I=ones(256);
I=imread('cow.bmp');
[x,y,z]=size(I);  %grab dims of image
u=1:1/p:x; v=1:1/p:y;   %create image array of new size (basically overlaying over old coordinates)
U=round(u); V=round(v);  %grab the nearest old pixle to the new overlay
U(find(U<1))=1; V(find(V<1))=1;  %test bounds
U(find(U>x))=x; V(find(V>y))=y;
A=I(U,V,:);  %create new image using nearest pixle values to new image size
figure(1)
imshow(I);
title('original')
figure(2)
imshow(A);
title('nearest neighbor')

%bi-linear
II=im2double(I);  %switch to double precision
[XI, YI] = ndgrid(u,v);  %create a square array X1 st columns are replications of new indicies values overlayed on old pixles
                         %"                     Y1 st rows "
UI=XI-floor(XI); VI=YI-floor(YI); 
for i=1:z
    I1=II(floor(u),floor(v),i); I2=II(floor(u),ceil(v),i); I3=II(ceil(u),floor(v),i); I4=II(ceil(u),ceil(v),i);
    c1=(1-UI).*(1-VI); c2=(1-UI).*VI; c3=UI.*(1-VI); c4=UI.*VI;
    B(:,:,i)=c1.*I1+c2.*I2+c3.*I3+c4.*I4;
end
figure(3)
imshow(B)
title('bilinear')

%bicubic
X1 = floor(XI)-1; X2 = floor(XI); X3 = floor(XI)+1; X4 = floor(XI)+2;
Y1 = floor(YI)-1; Y2 = floor(YI); Y3 = floor(YI)+1; Y4 = floor(YI)+2;

% X1 = floor(XI)-1; X2 = floor(XI); X3 = ceil(XI); X4 = ceil(XI)+1;
% Y1 = floor(YI)-1; Y2 = floor(YI); Y3 = ceil(YI); Y4 = ceil(YI)+1;


% X1(find(X1<1))=4; Y1(find(Y1<1))=4;  %test bounds
% X2(find(X2<1))=4; Y2(find(Y2<1))=4;
% % X3(find(X3<1))=4; Y3(find(Y3<1))=4;
% % X4(find(X4<1))=4; Y4(find(Y4<1))=4;
% % X1(find(X1>x))=x-3; Y1(find(Y1>y))=y-3;
% % X2(find(X2>x))=x-3; Y2(find(Y2>y))=y-3;
% X3(find(X3>x))=x-3; Y3(find(Y3>y))=y-3;
% X4(find(X4>x))=x-3; Y4(find(Y4>y))=y-3;


H11 = sombrero(X1-XI).*sombrero(Y1-YI); H12 = sombrero(X1-XI).*sombrero(Y2-YI);
H13 = sombrero(X1-XI).*sombrero(Y3-YI); H14 = sombrero(X1-XI).*sombrero(Y4-YI);

H21 = sombrero(X2-XI).*sombrero(Y1-YI); H22 = sombrero(X2-XI).*sombrero(Y2-YI);
H23 = sombrero(X2-XI).*sombrero(Y3-YI); H24 = sombrero(X2-XI).*sombrero(Y4-YI);

H31 = sombrero(X3-XI).*sombrero(Y1-YI); H32 = sombrero(X3-XI).*sombrero(Y2-YI);
H33 = sombrero(X3-XI).*sombrero(Y3-YI); H34 = sombrero(X3-XI).*sombrero(Y4-YI);

H41 = sombrero(X4-XI).*sombrero(Y1-YI); H42 = sombrero(X4-XI).*sombrero(Y2-YI);
H43 = sombrero(X4-XI).*sombrero(Y3-YI); H44 = sombrero(X4-XI).*sombrero(Y4-YI);

% H11 = sombrero((UI+1)-XI).*sombrero(Y1-YI); H12 = sombrero((UI+1)-XI).*sombrero(Y2-YI);
% H13 = sombrero((UI+1)-XI).*sombrero(Y3-YI); H14 = sombrero((UI+1)-XI).*sombrero(Y4-YI);
% 
% H21 = sombrero(UI-XI).*sombrero(Y1-YI); H22 = sombrero(UI-XI).*sombrero(Y2-YI);
% H23 = sombrero(UI-XI).*sombrero(Y3-YI); H24 = sombrero(UI-XI).*sombrero(Y4-YI);
% 
% H31 = sombrero((1-UI)-XI).*sombrero(Y1-YI); H32 = sombrero(X1-XI).*sombrero(Y2-YI);
% H33 = sombrero(X3-XI).*sombrero(Y3-YI); H34 = sombrero(X3-XI).*sombrero(Y4-YI);
% 
% H41 = sombrero(X1-XI).*sombrero(Y1-YI); H42 = sombrero(X1-XI).*sombrero(Y2-YI);
% H43 = sombrero(X1-XI).*sombrero(Y3-YI); H44 = sombrero(X1-XI).*sombrero(Y4-YI);

% I11 = II(X1,Y1); I12 = II(X1,Y2); I13 = II(X1,Y3); I14 = II(X1,Y4); 
% I21 = II(X2,Y1); I22 = II(X2,Y2); I23 = II(X2,Y3); I24 = II(X2,Y4); 
% I31 = II(X3,Y1); I32 = II(X3,Y2); I33 = II(X3,Y3); I34 = II(X3,Y4); 
% I41 = II(X4,Y1); I42 = II(X4,Y2); I43 = II(X4,Y3); I44 = II(X4,Y4); 

X1(find(X1<1))=4; Y1(find(Y1<1))=4;  %test bounds
X2(find(X2<1))=4; Y2(find(Y2<1))=4;
% X3(find(X3<1))=4; Y3(find(Y3<1))=4;
% X4(find(X4<1))=4; Y4(find(Y4<1))=4;
% X1(find(X1>x))=x-3; Y1(find(Y1>y))=y-3;
% X2(find(X2>x))=x-3; Y2(find(Y2>y))=y-3;
X3(find(X3>x))=x-3; Y3(find(Y3>y))=y-3;
X4(find(X4>x))=x-3; Y4(find(Y4>y))=y-3;
for i=1:z
    I11 = II(X1(:,1)', Y1(1,:),i); I12 = II(X1(:,1)', Y2(1,:),i);
    I13 = II(X1(:,1)', Y3(1,:),i); I14 = II(X1(:,1)', Y4(1,:),i);

    I21 = II(X2(:,1)', Y1(1,:),i); I22 = II(X2(:,1)', Y2(1,:),i);
    I23 = II(X2(:,1)', Y3(1,:),i); I24 = II(X2(:,1)', Y4(1,:),i);

    I31 = II(X3(:,1)', Y1(1,:),i); I32 = II(X3(:,1)', Y2(1,:),i);
    I33 = II(X3(:,1)', Y3(1,:),i); I34 = II(X3(:,1)', Y4(1,:),i);

    I41 = II(X4(:,1)', Y1(1,:),i); I42 = II(X4(:,1)', Y2(1,:),i);
    I43 = II(X4(:,1)', Y3(1,:),i); I44 = II(X4(:,1)', Y4(1,:),i);

    C(:,:,i) = H11.*I11 + H12.*I12 + H13.*I13 + H14.*I14 + ...
               H21.*I21 + H22.*I22 + H23.*I23 + H24.*I24 + ...
               H31.*I31 + H32.*I32 + H33.*I33 + H34.*I34 + ...
               H41.*I41 + H42.*I42 + H43.*I43 + H44.*I44;
end
figure(4)
imshow(C)
title('bicubic')