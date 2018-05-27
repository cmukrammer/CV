function [locs, desc] = briefLite(im)
% input
% im - gray image with values between 0 and 1
%
% output
% locs - an m x 3 vector, where the first two columns are the image coordinates of keypoints and the third column 
% 		 is the pyramid level of the keypoints
% desc - an m x n bits matrix of stacked BRIEF descriptors. 
%		 m is the number of valid descriptors in the image and will vary
% 		 n is the number of bits for the BRIEF descriptor

%%%

load('testPattern.mat','compareA','compareB');
corners = detectHarrisFeatures(im);
% imshow(im); hold on;
% plot(corners.selectStrongest(50));
% corners = detectFASTFeatures(im);
[locs, desc] = computeBrief(im, corners.Location, compareA, compareB);

end