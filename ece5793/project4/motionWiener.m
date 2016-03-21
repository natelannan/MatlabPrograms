function [ W ] = motionWiener( u,v,k, varargin)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

optArgs = {0.1 0.1 1};
optArgs(1:length(varargin))=varargin;
[a b T] = optArgs{:};

weight = u*a+v*b;
H = T/(pi*weight) * sin(pi*weight) * exp(-1i*pi*weight);

W = 1/H * abs(H)^2/(abs(H)^2+k);

end

