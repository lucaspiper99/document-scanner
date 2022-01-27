clc;
clear;
close all;

% arguments of pivproject2021
ref_path = "DATASETS\InitialDataset\templates\template2_fewArucos.png";

input_path = "DATASETS\InitialDataset\FewArucos-Viewpoint2_images";
output_path = "DATASETS\InitialDataset\output2";
arg2 = 0;

reference = get_image(ref_path);

[refCornersCoords, template_ids]  = getCorners(reference);
ref_h = size(reference,1);
ref_w = size(reference,2);     
        
files = dir(fullfile(input_path));
files(1:2) = [];

imgs2compare = 10;
num_images = length(files);
homographys = zeros(3, 3, num_images);
rgb_images = zeros(ref_h, ref_w, 3, imgs2compare);

for i = 1:num_images
        

        image = get_image(input_path,files(i).name);
        
        if i > imgs2compare
            
            
            best_i = compare2(rgb_images);
            best_image = get_image(input_path, best_name);
            H1 = get_SIFT_H(best_image, image, 2000, 1);
            H2 = homographys(:,:,best_i);
            homographys(:,:,i) = H2*H1;
            
            rgb_images(:,:,:,1) = [];
            rgb_images(:,:,:,imgs2compare) = frame_homography(homographys(:,:,i),...
                ref_h, ref_w, image);
            imwrite(rbg_images(:,:,:,imgs2compare),append(output_path,'\',files(i).name));
            
        else
            if i == 1
                for j=1:imgs2compare
                    
                    image = get_image(input_path,files(j).name);
                    homographys(:,:,j) = get_SIFT_H(reference, image, 3000, 80);
                    rgb_images(:,:,:,j) = frame_homography(homographys(:,:,j),...
                        ref_h, ref_w, image);
                    
                end
            end
            
            best_i = compare2(rgb_images);
            best_first_name = files(best_i).name;
            best_image = get_image(input_path, best_first_name);

            H2 = homographys(:,:,best_i);
            H1 = get_SIFT_H(best_image, image, 2000, 1);
            homographys(:,:,i) = H2*H1;

            rbg_images(:,:,:,i) = frame_homography(homographys(:,:,i),...
            ref_h, ref_w, image);
        
            imwrite(rbg_images(:,:,:,i),append(output_path,'\',files(i).name));
        end
        i
        best_i
end