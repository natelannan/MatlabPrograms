clear all
close all
clc

I=imread('lean256B.bmp');
II=im2double(I);
target=imread('lena256.bmp');
% I = ones(4,120);
figure(1)
imshow(I);
title('Original')
figure(2)
imshow(target)
title('Target')
A=[3 69 1 0 0 0; ... 
   0 0 0 3 69 1; ...
   69 315 1 0 0 0; ...
   0 0 0 69 315 1; ...
   315 249 1 0 0 0; ...
   0 0 0 315 249 1; ...
   249 3 1 0 0 0; ...
   0 0 0 249 3 1];

B=[0;0;0;size(target,2); size(target,1);size(target,2);size(target,1);0];
t=linsolve(A,B);
T=[t(1) t(4) 0; t(2) t(5) 0; t(3) t(6) 1];
invT=inv(T);
for i=1:size(target,1)
    for j=1:size(target,2)
        coord=[i j 1]*invT;
        u=coord(1); v=coord(2);
        %-----------Nearest Neighbor---------------------------------------
        U=round(u); V=round(v);
        NN(i,j) = I(U,V);
        
        %----------Bilinear------------------------------------------------
        UI=u-floor(u); VI=v-floor(v);
        I1=II(floor(u),floor(v)); I2=II(floor(u),ceil(v)); 
        I3=II(ceil(u),floor(v)); I4=II(ceil(u),ceil(v));
        c1=(1-UI)*(1-VI); c2=(1-UI)*VI; c3=UI*(1-VI); c4=UI*VI;
        BL(i,j)=c1.*I1+c2.*I2+c3.*I3+c4.*I4;
        
        %----------Bicubic-------------------------------------------------
        X1 = floor(u)-1; X2 = floor(u); X3 = floor(u)+1; X4 = floor(u)+2;
        Y1 = floor(v)-1; Y2 = floor(v); Y3 = floor(v)+1; Y4 = floor(v)+2;
        
        
        H11 = sombrero(X1-u)*sombrero(Y1-v); H12 = sombrero(X1-u)*sombrero(Y2-v);
        H13 = sombrero(X1-u)*sombrero(Y3-v); H14 = sombrero(X1-u)*sombrero(Y4-v);

        H21 = sombrero(X2-u)*sombrero(Y1-v); H22 = sombrero(X2-u)*sombrero(Y2-v);
        H23 = sombrero(X2-u)*sombrero(Y3-v); H24 = sombrero(X2-u)*sombrero(Y4-v);

        H31 = sombrero(X3-u)*sombrero(Y1-v); H32 = sombrero(X3-u)*sombrero(Y2-v);
        H33 = sombrero(X3-u)*sombrero(Y3-v); H34 = sombrero(X3-u)*sombrero(Y4-v);

        H41 = sombrero(X4-u)*sombrero(Y1-v); H42 = sombrero(X4-u)*sombrero(Y2-v);
        H43 = sombrero(X4-u)*sombrero(Y3-v); H44 = sombrero(X4-u)*sombrero(Y4-v);
        
        %X1(find(X1<1))=1; Y1(find(Y1<1))=1;  %test bounds
        %X4(find(X4>size(target,1)))=size(target,1); Y4(find(Y4>size(target,2)))=size(target,2);
        
        I11 = II(X1, Y1); I12 = II(X1, Y2);
        I13 = II(X1, Y3); I14 = II(X1, Y4);

        I21 = II(X2, Y1); I22 = II(X2, Y2);
        I23 = II(X2, Y3); I24 = II(X2, Y4);

        I31 = II(X3, Y1); I32 = II(X3, Y2);
        I33 = II(X3, Y3); I34 = II(X3, Y4);

        I41 = II(X4, Y1); I42 = II(X4, Y2);
        I43 = II(X4, Y3); I44 = II(X4, Y4);
        
        BC(i,j) = H11*I11 + H12*I12 + H13*I13 + H14*I14 + ...
               H21*I21 + H22*I22 + H23*I23 + H24*I24 + ...
               H31*I31 + H32*I32 + H33*I33 + H34*I34 + ...
               H41*I41 + H42*I42 + H43*I43 + H44*I44;
    end
end
figure(3)
imshow(NN)
title('Nearest Neighbor')
figure(4)
imshow(BL)
title('Bilinear')
figure(5)
imshow(BC)
title('Bicubic')