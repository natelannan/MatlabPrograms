function [ num, dots ] = countDiscs( varargin )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
[I, component]=parseInput(varargin{:});
dots=zeros(size(I));
cross=[0 1 0;1 1 1;0 1 0];
template=imread('disc.bmp');
emplat=imerode(template,cross);
eroded=imerode(I,emplat);


% figure(9)
% imshow(eroded);
candidates=find(eroded==1);
for i=1:length(candidates)
    eroded(candidates(i))=0;
    restored=imdilate(eroded,emplat);
    errs=sum(sum(xor(I,restored)));
%     diff=abs(I-restored);
%     errs=find(diff==1);
    rank(i)=(errs/numel(I))*100;
    eroded(candidates(i))=1;
end 
skipped=[];
sorted=sort(rank,'descend');
j=1;
i=1;
thresh=3;
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
        prev=find(dots==1);
        for k=1:length(prev)
            D(k)=LinDistance(candidates(index),prev(k),size(I));
        end
%         [xcoor,ycoor]=ind2sub(size(I),candidates(index));
%         [xlast,ylast]=ind2sub(size(I),candidates(prev));
%         D=sqrt((xlast-xcoor)^2+(ylast-ycoor)^2);
    end
    
    if i==1 || min(D>10)  %what to set D thresh to?  min-> return 0 if any in D are < 7
        dots(candidates(index))=1;    
        rings=imdilate(dots,template);
        errs=sum(sum(xor(I,rings)));
%         diff=abs(I-rings);
%         errs=find(diff==1);
        percdiff=(errs/numel(I))*100;
        prev=index;
    else
        skipped=[skipped index];    %may need to revisit these with very busy subimages
    end
    i=i+1;
    if i > length(sorted)
        for i = 1:length(skipped)
            oldPerc=percdiff;
            dots(candidates(skipped(i)))=1;
            rings=imdilate(dots,template);
            errs=sum(sum(xor(I,rings)));
%             diff=abs(I-rings);
%             errs=find(diff==1);
            percdiff=(errs/numel(I))*100;
            change=abs(oldPerc-percdiff);
            if numel(I)>4500  %3000
                if change <.4
                    dots(candidates(skipped(i)))=0;
                end
            elseif numel(I)>3000
                if change <1
                    dots(candidates(skipped(i)))=0;
                end
            elseif numel(I)>2000
                if change < 2
                    dots(candidates(skipped(i)))=0;
                end
            elseif numel(I)>1300
                if change < 1.448
                    dots(candidates(skipped(i)))=0;
                end
            else
                if change <5
                    dots(candidates(skipped(i)))=0;
                end
            end
        end
        percdiff=thresh;
    end
end

num = numel(find(dots == 1));
% figure(10)
% imshow(dots)
% figure(11)
% imshow(rings)

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

