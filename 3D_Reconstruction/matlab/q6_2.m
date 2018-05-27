clear;
img1 = imread('../data/templeRing/templeR0013.png');
img2 = imread('../data/templeRing/templeR0014.png');
img3 = imread('../data/templeRing/templeR0015.png');
img4 = imread('../data/templeRing/templeR0016.png');
img5 = imread('../data/templeRing/templeR0017.png');
img6 = imread('../data/templeRing/templeR0018.png');
load('../data/intrinsics.mat');
load('q6_2.mat');
h = size(img1,1);
w = size(img1,2);
N = h*w;

grayImg1 = grayscale(img1);
grayImg2 = grayscale(img2);
grayImg3 = grayscale(img3);
grayImg4 = grayscale(img4);
grayImg5 = grayscale(img5);
grayImg6 = grayscale(img6);
grayimgs = zeros(h,w,6);
imgs = zeros(h,w,3,6);
grayimgs(:,:,1)=grayImg1;grayimgs(:,:,2)=grayImg2;grayimgs(:,:,3)=grayImg3;
grayimgs(:,:,4)=grayImg4;grayimgs(:,:,5)=grayImg5;grayimgs(:,:,6)=grayImg6;
grayimgs = uint8(grayimgs);
imgs(:,:,:,1)=img1;imgs(:,:,:,2)=img2;imgs(:,:,:,3)=img3;
imgs(:,:,:,4)=img4;imgs(:,:,:,5)=img5;imgs(:,:,:,6)=img6;
newMs = zeros(3,4,6);
newMs(:,:,2:6) = Ms;
newMs(:,:,1) = [eye(3,3) zeros(3,1)];
Ms = newMs;
window = 5;
idx = 1;
pointsNum = 2000;
pts = zeros(pointsNum,4,5);
color = zeros(pointsNum,3,5);
allP = [];
for k=1:5
    gray = grayimgs(:,:,k);
    img = imgs(:,:,:,k);
    index = randperm(N,pointsNum);
    idx = 1;
    M1 = Ms(:,:,k);
    R1 = M1(1:3,1:3);
    t1 = M1(:,end);
    M2 = Ms(:,:,k+1);
    R2 = M2(1:3,1:3);
    t2 = M2(:,end);
    Rrel = R1'*R2;
    trel = t2 - t1;
    Trel = [0 -trel(3) trel(2); trel(3) 0 -trel(1); -trel(2) trel(1) 0];
    F = inv(K1)'*Trel*Rrel*inv(K1);
%     [coordsIM1, coordsIM2] = epipolarMatchGUI(img1, img2, F);
    for i=1:pointsNum
        x = mod(index(i)-1,w)+1;
        y = floor((index(i)-1)/w)+1;
        if x-window<6 || x+window>w || y-window<6 || y+window>h || gray(y,x)<=20
            continue
        end
        
        pts(idx,1,k) = x;
        pts(idx,2,k) = y;
        color(idx,:,k) = img(y,x,:);
        [ pts(idx,3,k), pts(idx,4,k) ] = epipolarCorrespondence( gray, grayimgs(:,:,k+1), F, pts(idx,1,k), pts(idx,2,k) );
        idx = idx + 1;
    end
%     [inliers, ~] = computeErr([pts(:,1:2,k) ones(size(pts,1),1)],...
%         [pts(:,3:4,k) ones(size(pts,1),1)], F);
    [ P, err ] = triangulate( K1*M1, pts(:,1:2,k),...
        K2*M2, pts(:,3:4,k));
    [coordsIM1, coordsIM2] = epipolarMatchGUI(img1, img2, F);
    for i=1:size(P,1)
        if abs(P(i,1))>20 || abs(P(i,2))>20 || abs(P(i,3))>20
            P(i,1) = 0;
            P(i,2) = 0;
            P(i,3) = 0;
        end
    end
    color = uint8(color);
    pcshow(P,color(:,:,k));
%     scatter3(P(:,1),P(:,2),P(:,3));
    allP = [allP;P];
end
% fprintf("%d\n",err);

% scatter3(P(:,1), P(:,2), P(:,3),'CData',P(:,3));
color = uint8(color);
color = [color(:,:,1);color(:,:,2);color(:,:,3);color(:,:,4);color(:,:,5);];
pcshow(allP,color);

function [gray] = grayscale(img)
gray = img;
if (ndims(img) == 3)
    gray = rgb2gray(img);
end
end

function [inliers, err] = computeErr(p1, p2, F)
p1p = F*p1';
p1p = p1p./p1p(3);
% s = zeros(1,size(p1p,2));
% s = sqrt(p1p(1,:).^2+p1p(2,:).^2);
% p1p = p1p./s;
p1p = p1p';
final = p1p.*p2;
err = sum(final,2);
err = err.^2;
inliers = err < 0.0001;
end