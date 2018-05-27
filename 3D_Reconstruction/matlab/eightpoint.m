function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup

N = size(pts1,1);
T = [1/M 0; 0 1/M];
% T = [1/M(2) 0; 0 1/M(1)];
pts3 = T*pts1';
pts3 = pts3';
pts4 = T*pts2';
pts4 = pts4';

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
F = V(:,end);
F = reshape(F, [3 3]);
F = F';
% rank-2 constraint
[U,S,V] = svd(F);
S(3,3) = 0;
NF = U*S*V';
T(3,:) = [0 0];
T(:,3) = [0 0 1];
F = T'*NF*T;

save('q2_1.mat','F','M','pts1','pts2');

end

