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
        serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
        # serial_port.flush()
        t_serial = Thread(target=RX_data2, args=(serial_port, ))
        time.sleep(0.1)
        t_serial.deamon = True
        t_serial.start() 
    
    operate_y = 1
    View_select = 0
    operate_g = 1
    while True:
        old_time = clock()
        search.yellow_line(View_select, operate_y)
        search.green_detect(View_select, operate_g)
        if Read_RX == 111:
            TX_data(serial_port, search.slope_yellow)
            print("search.slope_yellow")
        elif Read_RX == 112:
            TX_data(serial_port, search.center_yellow_X)
            print("search.center_yellow_X")
        elif Read_RX == 120:
            operate_g = 1
        elif Read_RX == 121:
            TX_data(serial_port, search.center_green_X)
            print("X_255_point0")
        elif Read_RX ==122:
            TX_data(serial_port, search.center_green_Y)
            print("Y_255_point0")

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
        print("time=  %.1f ms" % (Frame_time))

if __name__ == '__main__':
    BPS = 4800
    search = search.Search(4800, 240, 320)
    main()