function image = get_image(input_path, img_name)
%This function gets the image matrix from it's folde path and the name of
%the image or just from it's path directly
%
% Afonso Girbal - 93206
% Filipe Monteiro - 93248
% Lucas Piper - 93290
% Maria Inês Lopes - 93299
%

if nargin == 2
    path = append(input_path,'\', img_name);
else
   path = input_path; 
end

[image, map] = imread(path);
if size(image,3) == 1
    image = uint8(round(ind2rgb(image, map)*255));
end
end

