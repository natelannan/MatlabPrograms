function [ num, rings ] = countDiscs( varargin )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
[I, component]=parseInput(varargin{:});
dots=zeros(size(I));
cross=[0 1 0;1 1 1;0 1 0];
template=imread('disc.bmp');
emplat=imerode(template,cross);
eroded=imerode(I,emplat);
se=strel('disk',1);
innerC=imerode(emplat,se);
ring=emplat-innerC;

% figure(9)
% imshow(eroded);
candidates=find(eroded==1);
for i=1:length(candidates)
    eroded(candidates(i))=0;
    restored=imdilate(eroded,emplat);
    diff=abs(I-restored);
    errs=find(diff==1);
    rank(i)=(numel(errs)/numel(I))*100;
    eroded(candidates(i))=1;
end 
skipped=[];
sorted=sort(rank,'descend');
j=1;
i=1;
thresh=5;
percdiff=100;
while percdiff > thresh
    index=find(rank==sorted(i));
    if numel(index) > 1
        if j<length(index)
            index=index(j);
            j=j+1;
        else
            index=index(j);
            j=1;
        end
    end
    if i>1
        [xcoor,ycoor]=ind2sub(size(I),candidates(index));
        [xlast,ylast]=ind2sub(size(I),candidates(prev));
        D=sqrt((xlast-xcoor)^2+(ylast-ycoor)^2);
    end
    
    if i==1 || (D>7)  %what to set D thresh to?
        dots(candidates(index))=1;    
        rings=imdilate(dots,template);
        diff=abs(I-rings);
        errs=find(diff==1);
        percdiff=(numel(errs)/numel(I))*100;
        prev=index;
    else
        skipped=[skipped index];    %may need to revisit these with very busy subimages
    end
    i=i+1;
end
rings=imdilate(dots,ring);
num = numel(find(dots == 1));
figure(10)
imshow(dots)
figure(11)
imshow(rings)

end

%%%
%%% Subfunction parseInputs
%%%
function [I, component] = parseInput(varargin)
    if ~(nargin == 1 || nargin == 2)
        usage = ['displayLoners: Usage: arg1 - binary image ' ...
            'arg2 - optional component number to be displayed'];
        error(usage);
    elseif nargin == 2
        I=varargin{1};
        component=varargin{2};
    else
        I=varargin{1};
        component=0;
    end
end

