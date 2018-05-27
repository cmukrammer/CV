% [compareX, compareY] = makeTestPattern(9, 256);
% img1 = imread('../data/model_chickenbroth.jpg');
img1 = imread('../data/model_chickenbroth.jpg');
% img2 = imread('../data/chickenbroth_01.jpg');
img2 = imread('../data/chickenbroth_01.jpg');

im1 = rgb2gray(img1);
% level = graythresh(im1);
% im1 = imbinarize(im1, level);
im2 = rgb2gray(img2);
% level = graythresh(im2);
% im2 = imbinarize(im2, level);

% corners = detectHarrisFeatures(im);
% corners = detectFASTFeatures(im);
% imshow(img); hold on;
% plot(corners.selectStrongest(50));
% [locs, desc] = computeBrief(im, corners.Location, compareX, compareY);

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);
[matches] = briefMatch(desc1, desc2, 0.8);
plotMatches(im1, im2, matches, locs1, locs2);