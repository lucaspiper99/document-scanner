clc;
clear;
close all;

% arguments of pivproject2021
reference_path = "DATASETS\InitialDataset\templates\template2_fewArucos.png";
path_to_input_folder = "DATASETS\InitialDataset\FewArucos-Viewpoint1_images";
path_to_output_folder = "DATASETS\InitialDataset\output";
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
py.importlib.import_module('sift_features');
last2compare = 30;
images_processed = 0;
num_images = length(files)-2;
for i = 1:length(files) %reads every file in the input folder
    if files(i).isdir == 0
        
        %reads the input image
        [image,map] = imread(append(path_to_input_folder,'\',files(i).name));
        if size(image,3) == 1
            image = uint8(round(ind2rgb(image, map)*255));
        end
        
        py.sift_features.get_sift_pts(py.numpy.array(reference),...
        py.numpy.array(image));
        sift_pts = load('sift_pts.mat');
        ref_pts = squeeze(sift_pts.img1);
        img_pts = squeeze(sift_pts.img2);
        
        H = ransac_fcn(ref_pts, img_pts, 3000, 80);
        
        if images_processed > last2compare
            best_index = compare2(path_to_output_folder,...
                images_processed+1, last2compare);
        elseif images_processed == 0
            best_index = 0;
        else 
            best_index = compare2(path_to_output_folder,...
                images_processed+1, images_processed);
        end
        
        
        
        %gets homography matrix from matched features
%         if i == 3
%             H = ransac_fcn(ref_pts, img_pts, 3000, 80);
%         else
%             H = ransac_fcn(ref_pts, img_pts, 3000, 80);
%             py.importlib.import_module('sift_features');
%             py.sift_features.get_sift_pts(py.numpy.array(previous_image),...
%             py.numpy.array(image));
%             sift_pts = load('sift_pts.mat');
%             prev_pts = squeeze(sift_pts.img1);
%             img_pts = squeeze(sift_pts.img2);
%             H2 = H;
%             H1 = ransac_fcn(prev_pts, img_pts, 500, 1);
%             indirect_H = H2 * H1;
%             H = (direct_H + indirect_H)/2;
%         end
        
        %creates the output image
        [rgbIM] = frame_homography(H, ref_h, ref_w,...
            vectorMatrix, image);
        
        imshow(rgbIM)

        %saves the output image
        imwrite(rgbIM,append(path_to_output_folder,'\',files(i).name));
        
        previous_image = image;
        
        %displays the written file
        disp(files(i).name)
        images_processed = images_processed + 1;
    end
end