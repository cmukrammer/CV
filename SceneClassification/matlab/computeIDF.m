%method = 'Harris';
method = 'Random';
if strcmp('Harris',method)
    visionFileName = 'visionHarris.mat';
    imageExpend = '_Harris.mat';
    idfName = 'idfHarris.mat';
else
    visionFileName = 'visionRandom.mat';
    imageExpend = '_Random.mat';
    idfName = 'idfRandom.mat';
end
K = 100; % fix!!!!!!!!!!!!!!!!!!!!!!
load('traintest.mat');
IDF = zeros(1,K);
T = size(train_imagenames,2);
for i = 1:T
    load(sprintf('../data/%s',strrep(train_imagenames{1,i},'.jpg',imageExpend)));
    h = getImageFeatures(wordMap,K);
    for j = 1:K
        if h(j) > 0
            IDF(j) = IDF(j) + 1;
        end
    end
end

IDF = log((ones(1,K)*T)./IDF);
save(idfName,'IDF');