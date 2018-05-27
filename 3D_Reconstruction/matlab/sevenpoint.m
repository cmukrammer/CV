function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - 7x2 matrix of (x,y) coordinates
%   pts2 - 7x2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup
N = 7;
start = 8;
T = [1/M 0; 0 1/M];
% T = [1/M(2) 0; 0 1/M(1)];
pts3 = T*pts1';
pts3 = pts3';
pts4 = T*pts2';
pts4 = pts4';
% idx = randi(size(pts1, 1), 1, 7);
% idx = [83,20,57,85,55,25,19];
% pts3 = pts3(idx, :);
% pts4 = pts4(idx, :);

A = zeros(N,9);
for i=1:N
    x = pts3(i,1);
    y = pts3(i,2);
    xp = pts4(i,1);
    yp = pts4(i,2);
%     y = pts3(i,1);
%     x = pts3(i,2);
%     yp = pts4(i,1);
%     xp = pts4(i,2);
%     A(i,:) = [x*xp,x*yp,x,y*xp,y*yp,y,xp,yp,1];
    A(i,:) = [xp*x,xp*y,xp,yp*x,yp*y,yp,x,y,1];
end
[U,S,V] = svd(A'*A);
F1 = V(:,end-1);
F1 = reshape(F1, [3 3]);
F1 = F1';
F2 = V(:,end);
F2 = reshape(F2, [3 3]);
F2 = F2';
syms a;
eqn = det(a*F1+(1-a)*F2);
solalpha = solve(eqn);
a = double(solalpha(3,1));
F = a*F1 + (1-a)*F2;
% rank-2 constraint
% [U,S,V] = svd(F);
% S(3,3) = 0;
% NF = U*S*V';
NF = F;
T(3,:) = [0 0];
T(:,3) = [0 0 1];
F = T'*NF*T;
F = {F};

pts1 = pts3;
pts2 = pts4;
save('q2_2.mat','F','M','pts1','pts2');
end

