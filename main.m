clc;
clear;

%pcPythonExe = 'C:\Users\lucas\anaconda3\envs\IST_IPV21_Env\python.exe';
%[ver, exec, loaded]	= pyversion(pcPythonExe);

py.importlib.import_module('getCorners');
py.getCorners.run("img1.png");
aux = load('cornersIds.mat');
aux_corners = squeeze(aux.corners);
corners = permute(aux_corners, [1,3,2]);
ids = aux.ids;
clear aux aux_corners

fprintf("\nNote: The first detected Aruco marker is corners(1,:,:), the second is (2,:,:), and so on\n")

for i=1:4
    pts(4*i-3:4*i,:) = [corners(i,:,1); corners(i,:,2); corners(i,:,3);...
        corners(i,:,4)];
end


I = imread('img1.png');
% imshow(I);
newPts = [134, 1895; 371, 1895; 371, 2130; 134, 2130;...
    1277, 1895; 1514, 1895; 1514, 2130; 1276, 2130;...
    134, 144; 371, 144; 371, 380; 134, 380;...
    1277, 143; 1514, 143; 1514, 379; 1276, 380];

%UNDER CONSTRUCTION
H = homography(pts, newPts, 16);
tf = projective2d(H);
W = imwarp(I, tf);
imshow(W);
pts = [pts ones(size(pts,1),1)]; 
pts_projected = H*pts';