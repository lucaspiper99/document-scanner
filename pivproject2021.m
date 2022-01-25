%pivproject2021(1,  "DATASETS\InitialDataset\templates\template2_fewArucos.png" ,"output" ,"input", 0)
function pivproject2021(task,  reference_path ,path_to_output_folder , path_to_input_folder, arg2)
    if task == 1
        %reads reference template
        [reference,map] = imread(reference_path);
        if size(reference,3) == 1
            reference = uint8(round(ind2rgb(reference, map)*255));
        end
        [refCornersCoords, template_ids]  = getCorners(reference);
        ref_h = size(reference,1);
        ref_w = size(reference,2);
        vectorMatrix = [repelem(1:ref_w,ref_h); repmat(1:ref_h,[1,ref_w]);...
                    ones(1,ref_h*ref_w)];

        files = dir(fullfile(path_to_input_folder));
        for i = 1:length(files)                         %reads every file in the input folder
            if files(i).isdir == 0
                
                %reads the input image
                [image,map] = imread(append(path_to_input_folder,'\',files(i).name));
                if size(image,3) == 1
                    image = uint8(round(ind2rgb(image, map)*255));
                end
                
                %reads the aruco markers
                [imgCornersCoords, image_ids] = getCorners(image);
                numArucos = size(imgCornersCoords,1);
                refAruco = zeros(numArucos,1);
                for i = 1:numArucos
                    refAruco(i) = find(template_ids == image_ids(i));
                end

                %calculates the homography matrix
                H = homography(imgCornersCoords, refCornersCoords(refAruco(:), :, :));
                
                %creates the output image
                [rgbIM] = frame_homography(H ,ref_h,ref_w,vectorMatrix,image);

                %saves the output image
                imwrite(rgbIM,append(path_to_output_folder,'\',files(i).name))
            end
        end
    else 
        fprintf('This code only executes task 1 \n');
    end
end
