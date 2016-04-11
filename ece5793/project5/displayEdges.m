function [num,compNum,compImage] = displayEdges( varargin )
%UNTITLED3 Summary of this function goes here
%   subImage = I(round(s(1).BoundingBox(2):s(1).BoundingBox(2)+s(1).BoundingBox(4)),...
%        round(s(1).BoundingBox(1):s(1).BoundingBox(1)+s(1).BoundingBox(3)));

[original, component]=parseInput(varargin{:});
[labels,numComp]=bwlabel(original);
locator=zeros(size(original));
s=regionprops(logical(original), 'BoundingBox');
sizeO=size(original);
num=0;
compNum=[];
for i=1:numComp
    subImage{i} = {imcrop(original, s(i).BoundingBox)};
    if (round(s(i).BoundingBox(2))==1 || round(s(i).BoundingBox(2)) ... 
             +s(i).BoundingBox(4)-1==sizeO(1) || ... 
            round(s(i).BoundingBox(1))==1 || round(s(i).BoundingBox(1)) ... 
            +s(i).BoundingBox(3)-1==sizeO(2))
        locator(find(labels==i))=1;
        num=num+1;
        compNum=[compNum i];
    end
end
if component
    imshow(subImage{1,component}{1,1});
    compImage=subImage{1,component}{1,1};
else
    imshow(locator)
    compImage=subImage{1,compNum(1)}{1,1};
end
end

%%%
%%% Subfunction parseInputs
%%%
function [original, component] = parseInput(varargin)
    if ~(nargin == 1 || nargin == 2)
        usage = ['displayLoners: Usage: arg1 - original binary image ' ...
            'arg2 - optional component number to be displayed'];
        error(usage);
    elseif nargin == 2
        original=varargin{1};
        component=varargin{2};
    else
        original=varargin{1};
        component=0;
    end
end

