function [  ] = CreateWinterGif( picturePath )
% Creates a winter gif
FileName = 'test.gif';
scaleFactor = .25;
winterPic = double(imread(picturePath));
winterPic = imresize(winterPic, scaleFactor);
[rows, cols, ~] = size(winterPic);
locationArray = InitialSnowLocs(rows, cols);
fast_cols = ChooseFastCols(cols);
[locationArray, winterSlide] = GetWinterSlide(winterPic, locationArray, rows, cols, fast_cols);
[A, map] = rgb2ind(winterSlide,256);
imwrite(A, map, FileName, 'gif', 'LoopCount', Inf, 'DelayTime', .05);
for k = 2:1:rows
    % pause;
    [locationArray, winterSlide] = GetWinterSlide(winterPic, locationArray, rows, cols, fast_cols);
    [A, map] = rgb2ind(winterSlide,256);
    imwrite(A, map, FileName, 'gif', 'WriteMode', 'append', 'DelayTime', .05);
    k
end
end

function [locationArray, winterSlide] = GetWinterSlide(image, locationArray, rows, cols, fast_cols)
filter = GetImageFilter(locationArray, rows, cols);
winterSlide = image/255. + filter;
winterSlide(find(winterSlide>1))=1;
%imshow(winterSlide);
locationArray = IncrementFilter(locationArray, rows, fast_cols);
end

function [locationArray] = IncrementFilter(locationArray, rows, fast_cols)
locationArray = vertcat(locationArray(rows:rows, :),locationArray(1:rows-1, :));

for col = fast_cols
    locationArray(:,col:col) = vertcat(locationArray(rows:rows,col:col),locationArray(1:rows-1,col:col));
end
end

function [locationArray] = InitialSnowLocs(rows, cols)
locationArray = rand(rows, cols)>.995;
end

function [filter] = GetImageFilter(locationArray, rows, cols)
diam = 3;
rad = floor(diam/2);
G = fspecial('gaussian', [diam diam], .75)*3;
G = repmat(G, 1,1, 3);
filter = zeros(rows, cols, 3);
for row = rad + 1:1:rows-rad
    for col = rad + 1:1:cols-rad
        if locationArray(row,col) == 1
            filter(row-rad:row+rad,col-rad:col+rad,:) = G;
        end
    end
end
end

function [fast_cols] = ChooseFastCols(cols)
    fast_cols = floor(rand(1, floor(cols/10))*(cols-1))+ 1
end
