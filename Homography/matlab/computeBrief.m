function [locs, desc] = computeBrief(im, locs, compareX, compareY)
% Compute the BRIEF descriptor for detected keypoints.
% im is 1 channel image, 
% locs are locations
% compareX and compareY are idx in patchWidth^2
% Return:
% locs: m x 2 vector which contains the coordinates of the keypoints
% desc: m x nbits vector which contains the BRIEF descriptor for each
%   keypoint.

%%%

patchWidth = 9; % assumption
r = size(im,1);
c = size(im,2);
idx = 1;
new_locs = zeros(1,2);
test_points_len = size(compareX,1);
desc = zeros(1,test_points_len);

for i = 1:size(locs,1)
    x = floor(locs(i,1));
    y = floor(locs(i,2));
    if x-4 < 1 || y-4 < 1 || x+4 > c || y+4 > r
        continue;
    end
    new_locs(idx,:) = [x,y];
    tmp = zeros(1,test_points_len);
    x = x - 4;
    y = y - 4;
    for j = 1:test_points_len
        ax = x + floor((compareX(j)-1)/patchWidth);
        ay = y + rem(compareX(j)-1,patchWidth);
        bx = x + floor((compareY(j)-1)/patchWidth);
        by = y + rem(compareY(j)-1,patchWidth);
        if im(ay,ax) < im(by,bx)
            tmp(1,j) = 1;
        end
    end
    desc(idx,:) = tmp;
    idx = idx + 1;
end

locs = new_locs;

end