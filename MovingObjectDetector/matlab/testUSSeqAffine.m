% your code here
load('../data/usseq.mat');
load('usseqrects-wcrt.mat');
imshow(frames(:,:,1));
hold on;
for i=2:size(frames,3)-1
    recMask = zeros(size(frames,1), size(frames,2));
    mask = SubtractDominantMotion(frames(:,:,i), frames(:,:,i+1));
    recMask(rects(i-1,2):rects(i-1,4),rects(i-1,1):rects(i-1,3)) = mask(rects(i-1,2):rects(i-1,4),rects(i-1,1):rects(i-1,3));
    
    imshow(imfuse(frames(:,:,i), frames(:,:,i).*uint8(recMask),'falsecolor'));
    pause(0.01);
    if i == 5 || i == 25 || i == 50 || i == 75 || i == 99
        a = 1;
    end
end
