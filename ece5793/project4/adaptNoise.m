function [ filtered ] = adaptNoise( I, filtSize )
%UNTITLED Summary of this function goes here
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

localMean = filter2(ones(filtSize), I) / prod(filtSize);

localVar = filter2(ones(filtSize), I.^2) / prod(filtSize) - localMean.^2;

filtered = I - (min(1, noiseVar./localVar)) .* (I - localMean);

if ~doubleOut
    filtered=uint8(filtered);
else
    filtered=filtered/255;
end

end

