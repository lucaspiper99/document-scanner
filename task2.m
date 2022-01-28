clc;
clear;
close all;

% arguments of pivproject2021
ref_path = "DATASETS\GoogleGlass\template_glass.jpg";

input_path = "DATASETS\GoogleGlass\nexus";
output_path = "DATASETS\outputtest";
arg2 = 0;

reference = get_image(ref_path);

%[refCornersCoords, template_ids]  = getCorners(reference);
ref_h = size(reference,1);
ref_w = size(reference,2);     
        
files = dir(fullfile(input_path));
files(1:2) = [];

image = get_image(input_path,files(1).name);
im_h = size(image,1);
im_w = size(image,2);


imgs_max = 30;
num_images = length(files);
homographys = zeros(3, 3, 1);
rgb_imagesO = zeros(ref_h, ref_w, 3, 1);
base_images = zeros(im_h, im_w, 3, 1);

for i = 1:num_images
    
%         if i == imgs2compare+1
%             firsti = zeros(ref_h, ref_w, 3, 5);
%             for j = 1:5
%                 firsti(:,:,:,j) = get_image(output_path,files(bestfive(j)).name);
%             end
%         end
        

        image = get_image(input_path,files(i).name);
 
        tic
        H1 = get_SIFT_H(reference, image, 3000, 100);
        
        img_temp = frame_homography(H1,ref_h, ref_w, image);
        
        if compare4(img_temp,rgb_imagesO)
            img1_pts = [];
            img2_pts = [];
            index = compare3(image,base_images);
            %image_new = base_images(:,:,:,index);
            H2 = get_SIFT_H( get_image(input_path,files(index + uint16(i-imgs_max)).name), image, 300, 3);
            H1 = homographys(:,:,index);
            H1 = H1*H2; 
            img_temp = frame_homography(H1,ref_h, ref_w, image);
        end


        if any(i == 1:imgs_max)
            base_images(:,:,:,i) = frame_homography(eye(3),im_h, im_w, image); %O MATLAB EST� COMPLETAMENTE MALUCO, N�O PERCEBO
            homographys(:,:,i) = H1;
            rgb_imagesO(:,:,:,i) = img_temp;
            imwrite(img_temp,append(output_path,'\',files(i).name));
        else
            base_images(:,:,:,1) = [];
            homographys(:,:,1) = [];
            rgb_imagesO(:,:,:,1) = [];
            base_images(:,:,:,imgs_max) = frame_homography(eye(3),im_h, im_w, image);
            homographys(:,:,imgs_max) = H1;
            rgb_imagesO(:,:,:,imgs_max) = img_temp;
            imwrite(img_temp,append(output_path,'\',files(i).name));
        end

            
%             warning('')            
%             [warnMsg, warnId] = lastwarn;
%             if ~isempty(warnMsg)
%                 fix = 1:imgs_max;
%                 best_i = compare3(rgb_images(:,:,:,fix ~= best_i));
%                 best_image = get_image(input_path, files(best_i+i-imgs2compare-1).name);
%                 H1 = get_SIFT_H(best_image, image, 300, 2);
%                 H2 = homographys(:,:,best_i);
%                 homographys(:,:,1) = [];
%                 homographys(:,:,imgs2compare) = H2*H1;
%             end

    imwrite(rgb_imagesO(:,:,:,i),append(output_path,'\',files(i).name));    

    i

    toc      
end
