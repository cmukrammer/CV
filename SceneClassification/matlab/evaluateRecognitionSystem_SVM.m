method = 'Harris';
%method = 'Random';
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
t = templateSVM('KernelFunction','polynomial');
%t = templateSVM('KernelFunction','gaussian');
%t = templateSVM('KernelFunction','linear');
Mdl = fitcecoc(trainFeatures,trainLabels,'Learners',t);
%Mdl = fitcecoc(trainFeatures,trainLabels);
%load('../data/bedroom/sun_aafesxmciavqmkxw_Harris.mat');
K = 100;
%d = getImageFeatures(wordMap,K);
%label = predict(Mdl,d);
for i = 1:size(test_imagenames,2)
    load(sprintf('../data/%s',strrep(test_imagenames{1,i},'.jpg',imageExpend)));%!!!!!!!!
    d = getImageFeatures(wordMap,K);
    l = predict(Mdl,d);
    confusion(test_labels(i),l) = confusion(test_labels(i),l) + 1;
end
accuracy = 0;
for i = 1:8
    accuracy = accuracy + confusion(i,i);
end
accuracy = accuracy/sum(sum(confusion))