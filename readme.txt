The file getCorners.py has been modified, and the sent version has to be used.

The code can be executed by running the command pivproject2021(task,  path_to_template, path_to_output_folder, arg1, arg2)
where: 
	the task has to be 1, 2 or 4 
	the path_to_template has to be the path to the template, 
	the path_to_output_folder has to be the path to the output folder,
	the arg1 has to be the path to the first input folder,
	the arg2 has to be the path to the second input folder.

As for example:

	pivproject2021(1,  "DATASETS\InitialDataset\templates\template2_fewArucos.png" ,"output" ,"input", 0)

It was only used the default matlab toolbox, the AlphaBlender System object™, the Open-CV, NumPy and SciPy.IO libraries for Python.

pip install numpy
pip install scipy
pip install opencv-python