function [dictionary] = getDictionary(imgPaths, alpha, K, method)
% Generate the filter bank and the dictionary of visual words
% Inputs:
%   imgPaths:        array of strings that repesent paths to the images
%   alpha:          num of points
%   K:              K means parameters
%   method:         string 'random' or 'harris'
% Outputs:
%   dictionary:         a length(imgPaths) * K matrix where each column
%                       represents a single visual word
    % -----fill in your implementation here --------
    datadir = '../data';
    pixelResponses = zeros(alpha*size(imgPaths,2),3*20); % fix n = 20
    if method == 'random'
        for i = 1:size(imgPaths,2)
            img = imread(sprintf('%s/%s', datadir, imgPaths{i}));
            responses = extractFilterResponses(img, createFilterBank());
            points = getRandomPoints(img, alpha);
            if mod(i,5) == 0
                i           % print out the progress
            end
            x = size(points);
            for k = 1:size(points)
                for j = 1:size(responses,3)
                    pixelResponses((i-1)*x+k,j) = responses(points(k,1),points(k,2),j);
                end
            end
        end
        [~, dictionary] = kmeans(pixelResponses, K, 'EmptyAction', 'drop');
        save('dictionaryRandom.mat','dictionary');
    else
        for i = 1:size(imgPaths,2)
            img = imread(sprintf('%s/%s', datadir, imgPaths{i}));
            responses = extractFilterResponses(img, createFilterBank());
            k = 0.04;
            points = getHarrisPoints(img, alpha, k);
            if mod(i,5) == 0
                i           % print out the progress
            end
            x = size(points);
            for k = 1:size(points)
                for j = 1:size(responses,3)
                    pixelResponses((i-1)*x+k,j) = responses(points(k,1),points(k,2),j);
                end
            end
        end
        [~, dictionary] = kmeans(pixelResponses, K, 'EmptyAction', 'drop');
        save('dictionaryHarris.mat','dictionary');
    end
    % ------------------------------------------
