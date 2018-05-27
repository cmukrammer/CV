function [H2to1] = computeH_norm(p1, p2)
% inputs:
% p1 and p2 should be 2 x N matrices of corresponding (x, y)' coordinates between two images
%
% outputs:
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation

%%%
N = size(p1,2);
orig_p1 = p1;
orig_p1(3,:) = ones(1,size(orig_p1,2));
orig_p2 = p2;
orig_p2(3,:) = ones(1,size(orig_p2,2));
mean_p1 = sum(p1,2)/N;
mean_p2 = sum(p2,2)/N;

% x' = (x-mean)*sqrt(2)/max(x)
%    = (x-mean)*A
%    = x*A - mean*A
p1 = p1 - mean_p1;
p2 = p2 - mean_p2;
T = [sqrt(2)/max(p1(1,:),[],2) 0                            -1*mean_p1(1)*sqrt(2)/max(p1(1,:),[],2); ...
     0                         sqrt(2)/max(p1(2,:),[],2)    -1*mean_p1(2)*sqrt(2)/max(p1(2,:),[],2); ...
     0                         0                            1];
T1= [sqrt(2)/max(p2(1,:),[],2) 0                            -1*mean_p2(1)*sqrt(2)/max(p2(1,:),[],2); ...
     0                         sqrt(2)/max(p2(2,:),[],2)    -1*mean_p2(2)*sqrt(2)/max(p2(2,:),[],2); ...
     0                         0                            1];

p1 = (p1./max(p1,[],2))*sqrt(2);
p2 = (p2./max(p2,[],2))*sqrt(2);
[H2to1] = computeH(p1, p2);
H2to1 = T\H2to1*T1;
end