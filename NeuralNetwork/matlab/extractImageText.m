function [text] = extractImageText(fname)
% [text] = extractImageText(fname) loads the image specified by the path 'fname'
% and returns the next contained in the image as a string.
img = imread(fname);
load('nist36_model.mat', 'W', 'b');
keySet = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36];
valueSet = {'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','0','1','2','3','4','5','6','7','8','9'};
mapObj = containers.Map(keySet,valueSet);
[lines, bw] = findLetters(img);
curL = 1;
curP = 1;
for i=1:length(bw)
    im = imresize(bw{i},[32 32]);
    [out, act_h, act_a] = Forward(W, b, im(:)');
    fprintf('%s',mapObj(find(out'==max(out'))));
    curP = curP + 1;
    if curP > size(lines{curL},1)
        curP = 1;
        curL = curL + 1;
        fprintf('\n');
    end
end
