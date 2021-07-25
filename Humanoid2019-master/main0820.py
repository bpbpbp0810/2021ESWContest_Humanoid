import platform
import serial
import search_ver2 as search
from multiprocessing import Process
import os
import sys
import time
import cv2

serial_use = 0
serial_port =  None
Temp_count = 0
Read_RX =  0

def TX_data(serial, one_byte):  # one_byte= 0~255
    global Temp_count
    try:
        serial.write(chr(int(one_byte)))
    except:
        Temp_count = Temp_count  + 1
        print("Serial Not Open " + str(Temp_count))
        #pass
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
        #pass
#------------------

def go_forward():       #101
        TX_data(serial_port, 101)
        print(1)

def stop():             #102
        TX_data(serial_port, 102)
        print(2)

def backward():         #103
        TX_data(serial_port, 103)
        print(3)

def turn_left30():      #111  
        TX_data(serial_port, 111)
        

def turn_left45():      #112
        TX_data(serial_port, 112)
        

def move_left():        #113
        TX_data(serial_port, 113)


def turn_right30():     #121        
        TX_data(serial_port, 121)

def turn_right45():     #122
        TX_data(serial_port, 122)

def move_right():        #123
        TX_data(serial_port, 123)


def move_obstacle():
        pass

def obstacles():
        pass

def bridge():
        pass

def door():
        pass

def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()

if __name__ == '__main__':
        BPS = 4800
        W_View_size = 240
        H_View_size = 320
        serial_use = 1    
        if serial_use <> 0:
                serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
                serial_port.flush() # serial cls

        TX_data(serial_port, 250)
        search = search.Search(4800,240,320)
        View_select = 0
        while True:
                old_time = clock()
                if serial_port.inWaiting() > 0:
                        Read_RX = RX_data(serial_port)
                key = 0xFF & cv2.waitKey(1)
                if key == 27:  # ESC  Key
                        break
                elif key == ord(' '):  # spacebar Key
                        if View_select == 0:
                                View_select = 1
                
                        else:
                                View_select = 0
                else:
                        pass
                search.yellow_line(View_select)
                #search.blue_area(View_select)
                slope_y = search.slope_y
                cord_y = [search.X_255_point0, search.Y_255_point0]
                if cord_y[0] > 0:
                    if slope_y<50  :
                        turn_left30()
                    elif slope_y>50 and slope_y<70 :
                        if cord_y[0] > 130 and cord_y[0] < 190:
                            go_forward()
                        elif cord_y[0] > 190:
                            move_right()
                        elif cord_y[0]  <130:
                            move_left()
                    elif slope_y>70 and slope_y <150:
                        turn_right30()
                    else:
                        pass
                        #TX_data(serial_port, 0)
                else :
                    pass
                    #TX_data(serial_port, 0)


                Frame_time = (clock() - old_time) * 1000.
                old_time = clock() 
                
                print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
                
                # free HK, Taiwan Number One