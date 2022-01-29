function stitched_image = stitch(img1, img2, H1, H2, ref_size)
% This function calculates img1 and img2 after the homographys H1 and H2
% respectively and return the stitched image with the size ref_size 
%
% Afonso Girbal - 93206
% Filipe Monteiro - 93248
% Lucas Piper - 93290
% Maria Inês Lopes - 93299
%

% Initialize the "empty" image
stitched_image = zeros([ref_size(1) ref_size(2) 3], 'like', img1);

blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');  

% Create a 2-D spatial reference object defining the size of the reference
xLimits = [1 ref_size(2)];
yLimits = [1 ref_size(1)];
view = imref2d([ref_size(1) ref_size(2)], xLimits, yLimits);

% Create the stitched image
warpedImage = imwarp(img1, projective2d(H1'), 'OutputView', view);
mask = imwarp(true(size(img1,1),size(img1,2)), projective2d(H1'), 'OutputView', view);
stitched_image = step(blender, stitched_image, warpedImage, mask);

warpedImage = imwarp(img2, projective2d(H2'), 'OutputView', view);
mask = imwarp(true(size(img2,1),size(img2,2)), projective2d(H2'), 'OutputView', view);
stitched_image = step(blender, stitched_image, warpedImage, mask);
end

