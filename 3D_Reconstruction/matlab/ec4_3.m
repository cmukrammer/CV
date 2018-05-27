% Q4.2:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3

load('../data/templeCoords.mat');
load('../data/intrinsics.mat');
load('../data/some_corresp.mat');

img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');
load('q3_3.mat');


h = size(img1,1);
w = size(img1,2);
N = h*w;
pts1 = zeros(N,2);
pts2 = zeros(N,2);
color = zeros(N,3);
window = 5;
idx = 1;
if (ndims(img1) == 3)
    grayimg1 = rgb2gray(img1);
end
if (ndims(img2) == 3)
    img2 = rgb2gray(img2);
end
for i=1+window:w-window
    for j=1+window:h-window
        if grayimg1(j,i) <= 20
            continue;
        end
        pts1(idx,1) = i;
        pts1(idx,2) = j;
        color(idx,:) = img1(j,i,:);
        [ pts2(idx,1), pts2(idx,2) ] = epipolarCorrespondence( grayimg1, img2, F, pts1(idx,1), pts1(idx,2) );
        idx = idx + 1;
    end
    if mod(i,50) == 0
        fprintf("%d\n", i);
    end
end
[ P, err ] = triangulate( [K1 zeros(3,1)], pts1, K2*M2, pts2);
fprintf("%d\n",err);

% scatter3(P(:,1), P(:,2), P(:,3),'CData',P(:,3));
M1 = [eye(3) zeros(3,1)];
C1 = [K1 zeros(3,1)];
C2 = K2*M2;
color = uint8(color);
save('q4_3.mat','F','M1','M2','C1','C2','P','pts1','pts2','color');
pcshow(P, color);
% load('q4_3.mat');
% for i=1:N
%     if (pts1(i,1) == 0)
%         continue;
%     end
%     color(i,:) = img1(pts1(i,2),pts1(i,1),:);
% end
% color = uint8(color);