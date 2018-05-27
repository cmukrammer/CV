% classes = 26;
% layers = [32*32, 400, classes];
% [W, b] = InitializeNetwork(layers);
% [out, act_h, act_a] = Forward(W,b,ones(32*32,1));

% load('nist26_model.mat', 'W', 'b');
% a = W{1};
% a = mat2gray(a);
% figure;
% montage(a);

%img = imread('../images/01_list.jpg');
%img = imread('../images/02_letters.jpg');
img = imread('../images/03_haiku.jpg');
[lines, bw] = findLetters(img);