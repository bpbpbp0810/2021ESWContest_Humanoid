import platform
import serial
from threading import Thread
import os
import sys
import time
import cv2
import numpy as np
import houghline_search as search

serial_use = 0
serial_port = None
Temp_count = 0
Read_RX = 0
flag = 1
View_select = 0
operate = 1


def TX_data(serial, one_byte):  # one_byte= 0~255
    global Temp_count
    try:
        serial.write(chr(int(one_byte)))
        print("TX_data: %d" %(one_byte))
    except:
        Temp_count = Temp_count + 1
        print("TX_Serial Not Open " + str(Temp_count))
        # pass
# -----------------------------------------------

def RX_data(serial):
    global Temp_count
    try:
        if serial.inWaiting() > 0:
            result = serial.read(1)
            RX = ord(result)
            print("RX_data: %d" %(RX))
            return RX
        else:
            return 0
    except:
        Temp_count = Temp_count + 1
        print("RX_Serial Not Open " + str(Temp_count))
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
                print("RX2_data: %d" %(Read_RX))
                # return RX
            else:
                Read_RX = 0
        except:
            Temp_count = Temp_count + 1
            print("RX2_Serial Not Open " + str(Temp_count))
            Read_RX = 0

        serial.flush()

        time.sleep(0.007)

def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()


def main():
    global flag
    global Read_RX
    serial_use = 1
    if serial_use <> 0:
        serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.0001)
        #serial_port.flush()
        t_serial = Thread(target=RX_data2, args=(serial_port, ))
        time.sleep(0.1)
        t_serial.deamon = True
        t_serial.start() 

    #TX_data(serial_port, 250)
    #TX_data(serial_port, 250)
    TX_data(serial_port, 250)
    
    View_select = 0
    operate_y = 1
    operate_y_R = 0
    operate_y_1 = 0
    operate_g = 0
    operate_all = 1
    corner = 0
    #operate_y_all = 1
    while True:
        #Read_RX = 0
        #operate_y = 1
        old_time = clock()
        #if Read_RX != 0:
        slope_y = 0
        center_y = 0
        search.yellow_line(View_select, operate_y, operate_all, corner)
        search.yellow_line_R(View_select, operate_y_R, operate_all)
        search.yellow_detect(View_select, operate_y_1)
        search.green_detect(View_select, operate_g)
        

        if Read_RX == 111: 
            operate_y = 1   
            #operate_y_R = 1                                   #slope
            operate_g = 0
            operate_y_1 = 0
            if search.corner_slope == 255 and corner == 0:
                TX_data(serial_port, search.corner_slope)
                print("search.corner_slope = " + str(search.corner_slope))
                search.corner_slope = 0
            elif search.corner_slope == 254 and corner == 0:
                TX_data(serial_port, search.corner_slope)
                print("search.corner_slope = " + str(search.corner_slope))
                search.corner_slope = 0
            elif search.corner_slope == 253 and corner == 0:
                TX_data(serial_port, search.corner_slope)
                print("search.corner_slope = " + str(search.corner_slope))
                search.corner_slope = 0
            else:
                if search.slope_yellow != 0:
                    slope_y = search.slope_yellow
                elif search.slope_yellow == 0 and search.slope_yellow_R != 0:
                    slope_y = search.slope_yellow_R
                elif search.slope_yellow == 0 and search.slope_yellow_R == 0:
                    slope_y = 0
                
                TX_data(serial_port, slope_y)
                print("search.slope_yellow = " + str(search.slope_yellow))
        elif Read_RX == 150:
            corner = 1
            operate_y_R = 0
            operate_g = 0
        elif Read_RX == 140:
            operate_y_R = 1
            
        elif Read_RX == 112:     
            operate_y = 1                                   #center yellow
            operate_g = 0
            operate_y_1 = 0

            if search.center_yellow_X != 0:
                center_y = search.center_yellow_X
            elif search.center_yellow_X == 0 and search.center_yellow_X_R != 0:
                center_y = search.center_yellow_X_R
            elif search.center_yellow_X == 0 and search.center_yellow_X_R == 0:
                center_y = 0
            
            
            TX_data(serial_port, center_y)
            print("search.center_yellow_X = " + str(center_y))
        elif Read_RX == 113:   
            operate_y = 1                         #milk
            if search.center_yellow_X > 128:
                TX_data(serial_port, 2)
            else:
                TX_data(serial_port, 0)
            print("obstacle_yellow_X")
            #Read_RX = 0
        elif Read_RX == 114: 
            operate_y = 0
            operate_g = 0
            operate_y_1 = 1
            print("ETX 114,operate_y_1 =" + str(operate_y_1))
            #Read_RX = 0
            
        elif Read_RX == 115:    #door
            operate_g = 0
            operate_y_1 = 1
            TX_data(serial_port, search.door)
            print("search.door = " + str(search.door))
            #Read_RX = 0
            
        elif Read_RX == 120:
            operate_g = 1
            print("ETX 120,operate_g =" + str(operate_g))
            #Read_RX = 0
        elif Read_RX == 121:
            operate_g = 1
            TX_data(serial_port, search.center_green_X)
            print("X_255_point_G = " + str(search.center_green_X))
            #Read_RX = 0
        elif Read_RX ==122:
            operate_g = 1
            TX_data(serial_port, search.center_green_Y)
            print("Y_255_point_G = " + str(search.center_green_Y))
            #Read_RX = 0
        elif Read_RX == 202:
            operate_y = 1
            operate_g = 0
            operate_y_1 = 0
            print("ETX 202,operate_g =" + str(operate_g))
            #Read_RX = 0
        else:
            pass
        Frame_time = (clock() - old_time) * 1000.
        old_time = clock()

        key = 0xFF & cv2.waitKey(1)
        if key == 27:  # exit on ESC
            flag = 0
            operate_all = 0
            search.operate_y = 0
            search.operate_g = 0
            break
        elif key == ord(' '):  # spacebar Key
            if View_select == 0:
                View_select = 1
                search.View_select_y = 1
                search.View_select_g = 1
            else:
                View_select = 0
                search.View_select_y = 0
                search.View_select_g = 0
        elif key == ord('1'):
            print("time=  %.1f ms" % (Frame_time))

if __name__ == '__main__':
    BPS = 4800
    search = search.Search(4800, 320, 240)
    main()