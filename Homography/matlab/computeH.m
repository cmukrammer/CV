function [H2to1] = computeH(p1, p2)
% inputs:
% p1 and p2 should be 2 x N matrices of corresponding (x, y)' coordinates between two images
%
% outputs:
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation

%%%

A = zeros(size(p1,2)*2,9);
% A = zeros(9,9);

for i=1:size(p1,2)
    x = p2(1,i);
    y = p2(2,i);
    x_p = p1(1,i);
    y_p = p1(2,i);
    A((i-1)*2+1,:) = [-x,-y,-1,0,0,0,x*x_p,y*x_p,x_p];
%     if i ~= 5
        A((i)*2,:) = [0,0,0,-x,-y,-1,x*y_p,y*y_p,y_p];
%     end
end

[U,S,V] = svd(A);

h = V(:,end);
H2to1 = reshape(h,[3 3]);
H2to1 = H2to1';
bestH2to1 = H2to1;
for i=1:size(p1,2)
%     [p1(1,i) p1(2,i) 1]
%     x = H2to1*[p2(1,i) p2(2,i) 1]';
%     x = (x/x(3))'
%     pdist2([p1(1,i) p1(2,i) 1], x, 'euclidean')
%     (x*(1/x(3)))'
%     if pdist2([p1(1,i) p1(2,i) 1], (x*(1/x(3)))', 'euclidean') < 5
%         bestH2to1 = H2to1*(1/x(3));
%     end
end
% H2to1=bestH2to1;
% for i=1:5
%     [p1(1,i) p1(2,i) 1]
%     x = H2to1*[p2(1,i) p2(2,i) 1]';
%     x = x';
%     x
%     pdist2([p1(1,i) p1(2,i) 1], x, 'euclidean')
% end
end