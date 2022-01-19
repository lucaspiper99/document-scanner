clc;
clear;
close all;

reference_path = "DATASETS\InitialDataset\templates\template2_fewArucos.png";
path_to_input_folder = "input";
path_to_output_folder = "output";
arg2 = 0;

[reference,map] = imread(reference_path);
if size(reference,3) == 1
    reference = uint8(round(ind2rgb(reference, map)*255));
end

[refCornersCoords, template_ids]  = getCorners(reference);
ref_h = size(reference,1);
ref_w = size(reference,2);
vectorMatrix = [repelem(1:ref_w,ref_h); repmat(1:ref_h,[1,ref_w]);...
            ones(1,ref_h*ref_w)];

files = dir(fullfile(path_to_input_folder));

for i = 1:length(files)                         %reads every file in the input folder
    if files(i).isdir == 0

        %reads the input image
        [image,map] = imread(append(path_to_input_folder,'\',files(i).name));
        if size(image,3) == 1
            image = uint8(round(ind2rgb(image, map)*255));
        end
        
        %------------------------------------------------------------------
        % SEM ARUKOS
        %------------------------------------------------------------------
        
        image = im2gray(image);
        orb_points_img = detectSURFFeatures(image);
        
        reference = im2gray(reference);
        orb_points_ref = detectSURFFeatures(reference);
        
        [features_img, valid_points_img] = extractFeatures(image, orb_points_img);
        [features_ref, valid_points_ref] = extractFeatures(image, orb_points_ref);
        
        indexPairs = matchFeatures(features_img, features_ref, 'MatchThreshold', 20, 'Unique', true);
        
        matchedPoints_img = valid_points_img(indexPairs(:,1),:);
        matchedPoints_ref = valid_points_ref(indexPairs(:,2),:);
        
        figure; 
        showMatchedFeatures(image,reference,matchedPoints_img,matchedPoints_ref);
        
        %------------------------------------------------------------------
        
        %creates the output image
%         [rgbIM] = frame_homography(image, refCornersCoords, template_ids,ref_h,ref_w,vectorMatrix);

        %saves the output image
%         imwrite(rgbIM,append(path_to_output_folder,'\',files(i).name))
    end
end