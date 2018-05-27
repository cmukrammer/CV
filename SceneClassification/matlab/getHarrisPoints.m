function [points] = getHarrisPoints(I, alpha, k)
% Finds the corner points in an image using the Harris Corner detection algorithm
% Input:
%   I:                      grayscale image
%   alpha:                  number of points
%   k:                      Harris parameter
% Output:
%   points:                    point locations
%
    % -----fill in your implementation here --------

    if (ndims(I) == 3)
        I = rgb2gray(I);
    end
    [Ix, Iy] = imgradientxy(I);
    Ixx = Ix.*Ix;
    Ixy = Ix.*Iy;
    Iyy = Iy.*Iy;
    windowSize = 3;
    A = ones(windowSize, windowSize);
    %A = fspecial('gaussian');
    sumIxx = conv2(Ixx,A,'same');
    sumIxy = conv2(Ixy,A,'same');
    sumIyy = conv2(Iyy,A,'same');
    [h,w] = size(I);
    R = zeros(h,w);
    for i = 1:h
        for j = 1:w
            H = [sumIxx(i,j) sumIxy(i,j); sumIxy(i,j) sumIyy(i,j)];
            R(i,j) = det(H)-k*(trace(H))^2;
        end
    end
    sortedValues = sort(R(:),'descend');
    sortedValues = sortedValues(1:alpha, 1);
    num = 0;
    points = zeros(alpha,2);
    nPoints = 1;
    while (nPoints<=alpha)
        num = num + 1;
        [r,c] = find(R==sortedValues(num));
        i = 1;
        while ((i<=size(r,1)) && (nPoints<=alpha))
            points(nPoints,:) = [r(i),c(i)];
            i = i + 1;
            nPoints = nPoints + 1;
        end
    end

    % ------------------------------------------

end
