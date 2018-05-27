function layers = define_autoencoder()

rate = 0.1;
constant = 0;
conv1 = conv2D(4,1,4,1,2);
conv2 = conv2D(4,4,8,1,2);
conv3 = conv2D(8,8,64,0,1);
% conv1 = convolution2dLayer([4,4],4,'Padding',1,'Stride',2,'WeightLearnRateFactor',2,'BiasLearnRateFactor',2);
% conv2 = convolution2dLayer([4,4],8,'Padding',1,'Stride',2,'WeightLearnRateFactor',2,'BiasLearnRateFactor',2);
% conv3 = convolution2dLayer([8,8],64,'Padding',0,'Stride',1,'WeightLearnRateFactor',2,'BiasLearnRateFactor',2);
transConv1 = transpConv2D(8,64,8,0,1);
transConv2 = transpConv2D(4,8,4,1,2);
transConv3 = transpConv2D(4,4,1,1,2);
conv1.Weights = randn([4 4 1 4])*rate;
conv1.Bias = randn([1 1 4])*rate + constant;
conv2.Weights = randn([4 4 4 8])*rate;
conv2.Bias = randn([1 1 8])*rate + constant;
conv3.Weights = randn([8 8 8 64])*rate;
conv3.Bias = randn([1 1 64])*rate + constant;
transConv1.Weights = randn([8 8 8 64])*rate;
transConv1.Bias = randn([1 1 8])*rate + constant;
transConv2.Weights = randn([4 4 4 8])*rate;
transConv2.Bias = randn([1 1 4])*rate + constant;
transConv3.Weights = randn([4 4 1 4])*rate;
transConv3.Bias = randn([1 1 1])*rate + constant;

layers = [
    imageInputLayer([32,32,1])
    % intermediate layers go between here ...
    % original one
    conv1
%     batchNormalizationLayer
%     reluLayer
    conv2
%     batchNormalizationLayer
%     reluLayer
    conv3
%     batchNormalizationLayer
%     reluLayer
%     fullyConnectedLayer(64)
%     batchNormalizationLayer
%     reluLayer
    transConv1
%     batchNormalizationLayer
%     reluLayer
    transConv2
%     batchNormalizationLayer
%     reluLayer
    transConv3
    % ... and here
    
    regressionLayer
];
% 
% layers = [ 
%     imageInputLayer([32,32,1])
%     % intermediate layers go between here ...
%     conv2D(4,1,8,1,2)
%     conv2D(4,8,16,1,2)
%     conv2D(8,16,64,0,1)
%     transpConv2D(8,64,16,0,1)
%     transpConv2D(4,16,8,1,2)
%     transpConv2D(4,8,1,1,2)
%     % ... and here
%     regressionLayer
% ];
