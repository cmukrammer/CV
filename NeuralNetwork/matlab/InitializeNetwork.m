function [W, b] = InitializeNetwork(layers)
% InitializeNetwork([INPUT, HIDDEN, OUTPUT]) initializes the weights and biases
% for a fully connected neural network with input data size INPUT, output data
% size OUTPUT, and HIDDEN number of hidden units.
% It should return the cell arrays 'W' and 'b' which contain the randomly
% initialized weights and biases for this neural network.

input = layers(1);
hiddenLayers = length(layers)-1;

W = cell(1, hiddenLayers);
b = cell(1, hiddenLayers);

for i=2:length(layers)
    W{i-1} = rand(layers(i-1),layers(i))/100;
    b{i-1} = rand(1,layers(i))/100;
end

end
