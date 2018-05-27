function im3 = generatePanorama(im1, im2)

%%%
if (ndims(im1) == 3)
    im1_gray = rgb2gray(im1);
end
if (ndims(im2) == 3)
    im2_gray = rgb2gray(im2);
end
[locs1, desc1] = briefLite(im1_gray);
[locs2, desc2] = briefLite(im2_gray);
[matches] = briefMatch(desc1, desc2, 0.8);
plotMatches(im1, im2, matches, locs1, locs2);
new_locs1 = zeros(size(matches,1),2);
new_locs2 = zeros(size(matches,1),2);
for i=1:size(matches,1)
    idx1 = matches(i,1);
    idx2 = matches(i,2);
    new_locs1(i,:) = locs1(matches(i,1),:);
    new_locs2(i,:) = locs2(matches(i,2),:);
end
[ bestH2to1, inliers] = computeH_ransac( new_locs1, new_locs2);
panoImg = imageStitching_noClip(im1,im2,bestH2to1);
% panoImg = imageStitching(im1,im2,bestH2to1);
im3 = panoImg;
end