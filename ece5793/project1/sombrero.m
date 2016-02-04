function y =sombrero(x)
    X=abs(x);
%     if X <= 1
%         y=1-2*X^2+X^3;
%     elseif X <= 2
%         y=4-8*X+5*X^2-X^3;
%     else
%         y=0;
%     end
    A=(X<=1);
    Y1=(1-2.*X.^2+X.^3).*A;
    B=(X>1 & X<=2);
    Y2=(4-8.*X+5.*X.^2-X.^3).*B;
    y = Y1+Y2;
end    