function H = homography(imgPts, refPts)
%This function calculates the 3x3 homography matrix, H, given the
%coordinates of the points in the image and the coordinates of the points
%in the reference images

numPts = size(imgPts, 1)*size(imgPts, 3);
imgPts = reshape(permute(imgPts, [2,3,1]), 2, []);
refPts = reshape(permute(refPts, [2,3,1]), 2, []);

A = zeros(2*numPts,9);
for i=1:numPts
    A(i*2-1,:) = [imgPts(1,i), imgPts(2,i) , 1, 0, 0, 0,...
        -imgPts(1,i)*refPts(1,i),-imgPts(2,i)*refPts(1,i), -refPts(1,i)];
    A(i*2,:) = [0, 0, 0, imgPts(1,i), imgPts(2,i),1,...
        -imgPts(1,i)*refPts(2,i), -imgPts(2,i)*refPts(2,i), -refPts(2,i)];
end

[~,~,V] = svd(A);
H = V(:,end)./V(end,end);
H=reshape(H,3,3)';
end

