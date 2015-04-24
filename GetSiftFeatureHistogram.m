function [histogram_matrix] = GetSiftFeatureHistogram(images, visual_dict)
[rows, vocab_size] =size(visual_dict);
numlevels = 3;
total_len = 0;
for i = 0:numlevels-1
    total_len = total_len + (4^i)*vocab_size;
end
histogram_matrix = zeros(length(images), total_len);
for i = 1:length(images)
    im = images{i};
    histogram_matrix(i, :) = GetSiftHistogram(im, visual_dict, vocab_size, total_len, numlevels);
end

end

function [histogram_vector] = GetSiftHistogram(image, visual_dict, vocab_size, total_len, numlevels)
    [coord, features] = vl_dsift(single(image),'step',8, 'size', 16);
    distances = vl_alldist2(double(features), visual_dict);
    [~,vocab_match] = min(distances, [], 2);
    histogram_vector = [];
    total_len = 0;
    histogram_vector = zeros(1, total_len);
    start_col = 1;
    end_col = vocab_size;
    for i = 0:1:numlevels-1
        vec = GetHistogramForLayer(coord, vocab_match, vocab_size, i);
        vec = vec / (2^(numlevels - i));
        histogram_vector(start_col:end_col) = vec;
        start_col = end_col+1;
        end_col = end_col + (4^(i+1)*200);
    end

    
end

function[histogram_vector] = GetHistogramForLayer(coord, vocab_match, vocab_size, level)
level_size = (4^level)*vocab_size;

histrogram_vector = ones(1, level_size)*-3000; % 200 is the vocab size
if level == 0
    for j = 1:1:vocab_size
        histrogram_vector(j) = sum(vocab_match==j);
    end
elseif level ==1
    section_width = 256/2;
    v1 = vocab_match((coord(1,:)<section_width & coord(2,:)<section_width));
    v2 = vocab_match((coord(1,:)<section_width & coord(2,:)>=section_width));
    v3 = vocab_match((coord(1,:)>=section_width & coord(2,:)<section_width));
    v4 = vocab_match((coord(1,:)>=section_width & coord(2,:)>=section_width));
    
    for j = 1:1:vocab_size
        histrogram_vector(j) = sum(v1==j);
        histrogram_vector(j+vocab_size) = sum(v2==j);
        histrogram_vector(j+vocab_size*2) = sum(v3==j);
        histrogram_vector(j+vocab_size*3) = sum(v4==j);    
    end
elseif level == 2
    
    section_width = 256/4;
    v1 = vocab_match((coord(1,:)<section_width & coord(2,:)<section_width));
    v2 = vocab_match((coord(1,:)>=section_width & coord(1,:)<section_width*2 & coord(2,:)<section_width));
    v3 = vocab_match((coord(1,:)>=section_width*2 & coord(1,:)<section_width*3 & coord(2,:)<section_width));
    v4 = vocab_match((coord(1,:)>=section_width*3 & coord(2,:)>=section_width));
    
    v5 = vocab_match((coord(1,:)<section_width & coord(2,:)>=section_width & coord(2,:)<section_width*2));
    v6 = vocab_match((coord(1,:)>=section_width & coord(1,:)<section_width*2 & coord(2,:)>=section_width & coord(2,:)<section_width*2));
    v7 = vocab_match((coord(1,:)>=section_width*2 & coord(1,:)<section_width*3 & coord(2,:)>=section_width & coord(2,:)<section_width*2));
    v8 = vocab_match((coord(1,:)>=section_width*3 & coord(2,:)>=section_width & coord(2,:)<section_width*2));
    
    v9 = vocab_match((coord(1,:)<section_width & coord(2,:)>=section_width*2 & coord(2,:)<section_width*3));
    v10 = vocab_match((coord(1,:)>=section_width & coord(1,:)<section_width*2 & coord(2,:)>=section_width*2 & coord(2,:)<section_width*3));
    v11 = vocab_match((coord(1,:)>=section_width*2 & coord(1,:)<section_width*3 & coord(2,:)>=section_width*2 & coord(2,:)<section_width*3));
    v12 = vocab_match((coord(1,:)>=section_width*3 & coord(2,:)>=section_width*2 & coord(2,:)<section_width*3));
    
    v13 = vocab_match((coord(1,:)<section_width & coord(2,:)>=section_width*3));
    v14 = vocab_match((coord(1,:)>=section_width & coord(1,:)<section_width*2 & coord(2,:)>=section_width*3));
    v15 = vocab_match((coord(1,:)>=section_width*2 & coord(1,:)<section_width*3 & coord(2,:)>=section_width*3));
    v16 = vocab_match((coord(1,:)>=section_width*3 & coord(2,:)>=section_width*3));
    
    for j = 1:1:vocab_size
        histrogram_vector(j) = sum(v1==j);
        histrogram_vector(j+vocab_size) = sum(v2==j);
        histrogram_vector(j+vocab_size*2) = sum(v3==j);
        histrogram_vector(j+vocab_size*3) = sum(v4==j);   
        histrogram_vector(j+vocab_size*4) = sum(v5==j);
        histrogram_vector(j+vocab_size*5) = sum(v6==j);
        histrogram_vector(j+vocab_size*6) = sum(v7==j);
        histrogram_vector(j+vocab_size*7) = sum(v8==j); 
        histrogram_vector(j+vocab_size*8) = sum(v9==j);
        histrogram_vector(j+vocab_size*9) = sum(v10==j);
        histrogram_vector(j+vocab_size*10) = sum(v11==j);
        histrogram_vector(j+vocab_size*11) = sum(v12==j);
        histrogram_vector(j+vocab_size*12) = sum(v13==j);
        histrogram_vector(j+vocab_size*13) = sum(v14==j);
        histrogram_vector(j+vocab_size*14) = sum(v15==j);
        histrogram_vector(j+vocab_size*15) = sum(v16==j);
    end
elseif level == 3
else
    fprintf('TOO MANY LEVELS');
end

histogram_vector = histrogram_vector/sum(histrogram_vector);
end
