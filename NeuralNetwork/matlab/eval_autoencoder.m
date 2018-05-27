% TODO: load test dataset
load('../data/nist36_test.mat', 'test_data', 'test_labels');
% TODO: reshape and adjust the dimensions to be in the order of [height,width,1,sample_index]
layers = define_autoencoder();

options = trainingOptions('sgdm',...
                          'InitialLearnRate',1e-3,...
                          'LearnRateSchedule','piecewise',...
                          'LearnRateDropFactor',0.5,...
                          'LearnRateDropPeriod',2,...
                          'MaxEpochs',3,...
                          'MiniBatchSize',3,...
                          'Shuffle','every-epoch',...
                          'Plot','training-progress',...
                          'VerboseFrequency',20);
X = zeros(32,32,1,size(test_data,1));
for i=1:size(test_data,1)
    X(:,:,1,i) = reshape(test_data(i,:),32,32);
end
net = trainNetwork(X,X,layers,options);
% TODO: run predict()
test_recon = predict(net,X);

total = 0;
for i=1:size(test_recon,4)
    total = total + psnr(double(test_recon(:,:,1,i)),reshape(test_data(i,:),32,32));
end
total = total/size(test_recon,4);

fprintf("%f\n",total);

% subplot(1,2,1)
% imshow(reshape(test_data(2,:),32,32))
% subplot(1,2,2)
% imshow(imresize(test_recon(:,:,1,2),[32 32]))

%psnr();

