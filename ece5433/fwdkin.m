function [ R, p ] = fwdkin( q, type, H, P, n )
% fwdkin calculates the forwrd kinematics for an input joint vector
%   q: input joint vector
%   type: vector indicating joint type (0 - rotational, 1 - prismatic)
%   H: 3xn matrix indicating axis of motion in zero configuration
%   P: 3xn matrix indicating link vectors in zero configuration
%   n: number of joints
%   R: orientation matrix (R0n)
%   p: position of end effector (p0n)


    % #1 - define base frame   
    % #2 - define zero configuration
    % #3 - choose Oi along hi
    % #4 - zero config
    % ----defined by H and P--------
    
    % #5 - apply fwd kinematic eqns
    % hi = hi in i-1 frame
    % R(i-1),i = expm(hat(hi)*qi); revolute
    % R(i-1),i = eye(3); prismatic
    % R0n = R01*R02 ... *R(n-1)n
    % p0n = p01 +R01*p12 + ... +R01*R12*...*R(n-2)(n-1)P(n-1)n
    % p(i-1),i = const. ; revolute
    % p(i-1),i = qi*hi + p(i-1),i(0); prismatic
    
    % initialize
    p = zeros(3,1);
    R = eye(3);
    
    for i=1:n
        if type(i)
            pos = P(:,i) + q(i)*H(:,i);
            rot = eye(3);
        else
            pos = P(:,i);
            rot = expm(hat(H(:,i))*q(i));
        end
        p = p+R*pos;  %previos R
        R = R*rot;
    end
    
    

end