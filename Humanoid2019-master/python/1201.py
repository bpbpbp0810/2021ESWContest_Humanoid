#-*- coding: utf-8 -*-

import platform
import numpy as np
import argparse
import cv2
import serial
import time
import sys



#-----------------------------------------------
Top_name = 'mini CTS4 setting'
hsv_Lower = [[0,0,0],[0,0,0],[0,0,0]]
hsv_Upper = [[0,0,0],[0,0,0],[0,0,0]]

color_num = [  0,  1,  2]
    
h_max =     [48,255,110] # Y-R-B
h_min =     [11,158,74]
    
s_max =     [255,255,255]
s_min =     [188,150,133]
    
v_max =     [198,239,255]
v_min =     [91,104,104]
    
min_area =  [ 10, 10, 10]

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

    
    
    W_View_size =  320
    H_View_size = int(W_View_size / 1.777)  
   
    BPS =  4800  # 4800,9600,14400, 19200,28800, 57600, 115200

    serial_use = 1

    hsv_Lower[0] = (h_min[0], s_min[0], v_min[0])
    hsv_Upper[0] = (h_max[0], s_max[0], v_max[0])
    hsv_Lower[1] = (h_min[1], s_min[1], v_min[1])
    hsv_Upper[1] = (h_max[1], s_max[1], v_max[1])
    hsv_Lower[2] = (h_min[2], s_min[2], v_min[2])
    hsv_Upper[2] = (h_max[2], s_max[2], v_max[2])

    now_color = 0

    View_select = 0#########################
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


    cv2.imshow(Top_name, img)
    #---------------------------
    if not args.get("video", False):
        camera = cv2.VideoCapture(0)
    else:
        camera = cv2.VideoCapture(args["video"])
    #---------------------------
    camera.set(3, W_View_size)
    camera.set(4, H_View_size)
    camera.set(5,60)

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
        Frame_time=0
        if serial_port.inWaiting() > 0:
            Read_RX = RX_data(serial_port)
        while Read_RX==100: #Y
            (grabbed, frame) = camera.read()

            if args.get("video") and not grabbed:
                break

            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
            mask0 = cv2.inRange(hsv, hsv_Lower[0], hsv_Upper[0])
            mask0 = cv2.erode(mask0, None, iterations=1)
            mask0 = cv2.dilate(mask0, None, iterations=1)
            cnts0 = cv2.findContours(mask0.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            center0 = None

            
            if len(cnts0) > 0:
                c = max(cnts0, key=cv2.contourArea)
                ((X, Y), radius) = cv2.minEnclosingCircle(c)
                leftmost = tuple(c[c[:,:,0].argmin()][0])
                rightmost = tuple(c[c[:,:,0].argmax()][0])
                topmost = tuple(c[c[:,:,1].argmin()][0])
                bottommost = tuple(c[c[:,:,1].argmax()][0])
                Area0 = cv2.contourArea(c) / min_area[0]
                x4, y4, w4, h4 = cv2.boundingRect(c)
                cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 255), 2)
                if Area0 > 255:
                    Area0 = 255
                    X_Size0 = int((255.0 / W_View_size) * w4)
                    Y_Size0 = int((255.0 / H_View_size) * h4)
                    X_255_point0 = int((255.0 / W_View_size) * X)
                    Y_255_point0 = int((255.0 / H_View_size) * Y)
                        
                elif Area0 > min_area[0]:
                    X_Size0 = int((255.0 / W_View_size) * w4)
                    Y_Size0 = int((255.0 / H_View_size) * h4)
                    X_255_point0 = int((255.0 / W_View_size) * X)
                    Y_255_point0 = int((255.0 / H_View_size) * Y)
            else:  
                X = 0
                Y = 0
                X_255_point0 = 0
                Y_255_point0 = 0
                X_Size0 = 0
                Y_Size0 = 0
                Area0 = 0
            TX_data(serial_port,X_255_point0)#yellow X 중심
            if serial_port.inWaiting() > 0:
                Read_RX = RX_data(serial_port)
            
            if View_select == 0: # Fast operation 
                print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
                #temp = Read_RX
                #print(X_255_point0)
                pass
            elif View_select == 1: # Debug
                draw_str2(frame, (5, 15),'(x_center,y_center, Area) Y(%.1d, %.1d,%.1d) ' % (X_255_point0, Y_255_point0, Area0))
                draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d Time: %.1f ms  Space: Fast <=> Video and Mask.'  % (W_View_size, H_View_size, Frame_time))
                cv2.imshow('mini CTS4 - Video', frame )
                cv2.imshow('mini CTS4 - Mask0', mask0)
                print(leftmost[0])
                print(rightmost[0])
            
                

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
    #----------------------------------------------------------------------
        #while True:
        while Read_RX==101: #R
            (grabbed, frame) = camera.read()

            if args.get("video") and not grabbed:
                break

            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

            mask1 = cv2.inRange(hsv, hsv_Lower[1], hsv_Upper[1])
            mask1 = cv2.erode(mask1, None, iterations=1)
            mask1 = cv2.dilate(mask1, None, iterations=1)
            cnts1 = cv2.findContours(mask1.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            center1 = None
            if len(cnts1) > 0:
                c = max(cnts1,key=cv2.contourArea)
                ((X, Y), radius) = cv2.minEnclosingCircle(c)
                
                Area1 = cv2.contourArea(c) / min_area[1]
                x4, y4, w4, h4 = cv2.boundingRect(c)
                cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 255), 2)
                if Area1 > 255:
                    Area1 = 255
                    X_Size1 = int((255.0 / W_View_size) * w4)
                    Y_Size1 = int((255.0 / H_View_size) * h4)
                    X_255_point1 = int((255.0 / W_View_size) * X)
                    Y_255_point1 = int((255.0 / H_View_size) * Y)
                        
                elif Area1 > min_area[1]:
                    X_Size1 = int((255.0 / W_View_size) * w4)
                    Y_Size1 = int((255.0 / H_View_size) * h4)
                    X_255_point1 = int((255.0 / W_View_size) * X)
                    Y_255_point1 = int((255.0 / H_View_size) * Y)
            else:  
                X = 0
                Y = 0
                X_255_point1 = 0
                Y_255_point1 = 0
                X_Size1 = 0
                Y_Size1 = 0
                Area1 = 0
            TX_data(serial_port,X_255_point1)#RED X 중심
            if serial_port.inWaiting() > 0:
                Read_RX = RX_data(serial_port)

            if View_select == 0: # Fast operation 
                #print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
                #temp = Read_RX
                print(X_255_point1)
                pass
            elif View_select == 1: # Debug
                draw_str2(frame, (5, 15),'(x_center,y_center, Area) R(%.1d, %.1d,%.1d) ' % (X_255_point1, Y_255_point1, Area1))
                draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d Time: %.1f ms  Space: Fast <=> Video and Mask.'  % (W_View_size, H_View_size, Frame_time))
                cv2.imshow('mini CTS4 - Video', frame )
                cv2.imshow('mini CTS4 - Mask0', mask1)
            

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

    #----------------------------------------------
     
      #while True:
        while Read_RX==102: #B
            (grabbed, frame) = camera.read()

            if args.get("video") and not grabbed:
                break

            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

            mask2 = cv2.inRange(hsv, hsv_Lower[2], hsv_Upper[2])
            mask2 = cv2.erode(mask2, None, iterations=1)
            mask2 = cv2.dilate(mask2, None, iterations=1)
            cnts2 = cv2.findContours(mask2.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            center2 = None
            if len(cnts2) > 0:
                c = max(cnts2, key=cv2.contourArea)
                ((X, Y), radius) = cv2.minEnclosingCircle(c)
                
                Area2 = cv2.contourArea(c) / min_area[2]
                x4, y4, w4, h4 = cv2.boundingRect(c)
                cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0,0,255), 2)                
                if Area2 > 255:
                    Area2 = 255
                    X_Size2 = int((255.0 / W_View_size) * w4)
                    Y_Size2 = int((255.0 / H_View_size) * h4)
                    X_255_point2 = int((255.0 / W_View_size) * X)
                    Y_255_point2 = int((255.0 / H_View_size) * Y)
                        
                elif Area2 > min_area[2]:
                    X_Size2 = int((255.0 / W_View_size) * w4)
                    Y_Size2 = int((255.0 / H_View_size) * h4)
                    X_255_point2 = int((255.0 / W_View_size) * X)
                    Y_255_point2 = int((255.0 / H_View_size) * Y)
            else:  
                X = 0
                Y = 0
                X_255_point2 = 0
                Y_255_point2 = 0
                X_Size2 = 0
                Y_Size2 = 0
                Area2 = 0

            TX_data(serial_port,X_255_point2)#BLUE x 중심
            if serial_port.inWaiting() > 0:
                Read_RX = RX_data(serial_port)   


            if View_select == 0: # Fast operation 
                #print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
                #temp = Read_RX
                print(X_255_point2)
                pass
            elif View_select == 1: # Debug
                draw_str2(frame, (5, 15),'(x_center,y_center, Area) B(%.1d,%.1d, %.1d)'
                        % (X_255_point2, Y_255_point2, Area2))
                draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d Time: %.1f ms  Space: Fast <=> Video and Mask.'% (W_View_size, H_View_size, Frame_time))
                cv2.imshow('mini CTS4 - Video', frame )
                cv2.imshow('mini CTS4 - Mask0', mask2)
            
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
            
        key = 0xFF & cv2.waitKey(1)
        if key == 27:  # ESC  Key
            break
         
    #----------------------------------------------

        while Read_RX==103 or Read_RX ==105: #Y
            (grabbed, frame) = camera.read()

            if args.get("video") and not grabbed:
                break

            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
            mask0 = cv2.inRange(hsv, hsv_Lower[0], hsv_Upper[0])
            mask0 = cv2.erode(mask0, None, iterations=1)
            mask0 = cv2.dilate(mask0, None, iterations=1)
            cnts0 = cv2.findContours(mask0.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            center0 = None
            if len(cnts0) > 0:
                c = max(cnts0, key=cv2.contourArea)
                #((X, Y), radius) = cv2.minEnclosingCircle(c)
                cv2.drawContours(frame, [c], 0, (0, 255, 0), 0)
                leftmost = tuple(c[c[:,:,0].argmin()][0])
                rightmost = tuple(c[c[:,:,0].argmax()][0])
                topmost = tuple(c[c[:,:,1].argmin()][0])
                bottommost = tuple(c[c[:,:,1].argmax()][0])
                Area0 = cv2.contourArea(c) / min_area[0]
                #x4, y4, w4, h4 = cv2.boundingRect(c)
                #cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 255), 2)
                if Area0 > 255:
                    Area0 = 255
                    #X_Size0 = int((255.0 / W_View_size) * w4)
                    #Y_Size0 = int((255.0 / H_View_size) * h4)
                    X_255_point0 = int((leftmost[0]+rightmost[0]+topmost[0]+bottommost[0])/4)
                    Y_255_point0 = int((leftmost[1]+rightmost[1]+topmost[1]+bottommost[1])/4)
                    slope_o=float((((topmost[0]-bottommost[0])/((bottommost[1]-topmost[1])*1.777))*100))
                    slope=int(slope_o+60) 
                elif Area0 > min_area[0]:
                    #X_Size0 = int((255.0 / W_View_size) * w4)
                    #Y_Size0 = int((255.0 / H_View_size) * h4)
                    X_255_point0 = int((leftmost[0]+rightmost[0]+topmost[0]+bottommost[0])/4)
                    Y_255_point0 = int((leftmost[1]+rightmost[1]+topmost[1]+bottommost[1])/4)
                    slope_o=float((((topmost[0]-bottommost[0])/((bottommost[1]-topmost[1])*1.777))*100))
                    slope=int(slope_o+60) 
                    
            else:  
                #X = 0
                #Y = 0
                X_255_point0 = 0
                Y_255_point0 = 0
                #X_Size0 = 0
                #Y_Size0 = 0
                Area0 = 0
            if Read_RX ==103:
                if X_255_point0 > 0:
                    if slope<50  :
                        TX_data(serial_port, 103)
                    elif slope>50 and slope<70 :
                        if X_255_point0 > 130 and X_255_point0 < 190:
                            TX_data(serial_port, 128)
                        elif X_255_point0 > 190:
                            TX_data(serial_port, 130)
                        elif X_255_point0 <130:
                            TX_data(serial_port, 150)
                    elif slope>70 and slope <150:
                        TX_data(serial_port, 153)
                    else:
                        TX_data(serial_port, 0)
                else :
                    TX_data(serial_port, 0)
            elif Read_RX ==105:
                TX_data(serial_port, rightmost)
            #if  X_255_point0>0 and X_255_point0<103:
             #   TX_data(serial_port, 103)
            #elif  X_255_point0>103 and X_255_point0<153:
             #   TX_data(serial_port, 128)
            #elif  X_255_point0>153:
             #   TX_data(serial_port, 153)
            #else:
             #   TX_data(serial_port, 0)


            if serial_port.inWaiting() > 0:
                Read_RX = RX_data(serial_port)
            
            if View_select == 0: # Fast operation 
                print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
                #temp = Read_RX
                #print(X_255_point0)
                pass
            elif View_select == 1: # Debug
                draw_str2(frame, (5, 15),'(x_center,y_center, Area) Y(%.1d, %.1d,%.1d) ' % (X_255_point0, Y_255_point0, slope))
                draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d Time: %.1f ms  Space: Fast <=> Video and Mask.'  % (W_View_size, H_View_size, Frame_time))
                cv2.imshow('mini CTS4 - Video', frame )
                cv2.imshow('mini CTS4 - Mask0', mask0)
                
            
                

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
     #----------------------------------------------------------------------
 
       #------------------------------------------     
        while Read_RX==104: #R
            (grabbed, frame) = camera.read()

            if args.get("video") and not grabbed:
                break

            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
            mask3 = cv2.inRange(hsv, hsv_Lower[1], hsv_Upper[1])
            mask3 = cv2.erode(mask3, None, iterations=1)
            mask3 = cv2.dilate(mask3, None, iterations=1)
            cnts3 = cv2.findContours(mask3.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            center0 = None
            if len(cnts3) > 0:
                c = max(cnts3, key=cv2.contourArea)
                #((X, Y), radius) = cv2.minEnclosingCircle(c)
                cv2.drawContours(frame, [c], 0, (0, 255, 0), 0)
                leftmost = tuple(c[c[:,:,0].argmin()][0])
                rightmost = tuple(c[c[:,:,0].argmax()][0])
                topmost = tuple(c[c[:,:,1].argmin()][0])
                bottommost = tuple(c[c[:,:,1].argmax()][0])
                Area3 = cv2.contourArea(c) / min_area[1]
                #x4, y4, w4, h4 = cv2.boundingRect(c)
                #cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 255), 2)
                if Area3 > 255:
                    Area3 = 255
                    #X_Size0 = int((255.0 / W_View_size) * w4)
                    #Y_Size0 = int((255.0 / H_View_size) * h4)
                    X_255_point3 = int((leftmost[0]+rightmost[0]+topmost[0]+bottommost[0])/4)
                    Y_255_point3 = int((leftmost[1]+rightmost[1]+topmost[1]+bottommost[1])/4)
                    slope_o=float((((topmost[0]-bottommost[0])/((bottommost[1]-topmost[1])*1.777))*100))
                    slope=int(slope_o+60) 
                elif Area3 > min_area[1]:
                    #X_Size0 = int((255.0 / W_View_size) * w4)
                    #Y_Size0 = int((255.0 / H_View_size) * h4)
                    X_255_point3 = int((leftmost[0]+rightmost[0]+topmost[0]+bottommost[0])/4)
                    Y_255_point3 = int((leftmost[1]+rightmost[1]+topmost[1]+bottommost[1])/4)
                    slope_o=float((((topmost[0]-bottommost[0])/((bottommost[1]-topmost[1])*1.777))*100))
                    slope=int(slope_o+60) 
                    
            else:  
                #X = 0
                #Y = 0
                X_255_point3 = 0
                Y_255_point3 = 0
                #X_Size0 = 0
                #Y_Size0 = 0
                Area3 = 0
            if X_255_point3 > 0:
                if slope<50  :
                    TX_data(serial_port, 103)
                elif slope>50 and slope<70 :
                    if X_255_point3 > 130 and X_255_point3 < 190:
                        TX_data(serial_port, 128)
                    elif X_255_point3 > 190:
                        TX_data(serial_port, 130)
                    elif X_255_point3 <130:
                        TX_data(serial_port, 150)
                elif slope>70 and slope <150:
                    TX_data(serial_port, 153)
                else:
                    TX_data(serial_port, 0)
            else :
                TX_data(serial_port, 0)
            #if  X_255_point0>0 and X_255_point0<103:
             #   TX_data(serial_port, 103)
            #elif  X_255_point0>103 and X_255_point0<153:
             #   TX_data(serial_port, 128)
            #elif  X_255_point0>153:
             #   TX_data(serial_port, 153)
            #else:
             #   TX_data(serial_port, 0)


            if serial_port.inWaiting() > 0:
                Read_RX = RX_data(serial_port)
            
            if View_select == 0: # Fast operation 
                print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
                #temp = Read_RX
                #print(X_255_point0)
                pass
            elif View_select == 1: # Debug
                draw_str2(frame, (5, 15),'(x_center,y_center, Area) Y(%.1d, %.1d,%.1d) ' % (X_255_point3, Y_255_point3, slope))
                draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d Time: %.1f ms  Space: Fast <=> Video and Mask.'  % (W_View_size, H_View_size, Frame_time))
                cv2.imshow('mini CTS4 - Video', frame )
                cv2.imshow('mini CTS4 - Mask0', mask3)
                
            
                

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



        #while True:
        while Read_RX==106: #Y 문 지나고 나서 X중심 값만
            (grabbed, frame) = camera.read()

            if args.get("video") and not grabbed:
                break

            hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)
            mask0 = cv2.inRange(hsv, hsv_Lower[1], hsv_Upper[1])
            mask0 = cv2.erode(mask0, None, iterations=1)
            mask0 = cv2.dilate(mask0, None, iterations=1)
            cnts0 = cv2.findContours(mask0.copy(), cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)[-2]
            center0 = None
            if len(cnts0) > 0:
                c = max(cnts0, key=cv2.contourArea)
                #((X, Y), radius) = cv2.minEnclosingCircle(c)
                cv2.drawContours(frame, [c], 0, (0, 255, 0), 0)
                leftmost = tuple(c[c[:,:,0].argmin()][0])
                rightmost = tuple(c[c[:,:,0].argmax()][0])
                topmost = tuple(c[c[:,:,1].argmin()][0])
                bottommost = tuple(c[c[:,:,1].argmax()][0])
                Area0 = cv2.contourArea(c) / min_area[0]
                #x4, y4, w4, h4 = cv2.boundingRect(c)
                #cv2.rectangle(frame, (x4, y4), (x4 + w4, y4 + h4), (0, 255, 255), 2)
                if Area0 > 255:
                    Area0 = 255
                    #X_Size0 = int((255.0 / W_View_size) * w4)
                    #Y_Size0 = int((255.0 / H_View_size) * h4)
                    X_255_point0 = int((leftmost[0]+rightmost[0]+topmost[0]+bottommost[0])/4)
                    Y_255_point0 = int((leftmost[1]+rightmost[1]+topmost[1]+bottommost[1])/4)
                   # slope_o=float((((topmost[0]-bottommost[0])/((bottommost[1]-topmost[1])*1.777))*100))
                    #slope=int(slope_o+60) 
                elif Area0 > min_area[0]:
                    #X_Size0 = int((255.0 / W_View_size) * w4)
                    #Y_Size0 = int((255.0 / H_View_size) * h4)
                    X_255_point0 = int((leftmost[0]+rightmost[0]+topmost[0]+bottommost[0])/4)
                    Y_255_point0 = int((leftmost[1]+rightmost[1]+topmost[1]+bottommost[1])/4)
                    #slope_o=float((((topmost[0]-bottommost[0])/((bottommost[1]-topmost[1])*1.777))*100))
                   # slope=int(slope_o+60) 
                    
            else:  
                #X = 0
                #Y = 0
                X_255_point0 = 0
                Y_255_point0 = 0
                #X_Size0 = 0
                #Y_Size0 = 0
                Area0 = 0
            if X_255_point0 > 0:
                if X_255_point0 > 130 and X_255_point0 < 190:
                    TX_data(serial_port, 128)
                elif X_255_point0 > 190:
                    TX_data(serial_port, 130)
                elif X_255_point0 <130:
                    TX_data(serial_port, 150)
            else :
                TX_data(serial_port, 0)
            #if  X_255_point0>0 and X_255_point0<103:
             #   TX_data(serial_port, 103)
            #elif  X_255_point0>103 and X_255_point0<153:
             #   TX_data(serial_port, 128)
            #elif  X_255_point0>153:
             #   TX_data(serial_port, 153)
            #else:
             #   TX_data(serial_port, 0)


            if serial_port.inWaiting() > 0:
                Read_RX = RX_data(serial_port)
            
            if View_select == 0: # Fast operation 
                print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
                #temp = Read_RX
                #print(X_255_point0)
                pass
            elif View_select == 1: # Debug
                draw_str2(frame, (5, 15),'(x_center,y_center, Area) Y(%.1d, %.1d) ' % (X_255_point0, Y_255_point0))
                draw_str2(frame, (5, H_View_size - 5), 'View: %.1d x %.1d Time: %.1f ms  Space: Fast <=> Video and Mask.'  % (W_View_size, H_View_size, Frame_time))
                cv2.imshow('mini CTS4 - Video', frame )
                cv2.imshow('mini CTS4 - Mask0', mask0)
                
            
                

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







    # cleanup the camera and close any open windows
    if serial_use <> 0:
        serial_port.close()
    camera.release()
    cv2.destroyAllWindows()





