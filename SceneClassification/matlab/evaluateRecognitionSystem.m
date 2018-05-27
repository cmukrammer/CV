% evaluateRecognitionSystem.m
% This script evaluates nearest neighbour recognition system on test images
% load traintest.mat and classify each of the test_imagenames files.
% Report both accuracy and confusion matrix
method = 'Harris';
%method = 'Random';
%distanceMethod = 'euclidean';
distanceMethod = 'chi2';
if strcmp('Harris',method)
    visionFileName = 'visionHarris.mat';
    imageExpend = '_Harris.mat';
else
    visionFileName = 'visionRandom.mat';
    imageExpend = '_Random.mat';
end
load(visionFileName);
confusion = zeros(8,8);
load('traintest.mat');
K = 100;
%load('../data/bedroom/sun_aafesxmciavqmkxw_Harris.mat');
%d = getImageDistance(getImageFeatures(wordMap,K),trainFeatures,'euclidean');
%trainLabels(find(d==min(d)))
for i = 1:size(test_imagenames,2)
    load(sprintf('../data/%s',strrep(test_imagenames{1,i},'.jpg',imageExpend)));
    d = getImageDistance(getImageFeatures(wordMap,K),trainFeatures,distanceMethod);
    l = find(d==min(d));
    confusion(test_labels(i),train_labels(l)) = confusion(test_labels(i),train_labels(l)) + 1;
end
accuracy = 0;
for i = 1:8
    accuracy = accuracy + confusion(i,i);
end
accuracy = accuracy/sum(sum(confusion))