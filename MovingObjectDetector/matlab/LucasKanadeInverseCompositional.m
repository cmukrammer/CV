function [u,v] = LucasKanadeInverseCompositional(It, It1, rect)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [u, v] in the x- and y-directions.
u = 0;
v = 0;
grayIt = double(grayscale(It));
grayIt1 = double(grayscale(It1));

[X,Y] = meshgrid(rect(1):rect(3),rect(2):rect(4));
T = interp2(grayIt,X,Y);
% imshow(uint8(T));
[TGx,TGy] = imgradientxy(T);
warp_x_0 = [1 0; 0 1];
steepest = [TGx(:) TGy(:)]*warp_x_0;
Hessian = steepest'*steepest;

while 1
    [X,Y] = meshgrid(rect(1)+u:rect(3)+u,rect(2)+v:rect(4)+v);
    warpIt1 = interp2(grayIt1,X,Y);
    errorImg = T-warpIt1;
    deltap = Hessian\(steepest'*errorImg(:));
    u = u + deltap(1);
    v = v + deltap(2);
    if sqrt(deltap(1)^2+deltap(2)^2) < 0.001
        break;
    end
end

end

function [gray] = grayscale(img)
gray = img;
if (ndims(img) == 3)
    gray = rgb2gray(img);
end
end