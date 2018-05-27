function [points] = getRandomPoints(I, alpha)
% Generates random points in the image
% Input:
%   I:                      grayscale image
%   alpha:                  random points
% Output:
%   points:                    point locations
%
	% -----fill in your implementation here --------

    h = size(I,1);
    w = size(I,2);
    points = [];
    hV = randi([1,h],alpha,1);
    wV = randi([1,w],alpha,1);
    points(:,1) = hV;
    points(:,2) = wV;
    

    % ------------------------------------------

end

