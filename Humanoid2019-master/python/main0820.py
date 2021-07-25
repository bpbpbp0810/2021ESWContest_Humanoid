import platform
import serial
import search_ver2 as search
#from multiprocessing import Process
from threading import Thread
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
def RX_data2(serial):
    
    while True:
        global Temp_count
        global Read_RX
        try:
            if serial.inWaiting() > 0:
                result = serial.read(1)
                Read_RX = ord(result)
                #return RX
            else:
                Read_RX = 0
        except:
            Temp_count = Temp_count + 1
            print("Serial Not Open " + str(Temp_count))
            #return 0
            Read_RX = 0
        time.sleep(5)

#------------------

def go_forward():       #101
        TX_data(serial_port, 101)
        print(1)
        
def stop():             #102
        TX_data(serial_port, 102)
        #print(2)
        
def backward():         #103
        TX_data(serial_port, 103)
        #print(3)

def turn_left30():      #111  
        TX_data(serial_port, 111)
        print(2)
        

def turn_left45():      #112
        TX_data(serial_port, 112)
        print(3)
        
        
def move_left():        #113
        TX_data(serial_port, 113)
        print(4)
        
def turn_head_left():
        pass

def turn_right30():     #121        
        TX_data(serial_port, 121)
        #print(5)

def turn_right45():     #122
        TX_data(serial_port, 122)
        #print(6)

def move_right():        #123
        TX_data(serial_port, 123)
        #print(7)

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
        W_View_size = 320
        H_View_size = 240
        serial_use = 1    
        if serial_use <> 0:
                serial_port = serial.Serial('/dev/ttyAMA0', BPS, timeout=0.001)
                #serial_port.flush()
                t = Thread(target  = RX_data2, args=(serial_port, ))
                time.sleep(0.1)
                t.deamon = True
                t.start()
        search = search.Search(4800,W_View_size,H_View_size)
        View_select = 0
        #start_signal = 1

        #t1 = Thread(target=RX_data2, args=(serial_port,))
        #t1.start()
        while True:
                old_time = clock()
                key = 0xFF & cv2.waitKey(1)
                if key == 27:  # ESC  Key
                        break
                elif key == ord(' '):  # spacebar Key
                        if View_select == 0:
                                View_select = 1
                
                        else:
                                View_select = 0  
                search.yellow_line(View_select)
                slope_y = search.slope_y
                cord_y = [int(search.X_255_point0), int(search.Y_255_point0)]
                if Read_RX == 111:
                        TX_data(serial_port, slope_y)
                        print(slope_y)
                elif Read_RX == 112:
                        TX_data(serial_port, cord_y[0])
                        print(cord_y[0])
                
                print(Read_RX)
                Frame_time = (clock() - old_time) * 1000.
                old_time = clock() 
                #start_signal = 0
                #print(" " + str(W_View_size) + " x " + str(H_View_size) + " =  %.1f ms" % (Frame_time))
        t.join()