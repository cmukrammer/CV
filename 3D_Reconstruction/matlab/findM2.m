% Q3.3:
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, C2, p1, p2, R and P to q3_3.mat

load('../data/intrinsics.mat');
load('../data/some_corresp.mat');

img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');
% M = max(size(img1,2), size(img1,1));
% F = eightpoint( pts1, pts2, M );
load('q2_1.mat');
% F = sevenpoint( pts1, pts2, M );

% displayEpipolarF(img1, img2, F);

[ E ] = essentialMatrix( F, K1, K2 );
[M2s] = camera2(E);
best = 0;
for i=1:4
    [ P, err ] = triangulate( [K1 zeros(3,1)], pts1, K2*M2s(:,:,i), pts2);
    fprintf("%d\n",err);
    if length(find(P(:,3)<0)) == 0
        best = i;
    end
end
M2 = M2s(:,:,best);
p1 = pts1;
p2 = pts2;
C2 = K2*M2s(:,:,best);
P = P(:,1:3);
save('q3_3.mat','M2','C2','p1','p2','P');
% [ P, err ] = triangulate( [K1 zeros(3,1)], pts1, K2*M2s(:,:,1), pts2);
% fprintf("%d\n",err);
% [ P, err ] = triangulate( [K1 zeros(3,1)], pts1, K2*M2s(:,:,2), pts2);
% fprintf("%d\n",err);

% [ P, err ] = triangulate( [K1 zeros(3,1)], pts1, K2*M2s(:,:,4), pts2);
% fprintf("%d\n",err);