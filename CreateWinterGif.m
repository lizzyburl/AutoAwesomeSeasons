function [  ] = CreateWinterGif( picturePath )
% Creates a winter gif
FileName = 'test.gif';
scaleFactor = .25
winterPic = double(imread(picturePath));
winterPic = imresize(winterPic, scaleFactor);
[rows, cols, ~] = size(winterPic);
filter = InitialShowFilter(rows, cols);
[filter, winterSlide] = GetWinterSlide(winterPic, filter, rows, cols);
[A, map] = rgb2ind(winterSlide,256);
imwrite(A, map, FileName, 'gif', 'LoopCount', Inf, 'DelayTime', .05);
for k = 2:1:rows
    % pause;
    [filter, winterSlide] = GetWinterSlide(winterPic, filter, rows, cols);
    [A, map] = rgb2ind(winterSlide,256);
    imwrite(A, map, FileName, 'gif', 'WriteMode', 'append', 'DelayTime', .05);
    k
end
end

function [filter, winterSlide] = GetWinterSlide(image, filter, rows, cols)
winterSlide = image/255. + filter;
winterSlide(find(winterSlide>1))=1;
%imshow(winterSlide);
filter = IncrementFilter(filter, rows, cols)
end

function [filter] = IncrementFilter(filter, rows, cols)
filter = vertcat(filter(rows:rows, :, :),filter(1:rows-1, :, :));

end

function [filter] = InitialShowFilter(rows, cols)
locationArray = rand(rows, cols)>.995;
filter = getImageFilter(locationArray, rows, cols);
end

function [filter] = getImageFilter(locationArray, rows, cols)
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
