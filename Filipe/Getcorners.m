function [ListaCorners] = Getcorners(image)
py.importlib.import_module('getCorners');
py.getCorners.run(image);

aux = load('cornersIds.mat');
aux_corners = squeeze(aux.corners);
corners = permute(aux_corners, [1,3,2]);
ids = aux.ids;

clear aux aux_corners

fprintf("\nNote: The first detected Aruco marker is corners(1,:,:), the second is (2,:,:), and so on\n")


ListaCorners1(:,:) = corners(1,:,:);
ListaCorners2(:,:) = corners(2,:,:);
ListaCorners3(:,:) = corners(3,:,:);
ListaCorners4(:,:) = corners(4,:,:);

ListaCorners(:,:) = [ListaCorners1(:,:) ListaCorners2(:,:) ListaCorners3(:,:) ListaCorners4(:,:)];

end
%[M,I] = max(ListaCorners(2,:);