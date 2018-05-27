function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q4.1:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q4_1.mat
%
%           Explain your methods and optimization in your writeup

if (ndims(im1) == 3)
    im1 = rgb2gray(im1);
end
if (ndims(im2) == 3)
    im2 = rgb2gray(im2);
end

h = size(im1,1);
w = size(im1,2);
lp = F*[x1;y1;1];
lp = lp./lp(3);
s = sqrt(lp(1)^2+lp(2)^2);
lp = lp/s;
g = fspecial('gaussian');
% im1 = conv2(im1,g);
% im2 = conv2(im2,g);
im1 = double(im1);
im2 = double(im2);
thrd = 5;
minx = max(1,x1-thrd);
maxx = min(w,x1+thrd);
miny = max(1,y1-thrd);
maxy = min(h,y1+thrd);

window = 5;
target = im1(y1-window:y1+window,x1-window:x1+window);
target = target(:);
minV = -1;
minpx = 0;
minpy = 0;
%from x
for i=minx:maxx
    x = i;
    if (lp(2) == 0)
        y = y1;
    else
        y = (-lp(3)-lp(1)*x)/lp(2);
    end
    x = floor(x);
    y = floor(y);
    if (x-window<1 || y-window<1 || x+window>w || y+window>h || (x-x1)^2+(y-y1)^2 > 1000)
        continue
    end
    new = im2(y-window:y+window,x-window:x+window);
    new = new(:);
    d = pdist2(target', new');
    if (minV == -1 || d < minV)
        minV = d;
        minpx = x;
        minpy = y;
    end
end
%from y
for i=miny:maxy
    y = i;
    if (lp(1) == 0)
        x = x1;
    else
        x = (-lp(3)-lp(2)*y)/lp(1);
    end
    x = floor(x);
    y = floor(y);
    if (x-window<1 || y-window<1 || x+window>w || y+window>h || (x-x1)^2+(y-y1)^2 > 1000)
        continue
    end
    new = im2(y-window:y+window,x-window:x+window);
    new = new(:);
    d = pdist2(target', new');
    if (minV == -1 || d < minV)
        minV = d;
        minpx = x;
        minpy = y;
    end
end

x2 = minpx; 
y2 = minpy;

end

