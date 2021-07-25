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
import argparse

Top_name = 'Hands'
LEFT_1 = -10
LEFT_2 = -20
LEFT_3 = -30
LEFT_4 = -40
RIGHT_1 = 10
RIGHT_2 = 20
RIGHT_3 = 30
RIGHT_4 = 40

class Search():


    def __init__(self, BPS, W_View_size, H_View_size):
        self.BPS =  BPS
        self.W_View_size = W_View_size   #240
        self.H_View_size = H_View_size   #320
        self.slope_yellow = 0
        self.center_yellow_X=0
        self.center_yellow_Y=0
        self.center_green_X=0
        self.center_green_Y=0
        self.operate_y = 0
        self.operate_g = 0
        self.View_select_y = 0
        self.View_select_g = 0
        self.ap = argparse.ArgumentParser()
        self.ap.add_argument("-v", "--video",
                    help="path to the (optional) video file")
        self.ap.add_argument("-b", "--buffer", type=int, default=64,
                    help="max buffer size")
        self.args = vars(self.ap.parse_args())
        self.yuv_Lower = np.array([[40,100,23],[30,12,46],[65,104,104]])
        self.yuv_Upper = np.array([[140,255,120],[126,120,135],[100,239,255]])
        self.min_area =  [ 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
        self.img = create_blank(320, 50, rgb_color=(0, 0, 255))
        cv2.namedWindow(Top_name)
        cv2.imshow(Top_name, self.img)

    #---------------------------
        if not self.args.get("video", False):
            self.camera = cv2.VideoCapture(0)
        else:
            self.camera = cv2.VideoCapture(self.args["video"])

    
    #---------------------------
        self.camera.set(3, self.H_View_size)
        self.camera.set(4, self.W_View_size)
        self.camera.set(5,60)
        time.sleep(0.5)  

    def yellow_line(self, View_select_y, operate):
        #k = self.operate_y
        #while True: #Y
        #old_time = clock()
        slope = []
        slope_another = 0
        (grabbed1, frame1) = self.camera.read()
        yuv = cv2.cvtColor(frame1, cv2.COLOR_BGR2YCrCb)
        mask0 = cv2.inRange(yuv, self.yuv_Lower[0], self.yuv_Upper[0])
        mask0 = cv2.erode(mask0, None, iterations=1)
        mask0 = cv2.dilate(mask0, None, iterations=1)
        edges = cv2.Canny(mask0, 75, 150, apertureSize=5, L2gradient=True)
        lines = cv2.HoughLines(edges, 1, np.pi / 180, 70)
        #cnts0 = cv2.findContours(mask0.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
        #center0 = None
        self.slope_yellow = 0
        center_x = []

        if lines is not None:
            for x in range(0, len(lines)):
                for rho, theta in lines[x]:
                    a = np.cos(theta)
                    b = np.sin(theta)
                    x0 = a * rho
                    y0 = b * rho
                    x1 = int(x0 + 300 * (-b))
                    y1 = int(y0 + 300 * (a))
                    x2 = int(x0 - 300 * (-b))
                    y2 = int(y0 - 300 * (a))
                    cv2.line(frame1, (x1, y1), (x2, y2), (0, 255, 0), 3)
                    center_x.append(-(self.W_View_size-y0) * np.tan(theta) + x0)
                    theta_degree = int(theta*180/np.pi)
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
                    elif 100 >= theta_degree > 80:          #detect horizontal line
                        slope_another = 255                 
                    else:
                        pass

        else:
            pass
            #print("NO LINE DETECTED")

        if len(slope) == 0:
            self.slope_yellow = 0
            self.center_yellow_X = 0
        else:
            self.slope_yellow = int(np.mean(slope)+128)
            X_point_320 = int(np.mean(center_x))
            self.center_yellow_X = int(X_point_320 * 255 / 320)

        if slope_another == 255:                            #if we detect horizontal line
            self.slope_yellow = 255                         #then slope_yellow is 255
            slope_another = 0

        if View_select_y == 0: # Fast operation 
            #print("time=  %.1f ms" % (Frame_time))
        #print(X_point_255)
            #print(self.slope_yellow)
            pass
        elif View_select_y == 1: # Debug
            cv2.imshow('Hands', frame1)
            cv2.imshow("edges", edges)
            cv2.imshow('Hands_mask', mask0)
            #print(slope_y)
            #print(self.center_yellow_X)
            #print(self.center_yellow_Y)
        if operate == 0:
            cv2.destroyAllWindows()
            self.camera.release()


    def green_detect(self, View_select_g, operate):

        (grabbed2, frame2) = self.camera.read()
        yuv1 = cv2.cvtColor(frame2, cv2.COLOR_BGR2YCrCb)
        mask1 = cv2.inRange(yuv1, self.yuv_Lower[1], self.yuv_Upper[1])
        mask1 = cv2.erode(mask1, None, iterations=1)
        mask1 = cv2.dilate(mask1, None, iterations=1)
        cnts0 = cv2.findContours(mask1.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
        center0 = None
        if len(cnts0) > 0:
            c = max(cnts0, key=cv2.contourArea)
            #((X, Y), radius) = cv2.minEnclosingCircle(c)
            cv2.drawContours(frame2, [c], 0, (0, 255, 0), 0)
            leftmost0 = tuple(c[c[:,:,0].argmin()][0])
            rightmost0 = tuple(c[c[:,:,0].argmax()][0])
            topmost0 = tuple(c[c[:,:,1].argmin()][0])
            bottommost0 = tuple(c[c[:,:,1].argmax()][0])
            Area0 = cv2.contourArea(c) / self.min_area[0]
            #x4, y4, w4, h4 = cv2.boundingRect(c)
            #cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 255), 2)
            if Area0 > 255:
                Area0 = 255
                X_320_point0 = int((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)
                Y_240_point0 = int((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)

            elif Area0 > self.min_area[0]:
                X_320_point0 = int((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)
                Y_240_point0 = int((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)

            else:
                X_320_point0 = int((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)
                Y_240_point0 = int((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)

        else:
            X_320_point0 = 0
            Y_240_point0 = 0
            Area0 = 0


        self.center_green_X = int(X_320_point0*255/320)
        self.center_green_Y = int(Y_240_point0*255/240)

        if View_select_g == 0: # Fast operation 
            print(self.center_green_X)
            #pass

        elif View_select_g == 1: # Debug
            cv2.imshow('Hands', frame2)
            cv2.imshow('Hands_mask', mask1)

        if operate == 0:
            cv2.destroyAllWindows()
            self.camera.release()

def create_blank(width, height, rgb_color=(0, 0, 0)):

    image = np.zeros((height, width, 3), np.uint8)
    color = tuple(reversed(rgb_color))
    image[:] = color

    return image
#------------------------
def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()
#----------------------------------------------- 
#-----------------------------------------------

