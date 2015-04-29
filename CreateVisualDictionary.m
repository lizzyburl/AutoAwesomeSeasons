function [visual_dict] = CreateVisualDictionary(train_images)
% 1) Get a vocabulary built of off sift descriptors
%    a) Load images from the training set
%    b) Get sift features with vl_dsift
%    c) Cluster sift features with k means, where k is the size of your
%    vocabulary (200 - 400)

features = [];
for i = 1:length(train_images)
    [coord, desc] = vl_dsift(single(train_images{i}), 'step', 5, 'size', 16);
    features = [features, desc];
end
[r , c] =size(features)

rand_sample = randsample(c, c/2);
% 400 was found to be the best vocab size in the paper, but for speed we
% will do 200

[visual_dict] = vl_kmeans(double(features(:,rand_sample)), 200);

save('visual_dict.mat', 'visual_dict')
end