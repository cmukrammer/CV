function M = LucasKanadeAffine(It, It1)

% input - image at time t, image at t+1 
% output - M affine transformation matrix
p = [0,0,0,0,0,0];
grayIt = double(grayscale(It));
grayIt1 = double(grayscale(It1));

[X,Y] = meshgrid(1:size(It,2),1:size(It,1));
T = interp2(grayIt,X,Y);
% imshow(uint8(T));
[TGx,TGy] = imgradientxy(T);
steepest = [TGx(:).*X(:),TGy(:).*X(:),TGx(:).*Y(:),TGy(:).*Y(:),TGx(:),TGy(:)];
coordinates = [X(:),Y(:),ones(1,size(It,1)*size(It,2))'];
T = T(:);
while 1
    M = [1+p(1),p(3),p(5);p(2),1+p(4),p(6);0,0,1];
    IW = coordinates*M';
    validX = (IW(:,1)>=1)&(IW(:,1)<=size(It,2));
    validY = (IW(:,2)>=1)&(IW(:,2)<=size(It,1));
    validBoth = validX & validY;
    
    warpIt1 = interp2(grayIt1,IW(:,1),IW(:,2));
    newSteepest = steepest(validBoth,:);
    Hessian = newSteepest'*newSteepest;
    
    errorImg = T-warpIt1;
    errorImg = errorImg(validBoth);
    deltap = Hessian\(newSteepest'*errorImg);
    p = p + deltap';
    if sqrt(deltap(1)^2+deltap(2)^2+deltap(3)^2+deltap(4)^2+deltap(5)^2+deltap(6)^2) < 0.1
        break;
    end
end
M = [1+p(1),p(3),p(5);p(2),1+p(4),p(6);0,0,1];
end

function [gray] = grayscale(img)
gray = img;
if (ndims(img) == 3)
    gray = rgb2gray(img);
end
end
