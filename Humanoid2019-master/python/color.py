import cv2
import numpy as np

colors = []
Top_name = 'Testing'

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

def on_mouse_click (event, x, y, flags, frame):
    if event == cv2.EVENT_LBUTTONUP:
        colors.append(frame[y,x].tolist())


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


def main():
    cap = cv2.VideoCapture(0)
    cap.set(3, 320)
    cap.set(4, 180)

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

    while True:
        _, frame = cap.read()

        hsv = cv2.cvtColor(frame, cv2.COLOR_BGR2HSV)

        lower_blue = np.array([0,75,95])
        upper_blue = np.array([15,105,160])

        mask = cv2.inRange(hsv, hsv_Lower, hsv_Upper)

        res = cv2.bitwise_and(frame,frame, mask=mask)

        cv2.imshow('frame',frame)
        cv2.imshow('mask', mask)
        cv2.imshow('res',res)
        if colors:
            cv2.putText(hsv, str(colors[-1]), (10, 50), cv2.FONT_HERSHEY_PLAIN, 2, (0, 0, 0), 2)
        cv2.imshow('frame', hsv)
        cv2.setMouseCallback('frame', on_mouse_click, hsv)
        k = cv2.waitKey(5) & 0xFF
        if k == 27:
            break
    cap.release()
    cv2.destroyAllWindows()
    minb = min(c[0] for c in colors)
    ming = min(c[1] for c in colors)
    minr = min(c[2] for c in colors)
    maxb = max(c[0] for c in colors)
    maxg = max(c[1] for c in colors)
    maxr = max(c[2] for c in colors)
    print minr, ming, minb, maxr, maxg, maxb

    lb = [minb,ming,minr]
    ub = [maxb,maxg,maxr]
    print lb, ub


if __name__ == "__main__":
    main()
