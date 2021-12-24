function rgbIM = frame_homography(image_path, reference_path)
%This function returns the RGB frame/image after the homography, given the
%original frame/image and the reference

[refCornersCoords, template_ids]  = getCorners(reference_path);
[imgCornersCoords, image_ids] = getCorners(reshape(image_path, 1, []));
numArucos = size(imgCornersCoords,1);

image = imread(image_path);
reference = imread(reference_path);
ref_h = size(reference,1);
ref_w = size(reference,2);

refAruco = zeros(numArucos,1);
for i = 1:numArucos
    refAruco(i) = find(template_ids == image_ids(i));
end

H = homography(imgCornersCoords, refCornersCoords(refAruco(:), :, :));

rgbIM = zeros(ref_h, ref_w, 3);
vectorMatrix = [repelem(1:ref_w,ref_h); repmat(1:ref_h,[1,ref_w]);...
    ones(1,ref_h*ref_w)];
vectorCMatrix = H^(-1)*vectorMatrix;
vectorRESMatrix = [uint16(vectorCMatrix(2,:)./vectorCMatrix(3,:));...
    uint16(vectorCMatrix(1,:)./vectorCMatrix(3,:))];

n=1;
for i = 1:ref_w
    for j = 1:ref_h
            n = n+1;
            rgbIM(j,i,1) = double(image(vectorRESMatrix(1,n-1),...
                vectorRESMatrix(2,n-1),1))/255;
            rgbIM(j,i,2) = double(image(vectorRESMatrix(1,n-1),...
                vectorRESMatrix(2,n-1),2))/255;
            rgbIM(j,i,3) = double(image(vectorRESMatrix(1,n-1),...
                vectorRESMatrix(2,n-1),3))/255;
    end
end





