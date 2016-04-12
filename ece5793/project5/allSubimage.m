function [ subImage, origin, numComp ] = allSubimage( varargin )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
original=parseInput(varargin{:});
[labels,numComp]=bwlabel(original);
s=regionprops(logical(original), 'BoundingBox');
sizeO=size(original);
origin=zeros(numComp,2);
for i=1:numComp
    subImage{i} = {imcrop(original, s(i).BoundingBox)};
    origin(i,1) = round(s(i).BoundingBox(2));
    origin(i,2) = round(s(i).BoundingBox(1));
    compImage=subImage{1,i}{1,1};
    [labelsSub, numCompSub] = bwlabel(compImage);
    if numCompSub>1
        subS=regionprops(logical(labelsSub),'Area');
        [~,index] = max([subS.Area]);
        compImage(find(labelsSub~=index))=0;
        subImage{1,i}{1,1}=compImage;
    end
end
end


%%%
%%% Subfunction parseInputs
%%%
function original = parseInput(varargin)
    if ~(nargin == 1)
        usage = 'allSubimage: Usage: arg1 - original binary image';
        error(usage);
    else
        original=varargin{1};
    end
end