function H = get_SIFT_H(img1, img2, iterations, distance)
%This function gets the homography matrix, H, from two images, img1 and
%img2, the iterations of the RANSAC algorithm and the minimum inlier
%distance between img1 and img2 points   'MinLength',res*166

py.importlib.import_module('sift_features');
py.sift_features.get_sift_pts(py.numpy.array(img1),...
    py.numpy.array(img2));
sift_pts = load('sift_pts.mat');
img1_pts = squeeze(sift_pts.img1);
img2_pts = squeeze(sift_pts.img2);

H = ransac_fcn(img1_pts, img2_pts, iterations, distance);

end

