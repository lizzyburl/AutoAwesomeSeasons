function[] = SceneClassification()
% Make sure vl_version is loaded


try
    vl_version;
catch
    % This only needs to happen each time Matlab is opened
    run('C:\Users\Lizzy\Documents\MATLAB\vlfeat-0.9.20\toolbox\vl_setup')
end
addpath('windows');

% STEPS
load image_info.mat
% 1) Get a vocabulary built of off sift descriptors
%    a) Load images from the training set
%    b) Get sift features with vl_dsift
%    c) Cluster sift features with k means, where k is the size of your
%    vocabulary (200 - 400)
if ~exist('visual_dict.mat')
    visual_dict = CreateVisualDictionary(train_images);
else
    load visual_dict.mat
end

% 2) Get sift features
%    a) For each image, call vl_dsift aburtgain
%    b) For each feature, assign it to a cluster in the vocabulary
%    c) Build a histogram of how many times that was used
%    d) Normalize the histogram
if ~exist('train_features.mat')
    train_features = GetSiftFeatureHistogram(train_images, visual_dict);
    fprintf('Done with the training features\n');
    test_features = GetSiftFeatureHistogram(test_images, visual_dict);
    fprintf('Done with the test features\n');
    save('train_features.mat', 'train_features', '-v7.3');
    save('test_features.mat', 'test_features', '-v7.3');
else
    load train_features.mat;
    load test_features.mat;
end
GetLabels(train_category_labels)
model = train(GetLabels(train_scene_labels), sparse(double(train_features)));
[p_lab, acc, p_ests] = predict(GetLabels(test_scene_labels), sparse(double(test_features)), model);
acc
% 3) Split the image in 4 and repeat step 2 again for each segment. Do this
%    for 2-3 levels
% 4) Classify!
%    a) Concatenate all of the histograms for an image into a single vector
%    b) Use a linear svm to train and test (you should be making these
%       histograms for both the training and the test set.

end


function[labels] = GetLabels(cell_array_of_labels)

labels = zeros(length(cell_array_of_labels),1);
for i = 1:1:length(labels)
    if strcmp(cell_array_of_labels{i}, 'beach')
        labels(i) = -11;
    else
        labels(i) = 1;
    end
end
labels = double(labels);
sum(labels==1)
sum(labels==-1)
end