% This function resizes all images to the same size, splits them into a
% testing and training set, and then puts them in .mat files that specify
% the images.

function[] = PrepareImages()

image_dir = 'C:\Users\Lizzy\Documents\Machine Learning\FinalProject\Data';

categories = dir(image_dir);
train_idx = 1;
test_idx = 1;

train_images = {};
train_scene_labels = {};
train_category_labels = {};

test_images = {};
test_scene_labels = {};
test_category_labels = {};

for classes = 1:length(categories)
    if IsLegitDir(categories(classes))
        category_dir = strcat(image_dir,'\',categories(classes).name);
        category_scenes = dir(category_dir);
        for scene = 1:length(category_scenes)
            if IsLegitDir(category_scenes(scene))
                category_dir_scene = strcat(category_dir,'\', category_scenes(scene).name);
                images_in_dir = dir(category_dir_scene);
                train_images_idx = randperm(length(images_in_dir)-2, 30) + 2;
                test_images_idx = setdiff(1:length(images_in_dir),train_images_idx);
                train_im_in_dir = images_in_dir(train_images_idx);
                test_im_in_dir = images_in_dir(test_images_idx);
                for i = 1:length(train_im_in_dir)
                    if IsLegitDirListing(train_im_in_dir(i))
                        im_path = strcat(category_dir_scene, '\', train_im_in_dir(i).name);
                        im = imread(im_path);
                        if size(im, 3) == 3
                            im = rgb2gray(im);
                        end
                        im = imresize(im, [256 256]);
                        imshow(im);
                        train_images{train_idx} = im;
                        train_scene_labels{train_idx} = category_scenes(scene).name;
                        train_category_labels{train_idx} = categories(classes).name;
                        train_idx = train_idx + 1;
                    end
                end
                for i = 1:1:length(test_im_in_dir)
                    if IsLegitDirListing(test_im_in_dir(i))
                        im_path = strcat(category_dir_scene, '\', test_im_in_dir(i).name);
                        im = imread(im_path);
                        if size(im, 3) == 3
                            im = rgb2gray(im);
                        end
                        im = imresize(im, [256 256]);
                        imshow(im);
                        test_images{test_idx} = im;
                        test_scene_labels{test_idx} = category_scenes(scene).name;
                        test_category_labels{test_idx} = categories(classes).name;
                        test_idx = test_idx + 1;
                    end
                end
            end
        end
    end
end

save('image_info_seasons.mat', 'test_images', 'test_scene_labels', 'test_category_labels', 'train_images', 'train_scene_labels', 'train_category_labels','-v7.3');
end


function[is_legit] = IsLegitDir(dir_listing)

is_legit = IsLegitDirListing(dir_listing) && dir_listing.isdir;
end

function[is_legit] = IsLegitDirListing(dir_listing)
is_legit = ~(strcmp(dir_listing.name,'.')||...
    strcmp(dir_listing.name,'..'));
end