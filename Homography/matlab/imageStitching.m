function [panoImg] = imageStitching(img1, img2, H2to1)
%
% input
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear equation
%
% output
% Blends img1 and warped img2 and outputs the panorama image

%%%

out_size = [size(img1,1) size(img1,2)+size(img2,2)];
warp_im = warpH(img2, H2to1, out_size, 0);
% imshow(warp_im);
% composite_img = compositeH(H2to1, img1, warp_im);
panoImg = warp_im;
panoImg(1:size(img1,1)-10,1:size(img1,2)-10,:) = img1(1:size(img1,1)-10,1:size(img1,2)-10,:);
% imshow(panoImg);

end