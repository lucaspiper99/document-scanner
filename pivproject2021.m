function pivproject2021(task, path_to_template, path_to_output_folder, arg1, arg2)
% This function runs our Image Processing and Vision project, by selecting
% the desired task (task), the path to the dataset template
% (path_to_template), the path to the output folder (path_to_output_folder)
% and the path to the input folder(s) (arg1 and arg2)
%
% Afonso Girbal - 93206
% Filipe Monteiro - 93248
% Lucas Piper - 93290
% Maria Inês Lopes - 93299
%

switch task
   case 1
       task1(path_to_template, path_to_output_folder, arg1);
   case 2
       task2(path_to_template, path_to_output_folder, arg1);
   case 4
       task4(path_to_template, path_to_output_folder, arg1, arg2);
   otherwise
       fprintf('Select one of the available tasks: 1, 2 and 4\n');
end 
end
