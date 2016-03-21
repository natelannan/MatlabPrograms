function [ filtered ] = adaptNoise( I, filtSize )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

if(~isfloat(I))
    I=double(I);
    doubleOut=false;
else
    I=round(255*I);
    doubleOut=true;
end

dims=size(filtSize);
Idims=size(I);
noiseVar=1000;
if(length(dims)>2)
        error('Enter filter size in the form of row and column dimensions: ' ...
            + '[3 4] or 3 for square matrix.')    
elseif(dims(1)>1)
    if(dims(2)>1)
        error('Enter filter size in the form of row and column dimensions: ' ...
            + '[3 4] or 3 for square matrix.')
    else
        filtSize=filtSize';
    end
elseif(dims(1)==1 && dims(2)==1)
    filtSize=[filtSize filtSize];
end

center = [ceil(filtSize(1)/2) ceil(filtSize(2)/2)];
%geoMean=ones(filtSize);
%logI=log(I);
%padded=padarray(I,[filtSize(1)-center(1) filtSize(2)-center(2)],1);
filtered=zeros(Idims(1),Idims(2));
for i=1:Idims(1)
    for j=1:Idims(2)
        xStart=i-(center(1)-1); xStop=i+(filtSize(1)-center(1));
        yStart=j-(center(1)-1); yStop=j+(filtSize(1)-center(1));
        if xStart < 1 xStart = 1; end
        if yStart < 1 yStart = 1; end
        if xStop > Idims(1) xStop=Idims(1); end
        if yStop > Idims(2) yStop=Idims(2); end
        temp=I(xStart:xStop,yStart:yStop);
        localVar=var(var(temp));
        localMean=mean(mean(temp));
        if noiseVar > localVar
            varRatio=1;
        else
            varRatio=noiseVar/localVar;
        end
        filtered(i,j)= I(i,j)-varRatio*(I(i,j)-localMean);

    end
end


if ~doubleOut
    filtered=uint8(filtered);
else
    filtered=filtered/255;
end

end

