% buildRecognitionSystem.m
% This script loads the visual word dictionary (in dictionaryRandom.mat or dictionaryHarris.mat) and processes
% the training images so as to build the recognition system. The result is
% stored in visionRandom.mat and visionHarris.mat.
K = 100; % fix to 100 now
method = 'Harris';
%method = 'Random';
if strcmp('Harris',method)
    dicFileName = 'visionHarris.mat';
    imageExpend = '_Harris.mat';
    visionFileName = 'visionHarris.mat'
else
    dicFileName = 'visionRandom.mat';
    imageExpend = '_Random.mat';
    visionFileName = 'visionRandom.mat'
end

%load('dictionaryHarris.mat'); !!!!!!!!!!!!!!!!!!!!!!!!!!!
load(dicFileName);
filterBank = createFilterBank();
traintest = load('../data/traintest.mat');
trainLabels = traintest.train_labels';
trainImages = traintest.train_imagenames;
T = size(trainLabels,1);
trainFeatures = zeros(T,K);
for i = 1:size(trainImages,2)
%for i = 1:5
    %load(sprintf('../data/%s',strrep(trainImages{1,i},'.jpg','_Harris.mat')));%!!!!!!!!!!!!!!!!
    load(sprintf('../data/%s',strrep(trainImages{1,i},'.jpg',imageExpend)));
    trainFeatures(i,:) = getImageFeatures(wordMap,K);
end
%save('visionHarris.mat','dictionary','filterBank','trainFeatures','trainLabels');%!!!!!!!!!!!!!!!!!!
save(visionFileName,'dictionary','filterBank','trainFeatures','trainLabels');