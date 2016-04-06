function [ smoothed ] = adaptMed( inVector, maxWinSize )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if length(inVector)<maxWinSize
    error('length of input vector must be larger than max window size')
end

for i=1:length(inVector)
    winSize=1;
    b=0;
    while (~b && winSize<=maxWinSize)
        window=zeros(1,winSize);
        start=i-floor((winSize-1)/2);
        finish=i+ceil((winSize-1)/2);
        if start<1
            window(2-start:end)=inVector(1:finish);
        elseif finish > length(inVector)
            window(1:end-(finish-length(inVector)))=inVector(start:end);
        else 
            window=inVector(start:finish);
        end
        
        medMin=median(window)-min(window);
        medMax=median(window)-max(window);
        if (medMin > 0 && medMax < 0)
            b=1;
        else
            winSize=winSize+1;
        end
    end
    if(b)
        valMin=inVector(i)-min(window);
        valMax=inVector(i)-max(window);
        if valMin>0 && valMax<0
            smoothed(i)=inVector(i);
        else
            smoothed(i)=median(window);
        end
    else
        smoothed(i)=inVector(i);
    end
end


