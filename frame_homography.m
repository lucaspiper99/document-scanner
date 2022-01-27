function [rgbIM] = frame_homography(H ,ref_h, ref_w, image)

vectorMatrix = [repelem(1:ref_w,ref_h); repmat(1:ref_h,[1,ref_w]);...
    ones(1,ref_h*ref_w)];

%initializes the output image
rgbIM = zeros(ref_h, ref_w, 3);

%calculates the coordinates of the output image's pixels in the input one
vectorCMatrix = H\vectorMatrix;
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

%Estimates the color of the points outside the input image

% for i = 1:length(OutPoints)
%     if OutPoints(i,3) ~= 0
%                 if vectorRESMatrix(1,OutPoints(i,3)-1) > ImageSize(1)
%                     j = 1;
%                     while rgbIM(OutPoints(i,1)-j+1,OutPoints(i,2),1) == 0 & rgbIM(OutPoints(i,1)-j+1,OutPoints(i,2),2) == 0 & rgbIM(OutPoints(i,1)-j+1,OutPoints(i,2),3) == 0 
%                         rgbIM(OutPoints(i,1),OutPoints(i,2),:) = rgbIM(OutPoints(i,1)-j,OutPoints(i,2),:);
%                         j = j +1;
%                     end
%                 elseif vectorRESMatrix(2,OutPoints(i,3)-1) > ImageSize(2)
%                     j = 1;
%                     while rgbIM(OutPoints(i,1),OutPoints(i,2)-j+1,1) == 0 & rgbIM(OutPoints(i,1),OutPoints(i,2)-j+1,2) == 0 & rgbIM(OutPoints(i,1),OutPoints(i,2)-j+1,3) == 0 
%                         rgbIM(OutPoints(i,1),OutPoints(i,2),:) = rgbIM(OutPoints(i,1),OutPoints(i,2)-j,:);
%                         j = j +1;
%                     end
%                 elseif vectorRESMatrix(1,OutPoints(i,3)-1) < 1
%                     j = 1;
%                     while rgbIM(OutPoints(i,1)+j-1,OutPoints(i,2),1) == 0 & rgbIM(OutPoints(i,1)+j-1,OutPoints(i,2),2) == 0 & rgbIM(OutPoints(i,1)+j-1,OutPoints(i,2),3) == 0 
%                         rgbIM(OutPoints(i,1),OutPoints(i,2),:) = rgbIM(OutPoints(i,1)+j,OutPoints(i,2),:);
%                         j = j +1;
%                     end
%                 elseif vectorRESMatrix(2,OutPoints(i,3)-1) < 1
%                     j = 1;
%                     while rgbIM(OutPoints(i,1),OutPoints(i,2)+j-1,1) == 0 & rgbIM(OutPoints(i,1),OutPoints(i,2)+j-1,2) == 0 & rgbIM(OutPoints(i,1),OutPoints(i,2)+j-1,3) == 0 
%                         rgbIM(OutPoints(i,1),OutPoints(i,2),:) = rgbIM(OutPoints(i,1),OutPoints(i,2)+j,:);
%                         j = j +1;
%                     end
%                 end
%     end
% end
end





