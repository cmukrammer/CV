function [accuracy, loss] = ComputeAccuracyAndLoss(W, b, data, labels)
% [accuracy, loss] = ComputeAccuracyAndLoss(W, b, X, Y) computes the networks
% classification accuracy and cross entropy loss with respect to the data samples
% and ground truth labels provided in 'data' and labels'. The function should return
% the overall accuracy and the average cross-entropy loss.

accuracy = 0;
ce = 0;
[out] = Classify(W, b, data);
for i = 1:size(data,1)
    %[out, act_h, act_a] = Forward(W, b, data(i,:));
    if find(out(i,:)==max(out(i,:))) == find(labels(i,:)==max(labels(i,:)))
        accuracy = accuracy + 1;
    end
    ce = ce - sum(labels(i,:)'.*log(out(i,:))');
end

accuracy = accuracy/size(data,1);
loss = ce/size(data,1);

end
