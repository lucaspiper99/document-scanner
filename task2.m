clc;
clear;
close all;

% arguments of pivproject2021
reference_path = "DATASETS\InitialDataset\templates\template2_fewArucos.png";

path_to_input_folder = "DATASETS\InitialDataset\FewArucos-Viewpoint2_images";
path_to_output_folder = "DATASETS\InitialDataset\output2";
arg2 = 0;

[reference,map] = imread(reference_path);
% reference = padarray(reference,[3 3]);
if size(reference,3) == 1
    reference = uint8(round(ind2rgb(reference, map)*255));
end

[refCornersCoords, template_ids]  = getCorners(reference);
ref_h = size(reference,1);
ref_w = size(reference,2);
vectorMatrix = [repelem(1:ref_w,ref_h); repmat(1:ref_h,[1,ref_w]);...
            ones(1,ref_h*ref_w)];     
        
files = dir(fullfile(path_to_input_folder));
files(1:2) = [];
py.importlib.import_module('sift_features');
imgs2compare = 10;
images_processed = 0;
num_images = length(files);
homographys = zeros(3, 3, num_images);
rgb_images = zeros(ref_h, ref_w, 3, imgs2compare);

for i = 1:num_images %reads every file in the input folder
        
        %reads the input image
        [image,map] = imread(append(path_to_input_folder,'\',files(i).name));
        if size(image,3) == 1
            image = uint8(round(ind2rgb(image, map)*255));
        end
        
        if images_processed > imgs2compare
            
            best_i = compare2(rgb_images);
            [best_image,map] = imread(append(path_to_input_folder,'\', best_name));
            if size(image,3) == 1
                best_image = uint8(round(ind2rgb(best_image, map)*255));
            end
            
            py.sift_features.get_sift_pts(py.numpy.array(best_image),...
            py.numpy.array(image));
            sift_pts = load('sift_pts.mat');
            best_pts = squeeze(sift_pts.img1);
            img_pts = squeeze(sift_pts.img2);
            H1 = ransac_fcn(best_pts, img_pts, 2000, 1);
            H2 = homographys(:,:,best_i);
            homographys(:,:,images_processed+1) = H2*H1;
            
            [rgbIM] = frame_homography(homographys(:,:,images_processed+1),...
                ref_h, ref_w, vectorMatrix, image);

            imwrite(rgbIM,append(path_to_output_folder,'\',files(i).name));
            rgb_images(:,:,:,1) = [];
            rgb_images(:,:,:,imgs2compare) = rgbIM;
        else
            if images_processed == 0
                for j=1:imgs2compare
                    [image,map] = imread(append(path_to_input_folder,'\',files(j).name));
                    if size(image,3) == 1
                        image = uint8(round(ind2rgb(image, map)*255));
                    end
                    py.sift_features.get_sift_pts(py.numpy.array(reference),...
                    py.numpy.array(image));
                    sift_pts = load('sift_pts.mat');
                    ref_pts = squeeze(sift_pts.img1);
                    img_pts = squeeze(sift_pts.img2);
                    homographys(:,:,j) = ransac_fcn(ref_pts, img_pts, 3000, 80);
                    rgb_images(:,:,:,j) = frame_homography(homographys(:,:,images_processed+1),...
                        ref_h, ref_w, vectorMatrix, image);
                end
                best_first_i = compare2(rgb_images);
                imshow(rgb_images(:,:,:,best_first_i))
                best_first_name = files(best_first_i).name;
                [best_image,map] = imread(append(path_to_input_folder,'\', best_first_name));
                if size(image,3) == 1
                    best_image = uint8(round(ind2rgb(best_image, map)*255));
                end
                H2 = homographys(:,:,best_first_i);
            end
            py.sift_features.get_sift_pts(py.numpy.array(best_image),...
            py.numpy.array(image));
            sift_pts = load('sift_pts.mat');
            best_pts = squeeze(sift_pts.img1);
            img_pts = squeeze(sift_pts.img2);
            H1 = ransac_fcn(best_pts, img_pts, 2000, 1);
            homographys(:,:,images_processed+1) = H2*H1;
            
            [rgbIM] = frame_homography(homographys(:,:,images_processed+1),...
            ref_h, ref_w, vectorMatrix, image);
        end
        
        imwrite(rgbIM,append(path_to_output_folder,'\',files(i).name));
        %displays the written file
        disp(files(i).name)
        images_processed = images_processed + 1
        
end