function [histogram_matrix] = GetSiftFeatureHistogram(images, visual_dict)
[rows, cols] =size(visual_dict);
histogram_matrix = zeros(length(images), cols);
for i = 1:length(images)
    im = images{i};
    histogram_matrix(i, :) = GetSiftHistogram(im, visual_dict, cols);
end

end

function [histrogram_vector] = GetSiftHistogram(image, visual_dict, vocab_size)
    [coord, features] = vl_dsift(single(image),'step',8, 'size', 16);
    distances = vl_alldist2(double(features), visual_dict);
    [~,vocab_match] = min(distances, [], 2);
    histrogram_vector = zeros(1, vocab_size); % 200 is the vocab size
    for j = 1:1:vocab_size
        histrogram_vector(j) = sum(vocab_match==j);
    end
    histrogram_vector = histrogram_vector/sum(histrogram_vector);
end
