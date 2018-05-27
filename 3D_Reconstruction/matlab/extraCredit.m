img1 = imread('../data/templeRing/templeR0013.png');
img2 = imread('../data/templeRing/templeR0014.png');
img3 = imread('../data/templeRing/templeR0015.png');
img4 = imread('../data/templeRing/templeR0016.png');
img5 = imread('../data/templeRing/templeR0017.png');
img6 = imread('../data/templeRing/templeR0018.png');
load('../data/intrinsics.mat');


preAllocSize = 2000;
Ms = zeros(3,4,5);
all3DMap = zeros(preAllocSize,3+6*2);
all3DMap = buildMap(all3DMap, img1, img2, img3, img4, img5, img6);
[M2, all3DMap] = processTwoImage(all3DMap, 1, 2, K1, [eye(3,3) zeros(3,1)], K2, img1);
Ms(:,:,1) = M2;
[Ms, all3DMap] = myBundleAdjustment(all3DMap, K1, Ms(:,:,1:1));
[M3, all3DMap] = poseAndUpdateMap(K1, M2, K1, all3DMap, 2, 3);
Ms(:,:,2) = M3;
[Ms, all3DMap] = myBundleAdjustment(all3DMap, K1, Ms(:,:,1:2));
[M4, all3DMap] = poseAndUpdateMap(K1, M3, K1, all3DMap, 3, 4);
Ms(:,:,3) = M4;
[Ms, all3DMap] = myBundleAdjustment(all3DMap, K1, Ms(:,:,1:3));
[M5, all3DMap] = poseAndUpdateMap(K1, M4, K1, all3DMap, 4, 5);
Ms(:,:,4) = M5;
[Ms, all3DMap] = myBundleAdjustment(all3DMap, K1, Ms(:,:,1:4));
[M6, all3DMap] = poseAndUpdateMap(K1, M5, K1, all3DMap, 5, 6);
Ms(:,:,5) = M6;
[Ms, all3DMap] = myBundleAdjustment(all3DMap, K1, Ms);

pcshow(all3DMap(:,1:3));
save('q6_2.mat','all3DMap','Ms');

function [all3DMap] = buildMap(all3DMap, img1, img2, img3, img4, img5, img6)
[pts11,pts12] = getPointsFromSurf(img1,img2);
[pts22,pts23] = getPointsFromSurf(img2,img3);
[pts33,pts34] = getPointsFromSurf(img3,img4);
[pts44,pts45] = getPointsFromSurf(img4,img5);
[pts55,pts56] = getPointsFromSurf(img5,img6);
[all3DMap] = updateMapByPts(all3DMap, pts11, pts12, 1, 2);
[all3DMap] = updateMapByPts(all3DMap, pts22, pts23, 2, 3);
[all3DMap] = updateMapByPts(all3DMap, pts33, pts34, 3, 4);
[all3DMap] = updateMapByPts(all3DMap, pts44, pts45, 4, 5);
[all3DMap] = updateMapByPts(all3DMap, pts55, pts56, 5, 6);
end

function [all3DMap] = updateMapByPts(all3DMap, pts1, pts2, index1, index2)
N = size(all3DMap, 1);
next = 1;
for i=1:size(all3DMap,1)
    if sum(all3DMap(i,:) > 0) == 0
        next = i;
        break;
    end
end
for i=1:size(pts1,1)
    found = 0;
    for j=1:N
        if all3DMap(j,2+2*index1) == pts1(i,1) && all3DMap(j,3+2*index1) == pts1(i,2)
            found = j;
            all3DMap(j,2+2*index2) = pts2(i,1);
            all3DMap(j,3+2*index2) = pts2(i,2);
            break;
        end
    end
    if found == 0
        all3DMap(next,2+2*index1) = pts1(i,1);
        all3DMap(next,3+2*index1) = pts1(i,2);
        all3DMap(next,2+2*index2) = pts2(i,1);
        all3DMap(next,3+2*index2) = pts2(i,2);
        next = next + 1;
    end
end
end

function [M3, all3DMap] = poseAndUpdateMap(K2, M2, K3, all3DMap, idx1, idx2)
loc = intersect(find(all3DMap(:,2+idx1*2)>0),find(all3DMap(:,2+idx2*2)>0));
computed3D = intersect(find(all3DMap(:,1)~=0), loc);
notComputed3D = intersect(find(all3DMap(:,1)==0), loc);
computedPts3 = all3DMap(computed3D,2+idx2*2:3+idx2*2);
N = size(computed3D,1);
computed3DPts = [all3DMap(computed3D,1:3) ones(N,1)];

A = zeros(N*2,12);
for i=1:N
    X = computed3DPts(i,:);
    xp = computedPts3(i,1);
    yp = computedPts3(i,2);
    A(2*i-1,:) = [X 0 0 0 0 -xp*X];
    A(2*i,:) = [0 0 0 0 X -yp*X];
end
[U,S,V] = svd(A);
p = V(:,end);
p = reshape(p,[4 3]);
p = p';
twoD = p*computed3DPts';
scale = sum(twoD(3,:))/size(twoD,2);
twoD = twoD./twoD(3,:);
twoD = twoD';
M3 = inv(K3)*p;
M3 = M3/scale;



uncommonPts2 = all3DMap(notComputed3D,2+idx1*2:3+idx1*2);
uncommonPts3 = all3DMap(notComputed3D,2+idx2*2:3+idx2*2);
[ P, err ] = triangulate( K2*M2, uncommonPts2, K3*M3, uncommonPts3);
for i=1:size(notComputed3D,1)
    all3DMap(notComputed3D(i),1:3) = P(i,:);
end
end

function [M2, all3DMap] = processTwoImage(all3DMap, idx1, idx2, K1, M1, K2, img1)
% [pts1,pts2] = getPointsFromSurf(img1,img2);
loc = intersect(find(all3DMap(:,2+idx1*2)>0),find(all3DMap(:,2+idx2*2)>0),'rows');
pts1 = all3DMap(loc,2+idx1*2:3+idx1*2);
pts2 = all3DMap(loc,2+idx2*2:3+idx2*2);
[P, M2] = mytriangulate(pts1, pts2, max(size(img1,1),size(img1,2)), K1, M1, K2);
% pcshow(P);
all3DMap(loc,1:3) = P;
end

function [pts1, pts2] = getPointsFromSurf(img1,img2)
grayimg1 = grayScale(img1);
grayimg2 = grayScale(img2);
[Features1, ValidPoints1] = getSurfFeaturePoints(grayimg1);
[Features2, ValidPoints2] = getSurfFeaturePoints(grayimg2);
indexPairs = matchFeatures(Features1, Features2, ...
    'MaxRatio', .7, 'Unique',  true);
% matchedPoints1 = preValidPoints(indexPairs(:,1),:);
% matchedPoints2 = currValidPoints(indexPairs(:,2),:);
% figure; showMatchedFeatures(img1,img2,matchedPoints1,matchedPoints2);
pts1 = double(ValidPoints1.Location(indexPairs(:,1),:));
pts2 = double(ValidPoints2.Location(indexPairs(:,2),:));
end

function [gray] = grayScale(img)
gray = img;
if (ndims(img) == 3)
    gray = rgb2gray(img);
end
end

function [features, validPoints] = getSurfFeaturePoints(img)
roi = [2 2];
prevPoints   = detectSURFFeatures(img, 'NumOctaves', 8);
[features, validPoints] = extractFeatures(img, prevPoints, 'Upright', true);
end

function [P, M2] = mytriangulate(pts1, pts2, M, K1, M1, K2)
[ F, inliers ] = ransacF( pts1, pts2, M );
% displayEpipolarF(img1, img2, F);
[coordsIM1, coordsIM2] = epipolarMatchGUI(img1, img2, F);
[ E ] = essentialMatrix( F, K1, K2 );
[M2s] = camera2(E);
best = 0;
count = 0;
for i=1:4
    [ P, err ] = triangulate( K1*M1, pts1, K2*M2s(:,:,i), pts2);
    %fprintf("%d\n",err);
    if length(find(P(:,3)<0)) == 0
        best = i;
        count = count + 1;
    end
end
M2 = M2s(:,:,best);
[ P, err ] = triangulate( K1*M1, pts1, K2*M2, pts2);
% [M2, P] = myBundleAdjustment(K1, [eye(3,3) zeros(3,1)], pts1(inliers,:), K2, M2, pts2(inliers,:), P);
end

function align(pts11, pts12, pts22, pts23, K, M1, M2, M3)
[ P12, err ] = triangulate( K*M1, pts11, K*M2, pts12);
[ P23, err ] = triangulate( K*M2, pts22, K*M3, pts23);

end

function [Ms, all3DMap] = myBundleAdjustment(all3DMap, K, Ms)
% bundleAdjustment:
% Inputs:
%   K1 - 3x3 camera calibration matrix 1
%   M1 - 3x4 projection matrix 1
%   p1 - Nx2 matrix of (x, y) coordinates
%   K2 - 3x3 camera calibration matrix 2
%   M2_init - 3x4 projection matrix 2
%   p2 - Nx2 matrix of (x, y) coordinates
%   P_init: Nx3 matrix of 3D coordinates
%
% Outputs:
%   M2 - 3x4 refined from M2_init
%   P - Nx3 refined from P_init

% x - (3N + 6)x1 flattened concatenation of P, r_2 and t_2
num = size(Ms,3);
endIndex = max(find(all3DMap(:,2+num*2)));
all3DPts = all3DMap(1:endIndex,1:3);
all3DPts = all3DPts';
X0 = [all3DPts(:)];
for i=1:num
    X0 = [X0;invRodrigues(Ms(1:3,1:3,i));Ms(:,end,i)];
end
options = optimoptions('lsqnonlin','Display','iter','Algorithm','levenberg-marquardt');

X = lsqnonlin(@(x) myRodriguesResidual(all3DMap,K,Ms,x), X0, [], [], options);
P = reshape(X(1:endIndex*3,:),[3 endIndex]);
P = P';
all3DPts(1:endIndex,1:3) = P;
for i=1:num
    r_2 = X(endIndex+(i-1)*6+1:endIndex+(i-1)*6+3,:);
    t_r = X(endIndex+(i-1)*6+4:endIndex+(i-1)*6+6,:);
    Ms(:,:,i) = [rodrigues(r_2) t_r];
end

end

function residuals = myRodriguesResidual(all3DMap,K,Ms,x)
% rodriguesResidual:
% Inputs:
%   K1 - 3x3 camera calibration matrix 1
%   M1 - 3x4 projection matrix 1
%   p1 - Nx2 matrix of (x, y) coordinates
%   K2 - 3x3 camera calibration matrix 2
%   p2 - Nx2 matrix of (x, y) coordinates
%   x - (3N + 6)x1 flattened concatenation of P, r_2 and t_2

% Output:
%   residuals - 4Nx1 vector

num = size(Ms,3);
endIndex = max(find(all3DMap(:,2+num*2)));
P = x(1:endIndex*3, :);
new3DP = reshape(P, [3 endIndex]);
new3DP = [new3DP;ones([1 endIndex])];
[Ms] = buildMs(num, x(endIndex*3+1:end, :));
residuals = zeros(endIndex,size(all3DMap,2));
map = all3DMap(1:endIndex,:) ~= 0;
for j=1:num+1
    if j-1 == 0
        M = [eye(3,3) zeros(3,1)];
    else
        M = Ms(:,:,j-1);
    end
    newP = K*M*new3DP;
    newP = newP./newP(3,:);
    newP = newP(1:2,:)';
    residuals(:,2+j*2:3+j*2) = newP;
end
residuals = residuals.*map;
residuals = all3DMap(1:endIndex,4:end) - residuals(:,4:end);
residuals = residuals(:);

end

function [Ms] = buildMs(num, x)
Ms = zeros(3,4,6);
for i=1:num
    r_2 = x((i-1)*6+1:(i-1)*6+3, :);
    t_2 = x((i-1)*6+4:(i-1)*6+6,:);
    Ms(:,:,i) = [rodrigues(r_2) t_2];
end
Ms = Ms(:,:,1:num);
end