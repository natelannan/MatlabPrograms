clear all
close all
clc

%=============problem 1====================================================
%SCARA
syms q1 q2 q3 q4 real;
syms l1 l2 l3 l4 real;
q = [ q1 q2 q3 q4 ];
type = [0 0 0 1];
H = [0 0 0 0; 0 0 0 0; 1 1 1 1];
P = [0 0 0 0;0 l1 l2 0;0 0 0 0];
n = 4;

[R,p] = fwdkin( q, type, H, P, n);
R=simplify(R)
p=simplify(p)

%Elbow manipulator
syms q5 q6 real;
syms l5 l6 real;
q = [ q1 q2 q3 q4 q5 q6];
type = [1 0 0 0 0 0];
H = [1 0 0 0 0 1; 0 0 1 1 1 0; 0 1 0 0 0 0];
P = [0 l1 0 l3 l4 0;0 0 0 0 0 0 ;0 0 l2 0 0 0];
n = 6;

[R,p] = fwdkin( q, type, H, P, n);
R=simplify(R)
p=simplify(p)

%======================problem 2===========================================
% i)
syms theta1 theta2 theta3 real;
h1=[0 0 1]'; h2 = [0 1 0]'; h3 = [1 0 0]';
R03 = expm(hat(h1)*theta1)*expm(hat(h2)*theta2)*expm(hat(h3)*theta3);
R03 = simplify(R03)

P03 = expm(hat(h1)*theta1)*[0 0 l1]';
P03 = simplify(P03)

% ii)
h1=[0 0 1]'; h2 = [0 1 0]'; h3 = [l2 0 l1]';
R03 = expm(hat(h1)*theta1)*expm(hat(h2)*theta2)*expm(hat(h3)*theta3);
R03 = simplify(R03)

P03 = expm(hat(h1)*theta1)*[0 0 l1]'+expm(hat(h2)*theta2)*[l2 0 0]';
P03 = simplify(P03)