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


def main():
    global flag

    serial_use = 1
    if serial_use <> 0:
        serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.0001)
        #serial_port.flush()
        t_serial = Thread(target=RX_data2, args=(serial_port, ))
        time.sleep(0.1)
        t_serial.deamon = True
        t_serial.start() 

    TX_data(serial_port, 250)
    TX_data(serial_port, 250)
    TX_data(serial_port, 250)
    
    operate_y = 1
    View_select = 0
    operate_g = 0
    operate_y_1 = 0
    while True:
        old_time = clock()
        search.yellow_line(View_select, operate_y)
        search.green_detect(View_select, operate_g)
        search.yellow_detect(View_select, operate_y_1)
        if Read_RX == 111:
            #operate_g = 0
            TX_data(serial_port, search.slope_yellow)
            print("search.slope_yellow = " + str(search.slope_yellow))
            #print("search.slope_yellow")                #0 = rectangular
        elif Read_RX == 112:
            #operate_g = 0
            TX_data(serial_port, search.center_yellow_X)
            print("search.center_yellow_X = " + str(search.center_yellow_X))
            #print("search.center_yellow_X")
        elif Read_RX == 113:
            #operate_g = 0
            if search.center_yellow_X > 128:
                TX_data(serial_port, 2)
            else:
                TX_data(serial_port, 0)
            print("obstacle_yellow_X")
        elif Read_RX == 114:
            operate_y = 0
            operate_g = 0
            operate_y_1 = 1
        elif Read_RX == 115:
            #operate_g = 0
            operate_y_1 = 1
            print("search.door = " + str(search.door))
            TX_data(serial_port, search.door)
            #print("door")
        elif Read_RX == 120:
            operate_g = 1
            print("green detect")
        elif Read_RX == 121:
            operate_g = 1
            TX_data(serial_port, search.center_green_X)
            print("X_255_point_G = " + str(search.center_green_X))

        elif Read_RX ==122:
            operate_g = 1
            TX_data(serial_port, search.center_green_Y)
            print("Y_255_point_G = " + str(search.center_green_Y))
        elif Read_RX == 202:
            operate_y = 1
            operate_g = 0
            operate_y_1 = 0
        else:
            pass
        Frame_time = (clock() - old_time) * 1000.
        old_time = clock()

        key = 0xFF & cv2.waitKey(1)
        if key == 27:  # exit on ESC
            flag = 0
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
        #\print("time=  %.1f ms" % (Frame_time))

if __name__ == '__main__':
    BPS = 4800
    search = search.Search(4800, 320, 240)
    main()
