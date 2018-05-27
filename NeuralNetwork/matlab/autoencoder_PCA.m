% Your code here.
load('../data/nist36_train.mat', 'train_data', 'train_labels')
load('../data/nist36_test.mat', 'test_data', 'test_labels');

[U,S,V] = svd(train_data);
% U_64 = U(:,1:64);
% S_64 = S(1:64,1:64);
% V_64 = V(1:64,1:64);

% S_64 = S;
% S_64(65:10800,:) = 0;
% new_train = U*S_64*V';

I_64 = eye(1024);
I_64(65:1024,:) = 0;
proM = V*I_64*V';
new_train = train_data*proM;
new_test = test_data*proM;

total = 0;
for i=1:size(new_test,1)
    total = total + psnr(reshape(new_test(i,:),[32 32]),reshape(test_data(i,:),32,32));
end
total = total/size(new_test,1);

fprintf("%f\n",total);

% subplot(1,2,1)
% imshow(reshape(test_data(2,:),32,32))
% subplot(1,2,2)
% imshow(reshape(new_test(1,:),[32 32]))

% subplot(1,2,1)
% imshow(reshape(test_data(2,:),32,32))
% subplot(1,2,2)
% imshow(reshape(new_test(2,:),[32 32]))

% subplot(1,2,1)
% imshow(reshape(test_data(100,:),32,32))
% subplot(1,2,2)
% imshow(reshape(new_test(100,:),[32 32]))

% subplot(1,2,1)
% imshow(reshape(test_data(99,:),32,32))
% subplot(1,2,2)
% imshow(reshape(new_test(99,:),[32 32]))

% subplot(1,2,1)
% imshow(reshape(test_data(101,:),32,32))
% subplot(1,2,2)
% imshow(reshape(new_test(101,:),[32 32]))

% subplot(1,2,1)
% imshow(reshape(test_data(102,:),32,32))
% subplot(1,2,2)
% imshow(reshape(new_test(102,:),[32 32]))

% subplot(1,2,1)
% imshow(reshape(test_data(201,:),32,32))
% subplot(1,2,2)
% imshow(reshape(new_test(201,:),[32 32]))

% subplot(1,2,1)
% imshow(reshape(test_data(202,:),32,32))
% subplot(1,2,2)
% imshow(reshape(new_test(202,:),[32 32]))

% subplot(1,2,1)
% imshow(reshape(test_data(301,:),32,32))
% subplot(1,2,2)
% imshow(reshape(new_test(301,:),[32 32]))

% subplot(1,2,1)
% imshow(reshape(test_data(302,:),32,32))
% subplot(1,2,2)
% imshow(reshape(new_test(302,:),[32 32]))