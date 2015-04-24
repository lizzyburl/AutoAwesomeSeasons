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
load image_info_seasons.mat
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
if ~exist('train_features_seasons_final.mat')
    train_features = GetSiftFeatureHistogram(train_images, visual_dict);
    fprintf('Done with the training features\n');
    save('train_features_seasons_final.mat', 'train_features', '-v7.3');

    test_features = GetSiftFeatureHistogram(test_images, visual_dict);
    fprintf('Done with the test features\n');
    save('test_features_seasons_final.mat', 'test_features', '-v7.3');
else
    load train_features_seasons_final.mat;
    load test_features_seasons_final.mat;
end
% 3) Split the image in 4 and repeat step 2 again for each segment. Do this
%    for 2-3 levels

% 4) Classify!
%    a) Concatenate all of the histograms for an image into a single vector
%    b) Use a linear svm to train and test (you should be making these
%       histograms for both the training and the test set.

train_features = train_features(:,1:end);
test_features = test_features(:,1:end);

% Add bias
[tr_rows,~] = size(train_features);
[ts_rows, ~] = size(test_features);


mapObj = containers.Map('KeyType', 'char', 'ValueType', 'int32');
[train_labels, mapObj] = GetLabels(train_category_labels, mapObj);
[test_labels, ~] = GetLabels(test_category_labels, mapObj);
model = train(train_labels, sparse(double(train_features)));
[p_lab, acc, p_ests] = predict(test_labels, sparse(double(test_features)), model);
acc



num_categories = mapObj.Count;
categories = 1:mapObj.Count;

% The confusion matrix references James Hays's code. (See Brown reference)
confusion_matrix = zeros(num_categories, num_categories);
for i = 1:length(p_lab)
    row = find(test_labels(i) == categories);
    col = find(p_lab(i) == categories);
    confusion_matrix(row, col) = confusion_matrix(row, col) + 1;
end

for i = 1:length(categories);
    confusion_matrix(:,i) = confusion_matrix(:,i) / double(sum(test_labels==categories(i)));
end
accuracy = mean(diag(confusion_matrix));
fprintf(     'Accuracy (mean of diagonal of confusion matrix) is %.3f\n', accuracy)

fig_handle = figure; 
imagesc(confusion_matrix, [0 1]); 
set(fig_handle, 'Color', [.988, .988, .988])
axis_handle = get(fig_handle, 'CurrentAxes');
set(axis_handle, 'XTick', 1:15)
set(axis_handle, 'XTickLabel', ShortenCat(mapObj.keys))
set(axis_handle, 'YTick', 1:15)
set(axis_handle, 'YTickLabel', mapObj.keys)

visualization_image = frame2im(getframe(fig_handle));
% getframe() is unreliable. Depending on the rendering settings, it will
% grab foreground windows instead of the figure in question. It could also
% return a partial image.
imwrite(visualization_image, 'confusion_matrix.png')
end

function[cat_short] = ShortenCat(cell_array)

cat_short = {};
for i = 1:length(cell_array)
    temp = cell_array{i};
    cat_short{i} = temp(1:3);
end
end

function[labels, mapObj] = GetLabels(cell_array_of_labels, mapObj)

class_index = 1;
labels = zeros(length(cell_array_of_labels),1);
for i = 1:1:length(labels)
    if (isKey(mapObj, cell_array_of_labels{i}))
        labels(i) = mapObj(cell_array_of_labels{i});
    else
        mapObj(cell_array_of_labels{i}) = class_index;
        class_index = class_index + 1;
        labels(i) = mapObj(cell_array_of_labels{i});
    end
end
labels = double(labels);

end