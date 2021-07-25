#-*- coding:utf-8 -*-
import platform
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
LEFT_5 = -50
LEFT_6 = -60
LEFT_7 = -70
LEFT_8 = -80
LEFT_9 = -90
LEFT_10 = -100
LEFT_11 = -110
LEFT_12 = -120
RIGHT_1 = 10
RIGHT_2 = 20
RIGHT_3 = 30
RIGHT_4 = 40
RIGHT_5 = 50
RIGHT_6 = 60
RIGHT_7 = 70
RIGHT_8 = 80
RIGHT_9 = 90
RIGHT_10 = 100
RIGHT_11 = 110
RIGHT_12 = 120


class Search():


    def __init__(self, BPS, W_View_size, H_View_size):
        self.BPS =  BPS
        self.W_View_size = W_View_size   #320
        self.H_View_size = H_View_size   #240
        self.slope_yellow = 0
        self.slope_yellow_R = 0
        self.corner_slope = 0
        self.center_yellow_X=0
        self.center_yellow_X_R=0
        self.center_yellow_Y=0
        self.center_yellow_X255 = 0
        self.center_yellow_Y255 = 0
        self.center_green_X=0
        self.center_green_Y=0
        self.operate_y = 0
        self.operate_g = 0
        self.View_select_y = 0
        self.View_select_g = 0
        self.View_select_y_d = 0
        self.door = 0
        self.ap = argparse.ArgumentParser()
        self.ap.add_argument("-v", "--video",
                    help="path to the (optional) video file")
        self.ap.add_argument("-b", "--buffer", type=int, default=64,
                    help="max buffer size")
        self.args = vars(self.ap.parse_args())
        self.yuv_Lower = np.array([[45,110,30],[30,12,46],[40,100,20]])
        self.yuv_Upper = np.array([[160,190,110],[126,120,135],[180,190,110]])
        self.min_area =  [ 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]
        self.img = create_blank(320, 50, rgb_color=(0, 0, 255))
        cv2.namedWindow(Top_name)
        cv2.imshow(Top_name, self.img)

    #---------------------------------------------------------
        if not self.args.get("video", False):
            self.camera = cv2.VideoCapture(0)
        else:
            self.camera = cv2.VideoCapture(self.args["video"])
    #---------------------------------------------------------------
        self.camera.set(3, self.W_View_size)
        self.camera.set(4, self.H_View_size)
        self.camera.set(5,60)
        time.sleep(0.5)  

    def yellow_line(self, View_select_y, operate, operate_all, corner):
        
        self.slope_yellow = 0
        slope = []
        slope_another = 0
        center_x = []
        center_y = []
        theta = 0
        rho = 0
        x1 = 0
        x2 = 0
        y1 = 0
        y2 = 0
  
        
        
        if operate == 1:
            (grabbed1, frame1) = self.camera.read()
            yuv = cv2.cvtColor(frame1, cv2.COLOR_BGR2YCrCb)
            mask0 = cv2.inRange(yuv, self.yuv_Lower[0], self.yuv_Upper[0])
            mask0 = cv2.erode(mask0, None, iterations=1)
            mask0 = cv2.dilate(mask0, None, iterations=1)
            edges = cv2.Canny(mask0, 75, 150, apertureSize=5, L2gradient=True)
            lines = cv2.HoughLines(edges, 1, np.pi / 180, 40)
            #cnts0 = cv2.findContours(mask0.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            #center0 = None
            

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
                        theta_degree = int(theta*180/np.pi)

                        #slope_degree.append(theta_degree)

                        if 120 >= theta_degree >= 60 and ((y1+y2)/2)>160:          #detect horizontal line
                            slope_another = 255
                        elif 120 >= theta_degree >= 60 and 160>=((y1+y2)/2)>120:          #detect horizontal line
                            slope_another = 254
                        elif 120 >= theta_degree >= 60 and 120>=((y1+y2)/2)>80:          #detect horizontal line
                            slope_another = 253
                        elif 120 >= theta_degree >= 60 and ((y1+y2)/2)<=80:
                            pass
                        else:
                            center_x.append(-(self.H_View_size-y0) * np.tan(theta) + x0)
                            #center_y.append(-(self.W_View_size-x0) * np.tan(theta) + y0)
                        if 0 <= theta_degree < 5:
                            slope.append(LEFT_1)
                        elif 5 <= theta_degree < 10:
                            slope.append(LEFT_2)
                        elif 10 <= theta_degree < 15:
                            slope.append(LEFT_3)
                        elif 15 <= theta_degree < 20:
                            slope.append(LEFT_4)
                        elif 20 <= theta_degree < 25:
                            slope.append(LEFT_5)
                        elif 25 <= theta_degree < 30:
                            slope.append(LEFT_6)
                        elif 30 <= theta_degree < 35:
                            slope.append(LEFT_7)
                        elif 35 <= theta_degree < 40:
                            slope.append(LEFT_8)
                        elif 40 <= theta_degree < 45:
                            slope.append(LEFT_9)
                        elif 45 <= theta_degree < 50:
                            slope.append(LEFT_10)
                        elif 50 <= theta_degree < 55:
                            slope.append(LEFT_11)
                        elif 55 <= theta_degree < 60:
                            slope.append(LEFT_12)
                        elif 180 >= theta_degree > 175:
                            slope.append(RIGHT_1)
                        elif 175 >= theta_degree > 170:
                            slope.append(RIGHT_2)
                        elif 170 >= theta_degree > 165:
                            slope.append(RIGHT_3)
                        elif 165 >= theta_degree > 160:
                            slope.append(RIGHT_4)  
                        elif 160 >= theta_degree > 155:
                            slope.append(RIGHT_5)  
                        elif 155 >= theta_degree > 150:
                            slope.append(RIGHT_6) 
                        elif 150 >= theta_degree > 145:
                            slope.append(RIGHT_7)
                        elif 145 >= theta_degree > 140:
                            slope.append(RIGHT_8)
                        elif 140 >= theta_degree > 135:
                            slope.append(RIGHT_9)
                        elif 135 >= theta_degree > 130:
                            slope.append(RIGHT_10)
                        elif 130 >= theta_degree > 125:
                            slope.append(RIGHT_11)
                        elif 125 >= theta_degree > 120:
                            slope.append(RIGHT_12)
                        else:
                            pass

            else:
                pass
                #print("NO LINE DETECTED")


            if len(slope) == 0:
                self.slope_yellow = 0
                self.corner_slope = 0
                self.center_yellow_X = 0
            else:
                self.slope_yellow = int(np.mean(slope)+128)
                X_point_320 = int(np.mean(center_x))
                if X_point_320 <= 0:
                    X_point_320 = 20
                elif X_point_320 >= 255:
                    X_point_320 = 250
 
                self.center_yellow_X = int(X_point_320 * 255 / 320)

            if corner == 0  and slope_another == 255:            #if we detect horizontal line
                self.corner_slope = 255
                slope_another = 0
                

            elif corner == 0  and slope_another == 254:                            #if we detect horizontal line
                #self.slope_yellow = 254  
                self.corner_slope = 254                       #then slope_yellow is 255
                slope_another = 0

            elif corner == 0  and slope_another == 253:         #if we detect horizontal line
                #self.slope_yellow = 253                         #then slope_yellow is 255
                self.corner_slope = 253
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
        if operate_all == 0:
            cv2.destroyAllWindows()
            self.camera.release()

    def yellow_line_R(self, View_select_y, operate, operate_all):
        
        self.slope_yellow_R = 0
        slope = []
        center_x = []
        center_y = []
        theta = 0
        rho = 0
        x1 = 0
        x2 = 0
        y1 = 0
        y2 = 0
  
        
        
        if operate == 1:
            (grabbed3, frame3) = self.camera.read()
            yuv = cv2.cvtColor(frame3, cv2.COLOR_BGR2YCrCb)
            mask3 = cv2.inRange(yuv, self.yuv_Lower[2], self.yuv_Upper[2])
            mask3 = cv2.erode(mask3, None, iterations=1)
            mask3 = cv2.dilate(mask3, None, iterations=1)
            edges = cv2.Canny(mask3, 75, 150, apertureSize=5, L2gradient=True)
            lines = cv2.HoughLines(edges, 1, np.pi / 180, 70)
            #cnts0 = cv2.findContours(mask0.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            #center0 = None
            

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
                        cv2.line(frame3, (x1, y1), (x2, y2), (0, 255, 0), 3)
                        theta_degree = int(theta*180/np.pi)

                        #slope_degree.append(theta_degree)

                        if 120 >= theta_degree >= 60 and ((y1+y2)/2)>160:          #detect horizontal line
                            #slope_another = 255
                            pass
                        elif 120 >= theta_degree >= 60 and 160>=((y1+y2)/2)>120:          #detect horizontal line
                            #slope_another = 254
                            pass
                        elif 120 >= theta_degree >= 60 and 120>=((y1+y2)/2)>80:          #detect horizontal line
                            #slope_another = 253
                            pass
                        elif 120 >= theta_degree >= 60 and ((y1+y2)/2)<=80:
                            pass
                        else:
                            center_x.append(-(self.H_View_size-y0) * np.tan(theta) + x0)
                            #center_y.append(-(self.W_View_size-x0) * np.tan(theta) + y0)
                        if 0 <= theta_degree < 5:
                            slope.append(LEFT_1)
                        elif 5 <= theta_degree < 10:
                            slope.append(LEFT_2)
                        elif 10 <= theta_degree < 15:
                            slope.append(LEFT_3)
                        elif 15 <= theta_degree < 20:
                            slope.append(LEFT_4)
                        elif 20 <= theta_degree < 25:
                            slope.append(LEFT_5)
                        elif 25 <= theta_degree < 30:
                            slope.append(LEFT_6)
                        elif 30 <= theta_degree < 35:
                            slope.append(LEFT_7)
                        elif 35 <= theta_degree < 40:
                            slope.append(LEFT_8)
                        elif 40 <= theta_degree < 45:
                            slope.append(LEFT_9)
                        elif 45 <= theta_degree < 50:
                            slope.append(LEFT_10)
                        elif 50 <= theta_degree < 55:
                            slope.append(LEFT_11)
                        elif 55 <= theta_degree < 60:
                            slope.append(LEFT_12)
                        elif 180 >= theta_degree > 175:
                            slope.append(RIGHT_1)
                        elif 175 >= theta_degree > 170:
                            slope.append(RIGHT_2)
                        elif 170 >= theta_degree > 165:
                            slope.append(RIGHT_3)
                        elif 165 >= theta_degree > 160:
                            slope.append(RIGHT_4)  
                        elif 160 >= theta_degree > 155:
                            slope.append(RIGHT_5)  
                        elif 155 >= theta_degree > 150:
                            slope.append(RIGHT_6) 
                        elif 150 >= theta_degree > 145:
                            slope.append(RIGHT_7)
                        elif 145 >= theta_degree > 140:
                            slope.append(RIGHT_8)
                        elif 140 >= theta_degree > 135:
                            slope.append(RIGHT_9)
                        elif 135 >= theta_degree > 130:
                            slope.append(RIGHT_10)
                        elif 130 >= theta_degree > 125:
                            slope.append(RIGHT_11)
                        elif 125 >= theta_degree > 120:
                            slope.append(RIGHT_12)
                        else:
                            pass

            else:
                pass
                #print("NO LINE DETECTED")


            if len(slope) == 0:
                self.slope_yellow_R = 0
                self.center_yellow_X_R = 0
            else:
                self.slope_yellow_R = int(np.mean(slope)+128)
                X_point_320_R = int(np.mean(center_x))
                if X_point_320_R <= 0:
                    X_point_320_R = 20
                elif X_point_320_R >= 255:
                    X_point_320_R = 250
 
                self.center_yellow_X_R = int(X_point_320_R * 255 / 320)

            """if corner == 0  and slope_another == 255:            #if we detect horizontal line
                #self.corner_slope_R = 255
                pass

            elif corner == 0  and slope_another == 254:                            #if we detect horizontal line
                #self.slope_yellow = 254  
                #self.corner_slope = 254                       #then slope_yellow is 255
                #slope_another = 0
                pass
            elif corner == 0  and slope_another == 253:         #if we detect horizontal line
                #self.slope_yellow = 253                         #then slope_yellow is 255
                #elf.corner_slope = 253
                #slope_another = 0
                pass"""
            if View_select_y == 0: # Fast operation 
                #print("time=  %.1f ms" % (Frame_time))
                #print(X_point_255)
                #print(self.slope_yellow)
                pass
            elif View_select_y == 1: # Debug
                cv2.imshow('Hands', frame3)
                cv2.imshow("edges", edges)
                cv2.imshow('Hands_mask', mask3)
                #print(slope_y)
                #print(self.center_yellow_X)
                #print(self.center_yellow_Y)
        if operate_all == 0:
            cv2.destroyAllWindows()
            self.camera.release()


    def yellow_detect(self, View_select_y_d, operate):
        self.center_yellow_X255 = 0
        if operate ==1:
            #print("yellow detect")
            self.center_yellow_X255 = 0
            (grabbed2, frame3) = self.camera.read()
            yuv2 = cv2.cvtColor(frame3, cv2.COLOR_BGR2YCrCb)
            mask2 = cv2.inRange(yuv2, self.yuv_Lower[0], self.yuv_Upper[0])
            mask2 = cv2.erode(mask2, None, iterations=1)
            mask2 = cv2.dilate(mask2, None, iterations=1)
            cnts0 = cv2.findContours(mask2.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            center0 = None
            slope = 0
            if len(cnts0) > 0:
                c = max(cnts0, key=cv2.contourArea)
                #((X, Y), radius) = cv2.minEnclosingCircle(c)
                cv2.drawContours(frame3, [c], 0, (0, 255, 0), 0)
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
                    if bottommost0[1]-topmost0[1] == 0:
                        slope_o = 0
                    else:
                        slope_o=float((((topmost0[0]-bottommost0[0])/((bottommost0[1]-topmost0[1])*1.777))*100))
                    slope=int(slope_o+60) 
                elif Area0 > self.min_area[0]:
                    X_320_point0 = int((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)
                    Y_240_point0 = int((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)
                    #X_255_point0 = int((leftmost[0]+rightmost[0]+topmost[0]+bottommost[0])/4)
                    #Y_255_point0 = int((leftmost[1]+rightmost[1]+topmost[1]+bottommost[1])/4)
                    if bottommost0[1]-topmost0[1] == 0:
                        slope_o = 0
                    else:
                        slope_o=float((((topmost0[0]-bottommost0[0])/((bottommost0[1]-topmost0[1])*1.777))*100))
                    slope=int(slope_o+60) 
                else:
                    X_320_point0 = int((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)
                    Y_240_point0 = int((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)
                    if bottommost0[1]-topmost0[1] == 0:
                        slope_o = 0
                    else:
                        slope_o=float((((topmost0[0]-bottommost0[0])/((bottommost0[1]-topmost0[1])*1.777))*100))
                    slope=int(slope_o+60) 
            else:
                X_320_point0 = 0
                Y_240_point0 = 0
                slope = 0
                Area0 = 0

            self.center_yellow_X255 = int(X_320_point0*255/320)
            self.center_yellow_Y255 = int(Y_240_point0*255/240)

            if self.center_yellow_X255 > 0:
                if slope<50  :
                    self.door = 103
                elif slope>50 and slope<70 :
                    if self.center_yellow_X255 > 130 and self.center_yellow_X255 < 190:
                        self.door = 128 
                    elif self.center_yellow_X255 > 190:
                        self.door = 130
                    elif self.center_yellow_X255 <130:
                        self.door = 150
                elif slope>70 and slope <150:
                    self.door = 153
                else:
                    self.door = 0
            else :
                self.door = 0

            
            if View_select_y_d == 0: # Fast operation 

                #print(self.center_yellow_X255)
                pass

            elif View_select_y_d == 1: # Debug
                cv2.imshow('Hands', frame3)
                cv2.imshow('Hands_mask', mask2)

    def green_detect(self, View_select_g, operate):
        #act = 0
        if operate ==1:
            #act = 1
            #print("green detect")
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
                #print(self.center_green_X)
                pass

            elif View_select_g == 1: # Debug
                cv2.imshow('Hands', frame2)
                cv2.imshow('Hands_mask', mask1)
        
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

