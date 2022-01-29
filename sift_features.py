import cv2
import numpy as np
from scipy.io import savemat


def get_sift_pts(img1, img2):
    """
    This functions creates a sift_pts.mat file from the commons SIFT features' coordinates from the two input images

    img1 - RGB image (width x height x 3 numpy array)
    img2 - RGB image (width x height x 3 numpy array)
    """

    sift = cv2.SIFT_create()
    kp1, des1 = sift.detectAndCompute(img1, None)
    kp2, des2 = sift.detectAndCompute(img2, None)

    bf = cv2.BFMatcher()  # Brute Force Matching
    matches = bf.knnMatch(des1, des2, k=2)  # 2 nearest neighbours

    good_matches = []
    distance_ratio = 0.6
    while True:
        good_matches = []
        for m, n in matches:
            if m.distance < distance_ratio * n.distance:  # trial and error determined distance
                good_matches.append(m)
        if len(good_matches)>100:
            break
        else:
            distance_ratio += .05
            
        
            

    dst_pts = np.float32([kp1[m.queryIdx].pt for m in good_matches]).reshape(-1, 2)
    src_pts = np.float32([kp2[m.trainIdx].pt for m in good_matches]).reshape(-1, 2)

    sift_pts_dict = {"img1": dst_pts, "img2": src_pts}
    savemat("sift_pts.mat", sift_pts_dict)

    return kp1, kp2, good_matches
