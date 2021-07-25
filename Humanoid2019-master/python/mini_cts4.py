# -*- coding: utf-8 -*-

import platform
import numpy as np
import argparse
import cv2
import serial
import time
import sys



#-----------------------------------------------
Top_name = 'mini CTS4 setting'
hsv_Lower = 0
hsv_Upper = 0

color_num = [  0,  1,  2,  3,  4,  5,  6,  7,  8,  9]
    
h_max =     [ 48, 64,196,111,110, 42, 62, 62, 62, 62]
h_min =     [ 11, 25,158, 59, 74,  0, 29, 29, 29, 29]
    
s_max =     [248,255,223,110,255,255,178,178,178,178]
s_min =     [ 70,164,150, 51,133,134, 51, 51, 51, 51]
    
v_max =     [237,255,239,156,255,253,236,236,236,236]
v_min =     [173,129,104, 61,104, 84, 22, 22, 22, 22]
    
min_area =  [ 10, 10, 10, 10, 10, 10, 10, 10, 10, 10]

now_color = 0
serial_use = 0

serial_port =  None
Temp_count = 0
Read_RX =  0
#-----------------------------------------------

def nothing(x):
    pass

#-----------------------------------------------
def create_blank(width, height, rgb_color=(0, 0, 0)):

    image = np.zeros((height, width, 3), np.uint8)
    color = tuple(reversed(rgb_color))
    image[:] = color

    return image
#-----------------------------------------------
def draw_str2(dst, target, s):
    x, y = target
    cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, 0.8, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
    cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, 0.8, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
def draw_str3(dst, target, s):
    x, y = target
    cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, 1.5, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
    cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, 1.5, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
def draw_str_height(dst, target, s, height):
    x, y = target
    cv2.putText(dst, s, (x+1, y+1), cv2.FONT_HERSHEY_PLAIN, height, (0, 0, 0), thickness = 2, lineType=cv2.LINE_AA)
    cv2.putText(dst, s, (x, y), cv2.FONT_HERSHEY_PLAIN, height, (255, 255, 255), lineType=cv2.LINE_AA)
#-----------------------------------------------
def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()
#-----------------------------------------------

def Trackbar_change(now_color):
    global  hsv_Lower,  hsv_Upper
    hsv_Lower = (h_min[now_color], s_min[now_color], v_min[now_color])
    hsv_Upper = (h_max[now_color], s_max[now_color], v_max[now_color])

#-----------------------------------------------
def Hmax_change(a):
    
    h_max[now_color] = cv2.getTrackbarPos('Hmax', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Hmin_change(a):
    
    h_min[now_color] = cv2.getTrackbarPos('Hmin', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Smax_change(a):
    
    s_max[now_color] = cv2.getTrackbarPos('Smax', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Smin_change(a):
    
    s_min[now_color] = cv2.getTrackbarPos('Smin', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Vmax_change(a):
    
    v_max[now_color] = cv2.getTrackbarPos('Vmax', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def Vmin_change(a):
    
    v_min[now_color] = cv2.getTrackbarPos('Vmin', Top_name)
    Trackbar_change(now_color)
#-----------------------------------------------
def min_area_change(a):
   
    min_area[now_color] = cv2.getTrackbarPos('Min_Area', Top_name)
    if min_area[now_color] == 0:
        min_area[now_color] = 1
        cv2.setTrackbarPos('Min_Area', Top_name, min_area[now_color])
    Trackbar_change(now_color)
#-----------------------------------------------
def Color_num_change(a):
    global now_color, hsv_Lower,  hsv_Upper
    now_color = cv2.getTrackbarPos('Color_num', Top_name)
    cv2.setTrackbarPos('Hmax', Top_name, h_max[now_color])
    cv2.setTrackbarPos('Hmin', Top_name, h_min[now_color])
    cv2.setTrackbarPos('Smax', Top_name, s_max[now_color])
    cv2.setTrackbarPos('Smin', Top_name, s_min[now_color])
    cv2.setTrackbarPos('Vmax', Top_name, v_max[now_color])
    cv2.setTrackbarPos('Vmin', Top_name, v_min[now_color])
    cv2.setTrackbarPos('Min_Area', Top_name, min_area[now_color])

    hsv_Lower = (h_min[now_color], s_min[now_color], v_min[now_color])
    hsv_Upper = (h_max[now_color], s_max[now_color], v_max[now_color])
#----------------------------------------------- 
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
# **************************************************
# **************************************************
# **************************************************
if __name__ == '__main__':

    #-------------------------------------
    print ("-------------------------------------")
    print ("(2018-6-15) mini CTS4 Program.    MINIROBOT Corp.")
    print ("-------------------------------------")
    print ("")
    os_version = platform.platform()
    print (" ---> OS " + os_version)
    python_version = ".".join(map(str, sys.version_info[:3]))
    print (" ---> Python " + python_version)
    opencv_version = cv2.__version__
    print (" ---> OpenCV  " + opencv_version)
    
    
    #-------------------------------------
    #---- user Setting -------------------
    #-------------------------------------
    W_View_size =  320 
    H_View_size = int(W_View_size / 1.777)  
    #H_View_size = int(W_View_size / 1.333)

    BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200

    serial_use = 1

    now_color = 0

    View_select = 0
    #-------------------------------------
    print(" ---> Camera View: " + str(W_View_size) + " x " + str(H_View_size) )
    print ("")
    print ("-------------------------------------")
    #-------------------------------------
    ap = argparse.ArgumentParser()
    ap.add_argument("-v", "--video",
                    help="path to the (optional) video file")
    ap.add_argument("-b", "--buffer", type=int, default=64,
                    help="max buffer size")
    args = vars(ap.parse_args())

    img = create_blank(320, 50, rgb_color=(0, 0, 255))
    
    cv2.namedWindow(Top_name)

    
    cv2.createTrackbar('Hmax', Top_name, h_max[now_color], 255, Hmax_change)
    cv2.createTrackbar('Hmin', Top_name, h_min[now_color], 255, Hmin_change)
    cv2.createTrackbar('Smax', Top_name, s_max[now_color], 255, Smax_change)
    cv2.createTrackbar('Smin', Top_name, s_min[now_color], 255, Smin_change)
    cv2.createTrackbar('Vmax', Top_name, v_max[now_color], 255, Vmax_change)
    cv2.createTrackbar('Vmin', Top_name, v_min[now_color], 255, Vmin_change)
    cv2.createTrackbar('Min_Area', Top_name, min_area[now_color], 255, min_area_change)
    cv2.createTrackbar('Color_num', Top_name,color_num[now_color], 9, Color_num_change)

    Trackbar_change(now_color)

    draw_str3(img, (15, 25), 'MINIROBOT Corp.')
    
    cv2.imshow(Top_name, img)
    #---------------------------
    if not args.get("video", False):
        camera = cv2.VideoCapture(0)
    else:
        camera = cv2.VideoCapture(args["video"])
    #---------------------------
    camera.set(3, W_View_size)
    camera.set(4, H_View_size)

    time.sleep(0.5)
    #---------------------------
    if serial_use <> 0:
        serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
        serial_port.flush() # serial cls
    #---------------------------
    (grabbed, frame) = camera.read()
    draw_str2(frame, (5, 15), 'X_Center x Y_Center =  Area' )
    draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d.  Space: Fast <=> Video and Mask.'
                      % (W_View_size, H_View_size))
    draw_str_height(frame, (5, (H_View_size/2)), 'Fast operation...', 3.0 )
    cv2.imshow('mini CTS4 - Video', frame )
    #---------------------------
    # First -> Start Code Send 
    TX_data(serial_port, 250)
    TX_data(serial_port, 250)
    TX_data(serial_port, 250)
    
    old_time = clock()

    # -------- Main Loop Start --------
    while True:
        
        # grab the current frame
        (grabbed, frame) = camera.read()

        if args.get("video") and not grabbed:
            break

        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2YCrCb)

        mask = cv2.inRange(hsv, hsv_Lower, hsv_Upper)
        
        mask = cv2.erode(mask, None, iterations=1)
        mask = cv2.dilate(mask, None, iterations=1)
        #mask = cv2.GaussianBlur(mask, (3, 3), 2)  # softly

        cnts = cv2.findContours(mask.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
        center = None


        if len(cnts) > 0:
            c = max(cnts, key=cv2.contourArea)
            ((X, Y), radius) = cv2.minEnclosingCircle(c)
            
            Area = cv2.contourArea(c) / min_area[now_color]
            if Area > 255:
                Area = 255
                    
            if Area > min_area[now_color]:
                x4, y4, w4, h4 = cv2.boundingRect(c)
                cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 0), 2)
                
                X_Size = int((255.0 / W_View_size) * w4)
                Y_Size = int((255.0 / H_View_size) * h4)
                X_255_point = int((255.0 / W_View_size) * X)
                Y_255_point = int((255.0 / H_View_size) * Y)
        else:
            
            x = 0
            y = 0
            X_255_point = 0
            Y_255_point = 0
            X_Size = 0
            Y_Size = 0
            Area = 0
            
        '''
        #--------------------------------------
        
        Read_RX = RX_data(serial_port)
        if Read_RX <> 0:
            print("Read_RX = " + str(Read_RX))
        
        #TX_data(serial_port,255)
        
        #--------------------------------------    
        '''
        Frame_time = (clock() - old_time) * 1000.
        old_time = clock()
        cv2.line(frame, (0, 0), (500, 281), (0, 255, 0), 3)
           
        if View_select == 0: # Fast operation 
            print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
            #temp = Read_RX
            
        elif View_select == 1: # Debug
            draw_str2(frame, (5, 15), 'X: %.1d,  Y: %.1d, Area: %.1d ' % (X_255_point, Y_255_point, Area))
            draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d Time: %.1f ms  Space: Fast <=> Video and Mask.'
                      % (W_View_size, H_View_size, Frame_time))
            cv2.imshow('mini CTS4 - Video', frame )
            cv2.imshow('mini CTS4 - Mask', mask)

        key = 0xFF & cv2.waitKey(1)
        
        if key == 27:  # ESC  Key
            break
        elif key == ord(' '):  # spacebar Key
            if View_select == 0:
                View_select = 1
            
            else:
                View_select = 0


    # cleanup the camera and close any open windows
    if serial_use <> 0:
        serial_port.close()
    camera.release()
    cv2.destroyAllWindows()






