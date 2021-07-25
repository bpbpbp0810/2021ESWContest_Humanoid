#-*- coding:utf-8 -*-
import platform
import os
import sys
import time
import cv2
import numpy as np
import houghline_searchtest as search


View_select = 0
operate = 1


def clock():
    return cv2.getTickCount() / cv2.getTickFrequency()


def main():
    global flag

    
    operate_y = 1
    View_select = 0
    operate_g = 1
    operate_y_1 = 1
    while True:
        old_time = clock()
        search.yellow_line(View_select, operate_y)
        search.green_detect(View_select, operate_g)
        search.yellow_detect(View_select, operate_y_1)
        

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
                search.View_select_y_g = 1
            else:
                View_select = 0
                search.View_select_y = 0
                search.View_select_g = 0
                search.View_select_y_d = 0
        elif key == ord('1'):
            print(search.slope_yellow)
        elif key == ord('2'):
            print(search.center_yellow_X)
        elif key == ord('3'):
            print(search.center_green_X)
        elif key == ord('4'):
            print(search.center_green_Y)
        elif key == ord('5'):
            print(search.center_yellow_X255)
        elif key == ord('6'):
            print(search.door)    
        #\print("time=  %.1f ms" % (Frame_time))

if __name__ == '__main__':
    BPS = 4800
    search = search.Search(4800, 320, 240)
    main()