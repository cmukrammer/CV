% Your code here.
delta = 1e-4;

sample = 100;

%init network
layers = [32*32, 400, 26];
learning_rate = 0.01;
load('../data/nist26_train.mat', 'train_data', 'train_labels')
[W, b] = InitializeNetwork(layers);
[m,n] = size(train_data);
errorW = 0;
errorB = 0;

for i=1:sample
    layer = randi([1,2]);
    if layer == 1
        x = randi([1,1024]);
        y = randi([1,400]);
    else
        x = randi([1,400]);
        y = randi([1,26]);
    end
    %w
    wPre = W;
    wPre{layer}(x,y) = wPre{layer}(x,y) + delta;
    [~, train_loss_pre] = ComputeAccuracyAndLoss(wPre, b, train_data(1,:), train_labels(1,:));
    wAfter = W;
    wAfter{layer}(x,y) = wAfter{layer}(x,y) - delta;
    [~, train_loss_after] = ComputeAccuracyAndLoss(wAfter, b, train_data(1,:), train_labels(1,:));
    derivative = (train_loss_pre-train_loss_after)/2*delta;
    
    [out, act_h, act_a] = Forward(W, b, train_data(1,:));
    [grad_W, grad_b] = Backward(W, b, train_data(1,:), train_labels(1,:), act_h, act_a);
    
    %fprintf("%d,%d,%d\n",grad_W{layer}(x,y)*delta,derivative,grad_W{layer}(x,y)*delta-derivative);
    errorW = errorW + sqrt((grad_W{layer}(x,y)*delta-derivative)^2);
    %b
    layer = randi([1,2]);
    if layer == 1
        y = randi([1,400]);
    else
        y = randi([1,26]);
    end
    bPre = b;
    bPre{layer}(1,y) = bPre{layer}(1,y) + delta;
    [~, train_loss_pre] = ComputeAccuracyAndLoss(W, bPre, train_data(1,:), train_labels(1,:));
    bAfter = b;
    bAfter{layer}(1,y) = bAfter{layer}(1,y) - delta;
    [~, train_loss_after] = ComputeAccuracyAndLoss(W, bAfter, train_data(1,:), train_labels(1,:));
    derivative = (train_loss_pre-train_loss_after)/2*delta;
    
    [out, act_h, act_a] = Forward(W, b, train_data(1,:));
    [grad_W, grad_b] = Backward(W, b, train_data(1,:), train_labels(1,:), act_h, act_a);
    
    %fprintf("%d,%d,%d\n",grad_W{layer}(x,y)*delta,derivative,grad_W{layer}(x,y)*delta-derivative);
    errorB = errorB + sqrt((grad_b{layer}(1,y)*delta-derivative)^2);
end

errorW/sample
errorB/sample