function [h] = getImageFeatures(wordMap, dictionarySize)
% Convert an wordMap to its feature vector. In this case, it is a histogram
% of the visual words
% Input:
%   wordMap:            an H * W matrix with integer values between 1 and K
%   dictionarySize:     the total number of words in the dictionary, K
% Outputs:
%   h:                  the feature vector for this image


	% -----fill in your implementation here --------

    vec = wordMap(:);
    h = zeros(1,dictionarySize);
    for i =1:size(h,2)
        h(i) = sum(vec==i);
    end
    h = h/sum(h);
%     h = tabulate(wordMap(:));
%     h = h(:,3)';
%     h = h/100;

    % ------------------------------------------

end
