%pivproject2021(1,  "DATASETS\InitialDataset\templates\template2_fewArucos.png" ,"output" ,"input", 0)
%function pivproject2021(task,  reference_path ,path_to_output_folder , path_to_input_folder, arg2)
        %reads reference template
        [reference,map] = imread("DATASETS\InitialDataset\templates\template2_fewArucos.png");
        if size(reference,3) == 1
            reference = uint8(round(ind2rgb(reference, map)*255));
        end
        [refCornersCoords, template_ids]  = getCorners(reference);
        reference=rgb2gray(reference);
        reference=im2double(reference);
        REF = detectSURFFeatures(reference);
        [f1,vpts1] = extractFeatures(reference,REF);
        %ref_h = size(reference,1);
        %ref_w = size(reference,2);
        %vectorMatrix = [repelem(1:ref_w,ref_h); repmat(1:ref_h,[1,ref_w]);...
         %           ones(1,ref_h*ref_w)];

        files = dir(fullfile("input"));
        for i = 1:length(files)                         %reads every file in the input folder
            if files(i).isdir == 0

                %reads the input image
                [image,map] = imread(append("input",'\',files(i).name));
                if size(image,3) == 1
                    image = uint8(round(ind2rgb(image, map)*255));
                end
                image=rgb2gray(image);
                image=im2double(image);
                IMG = detectSURFFeatures(image);
                [f2,vpts2] = extractFeatures(image,IMG);
                indexPairs = matchFeatures(f1,f2) ;
                matchedPoints1 = vpts1(indexPairs(:,1));
                matchedPoints2 = vpts2(indexPairs(:,2));
                showMatchedFeatures(reference,image,matchedPoints1,matchedPoints2);
            end
        end
        
        figure(1)
        imshow(reference)
        hold on
        gscatter(REF.Location(indexPairs(:,1),1),REF.Location(indexPairs(:,1),2));
        hold off
        
        figure(2)
        imshow(image)
        hold on
        gscatter(IMG.Location(indexPairs(:,2),1),IMG.Location(indexPairs(:,2),2));
        hold off
        
        
        matchedPoints1 = vpts1(indexPairs(:,1));
        matchedPoints2 = vpts2(indexPairs(:,2));
        showMatchedFeatures(reference,image,matchedPoints1,matchedPoints2);
        
        