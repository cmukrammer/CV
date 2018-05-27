function [ P, err ] = triangulate( C1, p1, C2, p2 )
% triangulate:
%       C1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       C2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

%       P - Nx3 matrix of 3D coordinates
%       err - scalar of the reprojection error

% Q4.2:
%       Implement a triangulation algorithm to compute the 3d locations
%

N = size(p1,1);
P1 = C1(1,:);
P2 = C1(2,:);
P3 = C1(3,:);
P1p = C2(1,:);
P2p = C2(2,:);
P3p = C2(3,:);
P = zeros(N,4);
for i=1:N
    x = p1(i,1);
    y = p1(i,2);
    xp = p2(i,1);
    yp = p2(i,2);
    A = [y*P3 - P2; P1 - x*P3; yp*P3p - P2p; P1p - xp*P3p];
    [U,S,V] = svd(A'*A);
    P(i,:) = V(:,end)';
end

P = P./P(:,4);
P = P';
p1Proj = C1*P;
p1Proj = p1Proj./p1Proj(3,:);
p1Proj = p1Proj(1:2,:)';
p2Proj = C2*P;
p2Proj = p2Proj./p2Proj(3,:);
p2Proj = p2Proj(1:2,:)';
err1 = (p1Proj - p1).*(p1Proj - p1);
err2 = (p2Proj - p2).*(p2Proj - p2);
err = err1 + err2;
err = sum(sum(err,2),1);
P = P';
P = P(:,1:3);
end
