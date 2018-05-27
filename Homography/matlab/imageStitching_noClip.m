function [panoImg] = imageStitching_noClip(img1, img2, H2to1)
%
% input
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation
%
% output
% Blends img1 and warped img2 and outputs the panorama image
%
% To prevent clipping at the edges, we instead need to warp both image 1 and image 2 into a common third reference frame 
% in which we can display both images without any clipping.

%%%

corners = [1 1 1; 1 size(img2,1) 1; size(img2,2) 1 1; size(img2,2) size(img2,1) 1];
%         top-left bottom-left      top-right         bottom-right
corners = corners';
trans_corners = H2to1*corners;
trans_corners = trans_corners./(trans_corners(3,:));
topLeft = trans_corners(:,1);
bottomLeft = trans_corners(:,2);
topRight = trans_corners(:,3);
bottomRight = trans_corners(:,4);
M = [1 0 0; 0 1 0; 0 0 1];
if topRight(2) < 0
    M(2,3) = -topRight(2);
end

% out_size = [size(img1,1) size(img1,2)+size(img2,2)];
if topRight(2) < 0
    out_size = [round(max(trans_corners(2,:)-min(trans_corners(2,:)))) round(max(trans_corners(1,:)))];
else
    out_size = [round(max(trans_corners(2,:))) round(max(trans_corners(1,:)))];
end
warp_im1 = warpH(img1, M, out_size, 0);
% imshow(warp_im1);
warp_im2 = warpH(img2, M*H2to1, out_size, 0);
% imshow(warp_im2);
panoImg = warp_im2;
% imshow(panoImg);
panoImg(round(M(2,3))+10:size(warp_im1,1),1:size(img1,2)-10,:) = warp_im1(round(M(2,3))+10:size(warp_im1,1),1:size(img1,2)-10,:);

end