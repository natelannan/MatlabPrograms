function [ num,compNum,compImage ] = displayClusters( varargin )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

[original, component]=parseInput(varargin{:});
[labels,numComp]=bwlabel(original);
locator=zeros(size(original));
s=regionprops(logical(original), 'BoundingBox');
sizeO=size(original);
num=0;
compNum=[];
for i=1:numComp
    subImage{i} = {imcrop(original, s(i).BoundingBox)};
    if (s(i).BoundingBox(4)>=29 || s(i).BoundingBox(3)>=29)
        locator(find(labels==i))=1;
        num=num+1;
        compNum=[compNum i];
    end

end
if component
    compImage=subImage{1,component}{1,1};
    [labelsSub, numCompSub] = bwlabel(compImage);
    if numCompSub>1
        subS=regionprops(logical(labelsSub),'Area');
        [maxValue,index] = max([subS.Area]);
        compImage(find(labelsSub~=index))=0;
%         if subS(1).Area> subS(2).Area 
%             compImage(find(labelsSub==2))=0;
%         else
%             compImage(find(labelsSub==1))=0;
%         end
    end
%     imshow(compImage)
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

