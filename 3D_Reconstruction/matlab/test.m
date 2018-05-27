load('../data/intrinsics.mat');
load('../data/some_corresp.mat');
% load('../data/my_corresp.mat');
load('../data/some_corresp_noisy.mat');
% h  = cpselect('../data/im1.png','../data/im2.png');
% pts1 = fixedPoints;
% pts2 = movingPoints;
img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');
M = max(size(img1,2), size(img1,1));
% F = eightpoint( pts1, pts2, M );
% F = sevenpoint( pts1, pts2, M );
% load('q2_1.mat');
% load('q3_3.mat');
% load('q2_2.mat');

% displayEpipolarF(img1, img2, F);

% [ E ] = essentialMatrix( F, K1, K2 );
% [M2s] = camera2(E);
% [ F, inliers ] = ransacF( pts1, pts2, M );
[coordsIM1, coordsIM2] = epipolarMatchGUI(img1, img2, F);
% save('q4_1.mat','F', 'pts1', 'pts2');
% [ F, inliers ] = ransacF( pts1, pts2, M );
% displayEpipolarF(img1, img2, F);