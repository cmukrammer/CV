function [ bestH2to1, inliers] = computeH_ransac( locs1, locs2)
%COMPUTEH_RANSAC A method to compute the best fitting homography given a
%list of matching points.

%Q2.2.3

%%%

range = size(locs1,1);
thr = 300;
num_points = 4;
bestH2to1 = zeros(3,3);
pre_inliers_nums = 0;
best_inliers = zeros(1,range);

if range < num_points
    inliers = best_inliers;
    return; 
end

for i=1:thr
    picks = randperm(range,num_points);
%     picks = [1 2 3 4 5];
    p1 = zeros(2,num_points);
    p2 = zeros(2,num_points);
    for j=1:num_points
        p1(:,j) = locs1(picks(j),:)';
        p2(:,j) = locs2(picks(j),:)';
    end
%     [H2to1] = computeH_norm(p1, p2);
    [H2to1] = computeH(p1,p2);
%     inliners = 0;
%     for j=1:range
%         new_x1 = H2to1*[locs2(j,1) locs2(j,2) 1]';
%         new_x1 = new_x1/(new_x1(3));
%         dist = pdist2(new_x1', [locs1(j,1) locs1(j,2) 1], 'euclidean');
%         if dist < 20
%             inliners = inliners + 1;
%         end
%     end
    
    new_x2 = locs2;
    new_x2 = [new_x2 ones(size(locs2,1),1)]';
    new_x2 = H2to1*new_x2;
    new_x2 = new_x2./new_x2(3,:);
    new_x1 = locs1;
    new_x1 = [new_x1 ones(size(locs1,1),1)]';
    diff = new_x2 - new_x1;
    diff = sqrt(diff(1,:).*diff(1,:) + diff(2,:).*diff(2,:));
    inliers = zeros(1,range);
    for j=1:range
        if diff(j) < 10
            inliers(j) = 1;
        end
    end
    
    total_inliers = sum(diff(:) < 10);
    
    if total_inliers > pre_inliers_nums
        best_inliers = inliers;
        pre_inliers_nums = total_inliers;
    end
end
inliers = best_inliers;
new_x2 = locs2(inliers==1,:);
new_x1 = locs1(inliers==1,:);
bestH2to1 = computeH_norm(new_x1',new_x2');
end

