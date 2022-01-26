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
    for m, n in matches:
        if m.distance < 0.9 * n.distance:  # trial and error determined distance
            good_matches.append(m)

    dst_pts = np.float32([kp1[m.queryIdx].pt for m in good_matches]).reshape(-1, 2)
    src_pts = np.float32([kp2[m.trainIdx].pt for m in good_matches]).reshape(-1, 2)

    sift_pts_dict = {"img1": dst_pts, "img2": src_pts}
    savemat("sift_pts.mat", sift_pts_dict)

    return


"""
img1 = cv2.imread("input/exemplo_2.jpg")
img2 = cv2.imread("DATASETS/InitialDataset/templates/template2_fewArucos.png")

height = int(img2.shape[0])
width = int(img1.shape[1] * (height / img1.shape[0]))
dim = (width, height)
img1 = cv2.resize(img1, dim, interpolation=cv2.INTER_AREA)

kp1, kp2, good_matches = get_sift_pts(img1, img2)

img_matches = np.empty((max(img1.shape[0], img2.shape[0]), img1.shape[1]+img2.shape[1], 3), dtype=np.uint8)
cv2.drawMatches(img1, kp1, img2, kp2, good_matches, img_matches, flags=cv2.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS)

cv2.namedWindow('Good Matches', cv2.WINDOW_NORMAL)
cv2.moveWindow('Good Matches', 50, 50)
cv2.imshow('Good Matches', img_matches)
cv2.resizeWindow('Good Matches', 800, 600)
cv2.waitKey()
cv2.destroyAllWindows()
"""
