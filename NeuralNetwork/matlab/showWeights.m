% load('nist26_model.mat');

% classes = 26;
% layers = [32*32, 400, classes];
% [W, b] = InitializeNetwork(layers);

X = W{1};
Y = zeros(32,32,1,size(W{1},2));
for i=1:size(Y,4)
    Y(:,:,1,i) = mat2gray(reshape(X(:,i),[32 32]));
end
%montage(mat2gray(reshape(W{1},[32,32,1,800])));
montage(Y);