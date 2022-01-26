import cv2
import numpy as np
from scipy.io import savemat
from scipy.io import loadmat
import matplotlib.pyplot as plt
from sift_features import get_sift_pts

def homography(src, dest, N):
    A = []
    for i in range(N):
        x, y = src[i][0], src[i][1]
        xp, yp = dest[i][0], dest[i][1]
        A.append([x, y, 1, 0, 0, 0, -x * xp, -xp * y, -xp])
        A.append([0, 0, 0, x, y, 1, -yp * x, -yp * y, -yp])
    A = np.asarray(A)
    _, _, V = np.linalg.svd(A)
    H = V[-1, :] / V[-1, -1]
    H = H.reshape(3, 3)
    return H


def ransac(src_Pts, dst_Pts):
    maxI = 0
    maxLSrc = []
    maxLDest = []
    for i in range(3000):

        srcP, destP = [], []
        for j in range(4):
            random_index = np.random.randint(src_Pts.shape[0])
            srcP.append(src_Pts[random_index])
            destP.append(dst_Pts[random_index])

        H = homography(srcP, destP, 4)

        inlines = 0
        linesSrc = []
        lineDest = []
        for p1, p2 in zip(src_Pts, dst_Pts):

            p1U = (np.append(p1, 1)).reshape(3, 1)
            p2e = H.dot(p1U)
            p2e = (p2e / p2e[2])[:2].reshape(1, 2)[0]

            if cv2.norm(p2 - p2e) < 80:
                inlines += 1
                linesSrc.append(p1)
                lineDest.append(p2)
        if inlines > maxI:
            maxI = inlines
            maxLSrc = linesSrc.copy()
            maxLSrc = np.asarray(maxLSrc, dtype=np.float32)
            maxLDest = lineDest.copy()
            maxLDest = np.asarray(maxLDest, dtype=np.float32)
    Hf = homography(maxLSrc, maxLDest, maxI)
    print(maxI)
    return Hf

img1 = cv2.imread("DATASETS/InitialDataset/templates/template2_fewArucos.png", 0)
img2 = cv2.imread("input/exemplo_1.jpg", 0)

height = int(img2.shape[0])
width = int(img1.shape[1] * (height / img1.shape[0]))
dim = (width, height)
img1 = cv2.resize(img1, dim, interpolation=cv2.INTER_AREA)

get_sift_pts(img1, img2)
sift_pts = loadmat("sift_pts.mat")
dst_pts, src_pts = sift_pts['img1'], sift_pts['img2']

print(dst_pts.shape[0])
M = ransac(src_pts, dst_pts)

img4 = cv2.warpPerspective(img2, M, (img1.shape[1], img1.shape[0]))
cv2.namedWindow('Good Matches', cv2.WINDOW_NORMAL)
cv2.moveWindow('Good Matches', 50, 50)
cv2.imshow('Good Matches', img4)
cv2.resizeWindow('Good Matches', int(img1.shape[1] * .6), int(img2.shape[0] * .6))
cv2.waitKey()


# M, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC, 80.0)
# matchesMask = mask.ravel().tolist()
# h, w = img1.shape
# pts = np.float32([[0, 0], [0, h - 1], [w - 1, h - 1], [w - 1, 0]]).reshape(-1, 1, 2)
# dst = cv2.perspectiveTransform(pts, M)
# img2 = cv2.polylines(img2, [np.int32(dst)], True, 0, 3, cv2.LINE_AA)
# draw_params = dict(matchColor=(0, 255, 0), singlePointColor=None, matchesMask=matchesMask, flags=2)
# img3 = cv2.drawMatches(img1, kp1, img2, kp2, good_matches, None, **draw_params)
# plt.imshow(img3, 'gray'), plt.show()

# H = ransacHomography(src_Pts, dst_Pts)
# print(H)
# H = np.array([[.3, 110, -2494], [-4.3, 4.2, 3286.4], [0, 0, 1]])

# warped = cv2.warpPerspective(img1, H, (img2.shape[0], img2.shape[1]))
# cv2.imshow('warped', warped)
# cv2.waitKey(0)
# img_matches = np.empty((max(img1.shape[0], img2.shape[0]), img1.shape[1]+img2.shape[1], 3), dtype=np.uint8)
#
# cv2.drawMatches(img1, kp1, img2, kp2, good_matches, img_matches, flags=cv2.DrawMatchesFlags_NOT_DRAW_SINGLE_POINTS)
#
# cv2.namedWindow('Good Matches', cv2.WINDOW_NORMAL)
# cv2.moveWindow('Good Matches', 50, 50)
# cv2.imshow('Good Matches', warped)
# cv2.resizeWindow('Good Matches', 800, 600)
# cv2.waitKey()
