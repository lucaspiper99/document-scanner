function [rgbIM] = frame_homography_teste(H ,ref_h,ref_w,vectorMatrix,image)

%initializes the output image
rgbIM = zeros(ref_h, ref_w, 1);

%calculates the coordinates of the output image's pixels in the input one
vectorCMatrix = H^(-1)*vectorMatrix;
vectorRESMatrix = [uint16(vectorCMatrix(2,:)./vectorCMatrix(3,:));...
    uint16(vectorCMatrix(1,:)./vectorCMatrix(3,:))];

%Atributes the color to each pixel and discovers pixels outside the input
%image
n = 1;
m = 1;
ImageSize = size(image);
OutPoints = zeros(ref_w*ref_h,3);

for i = 1:ref_w
    for j = 1:ref_h
            n = n+1;
            if 1 <= vectorRESMatrix(1,n-1) & vectorRESMatrix(1,n-1) <= ImageSize(1) & 1 <= vectorRESMatrix(2,n-1) & vectorRESMatrix(2,n-1) <= ImageSize(2)
                rgbIM(j,i,1) = double(image(vectorRESMatrix(1,n-1),...
                    vectorRESMatrix(2,n-1),1));
            else
                OutPoints(m,:) = [j,i,n];
                m = m+1;
            end
            
    end
end

end





