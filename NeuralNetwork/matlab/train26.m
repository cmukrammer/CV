num_epoch = 30;
classes = 26;
layers = [32*32, 400, classes];
learning_rate = 0.01;

load('../data/nist26_train.mat', 'train_data', 'train_labels')
load('../data/nist26_test.mat', 'test_data', 'test_labels')
load('../data/nist26_valid.mat', 'valid_data', 'valid_labels')

[W, b] = InitializeNetwork(layers);

% train_data = train_data(1:1500,:);
% train_labels = train_labels(1:1500,:);
% valid_data = valid_data(1:1500,:);
% valid_labels = valid_labels(1:1500,:);
[m,n] = size(train_data);
x1 = zeros(1,num_epoch);
for i=1:num_epoch
    x1(i) = i;
end
y1 = zeros(1,num_epoch);
y2 = zeros(1,num_epoch);
y3 = zeros(1,num_epoch);
y4 = zeros(1,num_epoch);
f1 = figure('Name','Acc');
f2 = figure('Name','Loss');
%plot(x1,y1,x1,y2);

confusion = zeros(classes,classes);

for j = 1:num_epoch
    
%     idx = randperm(m);
%     shuffle_train_data = train_data;
%     shuffle_train_labels = train_labels;
%     shuffle_train_data(idx,1) = train_data(:,1);
%     shuffle_train_labels(idx,1) = train_labels(:,1);
    
    [W, b] = Train(W, b, train_data, train_labels, learning_rate);

    [train_acc, train_loss] = ComputeAccuracyAndLoss(W, b, train_data, train_labels);
    [valid_acc, valid_loss] = ComputeAccuracyAndLoss(W, b, valid_data, valid_labels);
    
    y1(j) = train_acc;
    y2(j) = valid_acc;
    y3(j) = train_loss;
    y4(j) = valid_loss;
    figure(f1);
    plot(x1,y1,x1,y2);
    figure(f2);
    plot(x1,y3,x1,y4);
    %refreshdata
    pause(0.05)
    
    fprintf('Epoch %d - accuracy: %.5f, %.5f \t loss: %.5f, %.5f \n', j, train_acc, valid_acc, train_loss, valid_loss)
    fprintf('\n')
end

accuracy = 0;
[outputs] = Classify(W, b, test_data);
for i=1:size(test_data,1)
    x = find(test_labels(i,:)==1);
    y = find(max(outputs(i,:))==outputs(i,:));
    confusion(x,y) = confusion(x,y) + 1;
    if x == y
        accuracy = accuracy + 1;
    end
end
fprintf("Accuracy on test set: %f\n", accuracy/size(test_data,1));
save('nist26_model.mat', 'W', 'b')

[accuracy, loss] = ComputeAccuracyAndLoss(W, b, test_data, test_labels);
fprintf("Accuracy on test set: %f, Loss on test set: %f\n", accuracy, loss);
