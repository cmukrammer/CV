% [compareX, compareY] = makeTestPattern(9, 256);
% img1 = imread('../data/model_chickenbroth.jpg');
% img1 = imread('../data/model_chickenbroth.jpg');
% % img2 = imread('../data/chickenbroth_01.jpg');
% img2 = imread('../data/chickenbroth_01.jpg');

% im1 = rgb2gray(img1);
% % level = graythresh(im1);
% % im1 = imbinarize(im1, level);
% im2 = rgb2gray(img2);
% level = graythresh(im2);
% im2 = imbinarize(im2, level);

% corners = detectHarrisFeatures(im);
% corners = detectFASTFeatures(im);
% imshow(img); hold on;
% plot(corners.selectStrongest(50));
% [locs, desc] = computeBrief(im, corners.Location, compareX, compareY);

% [locs1, desc1] = briefLite(im1);
% [locs2, desc2] = briefLite(im2);
% [matches] = briefMatch(desc1, desc2, 0.8);
% plotMatches(im1, im2, matches, locs1, locs2);

% img1 = imread('../data/incline_L.png');
% img2 = imread('../data/incline_R.png');
% img1 = imread('../data/pnc1.png','BackgroundColor',[0,0,0]);
% img2 = imread('../data/pnc0.png','BackgroundColor',[0,0,0]);

% im1 = pnc1;
% if (ndims(im1) == 3)
%     im1 = rgb2gray(im1);
% end
% % level = graythresh(im1);
% % im1 = imbinarize(im1, level);
% im2 = pnc0;
% if (ndims(im2) == 3)
%     im2 = rgb2gray(im2);
% end
% 
% [locs1, desc1] = briefLite(im1);
% [locs2, desc2] = briefLite(im2);
% [matches] = briefMatch(desc1, desc2, 0.8);
% % plotMatches(im1, im2, matches, locs1, locs2);
% new_locs1 = zeros(size(matches,1),2);
% new_locs2 = zeros(size(matches,1),2);
% for i=1:size(matches,1)
%     idx1 = matches(i,1);
%     idx2 = matches(i,2);
%     new_locs1(i,:) = locs1(matches(i,1),:);
%     new_locs2(i,:) = locs2(matches(i,2),:);
% end
% 
% [ bestH2to1, inliers] = computeH_ransac( new_locs1, new_locs2);
% 
% % 
% % panoImg = imageStitching(pnc1,pnc0,bestH2to1);
% panoImg = imageStitching_noClip(pnc1,pnc0,bestH2to1);
% imshow(panoImg);
img1 = imread('../data/src_0006.png');
img1 = imresize(img1,1/4);
img2 = imread('../data/src_0005.png');
img2 = imresize(img2,1/4);
img3 = imread('../data/src_0004.png');
img3 = imresize(img3,1/4);
img4 = imread('../data/src_0003.png');
img4 = imresize(img4,1/4);
img5 = imread('../data/src_0002.png');
img5 = imresize(img5,1/4);
img6 = imread('../data/src_0001.png');
img6 = imresize(img6,1/4);
pano1 = generatePanorama(img1, img2);
pano2 = generatePanorama(img3, img4);
pano3 = generatePanorama(img5, img6);
pano4 = generatePanorama(pano1,pano2);
pano5 = generatePanorama(pano4,pano3);
% pano3 = generatePanorama(pano1, img4);
imshow(pano5);