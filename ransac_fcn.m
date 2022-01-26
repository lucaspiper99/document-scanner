function H = ransac_fcn(ref_pts, img_pts)
%This function calculates the 3x3 homography matrix, H, using the Random
%Sample Consensus algorithm

max_inliers = 0;
n = 4;
k = 3000;
for i=1:k
    for j=1:n
        random_index = randi(size(img_pts, 1));
        random_ref_pts(j, :) = ref_pts(random_index, :);
        random_img_pts(j, :) = img_pts(random_index, :);
    end
    
    H = homography(random_img_pts, random_ref_pts);
    
    inliers = 0;
    for j=1:size(img_pts, 1)
        
        vector_img = cart2hom(img_pts(j,:));
        vector_ref = hom2cart((H*vector_img')');
        
        if norm(ref_pts(j,:) - vector_ref) < 80
            inliers = inliers + 1;
            inliers_img(inliers, :) = img_pts(j, :);
            inliers_ref(inliers, :) = ref_pts(j, :);
        end
    end
    
    if inliers > max_inliers
        max_inliers = inliers;
        best_inliers_img = inliers_img;
        best_inliers_ref = inliers_ref;
    end
end
H = homography(best_inliers_img, best_inliers_ref);
max_inliers
end