function y =sombrero(x)
%SOMBRERO calculate mexican hat function for each value in a matrix.
%   Y = SOMBRERO(X) takes input X and calculates the output Y based on 
%   the 'mexican hat' function.  X can be a scalar or a matrix.
% 
% Preconditions:  Matrix or scalar X passed to function.
% Post conditions:  Returns matrix Y, based on 'mexican hat' function for
% each value in X.
% 
% Author:  Nate Lannan 
% CWID - 11776374
% date: 2/5/16
    X=abs(x);  %mexican hat is even about 0
    A=(X<=1);  %logical matrix for any value in X<=1
    Y1=(1-2.*X.^2+X.^3).*A;  %for any value in X<=1
    B=(X>1 & X<=2);  %logical matrix for any value in X between 1 and 2
    Y2=(4-8.*X+5.*X.^2-X.^3).*B; %for any value in X between 1 and 2
    y = Y1+Y2;  %'mexican hat' output for matrix x
end    