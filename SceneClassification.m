function[] = SceneClassification()
% Make sure vl_version is loaded


try
    % This only needs to happen each time Matlab is opened
    vl_version
catch
    run('C:\Users\Lizzy\Documents\MATLAB\vlfeat-0.9.20\toolbox\vl_setup')
end

% STEPS

% 1) Get a vocabulary built of off sift descriptors
%    a) Load images from the training set
%    b) Get sift features with vl_dsift
%    c) Cluster sift features with k means, where k is the size of your
%    vocabulary (200 - 400)
% 2) Get sift features
%    a) For each image, call vl_dsift again
%    b) For each feature, assign it to a cluster in the vocabulary
%    c) Build a histogram of how many times that was used
%    d) Normalize the histogram
% 3) Split the image in 4 and repeat step 2 again for each segment. Do this
%    for 2-3 levels
% 4) Classify!
%    a) Concatenate all of the histograms for an image into a single vector
%    b) Use a linear svm to train and test (you should be making these
%       histograms for both the training and the test set.

end