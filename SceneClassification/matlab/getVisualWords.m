function [wordMap] = getVisualWords(I, dictionary, filterBank)
% Convert an RGB or grayscale image to a visual words representation, with each
% pixel converted to a single integer label.   
% Inputs:
%   I:              RGB or grayscale image of size H * W * C
%   filterBank:     cell array of matrix filters used to make the visual words.
%                   generated from getFilterBankAndDictionary.m
%   dictionary:     matrix of size 3*length(filterBank) * K representing the
%                   visual words computed by getFilterBankAndDictionary.m
% Outputs:
%   wordMap:        a matrix of size H * W with integer entries between
%                   1 and K

    % -----fill in your implementation here --------
    responses = extractFilterResponses(I, filterBank);
    h = size(I,1);
    w = size(I,2);
    features = zeros(h*w,60); % fix value 60
    for k = 1:size(responses,3)
        A = responses(:,:,k);
        features(:,k) = A(:);
    end
    D = pdist2(features, dictionary);
    
    minD = min(D,[],2);
    tmp = zeros(h*w,1);
    for i = 1:size(minD,1)
        tmp(i,1) = find(D(i,:)==minD(i));
    end
    wordMap = reshape(tmp,h,w);
    % ------------------------------------------
end
