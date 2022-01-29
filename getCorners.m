function [corners, ids] = getCorners(image)
%This function obtains the Aruco corner's coordinates, given the image path
%
% Afonso Girbal - 93206
% Filipe Monteiro - 93248
% Lucas Piper - 93290
% Maria Inês Lopes - 93299
%

py.importlib.import_module('getCorners');
py.getCorners.run(py.numpy.array(image));
aux = load('cornersIds.mat');
aux_corners = squeeze(aux.corners);
dimensao = size(aux_corners);

%if there is only one aruco
if size(dimensao) < 3
    aux_cornersOLD = aux_corners;
    aux_corners = zeros(1,4,2);
    aux_corners(1,:,:) = aux_cornersOLD;
end

corners = permute(aux_corners, [1,3,2]);
ids = aux.ids;
clear aux aux_corners

end