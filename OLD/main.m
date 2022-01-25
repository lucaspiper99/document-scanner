%% IMAGE SECTION

clc;
clear all;
close all;


reference_path = "DATASETS\InitialDataset\templates\template2_fewArucos.png";
reference = imread(reference_path);
image = imread("screenshotSEMCANTO.png");
[refCornersCoords, template_ids]  = getCornersOLD(reference_path);
ref_h = size(reference,1);
ref_w = size(reference,2);
vectorMatrix = [repelem(1:ref_w,ref_h); repmat(1:ref_h,[1,ref_w]);...
    ones(1,ref_h*ref_w)]; %pode ser só uma vez

[rgbIM] = frame_homography(image, refCornersCoords, template_ids,ref_h,ref_w,vectorMatrix);
imshow(rgbIM);
ax = gca;
ax.YDir = 'reverse';
%% VIDEO SECTION

clc;
clear all;
close all;

vidObj = VideoReader('DATASETS/InitialDataset/FewArucos-Viewpoint2.mp4');
reference_path = "template2_fewArucos.png";
reference = imread(reference_path);
[refCornersCoords, template_ids]  = getCornersOLD(reference_path);
ref_h = size(reference,1);
ref_w = size(reference,2);

outVideo = VideoWriter('output.avi');
open(outVideo);
n =0;
tempoSUM=0;
vectorMatrix = [repelem(1:ref_w,ref_h); repmat(1:ref_h,[1,ref_w]);...
    ones(1,ref_h*ref_w)]; %pode ser só uma vez
vidObj = VideoReader('DATASETS/InitialDataset/FewArucos-Viewpoint1.mp4');

while n < vidObj.NumFrames
    tic;
    image = readFrame(vidObj);
    [rgbIM] = frame_homography(image, refCornersCoords, template_ids,ref_h,ref_w,vectorMatrix);
    writeVideo(outVideo,rgbIM);
    tempo= toc
    n = n +1
    tempoSUM = tempoSUM +tempo;
    tempoSUM/n
end
close(outVideo);