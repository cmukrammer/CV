img1 = imread('../data/model_chickenbroth.jpg');

iter = 36;
count = zeros(1,iter+1);
axis = zeros(1,iter+1);
% imshow(img1_rotate);
im1 = img1;
if (ndims(im1) == 3)
    im1 = rgb2gray(im1);
end
for j=0:iter
    im2 = imrotate(im1,10*j);
    [locs1, desc1] = briefLite(im1);
    [locs2, desc2] = briefLite(im2);
    [matches] = briefMatch(desc1, desc2, 0.8);
    if size(matches,1) > 1
        plotMatches(im1, im2, matches, locs1, locs2);
    end
    new_locs1 = zeros(size(matches,1),2);
    new_locs2 = zeros(size(matches,1),2);
    for i=1:size(matches,1)
        idx1 = matches(i,1);
        idx2 = matches(i,2);
        new_locs1(i,:) = locs1(matches(i,1),:);
        new_locs2(i,:) = locs2(matches(i,2),:);
    end

    [ bestH2to1, inliers] = computeH_ransac( new_locs1, new_locs2);
    count(j+1) = sum(inliers);
    axis(j+1) = 10*j;
end

bar(axis,count);