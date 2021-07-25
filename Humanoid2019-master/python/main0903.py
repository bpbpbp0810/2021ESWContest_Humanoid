import platform
import serial
import search_ver2 as search
#from multiprocessing import Process
from threading import Thread
import os
import sys
import time
import cv2
import numpy as np

serial_use = 0
serial_port = None
Temp_count = 0
Read_RX = 0
line = []
slope_y = 0
X_point_320 = 0
Y_point_240 = 0
flag = 1

LEFT_1 = -10
LEFT_2 = -20
LEFT_3 = -30
LEFT_4 = -40
RIGHT_1 = 10
RIGHT_2 = 20
RIGHT_3 = 30
RIGHT_4 = 40


def TX_data(serial, one_byte):  # one_byte= 0~255
    global Temp_count
    try:
        serial.write(chr(int(one_byte)))
    except:
        Temp_count = Temp_count + 1
        print("Serial Not Open " + str(Temp_count))
        # pass
# -----------------------------------------------


def RX_data(serial):
    global Temp_count
    try:
        if serial.inWaiting() > 0:
            result = serial.read(1)
            RX = ord(result)
            return RX
        else:
            return 0
    except:
        Temp_count = Temp_count + 1
        print("Serial Not Open " + str(Temp_count))
        return 0
        # pass
# ------------------


def RX_data2(serial):
    global Temp_count
    global Read_RX
    global flag
    while flag:
        try:
            if serial.inWaiting() > 0:
                result = serial.read(1)
                Read_RX = ord(result)
                # return RX
            else:
                Read_RX = 0
        except:
            Temp_count = Temp_count + 1
            print("Serial Not Open " + str(Temp_count))
# return 0
            Read_RX = 0
        time.sleep(0.005)


def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()

def green_detect():
    global X_255_point0
    global Y_255_point0
    i = 50
    cap1 = cv2.VideoCapture(0)
    ret1, frame1 = cap1.read()
    W_View_size1 = 320
    H_View_size1 = 240
    cap1.set(3, W_View_size1)
    cap1.set(4, H_View_size1)
    cap1.set(5, 60)
    time.sleep(0.5)

    yuv_Lower1 = np.array([0, 0, 0])
    yuv_Upper1 = np.array([0, 0, 0])
    View_select1 = 0

    while(i):
        yuv1 = cv2.cvtColor(frame1, cv2.COLOR_BGR2YCrCb)
        mask1 = cv2.inRange(yuv1, yuv_Lower1, yuv_Upper1)
        mask1 = cv2.erode(mask1, None, iterations=1)
        mask1 = cv2.dilate(mask1, None, iterations=1)
        cnts1 = cv2.findContours(mask1.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
        center1 = None
        if len(cnts1) > 0:
            c1 = max(cnts1, key=cv2.contourArea)
            # ((X, Y), radius) = cv2.minEnclosingCircle(c)
            cv2.drawContours(frame1, [c1], 0, (0, 255, 0), 0)
            leftmost0 = tuple(c1[c1[:, :, 0].argmin()][0])
            rightmost0 = tuple(c1[c1[:, :, 0].argmax()][0])
            topmost0 = tuple(c1[c1[:, :, 1].argmin()][0])
            bottommost0 = tuple(c1[c1[:, :, 1].argmax()][0])
            Area1 = cv2.contourArea(c1) / min_area[0]

            if Area1 > 255:
                Area0 = 255
                X_255_point0 = int((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)
                Y_255_point0 = int((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)
            elif Area0 > min_area[0]:
                X_255_point0 = int((leftmost0[0] + rightmost0[0] + topmost0[0] + bottommost0[0]) / 4)
                Y_255_point0 = int((leftmost0[1] + rightmost0[1] + topmost0[1] + bottommost0[1]) / 4)

            else:
                X_255_point0 = int((leftmost0[0] + rightmost0[0] + topmost0[0] + bottommost0[0]) / 4)
                Y_255_point0 = int((leftmost0[1] + rightmost0[1] + topmost0[1] + bottommost0[1]) / 4)

        else:
            X_255_point0 = 0
            Y_255_point0 = 0
            Area0 = 0
        i= i-1




def main():
    global slope_y
    global X_point_320
    global flag
    serial_use = 1
    if serial_use <> 0:
        serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
        # serial_port.flush()
        t = Thread(target=RX_data2, args=(serial_port, ))
        time.sleep(0.1)
        t.deamon = True
        t.start() 

    #t1 = Thread(target=green_detect,args=(,))
    #time.sleep(0.1)
    #t1.deamon = True

    windowName = "Preview"
    cv2.namedWindow(windowName)
    cap = cv2.VideoCapture(0)
    W_View_size = 320
    H_View_size = 240
    cap.set(3, W_View_size)
    cap.set(4, H_View_size)
    cap.set(5, 60)
    time.sleep(0.5)

        
    yuv_Lower = np.array([40, 88, 35])
    yuv_Upper = np.array([150, 233, 111])
    View_select = 0

    while True:
        slope = []
        
        old_time = clock()
        ret, frame = cap.read()
        yuv = cv2.cvtColor(frame, cv2.COLOR_BGR2YCrCb)
        mask = cv2.inRange(yuv, yuv_Lower, yuv_Upper)
        mask0 = cv2.erode(mask, None, iterations=1)
        mask0 = cv2.dilate(mask0, None, iterations=1)
        edges = cv2.Canny(mask0, 75, 150, apertureSize=5, L2gradient=True)
        lines = cv2.HoughLines(edges, 1, np.pi / 180, 70)
        #lines = cv2.HoughLinesP(edges, 1, np.pi / 180, 70, minLineLength = 150, maxLineGap = 10)
        slope_y = 0
        center_x = []
        if lines is not None:
            for x in range(0, len(lines)):
                for rho, theta in lines[x]:
                    # x1, y1, x2, y2 = lines[0]
                    # cv2.line(frame, (x1, y1), (x2, y2), (0,0,255), 3)
                    a = np.cos(theta)
                    b = np.sin(theta)
                    x0 = a * rho
                    y0 = b * rho
                    #l = (240-y0) * np.tan(theta)
                    x1 = int(x0 + 300 * (-b))
                    y1 = int(y0 + 300 * (a))
                    x2 = int(x0 - 300 * (-b))
                    y2 = int(y0 - 300 * (a))
                    cv2.line(frame, (x1, y1), (x2, y2), (0, 255, 0), 3)
                    #print(x0, y0, x1, y1, x2, y2)
                    center_x.append(-(240-y0) * np.tan(theta) + x0)
                    theta_degree = int(theta*180/np.pi)
                    # if theta*180/np.pi > 90 :
                    # return [x, theta*180/np.pi, x1, x2]
                    # line.append([x1,x2,theta*180/np.pi])
                    if 0 <= theta_degree < 10:
                        slope.append(LEFT_1)
                    elif 10 <= theta_degree < 20:
                        slope.append(LEFT_2)
                    elif 20 <= theta_degree < 30:
                        slope.append(LEFT_3)
                    elif 30 <= theta_degree < 40:
                        slope.append(LEFT_4)
                    elif 180 >= theta_degree > 170:
                        slope.append(RIGHT_1)
                    elif 170 >= theta_degree > 160:
                        slope.append(RIGHT_2)
                    elif 160 >= theta_degree > 150:
                        slope.append(RIGHT_3)
                    elif 150 >= theta_degree > 140:
                        slope.append(RIGHT_4)
                    else:
                        pass
                        
        else:
            print("NO LINE DETECTED")

        if len(slope) == 0:
            slope_y = 1000
            X_point_255 = 0
        else:
            slope_y = int(np.mean(slope)+128)
            X_point_320 = int(np.mean(center_x))
            X_point_255 = int(X_point_320 * 255 / 320)
        # slope_y = 0

        # for x in range(0, len(slope)):
        #     slope_y += slope[x]
        # if len(slope) == 0:
        #     print("No line: pass")
        #     slope_y = 10000
        #     #break
        # else:
        #     slope_y = int(slope_y / len(slope))
        key = 0xFF & cv2.waitKey(1)

        if key == 27:  # exit on ESC
            flag = 0
            break
        
        
        elif key == ord(' '):  # spacebar Key
            if View_select == 0:
                View_select = 1
            else:
                View_select = 0

        if Read_RX == 111:
            TX_data(serial_port, slope_y)
            print("slope_y")
        elif Read_RX == 112:
            TX_data(serial_port, X_point_255)
            print("X_point_255")
        elif Read_RX == 121:
            TX_data(serial_port, X_255_point0)
            print("X_255_point0")
        elif Read_RX ==122:
            TX_data(serial_port, Y_255_point0)
            print("Y_255_point0")


        Frame_time = (clock() - old_time) * 1000.
        old_time = clock()
        
        if View_select == 0:  # Fast operation
            print("time=  %.1f ms" % (Frame_time))
            #print(X_point_255)
            print(slope_y)
        elif View_select == 1:  # Debug
            cv2.imshow("windowName", frame)
            cv2.imshow("edges", edges)
            cv2.imshow("yuv", mask0)

    cv2.destroyAllWindows()
    cap.release()
    #t.join()
    #break
    # ------------------


if __name__ == '__main__':
    BPS = 4800
    
    main()
    
    #start_signal = 1
    

    
