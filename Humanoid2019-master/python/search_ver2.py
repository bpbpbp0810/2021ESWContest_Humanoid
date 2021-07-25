import platform
import numpy as np
import argparse
import cv2
import time
import sys
import os

Top_name = 'Hands'

h_max =     [255,255,110] # Y-R-B
h_min =     [0,158,74]
    
s_max =     [255,255,255]
s_min =     [ 0,150,133]
    
v_max =     [255,239,255]
v_min =     [ 0,104,104]
min_area =  [ 10, 10, 10]
serial_use = 0
serial_port =  None
Temp_count = 0
Read_RX =  0


class Search():


    def __init__(self, BPS, W_View_size, H_View_size):
        self.BPS =  BPS
        self.W_View_size = W_View_size
        self.H_View_size = H_View_size
        self.slope_y=-1
        self.X_255_point0=0
        self.Y_255_point0=0
        self.operate_y = 0
        self.ap = argparse.ArgumentParser()
        self.ap.add_argument("-v", "--video",
                    help="path to the (optional) video file")
        self.ap.add_argument("-b", "--buffer", type=int, default=64,
                    help="max buffer size")
        self.args = vars(self.ap.parse_args())
        self.yuv_Lower = np.array([[80,130,65],[5,100,133],[65,104,104]])
        self.yuv_Upper = np.array([[110,150,100],[60,155,182],[100,239,255]])
        self.img = create_blank(320, 50, rgb_color=(0, 0, 255))
        cv2.namedWindow(Top_name)
        cv2.imshow(Top_name, self.img)
        
    #---------------------------
        if not self.args.get("video", False):
            self.camera = cv2.VideoCapture(0)
        else:
            self.camera = cv2.VideoCapture(self.args["video"])

        
    #---------------------------
        self.camera.set(3, self.W_View_size)
        self.camera.set(4, self.H_View_size)
        self.camera.set(5,60)
        time.sleep(0.5)        
    
    def yellow_line(self, View_select):
        #View_select = 0
        (grabbed1, frame1) = self.camera.read()
        yuv = cv2.cvtColor(frame1, cv2.COLOR_BGR2YCrCb)
        mask0 = cv2.inRange(yuv, self.yuv_Lower[0], self.yuv_Upper[0])
        mask0 = cv2.erode(mask0, None, iterations=1)
        mask0 = cv2.dilate(mask0, None, iterations=1)
        cnts0 = cv2.findContours(mask0.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
        center0 = None
        if len(cnts0) > 0:
            c = max(cnts0, key=cv2.contourArea)
            #((X, Y), radius) = cv2.minEnclosingCircle(c)
            cv2.drawContours(frame1, [c], 0, (0, 255, 0), 0)
            leftmost0 = tuple(c[c[:,:,0].argmin()][0])
            rightmost0 = tuple(c[c[:,:,0].argmax()][0])
            topmost0 = tuple(c[c[:,:,1].argmin()][0])
            bottommost0 = tuple(c[c[:,:,1].argmax()][0])
            Area0 = cv2.contourArea(c) / min_area[0]
            
            #cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 255), 2)
            if Area0 > 255:
                Area0 = 255
                #X_Size0 = int((255.0 / W_View_size) * w4)
                #Y_Size0 = int((255.0 / H_View_size) * h4)
                self.X_255_point0 = int(((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)*255/self.W_View_size)
                self.Y_255_point0 = int(((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)*255/self.H_View_size)
                self.slope_o=int(float((((topmost0[0]-bottommost0[0])/((bottommost0[1]-topmost0[1])*1.777))*100))+128)
                if self.slope_o < 0:
                    self.slope_y = 0
                elif self.slope_o > 255:
                    self.slope_y = 255
            elif Area0 > min_area[0]:
                #X_Size0 = int((255.0 / W_View_size) * w4)
                #Y_Size0 = int((255.0 / H_View_size) * h4)
                self.X_255_point0 = int(((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)*255/self.W_View_size)
                self.Y_255_point0 = int(((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)*255/self.H_View_size)
                self.slope_o=int(float((((topmost0[0]-bottommost0[0])/((bottommost0[1]-topmost0[1])*1.777))*100))+128)
                if self.slope_o < 0:
                    self.slope_y = 0
                elif self.slope_o > 255:
                    self.slope_y = 255
            else:
                self.X_255_point0 = int(((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)*255/self.W_View_size)
                self.Y_255_point0 = int(((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)*255/self.H_View_size)
                self.slope_o=int(float((((topmost0[0]-bottommost0[0])/((bottommost0[1]-topmost0[1])*1.777))*100))+128)
                if self.slope_o < 0:
                    self.slope_y = 0
                elif self.slope_o > 255:
                    self.slope_y = 255
            
        else:
            self.X_255_point0 = 0
            self.Y_255_point0 = 0
            Area0 = 0
            self.slope_y=0
            
        #center_yellow_X = X_255_point0
        #center_yellow_Y = Y_255_point0
    

        #Frame_time = (clock() - old_time) * 1000.
        #old_time = clock()  
        if View_select == 0: # Fast operation 
            #print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
            #temp = Read_RX
            #print(self.slope_y)
            pass
        elif View_select == 1: # Debug
            cv2.imshow('Hands0', frame1)
            cv2.imshow('Hands_mask0', mask0)
            #cv2.imshow('Hands1', self.frame)
            #print(self.slope_y)

                
    def blue_area(self, View_select):
        #old_time = clock()
        #View_select = 0
        (grabbed2, frame2) = self.camera.read()
        yuv = cv2.cvtColor(frame2, cv2.COLOR_BGR2YCrCb)
        mask1 = cv2.inRange(yuv, self.yuv_Lower[1], self.yuv_Upper[1])
        mask1 = cv2.erode(mask1, None, iterations=1)
        mask1 = cv2.dilate(mask1, None, iterations=1)
        cnts1 = cv2.findContours(mask1.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
        center1 = None
        if len(cnts1) > 0:
            c1 = max(cnts1, key=cv2.contourArea)
            #((X, Y), radius) = cv2.minEnclosingCircle(c)
            cv2.drawContours(frame2, [c1], 0, (0, 255, 0), 0)
            leftmost1 = tuple(c1[c1[:,:,0].argmin()][0])
            rightmost1 = tuple(c1[c1[:,:,0].argmax()][0])
            topmost1 = tuple(c1[c1[:,:,1].argmin()][0])
            bottommost1 = tuple(c1[c1[:,:,1].argmax()][0])
            Area1 = cv2.contourArea(c1) / min_area[0]
            

            
        else:
            X_255_point0 = 0
            Y_255_point0 = 0
            #Area0 = 0
            
        #center_yellow_X = X_255_point0
        #center_yellow_Y = Y_255_point0
        

        #Frame_time = (clock() - old_time) * 1000.
        #old_time = clock()  
        if View_select == 0: # Fast operation 
            #print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
            #temp = Read_RX
            #print(X_255_point0)
            pass
        elif View_select == 1: # Debug
            cv2.imshow('Hands1', frame2)
            cv2.imshow('Hands_mask1', mask1)
            #cv2.imshow('Hands1', self.frame)

    def grean_area(self, View_select):
        pass
        

def create_blank(width, height, rgb_color=(0, 0, 0)):

    image = np.zeros((height, width, 3), np.uint8)
    color = tuple(reversed(rgb_color))
    image[:] = color

    return image


def TX_data(serial, one_byte):  # one_byte= 0~255
    global Temp_count
    try:
        serial.write(chr(int(one_byte)))
    except:
        Temp_count = Temp_count  + 1
        print("Serial Not Open " + str(Temp_count))
        pass
#-----------------------------------------------
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
        Temp_count = Temp_count  + 1
        print("Serial Not Open " + str(Temp_count))
        return 0
        pass  
#--------------
               
def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()
#----------------------------------------------- 

