import platform
import numpy as np
import argparse
import cv2
import serial
import time
import sys
from threading import Thread
from PIL import Image
import pytesseract
import math

global ABCD_list
ABCD_list = []

###  방 나갈 때마다 리셋해준다. (코너에 당도해서 고개돌리는 함수)
###  ABCD의 경우는 리셋하면서 ABCD_list에 반영되고, 0으로 리셋되지 않으면 이전 결과값을 바꾸지 않는 함수가 있으므로 리셋이 반드시 되어야 한다. ###
#### 방들어갈 때 마다 바뀌는 값 ####
global floorColor  # 확진구역 1, 안전구역 2
floorColor = 0
global abcdColor  # 빨간색 1 파란색 2, ABCD에서 인식에서 팩의 색을 인식하기 위함임
abcdColor = 0
global packLocation  # 155 왼쪽, 156 오른쪽, IsTherePack에서 팩 위치에 따라 보내준다.
packLocation = 0
global ABCD  # 150 : A /  151 : B /  152 : C /  153 : D
ABCD = 0

# 디버그용 이미지 저장 번호
global imgNum
imgNum = 1000

## 고개 컨트롤을 위한 글로벌 변수 ##
global lookDownCnt  # 팩집으러갈때 고개 두번내리는 것은 팩집는것과 동일한 신호이다.
lookDownCnt = 0
global sleepCnt  # 고개내리고 나서는 5초대기를 하지 않는다.
sleepCnt = 0
global lookDownCnt_Corner  # 코너에서 고개를 두번내리는 것은 코너에 당도할 정도로 가까이왔다는 뜻이다.
lookDownCnt_Corner = 0


# 입력받은 이미지를 따로 저장한다. 디버그용
def SaveImg(img):
    global imgNum
    imgNum = imgNum + 1
    cv2.imwrite(str(imgNum) + '.jpg', img)


def Mask_Red(img):
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    mask_Red1 = cv2.inRange(hsv, np.array([0, 80, 15]), np.array([12, 255, 255]))
    mask_Red2 = cv2.inRange(hsv, np.array([150, 80, 15]), np.array([180, 255, 255]))
    mask = cv2.bitwise_or(mask_Red1, mask_Red2)

    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    dst = cv2.bitwise_and(img, img, mask=mask)  # Red and Blue
    ret, dst = cv2.threshold(dst, 5, 255, cv2.THRESH_BINARY)
    # ~ #cv2.imshow('red',dst)
    # ~ cv2.waitKey(1)
    return dst


def Mask_Green(img):
    frame = cv2.cvtColor(img, cv2.COLOR_BGR2Lab)

    lab_upper = np.array([255, 115, 255])
    lab_lower = np.array([0, 0, 0])

    mask = cv2.inRange(frame, lab_lower, lab_upper)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    dst = cv2.bitwise_and(img, img, mask=mask)
    ret, dst = cv2.threshold(dst, 5, 255, cv2.THRESH_BINARY)
    # ~ #cv2.imshow('green',dst)
    # ~ cv2.waitKey(1)
    return dst


def Mask_Blue(img):
    hsv = cv2.cvtColor(img, cv2.COLOR_BGR2HSV)
    mask = cv2.inRange(hsv, np.array([100, 100, 20]), np.array([140, 255, 255]))

    # ~ frame = cv2.cvtColor(img, cv2.COLOR_BGR2Lab)

    # ~ lab_upper = np.array([255, 255, 120])
    # ~ lab_lower = np.array([0, 0, 0])

    # ~ mask = cv2.inRange(frame, lab_lower, lab_upper)
    img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    dst = cv2.bitwise_and(img, img, mask=mask)
    ret, dst = cv2.threshold(dst, 5, 255, cv2.THRESH_BINARY)
    # ~ #cv2.imshow('blue',dst)
    # ~ cv2.waitKey(1)
    return dst


def Mask_Yellow(frame):
    frame_yuv = cv2.cvtColor(frame, cv2.COLOR_BGR2YCrCb)
    yuv_Lower = np.array([[45, 110, 30], [40, 100, 20], [60, 85, 0]])
    yuv_Upper = np.array([[160, 190, 110], [180, 190, 110], [255, 190, 100]])
    yellow_mask = cv2.inRange(frame_yuv, yuv_Lower[2], yuv_Upper[2])
    yellow_mask = morph_tf(yellow_mask)

    return yellow_mask


def Mask_Black(frame):
    bgr_upper_b = np.array([60, 60, 60])  ### 그림자랑 같이 잡히지 않도록 조심해야한다.
    bgr_lower_b = np.array([0, 0, 0])
    mask = cv2.inRange(frame, bgr_lower_b, bgr_upper_b)

    img = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    dst = cv2.bitwise_and(img, img, mask=mask)  # Red and Blue
    ret, dst = cv2.threshold(dst, 5, 255, cv2.THRESH_BINARY)
    dst = 255 - dst

    # #cv2.imshow('Black',dst)
    cv2.waitKey(1)
    return dst


#### 코너를 볼때마다 바뀌는 값, 리셋할 필요는 없다. ###
global roomCnt  # 알파벳 3번관측 후 바깥쪽 코너를 만나면 그때 들어가야한다.
roomCnt = 0
global stepCnt  # 3번째 미션을 수행한후 차선 유지 함수가 호출된 횟수. 10번이상일 때 T형 코너를 찾기 시작한다.
stepCnt = 0
global cornerState  # 차선유지에서 코너를 만날때 마다 바뀌는값. 2가 ㄱ형 코너고 3이 T형 코너임
cornerState = 0


# 차선인식 부분
def morph_tf(img):  # 차선/코너인식 위한 이미지 전처리
    kernel = np.ones((3, 3), np.uint8)
    img = cv2.dilate(img, kernel, iterations=2)
    img = cv2.erode(img, kernel, iterations=2)
    return img


def ReadRoad(frame):
    global cornerState
    global roomCnt
    global stepCnt
    height, width, channel = frame.shape

    # ----------------------- 전처리 -----------------------------------
    yellow_mask = Mask_Yellow(frame)
    roi = yellow_mask[int(4 * height / 5): height, :]
    # ------------------ roi 이미지로 deviation 픽셀수 계산 ----------------------------------------
    roi_sum = roi.sum(axis=0)
    line_index = []

    for i in range(len(roi_sum)):
        if roi_sum[i] > 10000:
            line_index.append(i)
    try:
        line_mid = int(sum(line_index) / len(line_index))
        frame_mid = int(width / 2)
    except:
        frame_mid = int(width / 2)
        line_mid = frame_mid

    # ----------------------------------------------------------------------------

    # ------------------- 허프 라인 검출 및 직선 기울기 계산 -----------------------------
    canny = cv2.Canny(yellow_mask, 75, 200, apertureSize=5, L2gradient=True)

    lines = cv2.HoughLines(canny, 1, np.pi / 180, 70)  # np.pi / 180 = 1 degree in rad #원래 100이였음
    theta_list = []

    if lines is not None:
        for line in lines:
            rho, theta = line[0]
            a = np.cos(theta)
            b = np.sin(theta)
            x0 = a * rho
            y0 = b * rho
            x1 = int(x0 + 1000 * (-b))
            y1 = int(y0 + 1000 * (a))
            x2 = int(x0 - 1000 * (-b))
            y2 = int(y0 - 1000 * (a))
            cv2.line(frame, (x1, y1), (x2, y2), (0, 0, 255), 2)
            theta_degree = int(theta * 180 / np.pi)
            if 0 <= theta_degree < 45:
                theta_list.append(90 - theta_degree)
            elif 135 < theta_degree <= 180:
                theta_list.append((270 - theta_degree))
    if len(theta_list) != 0:
        theta_avg = int(sum(theta_list) / len(theta_list))
    else:
        theta_avg = 0
    # -------------------------------------------------------------------------------

    # ------------------- 화면에 deviation 및 degree 계산 결과 표시 ---------------------
    cv2.line(frame, (line_mid, int(4 * height / 5)), (frame_mid, int(4 * height / 5)), (255, 0, 0), thickness=2)
    cv2.putText(frame, str(frame_mid - line_mid), (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 0), 2, cv2.LINE_AA)
    cv2.putText(frame, str(theta_avg), (150, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 0), 2, cv2.LINE_AA)

    SaveImg(frame)

    point, isCorner = ReadCorner_XY(canny)  # isCorner : 170_코너검출 254_코너없음 253_선없음
    if (point != None):
        pointY = point[0][1] / height * 100
    else:
        pointY = 0

    print(point)

    stepCnt = stepCnt + 1
    print('cornerState :' + str(cornerState))
    if (isCorner == 253):  # 직선이 사라지는 순간 코너 당도했다는 신호를 주게된다.
        cornerState = 0
        return 170
    if (cornerState == 0):
        if (pointY > 40):  # 코너가 검출됐을경우 cornerState에 따라 다르게 세팅한다. return 170
            # ㄱ자형 코너와 T자형 코너를 구분하기 위해 화면 상단에 선이 보이는지 여부를 확인한다.
            roi_nine = yellow_mask[0: int(height / 3), int(width * 3 / 10):int(width * 7 / 10)]
            roi_nineSum = int(sum(roi_nine.sum(axis=0)) / 255)
            print(roi_nineSum)

            if (roi_nineSum > 150):  # Test 1000
                # print('corner and front line Detected')
                cornerState = 3
            else:
                # print('corner Detected and front line nonDetected')
                cornerState = 2

    elif (cornerState == 2):
        if (isCorner == 170):  # 코너가 있으면 무시한다.
            pass
        elif (isCorner == 253):
            cornerState = 0
            return 170  # 직선이 사라지는 순간 코너 당도했다는 신호를 주게된다.
        else:
            if (roomCnt >= 3 and stepCnt > 10):
                roomCnt = 0
                return 172  # 코너가 먼저사라지는 순간
    elif (cornerState == 3):
        if (isCorner == 170):
            pass
        elif (isCorner == 253):  # 직선이 사라지는 순간 코너 당도했다는 신호를 주게된다.
            cornerState = 0
            return 170
        elif (isCorner == 254):  # 코너가 사라지면 원상태로 돌아온다.
            cornerState = 0
            if (roomCnt >= 3 and stepCnt > 10):
                roomCnt = 0
                return 172

    if (frame_mid - line_mid) > 80:  # 기존값 55였는데 더 예민하게 40으로 바꿈
        print("one step to the left ")
        return 163
    elif (frame_mid - line_mid) < -80:
        print("one step to the right")
        return 164
    elif (180 > theta_avg > 95):
        print("Turn Left")
        return 161
    elif (0 < theta_avg < 85):
        print("Turn Right")
        return 162
    else:
        if (roomCnt >= 3):
            print("Go stragiht Slowly")
            return 210
        else:
            print("Go stragiht")
            return 160


def ReadCorner_XY(canny):  # 코너의 좌표값을 반환
    lines = cv2.HoughLines(canny, 1, np.pi / 70, 35)  # 180, 40 원래 도로주행시 코너는 80이고, 미션복귀시 코너는 20이였는데 둘다 20으로 퉁침.
    theta_list = []
    # cv2.imshow('ff23dfdf',canny)
    if lines is not None:
        for i in range(len(lines)):
            rho, theta = lines[i][0]
            a = np.cos(theta)
            b = np.sin(theta)
            x0 = a * rho
            y0 = b * rho
            x1 = int(x0 + 1000 * (-b))
            y1 = int(y0 + 1000 * (a))
            x2 = int(x0 - 1000 * (-b))
            y2 = int(y0 - 1000 * (a))
            cv2.line(canny, (x1, y1), (x2, y2), (155, 155, 155), 2)
            # cv2.imshow('ffdfdfdf',canny)
            theta_degree = int(theta * 180 / np.pi)
            if 0 <= theta_degree <= 90:
                theta_list.append((90 - theta_degree, i))
            elif 90 < theta_degree <= 180:
                theta_list.append((270 - theta_degree, i))

        for theta, index in theta_list[1:]:
            if 10 <= theta_list[0][0] <= 169 and not (theta_list[0][0] - 10 <= theta <= theta_list[0][0] + 10):
                line1 = lines[0][0]
                line2 = lines[index][0]
                point = intersection(line1, line2)
                cv2.circle(canny, tuple(point[0]), 12, (255, 255, 255), 12)
                # cv2.imshow('canny', canny)
                return point, 170
            elif 0 <= theta_list[0][0] <= 9 and \
                    not (theta_list[0][0] + 170 <= theta <= 179 or 0 <= theta <= theta_list[0][0] + 10):
                line1 = lines[0][0]
                line2 = lines[index][0]
                point = intersection(line1, line2)

                cv2.circle(canny, tuple(point[0]), 12, (255, 255, 255), 12)
                # cv2.imshow('canny', canny)
                return point, 170

            elif 170 <= theta_list[0][0] <= 179 and \
                    not ((theta_list[0][0] - 10 <= theta <= 179 or 0 <= theta <= theta_list[0][0] - 170)):
                line1 = lines[0][0]
                line2 = lines[index][0]
                point = intersection(line1, line2)
                cv2.circle(canny, tuple(point[0]), 12, (255, 255, 255), 12)
                # cv2.imshow('canny', canny)
                return point, 170
    else:
        # cv2.imshow('canny', canny)
        return None, 253  # 선이 없음
    # cv2.imshow('canny', canny)
    return None, 254  # 코너 없음


def CheckCorner(frame):  # 미션 직후 가야할 코너를 찾아서  254혹은 corner 좌표를 반환하는 함수,
    height, width, channel = frame.shape
    yellow_mask = Mask_Yellow(frame)
    mask = np.zeros(yellow_mask.shape, dtype=np.uint8)
    mask[:, :] = 255

    canny = cv2.Canny(yellow_mask, 100, 200, apertureSize=5, L2gradient=True)
    canny = cv2.bitwise_and(canny, canny, mask=mask)
    SaveImg(canny)
    # #cv2.imshow('test',canny)
    cv2.waitKey(1)
    point, temp = ReadCorner_XY(canny)  # temp는 쓰지 않는 변수이다.
    if (point != None):
        yellow_sum = np.sum(yellow_mask[int(point[0][1] + height * 0.1):, :])
        if (yellow_sum < 100 and 0 < point[0][1] and 0 < point[0][0] < width):  # 원하는 코너일때 point값을 반환함
            print("right corner")
            return point
        else:  # 잘못된 코너 관측시 none 반환
            print("wrong corner")
            return
    else:  # 코너가 관측되지 않는경우 none
        return


def GotoCorner(frame):  # 시야에 보이는 코너를 향해 가까이가면서 트래킹하는 함수
    global lookDownCnt
    global lookDownCnt_Corner

    height, width, channel = frame.shape
    point = CheckCorner(frame)

    print(point)
    if (point == None):
        centerX = 0
        centerY = 0
        print('No Data')
        return 173
    else:
        centerX = point[0][0] / width * 100
        centerY = point[0][1] / height * 100

    if (centerX == 0 and centerY == 0):
        print("No input, turn Right")
        return 173
    elif (centerY > height):
        print("Corner is below the sight. Go back")  # 코너가 로봇시야 아래에 존재하는경우. 후진한다.
        return 206
    elif (centerX < 43):
        print("Go Left")
        return 163
    elif (centerX > 57):
        print("Go Right")
        return 164
    elif (lookDownCnt_Corner == 0 and centerY > 60):
        lookDownCnt_Corner = 1
        return 169
    elif (lookDownCnt_Corner == 1 and centerY > 80):  # 원래 70이였는데 코너로 너무 가까이 근접해서 60으로 바꿈
        print("Corner Arrived")
        return 165

    else:
        print("Go straight")
        return 160


def GotoCorner_Closely(frame):  # 시야에 보이는 코너를 향해 가까이가면서 트래킹하는 함수, 확진구역에서 팩을 내려놓고 와서 호출되는 함수
    global lookDownCnt

    height, width, channel = frame.shape

    yellow_mask = Mask_Yellow(frame)

    mask = np.zeros(yellow_mask.shape, dtype=np.uint8)
    mask[:int(height * 0.8), :] = 255

    canny = cv2.Canny(yellow_mask, 100, 200, apertureSize=5, L2gradient=True)
    canny = cv2.bitwise_and(canny, canny, mask=mask)

    point, temp = ReadCorner_XY(canny)

    print(point)
    if (point == None):
        centerX = 0
        centerY = 0
        print('No Data')
        return 165  # 160이였는데 코너 당도한것으로 생각한다.
    else:
        centerX = point[0][0] / width * 100
        centerY = point[0][1] / height * 100

    SaveImg(canny)
    if (centerX == 0 and centerY == 0):
        print("No input, Go straight")  # or Right
        return 160
    elif (centerX < 40):
        print("Go Left")
        return 163
    elif (centerX > 70):
        print("Go Right")
        return 164
    elif (centerY > 100):
        print("Corner Arrived")
        # lookDownCnt = 1
        return 165
    else:
        print("Go straight")
        return 160


def intersection(line1, line2):
    """Finds the intersection of two lines given in Hesse normal form.

    Returns closest integer pixel locations.
    """

    rho1, theta1 = line1
    rho2, theta2 = line2
    A = np.array([
        [np.cos(theta1), np.sin(theta1)],
        [np.cos(theta2), np.sin(theta2)]
    ])
    b = np.array([[rho1], [rho2]])
    x0, y0 = np.linalg.solve(A, b)
    x0, y0 = int(np.round(x0)), int(np.round(y0))
    return [[x0, y0]]


# 코너에서 어느 라인을 따라서 갈지 알려주는 함수
def OnCorner(frame):  # 코너 위에서 선을 봤을 때 몇개가 보이는지 반환
    height, width, channel = frame.shape
    yellow_mask = Mask_Yellow(frame)

    mask = np.zeros(yellow_mask.shape, dtype=np.uint8)
    mask_left = mask.copy()
    mask_right = mask.copy()
    mask_left[:int(8.5 * height / 10), :int(width / 2)] = 255
    mask_right[:int(8.5 * height / 10), int(width / 2):] = 255

    canny = cv2.Canny(yellow_mask, 75, 200, apertureSize=5, L2gradient=True)
    canny_left = cv2.bitwise_and(canny, canny, mask=mask_left)
    canny_right = cv2.bitwise_and(canny, canny, mask=mask_right)

    lines = cv2.HoughLines(canny, 1, np.pi / 180, 50)  # np.pi / 180 = 1 degree in rad
    lines_left = cv2.HoughLines(canny_left, 1, np.pi / 180, 50)
    lines_right = cv2.HoughLines(canny_right, 1, np.pi / 180, 50)

    SaveImg(frame)
    SaveImg(canny_left)
    SaveImg(canny_right)

    if lines_left is not None and lines_right is not None:  # 좌우 모두 존재
        return 159
    elif ((lines_left is not None and lines_right is None) or (
            lines_left is None and lines_right is not None)):  # 선이 한개만 존재
        return 169
    else:  # 선이 없음
        return 179


def OnCorner_IsThereLine(frame):  # 코너 위에서 고개를 돌려 선을 봤을 때 보이지 않으면 그대로 쭉 간다.
    height, width, channel = frame.shape

    yellow_mask = Mask_Yellow(frame)

    mask = np.zeros(yellow_mask.shape, dtype=np.uint8)
    mask_left = mask.copy()
    mask_right = mask.copy()
    mask_left[:int(8.5 * height / 10), :int(width / 2)] = 255
    mask_right[:int(8.5 * height / 10), int(width / 2):] = 255

    canny = cv2.Canny(yellow_mask, 75, 200, apertureSize=5, L2gradient=True)
    canny_left = cv2.bitwise_and(canny, canny, mask=mask_left)
    canny_right = cv2.bitwise_and(canny, canny, mask=mask_right)

    lines = cv2.HoughLines(canny, 1, np.pi / 180, 50)  # np.pi / 180 = 1 degree in rad
    lines_left = np.sum(canny_left)
    lines_right = np.sum(canny_right)

    ####cv2.imshow('frame', frame)
    ####cv2.imshow('canny_left', canny_left)
    ####cv2.imshow('canny_right', canny_right)
    SaveImg(frame)
    SaveImg(canny_left)
    SaveImg(canny_right)
    if lines_left == 0 and lines_right == 0:  # 좌우 모두 없을때
        print('correct path')
        return 157
    else:  # 좌우 둘중하나만 있을때
        print('wrong path')
        return 158


# OCR 부분
def Read_NEWS(frame):
    whiteList = ['N', 'E', 'W', 'w', 's', 'S']
    characters = []

    # 전처리 부분
    frame2 = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    frame2 = cv2.GaussianBlur(frame2, (5, 5), 0)
    ret2, result = cv2.threshold(frame2, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
    result = cv2.dilate(result, kernel, iterations=2)

    ##Find Contours
    contours, hierarchy = cv2.findContours(result, cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)

    ##Remove Largest Contour
    contours = sorted(contours, key=cv2.contourArea)
    l = len(contours)
    contours = np.delete(contours, l - 1, 0)

    ##Apply OCR to 3 largest contour areas
    for i in range(max(l - 3, 0), max(l - 1, 0)):
        # blankimg는 외곽 지역을 지운 이미지임.
        x, y, w, h = cv2.boundingRect(contours[i])
        blankimg = frame[y:(y + h), x:(x + w)]

        # 전처리 과정
        blankimg = cv2.cvtColor(blankimg, cv2.COLOR_BGR2GRAY)
        blankimg = cv2.GaussianBlur(blankimg, (5, 5), 0)
        ret2, blankimg = cv2.threshold(blankimg, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
        kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
        blankimg = cv2.dilate(blankimg, kernel, iterations=2)

        # Tessearact에서 결과값을 반출한다.
        chara = pytesseract.image_to_string(blankimg, config='--psm 10')
        chara.strip()
        characters.append(chara[0])

    for char in characters:
        for white in whiteList:
            if char == 'N':
                print('확정 문자:' + char)
                return 153
            elif char == 'E':
                print('확정 문자:' + char)
                return 150
            elif char == 'S' or char == 's':
                print('확정 문자:' + char)
                return 152
            elif char == 'W':
                print('확정 문자:' + char)
                return 151
    return 254


def Read_ABCD(img):
    whiteList = ['A', 'a', 'B', 'C', 'c', 'Cc', 'cC', 'D']
    global floorColor
    global ABCD
    global abcdColor

    dst = cv2.bitwise_or(Mask_Red(img), Mask_Blue(img))  # 빨간색 인식 Mask과 파란색 인식 Mask를 합친다.
    kernel = np.ones((3, 3), np.uint8)  # 노이즈 제거부, 없을경우 인식률 낮아짐
    dst = cv2.morphologyEx(dst, cv2.MORPH_OPEN, kernel)
    dst = cv2.morphologyEx(dst, cv2.MORPH_CLOSE, kernel)
    dst, color = FilterSize_ABCD(dst, img)  # 외곽 불필요한 부분을 지워주는 부분
    dst = 255 - dst  # 흰색바탕이 더 결과가 잘나옴

    text = pytesseract.image_to_string(dst, config='--psm 10')
    text = text.strip()

    print(text)
    for white in whiteList:
        if (white == text):
            print(text + "입니다")
            if (ABCD == 0):
                # ABCD값이 새로 나왔을 때만 ABCD 색깔을 관측해서 글로벌 변수에 저장해준다.
                if (color == 'Red'):
                    abcdColor = 1
                elif (color == 'Blue'):
                    abcdColor = 2
                else:
                    print("ABCD color value is not set")

                # 확진구역일때만 ABCD 값을 저장해준다.
                if (floorColor == 1):
                    if (text == 'A' or text == 'a'):
                        ABCD = 150
                    elif (text == 'B'):
                        ABCD = 151
                    elif (text == 'C' or text == 'c' or text == 'Cc' or text == 'cC'):
                        ABCD = 152
                    elif (text == 'D'):
                        ABCD = 153
            return 171
    return 254


def FilterSize_ABCD(img, colorImg):  # OCR위한 ROI 컨투어 박스 영역 잡아준다.
    height, width = img.shape

    ## Find Contours
    contours, hierarchy = cv2.findContours(img.copy(), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)

    contours_poly = [None] * len(contours)
    boundRect = [None] * len(contours)

    for i, c in enumerate(contours):
        contours_poly[i] = cv2.approxPolyDP(c, 3, True)
        boundRect[i] = cv2.boundingRect(contours_poly[i])

    ## Draw Bounding Boxes on original image
    BiggestSize = 0
    center_x = 0
    center_y = 0
    center_x_length = 0
    center_y_length = 0
    lastFillRate = 0

    for i in range(len(contours)):
        x = int(boundRect[i][0])
        y = int(boundRect[i][1])
        x_length = int(boundRect[i][2])
        y_length = int(boundRect[i][3])
        size = x_length * y_length
        pixel = np.sum(img[y:y + y_length, x: x + x_length]) / 255
        fillRate = pixel / size

        # cv2.rectangle(img, (x, y), (x + x_length, y + y_length), (133, 133, 133), 2)

        if (BiggestSize < size and fillRate < 0.7):  # 74
            BiggestSize = size
            center_x = x
            center_y = y
            center_x_length = x_length
            center_y_length = y_length
            lastFillRate = fillRate

    print(lastFillRate)

    # ROI 바깥 부분을 지워준다.
    for j in range(0, center_y):
        for i in range(width):
            img[j, i] = 0
            colorImg[j, i] = 0
    for j in range(center_y + center_y_length, height):
        for i in range(width):
            img[j, i] = 0
            colorImg[j, i] = 0
    for j in range(height):
        for i in range(0, center_x):
            img[j, i] = 0
            colorImg[j, i] = 0
    for j in range(height):
        for i in range(center_x + center_x_length, width):
            img[j, i] = 0
            colorImg[j, i] = 0

    Red = Mask_Red(colorImg)
    Blue = Mask_Blue(colorImg)

    if (np.sum(Red) < np.sum(Blue)):
        print('Blue Detected')
        color = 'Blue'
    else:
        print('Red Detected')
        color = 'Red'

    SaveImg(img)
    return img, color


# 화살표 인식 전처리부분
def ReadArrow(img):
    lower = np.array([0, 0, 0])
    upper = np.array([100, 100, 100])
    mask = cv2.inRange(img, lower, upper)
    black = cv2.bitwise_and(img, img, mask=mask)

    ret, dst = cv2.threshold(black, 5, 255, cv2.THRESH_BINARY)

    # 노이즈 제거부
    kernel = np.ones((3, 3), np.uint8)
    dst = cv2.morphologyEx(dst, cv2.MORPH_OPEN, kernel)
    dst = cv2.morphologyEx(dst, cv2.MORPH_CLOSE, kernel)

    dst = cv2.cvtColor(dst, cv2.COLOR_BGR2GRAY)

    return FilterSize_Arrow(dst)


def FilterSize_Arrow(img):  # 화살표 인식위한 ROI 컨투어 박스 영역 잡아준다.
    height, width = img.shape
    ## Find Contours
    contours, hierarchy = cv2.findContours(img.copy(), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)

    contours_poly = [None] * len(contours)
    boundRect = [None] * len(contours)

    for i, c in enumerate(contours):
        contours_poly[i] = cv2.approxPolyDP(c, 3, True)
        boundRect[i] = cv2.boundingRect(contours_poly[i])

    ## Draw Bounding Boxes on original image
    shortestLength = 99999
    center_x = 0
    center_y = 0
    center_x_length = 0
    center_y_length = 0

    for i in range(len(contours)):
        x = int(boundRect[i][0])
        y = int(boundRect[i][1])
        x_length = int(boundRect[i][2])
        y_length = int(boundRect[i][3])
        length = math.sqrt(
            math.pow(height / 2 - (y + y_length * 0.5), 2) + math.pow(width / 2 - (x + x_length * 0.5), 2))

        # cv2.rectangle(img, (x, y), (x + x_length, y + y_length), (133, 133, 133), 2)

        if (shortestLength > length and x_length * y_length > width * height * 0.01):
            shortestLength = length
            center_x = x
            center_y = y
            center_x_length = x_length
            center_y_length = y_length
    leftSum = np.sum(img[center_y:center_y + center_y_length, center_x: int(center_x + center_x_length * 0.2)])
    rightSum = np.sum(
        img[center_y:center_y + center_y_length, int(center_x + center_x_length * 0.8): center_x + center_x_length])
    cv2.rectangle(img, (center_x, center_y), (center_x + center_x_length, center_y + center_y_length), (255, 255, 255),
                  2)
    SaveImg(img)

    if (leftSum > rightSum):
        print('To the right')
        return 156
    elif (leftSum < rightSum):
        print('To the left')
        return 155
    else:
        print('Lack of Data')
        return 254


# 안전구역인지 확진구역인지 알려주는 함수
def ReadArea(frame):
    global floorColor
    global roomCnt

    height, width, channel = frame.shape
    area = height * width

    green_mask_sum = np.sum(Mask_Green(frame)) / 255
    print(green_mask_sum / area)

    if ((green_mask_sum / area) >= 0.08):
        cv2.putText(frame, 'safe', (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 204, 0), 2, cv2.LINE_AA)
        floorColor = 2
        print('안전지역')
        SaveImg(frame)  ####디버그 용도. 대회에서는 지워도 될 듯
        return 201
    else:
        cv2.putText(frame, 'infected', (50, 50), cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2, cv2.LINE_AA)
        floorColor = 1
        print('확진지역')
        SaveImg(frame)  ####디버그 용도. 대회에서는 지워도 될 듯
        return 202


# 팩 집고 안전구역 안으로 들어갈때 충분히 안전구역 내부로 들어왔는지 확인하는 함수
def GotoArea(frame):
    height, width, channel = frame.shape

    dst = Mask_Green(frame)

    SaveImg(dst)
    cv2.waitKey(1)

    dst1 = dst[:int(height / 2), 0:int(width / 5 * 1)].copy()
    dst2 = dst[:int(height / 2), int(width / 5 * 4):].copy()
    dst3 = dst[int(height / 2):, 0:int(width / 5 * 1)].copy()
    dst4 = dst[int(height / 2):, int(width / 5 * 4):].copy()

    height, width = dst1.shape
    area = height * width

    mask1_sum = np.sum(dst1) / 255 * 100
    mask2_sum = np.sum(dst2) / 255 * 100
    mask3_sum = np.sum(dst3) / 255 * 100
    mask4_sum = np.sum(dst4) / 255 * 100

    print("upper" + str(mask1_sum / area) + "%, and " + str(mask2_sum / area) + "%")
    print("lower" + str(mask3_sum / area) + "%, and " + str(mask4_sum / area) + "%")
    if (((mask1_sum / area) >= 1 and (mask2_sum / area) >= 1) or (
            (mask3_sum / area) >= 1 and (mask4_sum / area) >= 1)):  # 10 #4 #3
        print('floor fully detected. Good to go')
        return 165
    else:
        print('아직 더 가야함')
        return 160


# 고개를 돌려 팩이 어느방향에 있는지 확인하는 함수
def IsTherePack(frame):
    global abcdColor
    global floorColor
    global packLocation
    height, width, channel = frame.shape
    SaveImg(frame)  ####디버그 용도. 대회에서는 지워도 될 듯

    if (abcdColor == 1):  # 빨간색이면
        res = Mask_Red(frame)
    elif (abcdColor == 2):  # 파란색이면
        res = Mask_Blue(frame)
    else:
        print('ABCD의 색깔 관측이 제대로 되지 않음')
        return 254

    pack_X, temp1, packSize, temp2 = FilterSize_Pack(res)

    if (floorColor == 2):  # 안전구역이면
        res_Area = Mask_Green(frame)
        area_X, temp1, temp2, temp3 = FilterSize_Pack(res_Area)
        print("packX" + str(pack_X) + "areaX" + str(area_X))
        if (pack_X > area_X):
            packLocation = 156
        else:
            packLocation = 155
    else:
        packLocation = 156

    print(str(pack_X) + "is X, and size is " + str(packSize) + "%")
    if (packSize > 0.05):  # 1로했을때 멀리있는건 안잡혔음
        print('Pack Detected')
        return 166
    else:
        print('No Pack')
        return 167


# 팩을 향해 가까이 가면서 고개를 내리는 함수
def GotoPack(frame):
    global abcdColor
    global lookDownCnt
    height, width, channel = frame.shape
    SaveImg(frame)

    if (abcdColor == 1):  # 빨간색이면
        res = Mask_Red(frame)
    elif (abcdColor == 2):  # 파란색이면
        res = Mask_Blue(frame)
    else:
        print('ABCD의 색깔 관측이 제대로 되지 않음')
        return 254

    centerX, centerY, centerSize, upperY = FilterSize_Pack(res)
    centerSize = int(centerSize)
    # print(str(centerX) + ":X, Y:" + str(centerY) + str(centerSize) + "centerSize, upperY"+str(upperY))
    print(upperY)
    if (centerSize == 0 and lookDownCnt == 0):
        print("No input")
        return 206  # 후진신호
    elif (centerSize == 0 and lookDownCnt > 0):
        print("No input")
        return 160  # go straight 신호
    elif (centerX < 45):
        print("Go Left")
        return 163
    elif (centerX > 55):
        print("Go Right")
        return 164
    elif (centerY > 70):
        print("Look Down")
        lookDownCnt = 1
        return 165
    elif (upperY > 0 and lookDownCnt == 1):  # 원래 15였음
        print("Pick the Pack")
        return 125
    else:
        print("Go straight")
        return 160


def FilterSize_Pack(frame):  # input : 이진화된 이미지, #output : centerX, centerY, objectSize, upperY
    height, width = frame.shape

    ## Dilated and processed
    kernel = cv2.getStructuringElement(cv2.MORPH_RECT, (3, 3))
    dilated = cv2.dilate(frame, kernel, iterations=2)

    ## Add a white line to outer sides of dilated
    cv2.rectangle(dilated, (0, 0), (np.shape(dilated)[1] - 1, np.shape(dilated)[0] - 1), (0, 0, 0), 1)

    ## Find Contours
    contours, hierarchy = cv2.findContours(dilated.copy(), cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)

    ## Find Bounding Boxes
    contours_poly = [None] * len(contours)
    boundRect = [None] * len(contours)

    for i, c in enumerate(contours):
        contours_poly[i] = cv2.approxPolyDP(c, 3, True)
        boundRect[i] = cv2.boundingRect(contours_poly[i])

    Biggest_size = 0
    x = 0
    y = 0
    x_length = 0
    y_length = 0

    for i in range(len(contours)):

        size = boundRect[i][2] * boundRect[i][3]
        # print(size)
        # print(boundRect)
        if (Biggest_size < size and size != width * height):
            x = int(boundRect[i][0])
            y = int(boundRect[i][1])
            x_length = int(boundRect[i][2])
            y_length = int(boundRect[i][3])
            Biggest_size = size

    centerX = (x + x_length * 0.5) / width * 100
    centerY = (y + y_length * 0.5) / height * 100
    upperY = y / height * 100
    objectSize = (Biggest_size * 100 / (height * width))

    ## Draw Bounding Boxes on original image, and print center coordinates
    cv2.rectangle(frame, (x, y), (x + x_length, y + y_length), (155, 155, 155), 2)
    # cv2.imshow('afd',frame)
    # print(int(centerX), int(centerY), objectSize, int(upperY))
    return int(centerX), int(centerY), objectSize, int(upperY)


# 통신변수들
global A, B
A = 0
B = 0
serial_port = None


# 통신부분
def TX_data_py2(ser, one_byte):  # one_byte= 0~255
    ser.write(serial.to_bytes([one_byte]))  # python3


def RX_data(ser):
    if ser.inWaiting() > 0:
        result = ser.read(1)
        RX = ord(result)
        return RX
    else:
        return 0


# 통신 쓰레드, A값을 갱신해주고 보낼 B값이 있으면 보내고 지워버린다.
def Receiving(ser):
    global A
    global B
    while True:

        if B > 0:
            TX_data_py2(ser, B)  # 송신부. 수신부와 송신부 서로 같은 채널을 공유하는듯.
            print('TX= ' + str(B))
            B = 0
        time.sleep(0.01)
        while ser.inWaiting() > 0:  # 뭔가 시리얼 포트로 부터 들어오는 값이 있으면 읽을 준비를 한다.
            RX = ser.read(1)
            if (A != ord(RX)):
                A = ord(RX)  # 문자의 유니코드값을 숫자화한다.
                print("RX=" + str(A))  # RX에 불러온값을 저장하여 문자열로 출력한다.


if __name__ == '__main__':

    frame = 0
    cap = cv2.VideoCapture(0)
    cap.set(3, 1280)  # 1440 #2592 그냥 늘려지는거.
    cap.set(4, int(1280 / 1.333))  # 1080 #int(W_View_size / 1.333)  # 사진이 이상하게 나온다면 W와 H픽셀수의 문제
    cap.set(5, 90)

    BPS = 4800
    serial_port = serial.Serial('/dev/ttyS0', BPS, timeout=0.01)
    serial_port.flush()  # serial cls

    serial_t = Thread(target=Receiving, args=(serial_port,))  # 아직은 쓰레드가 하나밖에 없음
    serial_t.daemon = True
    serial_t.start()
    TX_data_py2(serial_port, 111)

    while True:
        ret, img = cap.read()

        img = cv2.resize(img, dsize=(320, 240), interpolation=cv2.INTER_AREA)
        imgR = img[0:int(200 * 1), 0:320].copy()  # 480 400

        cv2.imshow('Original', img)
        cv2.imshow('A', Mask_Red(img))
        # cv2.imshow('B',Mask_Blue(img))

        frame = frame + 1
        if (frame > 10):
            # print(str(ABCD_list) + str(roomCnt))
            # B = IsTherePack(img)
            frame = 0
        if (A == 110):  # NEWS
            ret, img = cap.read()
            img = cv2.resize(img, dsize=(640, 480), interpolation=cv2.INTER_AREA)
            B = Read_NEWS(img)
            A = 0
        elif (A == 130):  # 마지막 확진구역 알파벳 말할때 로봇에게 알려줌
            if (len(ABCD_list) > 0):
                B = ABCD_list[0]
                print("send:" + str(B))
                del ABCD_list[0]
                A = 0
            else:
                B = 154
                A = 0
        elif (A == 131):  # IsTherepack에서 발견당시 왼쪽에 있었는지 오른쪽에 있었는지를 보내준다. 155왼쪽, 156오른
            B = packLocation
            print(packLocation)
            A = 0
        elif (A == 160 or A == 161 or A == 162):  # 고개돌릴때 팩이 있는지 여부 알려줌
            for i in range(5):
                ret, img = cap.read()
            img = cv2.resize(img, dsize=(320, 240), interpolation=cv2.INTER_AREA)

            if (IsTherePack(img) == 167):  # 팩이 없는경우는 203 204 205를 번갈아가면서 보내준다.
                if (A == 160):
                    B = 203
                elif (A == 161):
                    B = 204
                else:
                    B = 205
            else:  # 팩이있는경우는 166을 보내준다.
                if (A == 160):
                    B = 130
                elif (A == 161):
                    B = 131
                else:
                    B = 132

            time.sleep(0.3)
            A = 0
        elif (A == 180):  # 화살표 인식
            time.sleep(1)
            ret, img = cap.read()
            img = cv2.resize(img, dsize=(640, 480), interpolation=cv2.INTER_AREA)
            stepCnt = 0
            B = ReadArrow(img)
            A = 0
        elif (A == 181):  # 안전구역 확진구역 알려줌
            time.sleep(0.5)
            for i in range(5):
                ret, img = cap.read()
            SaveImg(img)
            img = cv2.resize(img, dsize=(640, 480), interpolation=cv2.INTER_AREA)
            B = ReadArea(img)
            A = 0
        elif (A == 182):  # ABCD 인식
            ret, img = cap.read()
            img = cv2.resize(img, dsize=(640, 480), interpolation=cv2.INTER_AREA)
            imgR = img[300:, :].copy()
            B = Read_ABCD(img)
            A = 0
        elif (A == 184):  # 팩집으러 갈때, Delay 이슈 있음, lookDownCnt를 재활용하기 때문에 영역봐주는 부분 + 차선 유지에서 reset을 해준다.
            for i in range(5):
                ret, imgR = cap.read()

            imgR = cv2.resize(imgR, dsize=(640, 480), interpolation=cv2.INTER_AREA)
            imgR = imgR[0:int(400), 0:640]
            B = GotoPack(imgR)

            if (
                    lookDownCnt == 1 and sleepCnt == 0):  # 두번 고개내리는 신호가 들어갈때 팩을 집으며, 5초대기는 처음 고개내릴때만 있게하고 싶기 때문에 두개의 cnt변수를 사용한다.
                time.sleep(2.5)
                sleepCnt = 1
            A = 0
        elif (A == 186):  # 초록색 안전구역에서 ROI중 어느정도가 차지되고 있는지 확인
            B = GotoArea(imgR)
            A = 0
        elif (A == 190 or A == 194):  # 차선유지, or A == 194를 따로 뺌
            time.sleep(0.3)

            for i in range(3):
                ret, imgR = cap.read()

            imgR = cv2.resize(imgR, dsize=(640, 480), interpolation=cv2.INTER_AREA)
            imgR = imgR[0:int(400 * 1), 0:640]
            cv2.waitKey(1)
            if (A == 190):
                B = ReadRoad(imgR)
                if (roomCnt >= 3):
                    time.sleep(0.3)
            elif (A == 194):
                B = ReadRoad(imgR)
            A = 0
        elif (A == 191):  # 코너쪽으로 접근하는 코드
            B = GotoCorner(imgR)
            A = 0
        elif (A == 192):  # 코너위에서 인식하는 경우 _ 고개돌리기 전
            B = OnCorner(imgR)
            A = 0
        elif (A == 193):  # 코너위에서 인식하는 경우_ 고개돌렸을때 선보이는지 여부, 여기서 변수 값 리셋
            if (floorColor != 0):
                roomCnt = roomCnt + 1
                floorColor = 0

            if (ABCD != 0):
                ABCD_list.append(ABCD)
                ABCD = 0
                print(ABCD_list)

            abcdColor = 0
            packLocation = 0

            lookDownCnt = 0
            sleepCnt = 0
            lookDownCnt_Corner = 0
            stepCnt = 0
            cornerState = 0

            B = OnCorner_IsThereLine(imgR)
            A = 0
        elif (A == 195):  # 코너 가까이에서 코너 바로 위로 접근하는 경우
            B = GotoCorner_Closely(imgR)
            A = 0

        cv2.waitKey(1)
# ver2.5

# 로봇 왼쪽 발 저는 문제

# T자에서 걷는 속도 낮게 되는지 확인해보기
# NEWS 왼쪽 오른쪽

# 동서남북 인식못하는 문제
# 동서남북에서 잘안가는 문제, TURN 문제.
# ABCD 인식시간

# 코너에서 각도못맞추고 가서 정면이 정면이 아닌문제, 초록색 위치를 기준으로 해서 체크 하기
# abcd가 중복해서 저자오디는 문제
# CUI 숙지하기, 라파 부팅시 자동실행 되도록해야함


## 초록색 영역 기준으로 판단
## 팩집을 때 위부분이 떨어졌는지 여부로
## 글로벌 변수 손대기


# 206 후진이 아니라 고개를 내려야 할듯