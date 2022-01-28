function [rgbIM] = frame_homography(H ,ref_h, ref_w, image)
% This function creates the final RGB image from the homography matrix (H),
% the size of the template (ref_h and ref_w) and the original RGB image
%
% Afonso Girbal - 93206
% Filipe Monteiro - 93248
% Lucas Piper - 93290
% Maria Inês Lopes - 93299
%

vectorMatrix = [repelem(1:ref_w,ref_h); repmat(1:ref_h,[1,ref_w]);...
    ones(1,ref_h*ref_w)];

%initializes the output image
rgbIM = zeros(ref_h, ref_w, 3);

%calculates the coordinates of the output image's pixels in the input one
vectorCMatrix = H\vectorMatrix;
vectorRESMatrix = [int16(vectorCMatrix(2,:)./vectorCMatrix(3,:));...
    int16(vectorCMatrix(1,:)./vectorCMatrix(3,:))];

%Atributes the color to each pixel and discovers pixels outside the input
%image
n = 1;
m = 1;
ImageSize = size(image);
OutPoints = zeros(ref_w*ref_h,3);

for i = 1:ref_w
    for j = 1:ref_h
            n = n+1;
            if 1 <= vectorRESMatrix(1,n-1) && vectorRESMatrix(1,n-1) <= ImageSize(1) &&...
                    1 <= vectorRESMatrix(2,n-1) && vectorRESMatrix(2,n-1) <= ImageSize(2)
                rgbIM(j,i,1) = double(image(vectorRESMatrix(1,n-1),...
                    vectorRESMatrix(2,n-1),1))/255;
                rgbIM(j,i,2) = double(image(vectorRESMatrix(1,n-1),...
                    vectorRESMatrix(2,n-1),2))/255;
                rgbIM(j,i,3) = double(image(vectorRESMatrix(1,n-1),...
                    vectorRESMatrix(2,n-1),3))/255;
            else
                OutPoints(m,:) = [j,i,n];
                m = m+1;
            end

    end
end
end





