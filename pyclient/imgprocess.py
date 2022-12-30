import cv2
import numpy as np


def RemoveBg(source, dest):
    print("RmBg src : ", source)
    print("RmBg dest : ", dest)

    # Read the image
    # image = cv2.imread(source, cv2.IMREAD_UNCHANGED)
    img = cv2.imread(source)

    # convert to graky
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)

    # threshold input image as mask
    mask = cv2.threshold(gray, 200, 255, cv2.THRESH_BINARY)[1]

    # negate mask
    mask = 255 - mask

    # apply morphology to remove isolated extraneous noise
    # use borderconstant of black since foreground touches the edges
    kernel = np.ones((3,3), np.uint8)
    mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel)

    # anti-alias the mask -- blur then stretch
    # blur alpha channel
    mask = cv2.GaussianBlur(mask, (0,0), sigmaX=2, sigmaY=2, borderType = cv2.BORDER_DEFAULT)

    # linear stretch so that 127.5 goes to 0, but 255 stays 255
    mask = (2*(mask.astype(nploat32))-255.0).clip(0,255).astype(np.uint8)

    # put mask into alpha channel
    result = img.copy()
    result = cv2.cvtColor(result, cv2.COLOR_BGR2BGRA)
    result[:, :, 3] = mask

    print(img)
    cv2.imwrite(dest, result)

def RemoveBgXXX(source, dest):
    print("RmBg src : ", source)
    print("RmBg dest : ", dest)

    # Read the image
    # image = cv2.imread(source, cv2.IMREAD_UNCHANGED)
    img = cv2.imread(source)

    print(img.shape)
    return

    # convert to graky
    gray = cv2.cvtColor(img, cv2.COLOR_BGRA2GRAY)
    cv2.imwrite("/Users/avikpaul/Documents/Processing/avik_demo_1/res/t1.png", gray)

    print(gray.ndim)
    return

    # threshold input image as mask
    mask = cv2.threshold(gray, 200, 255, cv2.THRESH_BINARY)[1]

    # negate mask
    mask = 255 - mask

    # apply morphology to remove isolated extraneous noise
    # use borderconstant of black since foreground touches the edges
    kernel = np.ones((3,3), np.uint8)
    mask = cv2.morphologyEx(mask, cv2.MORPH_OPEN, kernel)
    mask = cv2.morphologyEx(mask, cv2.MORPH_CLOSE, kernel)

    # anti-alias the mask -- blur then stretch
    # blur alpha channel
    mask = cv2.GaussianBlur(mask, (0,0), sigmaX=2, sigmaY=2, borderType = cv2.BORDER_DEFAULT)

    # linear stretch so that 127.5 goes to 0, but 255 stays 255
    mask = (2*(mask.astype(nploat32))-255.0).clip(0,255).astype(np.uint8)

    # put mask into alpha channel
    result = img.copy()
    result = cv2.cvtColor(result, cv2.COLOR_BGR2BGRA)
    result[:, :, 3] = mask

    print(img)
    cv2.imwrite(dest, result)