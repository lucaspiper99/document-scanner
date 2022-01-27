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

imgs2compare = 15;
num_images = length(files);
homographys = zeros(3, 3, imgs2compare);
rgb_images = zeros(ref_h, ref_w, 3, imgs2compare);

for i = 1:num_images
        

        image = get_image(input_path,files(i).name);
        
        if i > imgs2compare
            
            tic
            best_i = compare2(rgb_images);
            best_image = get_image(input_path, files(best_i+i-imgs2compare-1).name);
            H1 = get_SIFT_H(best_image, image, 300, 1);
            H2 = homographys(:,:,best_i);
            homographys(:,:,1) = [];
            homographys(:,:,imgs2compare) = H2*H1;
            
            if sum(homographys(:,:,imgs2compare),'all') == 9
               'a' 
            end
            
            
            
            rgb_images(:,:,:,1) = [];
            rgb_images(:,:,:,imgs2compare) = frame_homography(homographys(:,:,imgs2compare),...
                ref_h, ref_w, image);
            imwrite(rgb_images(:,:,:,imgs2compare),append(output_path,'\',files(i).name));
            files(best_i+i-imgs2compare-1).name     
            toc
            i
            
            
            
        else
            if i == 1
                for j=1:imgs2compare
                    tic
                    
                    image = get_image(input_path,files(j).name);
                    homographys(:,:,j) = get_SIFT_H(reference, image, 3000, 80);
                    rgb_images(:,:,:,j) = frame_homography(homographys(:,:,j),...
                        ref_h, ref_w, image);
                    toc

                    
                end
            end
            
            tic
            
            best_i = compare2(rgb_images);
            best_first_name = files(best_i).name;
            best_image = get_image(input_path, best_first_name);

            H2 = homographys(:,:,best_i);
            
            if i == best_i
                H1 = eye(3);
            else
                H1 = get_SIFT_H(best_image, image, 300, 1);
            end
            homographys(:,:,i) = H2*H1;

            rgb_images(:,:,:,i) = frame_homography(homographys(:,:,i),...
            ref_h, ref_w, image);
        
            imwrite(rgb_images(:,:,:,i),append(output_path,'\',files(i).name));
            i
            toc
        end
        
end