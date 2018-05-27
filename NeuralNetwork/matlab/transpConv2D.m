function layer = transpConv2D(filterSize,inN,outN,cropSize,strideSize)
% filterSize: size of filter (scalar, assumed square)
% inN: number of channels for the input
% outN: number of filters for the output
% cropSize: output cropping size (scalar, assume same for x and y) (reverse of padding)
% strideSize: stride size (scalar, assume same for x and y)

stddev = 0.01;
layer = transposedConv2dLayer([filterSize,filterSize],outN,'Stride',strideSize,'Cropping',cropSize);
layer.Weights = stddev * randn([filterSize,filterSize,outN,inN]);
layer.Bias = stddev * randn([1,1,outN]);
