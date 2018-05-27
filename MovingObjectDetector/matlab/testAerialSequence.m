% your code here
load('../data/aerialseq.mat');
% imshow(frames(:,:,1));
hold on;
rects = zeros(size(frames,3),4);
for i=2:size(frames,3)-1
    mask = SubtractDominantMotion(frames(:,:,i), frames(:,:,i+1));
    
    imshow(imfuse(frames(:,:,i), frames(:,:,i).*uint8(~mask),'falsecolor'));
    pause(0.01);
    if i == 30 || i == 60 || i == 90 || i == 120
        a = 1;
    end
end