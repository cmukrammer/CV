function mask = SubtractDominantMotion(image1, image2)

% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size
w = size(image1,2);
h = size(image1,1);
image1 = double(image1);
image2 = double(image2);
M = LucasKanadeAffine(image1, image2);
[X,Y] = meshgrid(1:w,1:h);
coordinate = [X(:),Y(:),ones(w*h,1)];
IW = coordinate*M';
newX = IW(:,1);
newY = IW(:,2);
t = interp2(image2,newX,newY);
IW = reshape(t,size(image1));
mask = IW - image1;
mask = uint8(mask);
mask(find(mask>40)) = 255;
mask(find(mask<=40)) = 0;

t = strel('disk',7);
mask = imdilate(mask,t);

% mask = bwareaopen(mask,60);
end