function [ psnr ] = myPSNR( original, filtered )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

[N,M,Z]=size(original);
if isfloat(filtered)
    filtered=255*filtered;
else
    filtered=double(filtered);
end
original=double(original);

mse=sum(sum(((original-filtered).^2)/(M*N)));
psnr=10*log10((255^2)/mse);


end

