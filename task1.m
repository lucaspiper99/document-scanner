function [] = task1(path_to_template, path_to_output_folder , arg1)
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

% Reads reference template
template = get_image(path_to_template);
temp_size(:) = size(template, 1:2);


% Get the coordinates and the IDs of the template Aruko Markers
[temp_corner_coords, temp_ids]  = getCorners(template);


% Save only the images from the input folder (starting with "rgb_...")
files = dir(fullfile(arg1));
unecessary_files = [];
for i=1:length(files)
    if ~startsWith(files(i).name,'rgb')
        unecessary_files(end+1) = i;
    end
end
files(unecessary_files) = [];
num_images = length(files);


% Reads every image from the input folder
for i = 1:num_images

    %reads the input image
    image = get_image(arg1, files(i).name);

    %reads the aruco markers
    [img_corner_coords, image_ids] = getCorners(image);
    num_arucos = size(img_corner_coords, 1);
    ref_aruco = zeros(num_arucos, 1);
    for j = 1:num_arucos
        ref_aruco(j) = find(temp_ids == image_ids(j));
    end

    %calculates the homography matrix
    H = homography(img_corner_coords, temp_corner_coords(ref_aruco(:), :, :));

    %creates the output image
    [rgbIM] = frame_homography(H ,temp_size(1),temp_size(2),image);

    %saves the output image
    imwrite(rgbIM, append(path_to_output_folder,'\',files(i).name))
end
end

