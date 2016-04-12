function [ Dist ] = LinDistance( linIndex1, linIndex2, sizeI )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

        [xcoor1,ycoor1]=ind2sub(sizeI,linIndex1);
        [xcoor2,ycoor2]=ind2sub(sizeI,linIndex2);
        Dist=sqrt((xcoor2-xcoor1)^2+(ycoor2-ycoor1)^2);
end

