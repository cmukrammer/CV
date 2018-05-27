clear;
datadir     = '../data/campus';
tmpdir      = '../tmp';
imglist = dir(sprintf('%s/sun_axkqbyzidznishmg.jpg', datadir));
%[path, imgname, dummy] = fileparts(imglist(1).name);
img = imread(sprintf('%s/%s', datadir, imglist(1).name));
%imshow(img);
%responses = extractFilterResponses(img, createFilterBank());
%for i = 1:size(responses,3)
%    imshow(responses(:,:,i));
%end
alpha = 200;
%randomPoints = getRandomPoints(responses{1,1}, alpha);

%imshow(responses{1,1});
%hold on
%plot(randomPoints(:,2), randomPoints(:,1), 'r.');
%hold off

% for i = 1:size(responses,3)
%     fname = sprintf('%s/sun_aeziduzkrhfvkqvy_%d.png', tmpdir, i);
%     imwrite(responses(:,:,i), fname);
% end
% alpha = 500;
% k = 0.04;
% harrisPoints = getHarrisPoints(img, alpha, k);
% imshow(img);
% hold on
% plot(harrisPoints(:,2), harrisPoints(:,1), 'r.');
% hold off
%img = rgb2gray(img);
%corners = detectHarrisFeatures(img);
%imshow(img); hold on;
%plot(corners.selectStrongest(50));

% K = 100;
% imgPaths = load('../data/traintest.mat');
% method = 'random';
% dictionary = getDictionary(imgPaths.all_imagenames, alpha, K, method);
% method = 'harris';
% dictionary = getDictionary(imgPaths.all_imagenames, alpha, K, method);

load('dictionaryHarris.mat');
%load('dictionaryRandom.mat');
wordMap = getVisualWords(img, dictionary, createFilterBank());
%load('../data/rainforest/sun_aicbcveujljxurib_Random.mat');
%imshow(label2rgb(wordMap));
%batchToVisualWords(2);
%load('../data/bedroom/sun_aacyfyrluprisdrx_Harris.mat');
%h = getImageFeatures(wordMap,K);

