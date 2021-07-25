import platform
import numpy as np
import argparse
import cv2
import time
import sys
import serial
#import move

Top_name = 'Hands'

h_max =     [255,255,110] # Y-R-B
h_min =     [0,158,74]
    
s_max =     [255,255,255]
s_min =     [ 0,150,133]
    
v_max =     [255,239,255]
v_min =     [ 0,104,104]
min_area =  [ 10, 10, 10]

operate = 1
#View_select = 0
class Search():


    def __init__(self, BPS, W_View_size, H_View_size):
        self.BPS =  BPS
        self.W_View_size = W_View_size
        self.H_View_size = H_View_size
        self.slope_yellow=-1
        self.center_yellow_X=0
        self.center_yellow_Y=0
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
        self.camera.set(3, self.H_View_size)
        self.camera.set(4, self.W_View_size)
        self.camera.set(5,60)
        time.sleep(0.5)        
    

    def yellow_line(self, operate_yellow):
        old_time = clock()
        View_select = 0
        k = operate_yellow
        X_255_point0 = 0
        Y_255_point0 = 0
        while k: #Y
            (self.grabbed, self.frame) = self.camera.read()
            self.yuv = cv2.cvtColor(self.frame, cv2.COLOR_BGR2YCrCb)
            mask0 = cv2.inRange(self.yuv, self.yuv_Lower[0], self.yuv_Upper[0])
            mask0 = cv2.erode(mask0, None, iterations=1)
            mask0 = cv2.dilate(mask0, None, iterations=1)
            cnts0 = cv2.findContours(mask0.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            center0 = None
            if len(cnts0) > 0:
                c = max(cnts0, key=cv2.contourArea)
                #((X, Y), radius) = cv2.minEnclosingCircle(c)
                cv2.drawContours(self.frame, [c], 0, (0, 255, 0), 0)
                leftmost0 = tuple(c[c[:,:,0].argmin()][0])
                rightmost0 = tuple(c[c[:,:,0].argmax()][0])
                topmost0 = tuple(c[c[:,:,1].argmin()][0])
                bottommost0 = tuple(c[c[:,:,1].argmax()][0])
                Area0 = cv2.contourArea(c) / min_area[0]
                #x4, y4, w4, h4 = cv2.boundingRect(c)
                #cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 255), 2)
                if Area0 > 255:
                    Area0 = 255
                    #X_Size0 = int((255.0 / W_View_size) * w4)
                    #Y_Size0 = int((255.0 / H_View_size) * h4)
                    X_255_point0 = int((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)
                    Y_255_point0 = int((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)
                    slope_o=float((((topmost0[0]-bottommost0[0])/((bottommost0[1]-topmost0[1])*1.777))*100))
                    slope_y=int(slope_o+60) 
                elif Area0 > min_area[0]:
                    #X_Size0 = int((255.0 / W_View_size) * w4)
                    #Y_Size0 = int((255.0 / H_View_size) * h4)
                    X_255_point0 = int((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)
                    Y_255_point0 = int((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)
                    slope_o=float((((topmost0[0]-bottommost0[0])/((bottommost0[1]-topmost0[1])*1.777))*100))
                    slope_y=int(slope_o+60)
                else:
                    X_255_point0 = int((leftmost0[0]+rightmost0[0]+topmost0[0]+bottommost0[0])/4)
                    Y_255_point0 = int((leftmost0[1]+rightmost0[1]+topmost0[1]+bottommost0[1])/4)
                    slope_o=float((((topmost0[0]-bottommost0[0])/((bottommost0[1]-topmost0[1])*1.777))*100))
                    slope_y=int(slope_o+60) 
            else:
                X_255_point0 = 0
                Y_255_point0 = 0
                Area0 = 0
                slope_y=0
                
            #self.center_yellow_X = X_255_point0
            #self.center_yellow_Y = Y_255_point0
            
            key = 0xFF & cv2.waitKey(1)
            
            if key == 27:  # ESC  Key
                break
            elif key == ord(' '):  # spacebar Key
                if View_select == 0:
                    View_select = 1
                
                else:
                    View_select = 0 

            Frame_time = (clock() - old_time) * 1000.
            old_time = clock()  
            if View_select == 0: # Fast operation 
                #print(" " + str(self.W_View_size) + " x " + str(self.H_View_size) + " =  %.1f ms" % (Frame_time))
                #temp = Read_RX
                print(int(X_255_point0/2))
                #print(Y_255_point0)
                #pass
            elif View_select == 1: # Debug
                cv2.imshow('Hands', self.frame)
                cv2.imshow('Hands_mask', mask0)
                #print(slope_y)
                #print(self.center_yellow_X)
                #print(self.center_yellow_Y)
                
             
    def green_obstacle(self):
        pass


    def blue_line(self):
        pass


    def obstacle_confirm(self):
        pass
    
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
#-----------------------------------------------

def nothing(x):
    pass

# #-----------------------------------------------
def create_blank(width, height, rgb_color=(0, 0, 0)):

    image = np.zeros((height, width, 3), np.uint8)
    color = tuple(reversed(rgb_color))
    image[:] = color

    return image
#-----------------------------------------------
# def draw_str2(dst, target, s):
#     x, y = target
#     cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, 0.8, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
#     cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, 0.8, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
# def draw_str3(dst, target, s):
#     x, y = target
#     cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, 1.5, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
#     cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, 1.5, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
# def draw_str_height(dst, target, s, height):
#     x, y = target
#     cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, height, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
#     cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, height, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()
#----------------------------------------------- 
#-----------------------------------------------


    
    

