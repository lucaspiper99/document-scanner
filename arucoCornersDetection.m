pcPythonExe = 'C:\Users\lucas\anaconda3\envs\IST_IPV21_Env\python.exe';
%[ver, exec, loaded]	= pyversion(pcPythonExe);

mod = py.importlib.import_module('getCorners');
py.getCorners.run("C:\Users\lucas\OneDrive\Documents\GitHub\piv_project\DATASETS\img1.png");

aux = load('cornersIds.mat');
aux_corners = squeeze(aux.corners);
corners = permute(aux_corners, [1,3,2]);
ids = aux.ids;

clear aux aux_corners

fprintf("\nNote: The first detected Aruco marker is corners(1,:,:), the second is (2,:,:), and so on\n")
