function corrected = equalize(I)
%EQUALIZE uses histogram equalization to enhance a greyscale or RGB image.
%   corrected = equalize(I) uses a greyscale or color image matrix I and 
%   equalizes the image's histogram.  
%   
%   Any image that is not greyscale or RGB will produce an error
% 
% Preconditions:  Image matrix passed to function.
% Post conditions:  Produces an enhanced version of the image, corrected,
% through the use of histogram equalization
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/19/16

%size and intensity of image
[N,M,Z]=size(I);
L=256;

%make sure greyscale or RGB
if (Z ~= 1) && (Z ~=3)
    error('Currently only supports RGB and gresyscale.');
end

%get histogram(s) for image
nk=zeros(L,Z);
for i=1:Z
    nk(:,i)=imhist(I(:,:,i));
end

sk=zeros(L,Z);
corrected=zeros(N,M,Z);
for i=1:Z
    for j=1:L
        sk(j,i)=(L-1)/(M*N)*sum(nk(1:j,i));
        sk(j,i)=round(sk(j,i));
        indexes=I(:,:,i)==(j-1);
        corrected(:,:,i)=corrected(:,:,i)+indexes*sk(j,i);
%         corrected(find(I(:,:,i)==(j-1)))=sk(j,i);
    end
end
corrected = cast(corrected,'uint8');