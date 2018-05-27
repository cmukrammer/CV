% your code here
load('../data/usseq.mat');
rect = [255,105,310,170];
imshow(frames(:,:,1));
hold on;
rects = zeros(size(frames,3),4);
[X,Y] = meshgrid(rect(1):rect(3),rect(2):rect(4));
T1 = interp2(double(frames(:,:,1)),X,Y);
Tn = T1;
rects(1,:) = rect;
for i=2:size(frames,3)
    imshow(frames(:,:,i));
    preRect = rect;
    [u,v] = newLucasKanadeInverseCompositional(frames(:,:,i-1), frames(:,:,i), rect, Tn);
    rect = [rect(1)+u,rect(2)+v,rect(3)+u,rect(4)+v];
    rect = round(rect);
    [newU, newV] = newLucasKanadeInverseCompositional(frames(:,:,i-1), frames(:,:,i), rect, T1);
    if sqrt((newU)^2+(newV)^2) < 0.01
        rect = [rect(1)+newU,rect(2)+newV,rect(3)+newU,rect(4)+newV];
        rect = round(rect);
        [X,Y] = meshgrid(rect(1):rect(3),rect(2):rect(4));
        Tn = interp2(double(frames(:,:,i)),X,Y);
    else
%         rect = preRect;
        
    end
    rectangle('Position',[rect(1) rect(2) rect(3)-rect(1) rect(4)-rect(2)],'EdgeColor', 'g');
    rects(i,:) = rect;
    pause(0.01);
    if i==5 || i==25|| i==50|| i==75||i==100
        a = 1;
    end
end
save('usseqrects-wcrt.mat','rects');

function [u,v] = newLucasKanadeInverseCompositional(It, It1, rect, T)

% input - image at time t, image at t+1, rectangle (top left, bot right coordinates)
% output - movement vector, [u, v] in the x- and y-directions.
u = 0;
v = 0;
grayIt = double(grayscale(It));
grayIt1 = double(grayscale(It1));

% imshow(uint8(T));
% T = T(1:rect(4)-rect(2), 1:rect(3)-rect(1));
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