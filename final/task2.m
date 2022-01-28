function [] = task2(path_to_template, path_to_output_folder , arg1)
% This function runs the first task of our Image Processing and Vision
% project, by selecting the path to the dataset template
% (path_to_template), the path to the output folder
% (path_to_output_folder), and the path to the input folder (arg1)
%
% Afonso Girbal - 93206
% Filipe Monteiro - 93248
% Lucas Piper - 93290
% Maria Inês Lopes - 93299
%

reference = get_image(path_to_template);

%[refCornersCoords, template_ids]  = getCorners(reference);
ref_h = size(reference,1);
ref_w = size(reference,2);     
        
files = dir(fullfile(arg1));
files(1:2) = [];

image = get_image(arg1,files(1).name);
im_h = size(image,1);
im_w = size(image,2);


imgs_max = 30;
num_images = length(files);
homographys = zeros(3, 3, 1);
rgb_imagesO = zeros(ref_h, ref_w, 3, 1);
base_images = zeros(im_h, im_w, 3, 1);

for i = 1:num_images

        image = get_image(arg1,files(i).name);
 
        H1 = get_SIFT_H(reference, image, 3000, 100);
        
        img_temp = frame_homography(H1,ref_h, ref_w, image);
        
        if diff_hist(img_temp, rgb_imagesO)
            index = most_similar_hist(image,base_images);
            H2 = get_SIFT_H( get_image(arg1,files(index + uint16(i-imgs_max)).name), image, 300, 3);
            H1 = homographys(:,:,index);
            H1 = H1*H2; 
            img_temp = frame_homography(H1,ref_h, ref_w, image);
        end

        if any(i == 1:imgs_max)
            base_images(:,:,:,i) = frame_homography(eye(3),im_h, im_w, image); %O MATLAB EST� COMPLETAMENTE MALUCO, N�O PERCEBO
            homographys(:,:,i) = H1;
            rgb_imagesO(:,:,:,i) = img_temp;
            imwrite(img_temp,append(path_to_output_folder,'\',files(i).name));
        else
            base_images(:,:,:,1) = [];
            homographys(:,:,1) = [];
            rgb_imagesO(:,:,:,1) = [];
            base_images(:,:,:,imgs_max) = frame_homography(eye(3),im_h, im_w, image);
            homographys(:,:,imgs_max) = H1;
            rgb_imagesO(:,:,:,imgs_max) = img_temp;
            imwrite(img_temp,append(path_to_output_folder,'\',files(i).name));
        end
end
end
