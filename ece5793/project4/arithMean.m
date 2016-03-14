function [ filtered ] = arithMean( I, filtSize )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

if(~isfloat(I))
    I=double(I);
    doubleOut=false;
else
    doubleOut=true;
end

dims=size(filtSize);
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

arithMean=(1/prod(filtSize))*ones(filtSize);
filtered=filter2(arithMean,I);
if ~doubleOut
    filtered=uint8(filtered);
end



end

