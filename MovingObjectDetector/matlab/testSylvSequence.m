% your code here
load('../data/sylvseq.mat');
load('../data/sylvbases.mat');
rect = [102,62,156,108];
rect2 = [102,62,156,108];
imshow(frames(:,:,1));
hold on;
rects = zeros(size(frames,3),4);
rects(1,:) = rect;
for i=2:size(frames,3)
    imshow(frames(:,:,i));
    [u,v] = LucasKanadeBasis(frames(:,:,i-1), frames(:,:,i), rect, bases);
    rect = [rect(1)+u,rect(2)+v,rect(3)+u,rect(4)+v];
    rect = round(rect);
    rectangle('Position',[rect(1) rect(2) rect(3)-rect(1) rect(4)-rect(2)],'EdgeColor', 'y');
    rects(i,:) = rect;
    
    [u,v] = LucasKanadeInverseCompositional(frames(:,:,i-1), frames(:,:,i), rect2);
    rect2 = [rect2(1)+u,rect2(2)+v,rect2(3)+u,rect2(4)+v];
    rect2 = round(rect2);
    rectangle('Position',[rect2(1) rect2(2) rect2(3)-rect2(1) rect2(4)-rect2(2)],'EdgeColor', 'g');
    
    pause(0.01);
    if i==400 || i==200 || i==350 || i==300 || i==2
        a = 1;
    end
end
save('sylvseqrects.mat', 'rects');