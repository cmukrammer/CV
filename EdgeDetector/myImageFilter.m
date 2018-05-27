function [img1] = myImageFilter(img0, h)

    hSize = size(h);
    B = padarray(img0, [floor(hSize(1)/2) floor(hSize(1)/2)]);
    %Sobel = [1,0,-1;2,0,-2;1,0,-1]/8;
    imgSize = size(img0);
    hCol = flipud(im2col(h, [hSize(1) hSize(2)]));
    %hCol = flipud(hCol);
    imgCol = im2col(B, [hSize(1) hSize(2)]);
    
    afterConv = sum(hCol.*imgCol);
    %afterConv = sum(afterConv);
    newImg = reshape(afterConv, [imgSize(1), imgSize(2)]);
    %verify = conv2(img0, h);
    img1 = newImg;

end
