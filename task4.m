function [] = task4(path_to_template, path_to_output_folder, arg1, arg2)
% This function runs the fourth task of our Image Processing and Vision
% project, by selecting the path to the dataset template
% (path_to_template), the path to the output folder
% (path_to_output_folder), and the path to the first camera input folder
% (arg1), the path to the first camera input folder 
%
% Afonso Girbal - 93206
% Filipe Monteiro - 93248
% Lucas Piper - 93290
% Maria Inês Lopes - 93299
%

% Reads reference template
reference = get_image(path_to_template);
ref_size(:) = size(reference, 1:2);


%Save only the images from the input folder (starting with "rgb_...")
files1 = dir(fullfile(arg1));
files2 = dir(fullfile(arg2));
unecessary_files1 = [];
unecessary_files2 = [];
for i=1:length(files1)
    if ~startsWith(files1(i).name,'rgb')
        unecessary_files1(end+1) = i;
    end
end
files1(unecessary_files1) = [];
for i=1:length(files2)
    if ~startsWith(files2(i).name,'rgb')
        unecessary_files2(end+1) = i;
    end
end
files2(unecessary_files2) = [];
num_max_images = max(length(files1), length(files2));


%Check for different framerates between the input folders
files1_60fps = length(files1)/length(files2) > 1.8;
files2_60fps = length(files2)/length(files1) > 1.8;

images1_ended = false;
images2_ended = false;

current_camera = 2;
imgs_max = 30;
rgb_imagesO = zeros(ref_size(1), ref_size(2), 3, 1);
last_change = -5;

% Reads every image from the input folder with the least images
for i = 1:num_max_images
        
        if ~images1_ended && ~images2_ended
            
            % Reads the correct images according to the framerate
            if files1_60fps
                index1 = 2*i-1;
                index2 = i;
                images1_ended = length(files1) == 2*i-1;
                images2_ended = length(files2) == i;
            elseif files2_60fps
                index1 = i;
                index2 = 2*i-1;
                images1_ended = length(files1) == i;
                images2_ended = length(files2) == 2*i-1;
            else
                index1 = i;
                index2 = i;
                images1_ended = length(files1) == i;
                images2_ended = length(files2) == i;
            end
            
            image1 = get_image(arg1,files1(index1).name);
            image2 = get_image(arg2,files2(index2).name);
            
            % Calculates the homography matrixes
            H1 = get_SIFT_H(reference, image1, 2000, 50);
            H2 = get_SIFT_H(reference, image2, 2000, 50);
            
            if current_camera == 1
                stitched_image = stitch(image2, image1, H2, H1, ref_size);
            else
                stitched_image = stitch(image1, image2, H1, H2, ref_size);
            end
            
            % Creates the output image (stitched when needed)
            if diff_hist(stitched_image, rgb_imagesO) && ((i-last_change)>=5)
                if current_camera == 1
                    stitched_image = stitch(image1, image2, H1, H2, ref_size);
                    current_camera = 2;
                    last_change = i;
                else
                    stitched_image = stitch(image2, image1, H2, H1, ref_size);
                    current_camera = 1;
                    last_change = i;
                end
            end
            
            if any(i == 1:imgs_max)
                rgb_imagesO(:,:,:,i) = stitched_image;
            else
                rgb_imagesO(:,:,:,1) = [];
                rgb_imagesO(:,:,:,imgs_max) = stitched_image;
            end
            
            % Saves the output image
            imwrite(stitched_image,append(path_to_output_folder, '\',...
                files1(index1).name));
            
        elseif images1_ended
            
            % Reads the correct images according to the framerate
            if files2_60fps
                index2 = 2*i-1;
            else
                index2 = i;
            end
            
            image2 = get_image(arg2, files2(index2).name);
            
            % Calculates the homography matrixes
            H2 = get_SIFT_H(reference, image2, 2000, 50);

            % Creates the output image
            final_image = frame_homography(H2, ref_size(1), ref_size(2), image);
            
            % Saves the output image
            imwrite(final_image, append(path_to_output_folder, '\',...
                files2(index2).name));
            
        elseif images2_ended
            
            % Reads the correct images according to the framerate
            if files1_60fps
                index1 = 2*i-1;
            else
                index1 = i;
            end
            
            image1 = get_image(arg2, files1(index1).name);
            
            % Calculates the homography matrixes
            H1 = get_SIFT_H(reference, image1, 2000, 50);

            % Creates the output image
            final_image = frame_homography(H1, ref_size(1), ref_size(2), image);

            % Saves the output image
            imwrite(final_image, append(path_to_output_folder, '\',...
                files1(index1).name));
            
        end
end
end