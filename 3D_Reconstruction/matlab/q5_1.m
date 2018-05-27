load('../data/intrinsics.mat');
load('../data/some_corresp_noisy.mat');
% load('../data/some_corresp.mat');
img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');
M = max(size(img1,2), size(img1,1));
[ F, inliers ] = ransacF( pts1, pts2, M );
[ E ] = essentialMatrix( F, K1, K2 );
[M2s] = camera2(E);
best = 0;
for i=1:4
    [ P, err ] = triangulate( [K1 zeros(3,1)], pts1(inliers,:), K2*M2s(:,:,i), pts2(inliers,:));
    fprintf("%d\n",err);
    if length(find(P(:,3)<0)) == 0
        best = i;
    end
end
M2 = M2s(:,:,best);
% [coordsIM1, coordsIM2] = epipolarMatchGUI(img1, img2, F);
[ P, err ] = triangulate( [K1 zeros(3,1)], pts1(inliers,:), K2*M2, pts2(inliers,:));
% [ P, err ] = triangulate( [K1 zeros(3,1)], pts1, K2*M2, pts2);
% scatter3(P(:,1), P(:,2), P(:,3));
[M2, P] = bundleAdjustment(K1, [eye(3,3) zeros(3,1)], pts1(inliers,:), K2, M2, pts2(inliers,:), P);

% [ P, err ] = triangulate( [K1 zeros(3,1)], pts1(inliers,:), K2*M2, pts2(inliers,:));
% scatter3(P(:,1), P(:,2), P(:,3));
% fprintf("%d\n",err);

% use templeCoords to scatter here
load('../data/templeCoords.mat');
pts1 = [x1 y1];
N = size(pts1,1);
pts2 = zeros(N,2);
[ P, err ] = triangulate( [K1 zeros(3,1)], pts1, K2*M2, pts2);
for i=1:N
    [ pts2(i,1), pts2(i,2) ] = epipolarCorrespondence( img1, img2, F, pts1(i,1), pts1(i,2) );
end
[ P, err ] = triangulate( [K1 zeros(3,1)], pts1, K2*M2, pts2);
fprintf("%d\n",err);
scatter3(P(:,1), P(:,2), P(:,3));