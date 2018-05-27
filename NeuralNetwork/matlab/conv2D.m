function layer = conv2D(filterSize,inN,outN,padSize,strideSize)
% filterSize: size of filter (scalar, assumed square)
% inN: number of channels for the input
% outN: number of filters for the output
% padSize: padding size (scalar, assume same for x and y)
% strideSize: stride size (scalar, assume same for x and y)

stddev = 0.01;
layer = convolution2dLayer([filterSize,filterSize],outN,'Padding',padSize,'Stride',strideSize);
layer.Weights = stddev * randn([filterSize,filterSize,inN,outN]);
layer.Bias = stddev * randn([1,1,outN]);
