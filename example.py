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


def ransac(src_Pts, dst_Pts, iterations, distance):
    maxI = 0
    maxLSrc = []
    maxLDest = []
    for i in range(iterations):

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

            if cv2.norm(p2 - p2e) < distance:
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
    return Hf



img = cv2.imread("DATASETS/test/rgb3393.jpg", 0)
ref = cv2.imread("DATASETS/GoogleGlass/template_glass.jpg", 0)

height = int(ref.shape[0])
width = int(img.shape[1] * (height / img.shape[0]))
dim = (width, height)
img = cv2.resize(img, dim, interpolation=cv2.INTER_AREA)

kp1, kp2, good_matches = get_sift_pts(ref, img)
#get_sift_pts(ref, img)
sift_pts = loadmat("sift_pts.mat")
dst_pts, src_pts = sift_pts['img1'], sift_pts['img2']
#H = ransac(src_pts, dst_pts, 3000, 80)
#final_img = cv2.warpPerspective(img, H, (ref.shape[1], ref.shape[0]))



#sift_pts = loadmat("sift_pts.mat")
#dst_pts, src_pts = sift_pts['img1'], sift_pts['img2']
#M = ransac(src_pts, dst_pts,3000, 80)
#print(np.linalg.norm(M-np.identity(3)))


'''Para gravar imagem depois da homografia'''
# M = ransac(src_pts, dst_pts)
# img4 = cv2.warpPerspective(img, M, (ref.shape[1], ref.shape[0]))
# cv2.imwrite(f"DATASETS/InitialDataset/output_python/{file}", img4)
# print('Working on', file)

'''Para mostrar imagem depois da homografia'''
# cv2.namedWindow('Good Matches', cv2.WINDOW_NORMAL)
# cv2.moveWindow('Good Matches', 50, 50)
# cv2.imshow('Good Matches', img4)
# cv2.resizeWindow('Good Matches', int(ref.shape[1] * .6), int(img2.shape[0] * .6))
# cv2.waitKey()

'''Para mostrar as matches entre imagens'''
M, mask = cv2.findHomography(src_pts, dst_pts, cv2.RANSAC, 10.0)
#print(np.linalg.norm(M-np.identity(3)))
matchesMask = mask.ravel().tolist()
h, w = ref.shape
pts = np.float32([[0, 0], [0, h - 1], [w - 1, h - 1], [w - 1, 0]]).reshape(-1, 1, 2)
dst = cv2.perspectiveTransform(pts, M)
draw_params = dict(matchColor=(0, 255, 0), singlePointColor=None, matchesMask=matchesMask, flags=2)
img3 = cv2.drawMatches(ref, kp1, img, kp2, good_matches, None, **draw_params)
plt.imshow(img3, 'gray'), plt.show()
