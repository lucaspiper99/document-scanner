function [corners, ids] = getCorners(image)
%This function obtains the Aruko corner's coordinates, given the image path

py.importlib.import_module('getCorners');
py.getCorners.run(image);
aux = load('cornersIds.mat');
aux_corners = squeeze(aux.corners);
corners = permute(aux_corners, [1,3,2]);
ids = aux.ids;
clear aux aux_corners

% fprintf("\nNote: The first detected Aruco marker is corners(1,:,:), the second is (2,:,:), and so on\n")
end