function H = homography(pts, newPts, nPts)
%This function calculates the 3x3 homography matrix, H,

A = zeros(2*nPts,9);

for i=1:nPts
    A(i*2-1,:) = [newPts(i,1), newPts(i,2) , 1, 0, 0, 0,...
        -newPts(i,1)*pts(i,1),-newPts(i,2)*pts(i,1), -pts(i,1)];
    A(i*2,:) = [0, 0, 0, newPts(i,1), newPts(i,2),1,...
        -newPts(i,1)*pts(i,2), -newPts(i,2)*pts(i,2), -pts(i,2)];
end

[~,~,V] = svd(A);
H = V(:,end);
H=reshape(H,3,3);
end

