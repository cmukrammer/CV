 function [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a)
% [grad_W, grad_b] = Backward(W, b, X, Y, act_h, act_a) computes the gradient
% updates to the deep network parameters and returns them in cell arrays
% 'grad_W' and 'grad_b'. This function takes as input:
%   - 'W' and 'b' the network parameters
%   - 'X' and 'Y' the single input data sample and ground truth output vector,
%     of sizes Nx1 and Cx1 respectively
%   - 'act_h' and 'act_a' the network layer pre and post activations when forward
%     forward propogating the input smaple 'X'

hiddenLayerNum = size(W,2);
t = act_h{hiddenLayerNum} - Y;
grad_W = cell(1,hiddenLayerNum);
grad_b = cell(1,hiddenLayerNum);

grad_W{hiddenLayerNum} = act_h{hiddenLayerNum-1}'*t;
grad_b{hiddenLayerNum} = t;

for i = hiddenLayerNum-1:-1:2
    t = act_h{i}.*(1-act_h{i}).*(t*W{i+1}');
    grad_W{i} = act_h{i-1}'*t;
    grad_b{i} = t;
end

t = act_h{1}.*(1-act_h{1}).*(t*W{2}');
grad_W{1} = X'*t;
grad_b{1} = t;

end
