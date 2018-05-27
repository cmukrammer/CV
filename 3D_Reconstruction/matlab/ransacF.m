function [ F, inliers ] = ransacF( pts1, pts2, M )
% ransacF:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q5.1:
%     Implement RANSAC
%     Generate a matrix F from some '../data/some_corresp_noisy.mat'
%          - using eightpoint
%          - using ransac

%     In your writeup, describe your algorithm, how you determined which
%     points are inliers, and any other optimizations you made
% load('q3_3.mat');
% load('../data/intrinsics.mat');
N = size(pts1,1);
thr = 1000;
bestF = zeros(3,3);
best_error = -1;
best_inliers = zeros(N,1);
pts1(:,3) = ones(N,1);
pts2(:,3) = ones(N,1);
pick_percent = 0.1;
best_picks = randperm(N,max(8,floor(N*pick_percent)));

for i=1:thr
    picks = randperm(N,max(8,floor(N*pick_percent)));
    p1 = pts1(picks,:);
    p2 = pts2(picks,:);
    [ F ] = eightpoint( p1(:,1:2), p2(:,1:2), M );
    % find inliers
    [inliers, err] = computeErr(pts1, pts2, F);
    if best_error == -1 || sum(inliers) > best_error
        best_error = sum(inliers);
        best_inliers = inliers;
        bestF = F;
        best_picks = picks;
        % fprintf("%d, %d\n", best_error, sum(inliers(best_picks)));
        % [inliers, err] = computeErr(p1, p2, F);
        % fprintf("%d %d\n", sum(inliers), i);
    end
    
end
inliers = best_inliers;
fprintf("%d\n",sum(inliers));
fprintf("%d\n",sum(inliers(best_picks)));
p1 = pts1(inliers,:);
p2 = pts2(inliers,:);
[ F ] = eightpoint( p1(:,1:2), p2(:,1:2), M );

% [inliers, err] = computeErr(p1, p2, F);
% fprintf("%d\n", sum(inliers));
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
