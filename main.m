%% IMAGE SECTION

clc;
clear all;
close all;

reference_path = "template2_fewArucos.png";
image_path = 'img1.png';

rgbIM = frame_homography(image_path, reference_path);
imshow(rgbIM);
ax = gca;
ax.YDir = 'reverse';
%% VIDEO SECTION

clc;
clear all;
close all;

vidObj = VideoReader('DATASETS/InitialDataset/FewArucos-Viewpoint2.mp4');
reference_path = "template2_fewArucos.png";
outVideo = VideoWriter('output.avi');
open(outVideo);

for i=1:180
    vidObj = VideoReader('DATASETS/InitialDataset/FewArucos-Viewpoint1.mp4');
    vidFrame = readFrame(vidObj);
    imwrite(vidFrame, 'screenshot.png');
    image_path = 'screenshot.png';
    rgbIM = frame_homography(image_path, reference_path);
    writeVideo(outVideo,rgbIM);
end
close(outVideo);