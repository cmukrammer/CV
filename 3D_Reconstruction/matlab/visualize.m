% Q4.2:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3

load('../data/templeCoords.mat');
load('../data/intrinsics.mat');
load('../data/some_corresp.mat');

img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');
% M = max(size(img1,2), size(img1,1));
% F = eightpoint( pts1, pts2, M );
% 
% [ E ] = essentialMatrix( F, K1, K2 );
% [M2s] = camera2(E);
load('q2_1.mat');
load('q3_3.mat');
pts1 = [x1 y1];
N = size(pts1,1);
pts2 = zeros(N,2);
for i=1:N
    [ pts2(i,1), pts2(i,2) ] = epipolarCorrespondence( img1, img2, F, pts1(i,1), pts1(i,2) );
end
[ P, err ] = triangulate( [K1 zeros(3,1)], pts1, K2*M2, pts2);
fprintf("%d\n",err);

scatter3(P(:,1), P(:,2), P(:,3));
M1 = [eye(3) zeros(3,1)];
C1 = [K1 zeros(3,1)];
C2 = K2*M2;
save('q4_2.mat','F','M1','M2','C1','C2');