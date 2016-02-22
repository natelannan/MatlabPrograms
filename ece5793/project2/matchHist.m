function corrected = matchHist(I,targetHist)
%MATCHHIST uses histogram matching to enhance a greyscale or RGB image.
%   corrected = matchHist(I,targetHist) uses a greyscale or color image 
%   matrix I and matches the image's histogram to the target histogram 
%   targetHist.  
%   
%   Any image that is not greyscale or RGB will produce an error
% 
% Preconditions:  Image matrix passed to function, taget histogram vector 
% passed into function.  equalize.m exists in the same directory.
% Post conditions:  Produces an enhanced version of the image, corrected,
% through the use of histogram matching.
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/19/16

%get initial data on image
[N,M,Z]=size(I);
L=256;

%Get equalized version of target histogram for reverse mapping
Gzq=zeros(L,Z);
for i=1:Z
    for j=1:L
        Gzq(j,i)=(L-1)*sum(targetHist(1:j,i));
        Gzq(j,i)=round(Gzq(j,i));
    end
end


%get equalized version of input image
equalized=equalize(I);

%----Reverse mapping of vlaues based on target histogram
corrected=zeros(N,M,Z);
zq=zeros(L,Z);
for i=1:Z
    for j=1:L
        Ginv = find(Gzq(:,i)==(j-1));
        if(Ginv) %check to see if Ginv maps to anything
            zq(j,i) = Ginv(1);  %in case of 1 to many, 
                                %just grab the first one
        elseif j==1
            zq(j,i) = 0;  %if no inverse for DC map back to DC
        else %if Ginv doesn't map, grab previous value
            zq(j,i) = zq((j-1),i);
        end
        indexes=equalized(:,:,i)==(j-1);  %find pixels with mapped value
                                          %give them value from zq
        corrected(:,:,i)=corrected(:,:,i)+indexes*zq(j,i);  
    end
end

corrected = cast(corrected,'uint8');