function [filterResponses] = extractFilterResponses(I, filterBank)
% CV Spring 2018 - Provided Code
% Extract the filter responses given the image and filter bank
% Pleae make sure the output format is unchanged.
% Inputs:
%   I:                  a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W*H x N*3 matrix of filter responses


    %Convert input Image to Lab
    doubleI = double(I);
    if length(size(doubleI)) == 2
        tmp = doubleI;
        doubleI(:,:,1) = tmp;
        doubleI(:,:,2) = tmp;
        doubleI(:,:,3) = tmp;
    end
    [L,a,b] = RGB2Lab(doubleI(:,:,1), doubleI(:,:,2), doubleI(:,:,3));
    h = size(I,1);
    w = size(I,2);
   
    % -----fill in your implementation here --------
    x = 1;
    filterResponses = zeros(h,w,60); % fix 60
    for i = 1:size(filterBank)
        %disp(filterBank{i})
        filterResponses(:,:,x) = conv2(L, filterBank{i}, 'same');
        filterResponses(:,:,x+1) = conv2(a, filterBank{i}, 'same');
        filterResponses(:,:,x+2) = conv2(b, filterBank{i}, 'same');
        %imshow(conv2(L, filterBank{i}));
        x = x + 3;
    end
    

    % ------------------------------------------
end
