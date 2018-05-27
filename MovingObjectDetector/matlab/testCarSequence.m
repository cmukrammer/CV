% your code here
load('../data/carseq.mat');
rect = [60,117,146,152];
% load('../data/sylvseq.mat');
% rect = [102,62,156,108];
imshow(frames(:,:,1));
hold on;
rects = zeros(size(frames,3),4);
rects(1,:) = rect;
for i=2:size(frames,3)
    imshow(frames(:,:,i));
    [u,v] = LucasKanadeInverseCompositional(frames(:,:,i-1), frames(:,:,i), rect);
    rect = [rect(1)+u,rect(2)+v,rect(3)+u,rect(4)+v];
    rect = round(rect);
    rectangle('Position',[rect(1) rect(2) rect(3)-rect(1) rect(4)-rect(2)],'EdgeColor', 'g');
    rects(i,:) = rect;
    pause(0.01);
end
save('carseqrects.mat', 'rects');