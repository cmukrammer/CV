cv_cover = imread('../data/cv_cover.jpg');
cv_desk = imread('../data/cv_desk.png');
hp_cover = imread('../data/hp_cover.jpg');
% hp_cover = imread('../data/pnd.png');
% hp_cover = imread('../data/model_chickenbroth.jpg');
% cv_desk = imread('../data/chickenbroth_01.jpg');];
hp_cover = imresize(hp_cover,[size(cv_cover,1),size(cv_cover,2)]);
% imshow(hp_cover);

im1 = cv_desk;
if (ndims(im1) == 3)
    im1 = rgb2gray(im1);
end
% level = graythresh(im1);
% im1 = imbinarize(im1, level);
im2 = cv_cover;
if (ndims(im2) == 3)
    im2 = rgb2gray(im2);
end
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
%plotMatches(im1, im2, matches, locs1, locs2);

new_locs1 = zeros(size(matches,1),2);
new_locs2 = zeros(size(matches,1),2);
for i=1:size(matches,1)
    idx1 = matches(i,1);
    idx2 = matches(i,2);
    new_locs1(i,:) = locs1(matches(i,1),:);
    new_locs2(i,:) = locs2(matches(i,2),:);
end

[ bestH2to1, inliers] = computeH_ransac( new_locs1, new_locs2);
out_size = [size(cv_desk,1) size(cv_desk,2)];
warp_im = warpH(hp_cover, bestH2to1, out_size, 0);
% imshow(warp_im);

cv_desk = imread('../data/cv_desk.png');
[ composite_img ] = compositeH(bestH2to1, cv_desk, warp_im);
imshow(composite_img);