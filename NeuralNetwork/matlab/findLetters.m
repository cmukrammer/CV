function [lines, bw] = findLetters(im)
% [lines, BW] = findLetters(im) processes the input RGB image and returns a cell
% array 'lines' of located characters in the image, as well as a binary
% representation of the input image. The cell array 'lines' should contain one
% matrix entry for each line of text that appears in the image. Each matrix entry
% should have size Lx4, where L represents the number of letters in that line.
% Each row of the matrix should contain 4 numbers [x1, y1, x2, y2] representing
% the top-left and bottom-right position of each box. The boxes in one line should
% be sorted by x1 value.

orig_im = im;

if ndims(im) == 3
    im = rgb2gray(im);
end

% mim = imfilter(im,fspecial('average',[11 11]),'replicate');
% %mim = imgaussfilt(im,11);
% im = mim-im-10;
% im = im2bw(im, 0);
% imshow(im);pause(5);

%im = imfilter(im,fspecial('average',[9 9]),'replicate');
%im = imgaussfilt(im,3);
level = graythresh(im);
im = imbinarize(im, level);
im = imcomplement(im);
beforeDilateIm = im;

%imshow(im);pause(1);
se1 = strel('line',6,0);    % thicker the texts
se2 = strel('line',6,90);
se3 = strel('line',5,180);
se4 = strel('line',5,270);
im = imdilate(im,[se1 se2 se3 se4],'full');
% se1 = strel('line',5,180);
% se2 = strel('line',5,270);
% im = imdilate(im,[se1 se2],'full');
%imshow(im);pause(2);

CC = bwconncomp(im);
% numPixels = cellfun(@numel,CC.PixelIdxList);
% [biggest,idx] = max(numPixels);
% im(CC.PixelIdxList{idx}) = 0;
imshow(orig_im);hold on;
[m,n] = size(im);
% get boxes
boxes = zeros(size(CC.PixelIdxList,2),4); % left,top,right,bottom
for k=1:length(CC.PixelIdxList)
    if length(CC.PixelIdxList{k}) < 5
        continue;
    end
    for i=1:length(CC.PixelIdxList{k})
        t = CC.PixelIdxList{k}(i);
        x = floor(t/m);
        y = mod(t,m);
        if x > boxes(k,3)
            boxes(k,3) = x;
        elseif boxes(k,1) == 0 || x < boxes(k,1)
            boxes(k,1) = x;
        end
        if boxes(k,2) == 0 || y < boxes(k,2)
            boxes(k,2) = y;
        elseif y > boxes(k,4)
            boxes(k,4) = y;
        end 
    end
end

%filter all rows contain zero
boxes = boxes(boxes(:,1)>0,:);
boxes = boxes(boxes(:,2)>0,:);
boxes = boxes(boxes(:,3)>0,:);
boxes = boxes(boxes(:,4)>0,:);
boxes = sortrows(boxes,2);
%boxes = sortrows(boxes,1);

lines = {};
lines{1} = [[boxes(1,1), boxes(1,2), boxes(1,3), boxes(1,4)]];
lineBot = boxes(1,4);
cur = 1;
% find lines
for i = 2:length(boxes)
    if (boxes(i,3)-boxes(i,1))*(boxes(i,4)-boxes(i,2)) < 1024
        continue
    end
    if boxes(i,2) > lineBot
        cur = cur + 1;
        lines{cur} = [[boxes(i,1), boxes(i,2), boxes(i,3), boxes(i,4)]];
        lineBot = boxes(i,4);
    else
        lineBot = max(lineBot,boxes(i,4));
        lines{cur} = [lines{cur};boxes(i,1), boxes(i,2), boxes(i,3), boxes(i,4)];
    end
end

%sort by x1
for i = 1:length(lines)
    lines{i} = sortrows(lines{i},1);
end
%group
% for i = 1:length(lines)
%     lines{i} = sortrows(lines{i},1);
%     tmp = [[lines{i}(1,1) lines{i}(1,2) lines{i}(1,3) lines{i}(1,4)]];
%     for j = 2:size(lines{i},1)
%         if lines{i}(j,1) > tmp(size(tmp,1),3)+0
%             tmp = [tmp;lines{i}(j,:)];
%         else
%             tmp(size(tmp,1),2) = min(tmp(size(tmp,1),2),lines{i}(j,2));
%             tmp(size(tmp,1),3) = max(tmp(size(tmp,1),3),lines{i}(j,3));
%             tmp(size(tmp,1),4) = max(tmp(size(tmp,1),4),lines{i}(j,4));
%         end
%     end
%     lines{i} = tmp;
% end

%plot(boxes(:,1),boxes(:,2),'yd');
for i = 1:length(lines)
    a = lines{i};
    for j = 1:size(lines{i},1)
        b = a(j,:);
        rectangle('Position',[b(1), b(2), b(3)-b(1), b(4)-b(2)],'EdgeColor','r');
    end
end

bw = {};
count = 1;
xPadding = 5;
yPadding = 5;
[m,n] = size(beforeDilateIm);
for i=1:length(lines)
    for j=1:size(lines{i},1)
        left = max(1,lines{i}(j,1)-xPadding);
        top = max(1,lines{i}(j,2)-yPadding);
        right = min(n,lines{i}(j,3)+xPadding);
        bot = min(m,lines{i}(j,4)+yPadding);
        bw{count} = imcomplement(beforeDilateIm(top:bot,left:right));
        %bw{count} = imgaussfilt(double(bw{count}));
        %imshow(reshape(imresize(bw{count},[32 32]),[32 32]));
        count = count + 1;
    end
end
%pause(1);
end
