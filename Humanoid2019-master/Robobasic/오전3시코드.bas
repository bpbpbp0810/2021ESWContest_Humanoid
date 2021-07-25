2'******** 2족 보행로봇 초기 영점 프로그램 ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM D AS BYTE
DIM 보행속도 AS BYTE
DIM 좌우속도 AS BYTE
DIM 좌우속도2 AS BYTE
DIM 보행순서 AS BYTE
DIM 현재전압 AS BYTE
DIM 반전체크 AS BYTE
DIM 모터ONOFF AS BYTE
DIM aaa AS BYTE
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER

DIM 곡선방향 AS BYTE
DIM STEPNUM AS BYTE
DIM 넘어진확인 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE

DIM 적외선거리값  AS BYTE

DIM 미션수행 AS BYTE
DIM ff  AS BYTE
DIM 히히 AS BYTE

DIM S11  AS BYTE

DIM S16  AS BYTE
DIM L AS INTEGER
'************************************************
DIM NO_0 AS BYTE
DIM NO_1 AS BYTE
DIM NO_2 AS BYTE
DIM NO_3 AS BYTE
DIM NO_4 AS BYTE

DIM NUM AS BYTE

DIM BUTTON_NO AS INTEGER
DIM SOUND_BUSY AS BYTE
DIM TEMP_INTEGER AS INTEGER

'**** 기울기센서포트 설정 ****
CONST 앞뒤기울기AD포트 = 0
CONST 좌우기울기AD포트 = 1
CONST 기울기확인시간 = 10  'ms

CONST min = 61	'뒤로넘어졌을때
CONST max = 107	'앞으로넘어졌을때
CONST COUNT_MAX = 3


CONST 머리이동속도 = 10
CONST LOW =103 ' 노란선 따라갈 때 중심 '범위중간 128
CONST HIGH = 153
DIM 보행후지연시간  AS INTEGER
보행후지연시간 =1000
DIM delayy AS INTEGER '연속전진 중간중간의 delay값
delayy = 50
DIM turn AS INTEGER
'************************************************



PTP SETON 				'단위그룹별 점대점동작 설정
PTP ALLON				'전체모터 점대점 동작 설정

DIR G6A,1,0,0,1,0,0		'모터0~5번
DIR G6D,0,1,1,0,1,1		'모터18~23번
DIR G6B,1,1,1,1,1,1		'모터6~11번
DIR G6C,0,0,0,0,1,0		'모터12~17번

'************************************************

OUT 52,0	'머리 LED 켜기
'***** 초기선언 '************************************************

보행순서 = 0
반전체크 = 0
기울기확인횟수 = 0
'보행횟수 = 1
모터ONOFF = 0

'****초기위치 피드백*****************************


TEMPO 230
MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
'S16 = MOTORIN(16)


S16 = 30

SERVO 11, 100
SERVO 16, S16



GOSUB 전원초기자세
GOSUB 기본자세


GOSUB 자이로INIT
GOSUB 자이로MID
GOSUB 자이로ON



PRINT "VOLUME 200 !"

GOSUB All_motor_mode3

'DELAY 3000
'GOSUB 횟수_전진종종걸음m


GOTO MAIN 	'시리얼 수신 루틴으로 가기

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
시작음:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
종료음:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
에러음:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '전포트서보모터사용설정

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    모터ONOFF = 0
    GOSUB 시작음			
    RETURN

    '************************************************
    '전포트서보모터사용설정
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    모터ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB 종료음	
    RETURN
    '************************************************
    '위치값피드백
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '위치값피드백
MOTOR_SET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
All_motor_Reset:

    MOTORMODE G6A,1,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1,1
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1

    RETURN
    '************************************************
All_motor_mode2:

    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2

    RETURN
    '************************************************
All_motor_mode3:

    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3

    RETURN
    '************************************************
Leg_motor_mode1:
    MOTORMODE G6A,1,1,1,1,1
    MOTORMODE G6D,1,1,1,1,1
    RETURN
    '************************************************
Leg_motor_mode2:
    MOTORMODE G6A,2,2,2,2,2
    MOTORMODE G6D,2,2,2,2,2
    RETURN

    '************************************************
Leg_motor_mode3:
    MOTORMODE G6A,3,3,3,3,3
    MOTORMODE G6D,3,3,3,3,3
    RETURN
    '************************************************
Leg_motor_mode4:
    MOTORMODE G6A,3,2,2,1,3
    MOTORMODE G6D,3,2,2,1,3
    RETURN
    '************************************************
Leg_motor_mode5:
    MOTORMODE G6A,3,2,2,1,2
    MOTORMODE G6D,3,2,2,1,2
    RETURN
    '************************************************
Arm_motor_mode1:
    MOTORMODE G6B,1,1,1,,,1
    MOTORMODE G6C,1,1,1,,1
    RETURN
    '************************************************
Arm_motor_mode2:
    MOTORMODE G6B,2,2,2,,,2
    MOTORMODE G6C,2,2,2,,2
    RETURN

    '************************************************
Arm_motor_mode3:
    MOTORMODE G6B,3,3,3,,,3
    MOTORMODE G6C,3,3,3,,3
    RETURN
    '************************************************
    '***********************************************
    '**** 자이로감도 설정 ****
자이로INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** 자이로감도 설정 ****
자이로MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
자이로MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
자이로MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
자이로ON:


    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0


    자이로ONOFF = 1

    RETURN
    '***********************************************
자이로OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    자이로ONOFF = 0
    RETURN

    '************************************************
전원초기자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '************************************************
고개들고_안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90,,100

    WAIT
    mode = 0

    RETURN
    '******************************************	
안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    SERVO 16, 30
    WAIT
    mode = 0

    RETURN

    '************************************************
기본자세:


    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    SERVO 16, 30
    WAIT
    mode = 0

    RETURN
    '******************************************	
기본자세2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    SERVO 16, 30
    mode = 0
    RETURN
    '******************************************	
기본자세3:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,30, 80
    MOVE G6C,100,30,80,,100
    WAIT
    'SERVO 16, 30
    mode = 0
    RETURN
    '******************************************	
차렷자세:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '******************************************
앉은자세:
    GOSUB 자이로OFF
    MOVE G6A,100, 145,  28, 145, 100, 100
    MOVE G6D,100, 145,  28, 145, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 1

    RETURN
    '**********************************************
RX_EXIT:

    ERX 4800, A, 진행코드_2

    GOTO RX_EXIT
    '**********************************************

GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************
    '**********************************************
팩치우기:


    SPEED 6
    MOVE G6A,100, 77, 145, 93, 100, 100
    MOVE G6D,100, 77, 145, 93, 100, 100
    MOVE G6B,100, 30, 80
    MOVE G6C,100, 30, 80
    WAIT

    MOVE G6A, 100, 97, 125, 88, 100,
    MOVE G6D, 100, 97, 125, 88, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6D, 100, 117, 105, 88, 100,
    MOVE G6A, 100, 117, 105, 88, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 132, 85, 93, 100,
    MOVE G6D, 100, 132, 85, 93, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6D, 100, 147, 60, 103, 100,
    MOVE G6A, 100, 147, 60, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 152, 55, 103, 100,
    MOVE G6D, 100, 152, 55, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 157, 50, 103, 100,
    MOVE G6D, 100, 157, 50, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 162, 45, 103, 100,
    MOVE G6D, 100, 162, 45, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A,100, 145, 28, 145, 100, 100
    MOVE G6D,100, 145, 28, 145, 100, 100
    MOVE G6B,100, 30, 80,
    MOVE G6C,100, 30, 80

    MOVE G6A,100, 145, 28, 157, 100, 100
    MOVE G6D,100, 145, 28, 157, 100, 100
    MOVE G6B,100, 30, 80,
    MOVE G6C,100, 30, 80

    MOVE G6A,100, 145, 28, 157, 100, 100
    MOVE G6D,100, 145, 28, 157, 100, 100
    MOVE G6B,160, 30, 80,
    MOVE G6C,100, 30, 80

    MOVE G6A,100, 145, 28, 157, 100, 100
    MOVE G6D,100, 145, 28, 157, 100, 100
    MOVE G6B,160, 10, 30,
    MOVE G6C,100, 30, 80

    MOVE G6A,100, 155, 28, 157, 100, 100
    MOVE G6D,100, 155, 28, 157, 100, 100
    MOVE G6B,160, 10, 30,
    MOVE G6C,100, 30, 80

    MOVE G6A,100, 155, 28, 157, 100, 100
    MOVE G6D,100, 155, 28, 157, 100, 100
    MOVE G6B,160, 10, 30,
    MOVE G6C,150, 30, 80

    MOVE G6A,100, 155, 28, 157, 100, 100
    MOVE G6D,100, 155, 28, 157, 100, 100
    MOVE G6B,160, 10, 30,
    MOVE G6C,150,10, 50

    MOVE G6A,100, 155, 28, 157, 100, 100
    MOVE G6D,100, 155, 28, 157, 100, 100
    MOVE G6B,160, 10, 30,
    MOVE G6C,150,30, 80

    MOVE G6A,100, 155, 28, 157, 100, 100
    MOVE G6D,100, 155, 28, 157, 100, 100
    MOVE G6B,160, 30, 80,
    MOVE G6C,150,30, 80

    MOVE G6A,100, 155, 28, 157, 100, 100
    MOVE G6D,100, 155, 28, 157, 100, 100
    MOVE G6B,100, 30, 80,
    MOVE G6C,150,30, 80

    MOVE G6A, 100, 155,  28, 142, 100,
    MOVE G6D, 100, 155,  28, 142, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 150,  30,  80,  ,  ,
    WAIT

    MOVE G6A, 100, 150,  33, 132, 100,
    MOVE G6D, 100, 150,  33, 132, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT

    MOVE G6A,100, 145, 28, 145, 100, 100
    MOVE G6D,100, 145, 28, 145, 100, 100
    MOVE G6B,100, 30, 80,
    MOVE G6C,100, 30, 80

    MOVE G6A, 100, 162, 45, 103, 100,
    MOVE G6D, 100, 162, 45, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 157, 50, 103, 100,
    MOVE G6D, 100, 157, 50, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 152, 55, 103, 100,
    MOVE G6D, 100, 152, 55, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6D, 100, 147, 60, 103, 100,
    MOVE G6A, 100, 147, 60, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 132, 85, 93, 100,
    MOVE G6D, 100, 132, 85, 93, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6D, 100, 117, 105, 88, 100,
    MOVE G6A, 100, 117, 105, 88, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 97, 125, 88, 100,
    MOVE G6D, 100, 97, 125, 88, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A,100, 77, 145, 93, 100, 100
    MOVE G6D,100, 77, 145, 93, 100, 100
    MOVE G6B,100, 30, 80
    MOVE G6C,100, 30, 80





    RETURN



연속전진:
    보행COUNT = 0
    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 10'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO 연속전진_1	
    ELSE
        보행순서 = 0

        SPEED 4

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 10

        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 연속전진_2	

    ENDIF


    '*******************************


연속전진_1:

    ETX 4800,11 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_2
    IF A = 11 THEN
        GOTO 연속전진_2
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF
    '**********

연속전진_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

연속전진_3:
    ETX 4800,11 '진행코드를 보냄

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, 연속전진_4
    IF A = 11 THEN
        GOTO 연속전진_4
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT	
        SPEED 2
        GOSUB 기본자세2

        GOTO RX_EXIT
    ENDIF

연속전진_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO 연속전진_1
    '*******************************
    '**********************************************
    '**********************************************
덤블링_1:
    GOSUB Leg_motor_mode3

    SPEED 8
    MOVE G6A,100, 77, 145, 93, 100, 100
    MOVE G6D,100, 77, 145, 93, 100, 100
    MOVE G6B,100, 30, 80
    MOVE G6C,100, 30, 80
    WAIT

    MOVE G6A, 100, 97, 125, 88, 100,
    MOVE G6D, 100, 97, 125, 88, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6D, 100, 117, 105, 88, 100,
    MOVE G6A, 100, 117, 105, 88, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 132, 85, 93, 100,
    MOVE G6D, 100, 132, 85, 93, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6D, 100, 147, 60, 103, 100,
    MOVE G6A, 100, 147, 60, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 152, 55, 103, 100,
    MOVE G6D, 100, 152, 55, 103, 100,

    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 157, 50, 103, 100,
    MOVE G6D, 100, 157, 50, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 162, 45, 103, 100,
    MOVE G6D, 100, 162, 45, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A,100, 145, 28, 145, 100, 100
    MOVE G6D,100, 145, 28, 145, 100, 100
    MOVE G6B,100, 30, 80,
    MOVE G6C,100, 30, 80

    MOVE G6B, 170, 30, 80, , ,
    MOVE G6C, 170, 30, 80, , ,

    MOVE G6A,100, 145, 60, 145, 100, 100
    MOVE G6D,100, 145, 60, 145, 100, 100
    MOVE G6B,160, 30, 80,
    MOVE G6C,160, 30, 80

    DELAY 1000

    MOVE G6A,100, 135, 60, 145, 100, 100
    MOVE G6D,100, 135, 60, 145, 100, 100
    MOVE G6B,140, 40, 60,
    MOVE G6C,140, 40, 60

    MOVE G6A,100, 145, 60, 115, 100, 100
    MOVE G6D,100, 145, 60, 115, 100, 100
    MOVE G6B,150, 40, 60,
    MOVE G6C,150, 40, 60

    MOVE G6A,100, 145, 60, 65, 100, 100
    MOVE G6D,100, 145, 60, 65, 100, 100
    MOVE G6B,160, 40, 60,
    MOVE G6C,160, 40, 60

    MOVE G6A,100, 145, 100, 25, 100, 100
    MOVE G6D,100, 145, 100, 25, 100, 100
    MOVE G6B,180, 40, 60,
    MOVE G6C,180, 40, 60, , 50

    MOVE G6A,100, 120, 80, 10, 100, 100
    MOVE G6D,100, 120, 80, 10, 100, 100
    MOVE G6B,190, 30, 80,
    MOVE G6C,190, 30, 80, , 90

    MOVE G6A,100, 120, 80, 10, 100, 100
    MOVE G6D,100, 120, 80, 10, 100, 100
    MOVE G6B,190, 30, 80,
    MOVE G6C,190, 30, 80, , 60

    MOVE G6A,100, 70, 130, 10, 100, 100
    MOVE G6D,100, 70, 130, 10, 100, 100
    MOVE G6B,190, 30, 80,
    MOVE G6C,190, 30, 80, , 40

    MOVE G6A,100, 70, 130, 10, 100, 100
    MOVE G6D,100, 70, 130, 10, 100, 100
    MOVE G6B,190, 30, 80,
    MOVE G6C,190, 30, 80, ,30

    MOVE G6A,100, 70, 140, 10, 100, 100
    MOVE G6D,100, 70, 140, 10, 100, 100
    MOVE G6B,190, 30, 80,
    MOVE G6C,190, 30, 80, , 10


    MOVE G6A,100, 20, 140, 10, 100, 100
    MOVE G6D,100, 20, 140, 10, 100, 100
    MOVE G6B,190, 10, 100,
    MOVE G6C,190, 10, 100, , 10

    DELAY 500


    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 15, 70, 140, 100,
    MOVE G6D,100, 15, 70, 140, 100,
    MOVE G6B,20, 140, 15
    MOVE G6C,20, 140, 15
    WAIT

    SPEED 12
    MOVE G6A,100, 136, 35, 80, 100,
    MOVE G6D,100, 136, 35, 80, 100,
    MOVE G6B,20, 30, 80
    MOVE G6C,20, 30, 80
    WAIT

    SPEED 12
    MOVE G6A,100, 165, 70, 30, 100,
    MOVE G6D,100, 165, 70, 30, 100,
    MOVE G6B,30, 20, 95
    MOVE G6C,30, 20, 95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165, 45, 90, 100,
    MOVE G6D,100, 165, 45, 90, 100,
    MOVE G6B,130, 50, 60
    MOVE G6C,130, 50, 60
    WAIT

    SPEED 6
    MOVE G6A,100, 145, 45, 130, 100,
    MOVE G6D,100, 145, 45, 130, 100,
    WAIT

    SPEED 8
    GOSUB All_motor_mode2

    DELAY 200
    GOSUB 기본자세
    GOSUB 자이로ON
    RETURN

    '*********************************************
진행코드:
    ETX 4800, 38
    PRINT "VOLUME 200 !"

진행코드_2:
    IF 미션수행>0 THEN GOTO 진행코드_3
    SERVO 16, 30
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인
    ETX 4800,107
    GOSUB 횟수_전진종종걸음m
    ''	GOSUB 횟수_전진종종걸음m
    ''	GOSUB 횟수_전진종종걸음m
    ''	GOSUB 횟수_전진종종걸음m
    ff = 0
aa:
    ff = ff + 1
    IF ff > 5 THEN GOTO 진행코드_2
    DELAY 1
    ERX 4800,A,aa

    IF  A=101 THEN
        보행횟수=6
        GOSUB 횟수_전진종종걸음m
        GOSUB 덤블링
        ''  GOSUB 계단오른발오르기1cmm
        '' GOSUB 횟수_전진종종걸음m
        ''  GOSUB 계단오른발오르기1cmm
        ''  GOSUB 한발앞으로가기
        ''  GOSUB mm계단내려가기
        'GOSUB mm계단내려가
        'GOSUB m오른쪽옆으로20
        'GOSUB m오른쪽옆으로20
        'GOSUB m오른쪽옆으로20
        'GOSUB m오른쪽옆으로20

        ETX 4800, 103

        미션수행=미션수행+1
        GOSUB 계단끝나고
        GOTO 진행코드_2

    ELSE
        SERVO 16, 30
        GOTO 곡선전진종종걸음

    ENDIF



진행코드_3:
    IF 미션수행>1 THEN GOTO 진행코드_4
    SERVO 16, 30
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인
    ETX 4800,103

    ff = 0
bb:
    ff = ff + 1
    IF ff > 5 THEN GOTO 진행코드_3

    DELAY 10

    IF  적외선거리값 > 100 THEN
        MUSIC "C"

        GOSUB 문앞에서
        GOSUB 새문열기
        'GOSUB 한발앞으로가기
        'GOSUB 한발앞으로가기
        'GOSUB 한발앞으로가기
        미션수행=미션수행+1
        GOTO 진행코드_3

    ELSE  ' A>0 THEN
        SERVO 16, 30
        GOTO 곡선전진종종걸음3

    ENDIF

진행코드_4:
    IF 미션수행>2 THEN GOTO 진행코드_5
    SERVO 16, 30
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인
    ETX 4800,103

    ff = 0
cc:
    ff = ff + 1
    IF ff > 5 THEN GOTO 진행코드_4
    DELAY 1
    ERX 4800,A,cc


    IF 적외선거리값 > 70 THEN
        GOSUB 터널
        'GOSUB gggg
        IF 적외선거리값 > 100 THEN
            'GOSUB 터널
            GOSUB 터널
            '        GOSUB 터널앞으로
            '       GOSUB 터널앞으로
        ENDIF
        ' GOSUB 터널앞으로
        'GOSUB 터널앞으로
        'GOSUB 기본자세
        '2->3
        GOSUB 기본자세2
        미션수행=미션수행+1
        GOTO 진행코드_4
    ELSEIF A>0 THEN
        GOTO 곡선전진종종걸음3
    ENDIF



진행코드_5:
    IF 미션수행 <3 THEN
        GOTO 진행코드_4
    ENDIF
    SERVO 16, 30
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인
    ETX 4800,103

    ff = 0
dd:
    ff = ff + 1
    IF ff > 5 THEN GOTO 진행코드_5
    DELAY 1
    ERX 4800,A,dd
    GOTO 곡선전진종종걸음4
    'STEPNUM = 18
    'GOTO num곡선전진종종걸음
ee:
    ETX 4800, 103
    SERVO 16, 30
    GOSUB 레버앞에서
ffff:
    ETX 4800, 106
    GOTO 레버앞에서2
    GOTO ffff
    'ETX 4800, 106
    'GOTO mmmLL연속전진


곡선전진종종걸음:
    SERVO 16, 30
    넘어진확인 = 0
    'ETX 4800, 103
    곡선방향 = 2
    SPEED 7
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 곡선전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 곡선전진종종걸음_4
    ENDIF



    '**********************

곡선전진종종걸음_1:
    SPEED 6
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


곡선전진종종걸음_3:
    SPEED 6
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,곡선전진종종걸음_4_0
    IF A= 102 THEN
        GOTO 곡선전진종종걸음좌회전_3멈춤
    ELSEIF A = 153 THEN
        '곡선방향 = 3
        GOTO 곡선전진종종걸음우_3멈춤
    ELSEIF A = 103 THEN  '왼쪽턴
        '곡선방향 = 1
        GOTO 곡선전진종종걸음좌_3멈춤
    ELSEIF A = 128 THEN
        곡선방향 = 2
    ELSEIF A = 150 THEN
        GOTO 곡선전진종종걸음좌_3멈춤
    ELSEIF A = 130 THEN
        GOTO 곡선전진종종걸음우_3멈춤
    ELSEIF A=154 THEN
        GOTO 곡선전진종종걸음우회전_3멈춤
    ELSE  '정지
        GOTO 곡선전진종종걸음_3멈춤
    ENDIF

곡선전진종종걸음_4_0:

    IF  곡선방향 = 1 THEN'왼쪽

    ELSEIF  곡선방향 = 3 THEN'오른쪽
        HIGHSPEED SETOFF
        SPEED 6
        'MOVE G6D,103,  71, 140, 105,  100
        'MOVE G6A, 95,  82, 146,  87, 102
        MOVE G6D,103,  73, 140, 100,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO 곡선전진종종걸음_1

    ENDIF



    '*********************************

곡선전진종종걸음_4:
    SPEED 6
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


곡선전진종종걸음_6:
    SPEED 6
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT



    ERX 4800, A ,곡선전진종종걸음_1_0
    IF A= 102 THEN
        GOTO 곡선전진종종걸음좌회전_6멈춤
    ELSEIF A = 153 THEN
        '곡선방향 = 3
        GOTO 곡선전진종종걸음우_6멈춤
    ELSEIF A = 103 THEN
        '곡선방향 = 1
        GOTO 곡선전진종종걸음좌_6멈춤
    ELSEIF A = 128 THEN
        곡선방향 = 2
    ELSEIF A = 150 THEN
        GOTO 곡선전진종종걸음좌_6멈춤
    ELSEIF A = 130 THEN
        GOTO 곡선전진종종걸음우_6멈춤
    ELSEIF A=154 THEN
        GOTO 곡선전진종종걸음우회전_6멈춤
    ELSE  '정지
        GOTO 곡선전진종종걸음_6멈춤
    ENDIF

곡선전진종종걸음_1_0:

    IF  곡선방향 = 1 THEN'왼쪽
        HIGHSPEED SETOFF
        SPEED 6
        'MOVE G6A,103,   71, 140, 105,  100
        'MOVE G6D, 95,  82, 146,  87, 102
        MOVE G6A,103,   73, 140, 100,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO 곡선전진종종걸음_4
    ELSEIF 곡선방향 = 3 THEN'오른쪽


    ENDIF



    GOTO 곡선전진종종걸음_1
    '******************************************
    '******************************************
    '*************************  ********
곡선전진종종걸음_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOTO 진행코드 	
    '*************************  ********
곡선전진종종걸음좌_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m왼쪽옆으로20
    'GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음	
    '*************************  ********
곡선전진종종걸음좌회전_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m왼쪽턴20
    'GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음	
    '*************************  ********
곡선전진종종걸음우_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m오른쪽옆으로20
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음
    '******************************************
곡선전진종종걸음우회전_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m오른쪽턴20
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음
    '******************************************
곡선전진종종걸음좌_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m왼쪽옆으로20
    ' GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음
    '******************************************
곡선전진종종걸음좌회전_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m왼쪽턴20
    DELAY 1000
    ' GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음
    '******************************************
곡선전진종종걸음우_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m오른쪽옆으로20
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음
    '******************************************
곡선전진종종걸음우회전_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m오른쪽턴20
    DELAY 1000
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음
    '******************************************
곡선전진종종걸음_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOTO 진행코드
    '***************************************************
num곡선전진종종걸음:

    SERVO 16, 30
    넘어진확인 = 0
    ETX 4800, 103
    곡선방향 = 2
    SPEED 7
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    ' STEPNUM = STEPNUM-1

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO num곡선전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO num곡선전진종종걸음_4
    ENDIF



    '**********************

num곡선전진종종걸음_1:
    SPEED 6
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


num곡선전진종종걸음_3:
    SPEED 6
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,num곡선전진종종걸음_4_0

    STEPNUM = STEPNUM-1
    IF A = 153 THEN
        곡선방향 = 3
    ELSEIF A = 103 THEN  '왼쪽턴
        곡선방향 = 1
    ELSEIF A = 128 THEN
        곡선방향 = 2
    ELSEIF A = 150 THEN
        GOTO num곡선전진종종걸음좌_3멈춤
    ELSEIF A = 130 THEN
        GOTO num곡선전진종종걸음우_3멈춤
    ELSE  '정지
        GOTO num곡선전진종종걸음_3멈춤
    ENDIF

num곡선전진종종걸음_4_0:

    IF  곡선방향 = 1 THEN'왼쪽

    ELSEIF  곡선방향 = 3 THEN'오른쪽
        HIGHSPEED SETOFF
        SPEED 6
        'MOVE G6D,103,  71, 140, 105,  100
        'MOVE G6A, 95,  82, 146,  87, 102
        MOVE G6D,103,  73, 140, 100,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO num곡선전진종종걸음_1

    ENDIF



    '*********************************

num곡선전진종종걸음_4:
    SPEED 6
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


num곡선전진종종걸음_6:
    SPEED 6
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT



    ERX 4800, A ,num곡선전진종종걸음_1_0
    STEPNUM = STEPNUM -1
    IF A = 153 THEN
        곡선방향 = 3
    ELSEIF A = 103 THEN
        곡선방향 = 1
    ELSEIF A = 128 THEN
        곡선방향 = 2
    ELSEIF A = 150 THEN
        GOTO num곡선전진종종걸음좌_6멈춤
    ELSEIF A = 130 THEN
        GOTO num곡선전진종종걸음우_6멈춤
    ELSE  '정지
        GOTO num곡선전진종종걸음_6멈춤
    ENDIF

num곡선전진종종걸음_1_0:

    IF  곡선방향 = 1 THEN'왼쪽
        HIGHSPEED SETOFF
        SPEED 6
        'MOVE G6A,103,   71, 140, 105,  100
        'MOVE G6D, 95,  82, 146,  87, 102
        MOVE G6A,103,   73, 140, 100,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO num곡선전진종종걸음_4
    ELSEIF 곡선방향 = 3 THEN'오른쪽


    ENDIF



    GOTO num곡선전진종종걸음_1
    '******************************************
    '******************************************
    '*************************  ********
num곡선전진종종걸음_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    IF STEPNUM <10 THEN   '-값 되면 이상해짐
        GOTO ee
    ENDIF
    GOTO 진행코드 	
    '*************************  ********
num곡선전진종종걸음좌_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    IF STEPNUM <10 THEN
        GOTO ee
    ENDIF
    GOSUB m왼쪽옆으로20
    'GOSUB m왼쪽옆으로20
    GOTO num곡선전진종종걸음	
    '*************************  ********
num곡선전진종종걸음우_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    IF STEPNUM <10 THEN
        GOTO ee
    ENDIF
    GOSUB m오른쪽옆으로20
    'GOSUB m오른쪽옆으로20
    GOTO num곡선전진종종걸음
    '******************************************
num곡선전진종종걸음좌_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    IF STEPNUM <10 THEN
        GOTO ee
    ENDIF
    GOSUB m왼쪽옆으로20
    ' GOSUB m왼쪽옆으로20
    GOTO num곡선전진종종걸음
    '******************************************
num곡선전진종종걸음우_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    IF STEPNUM <10 THEN
        GOTO ee
    ENDIF
    GOSUB m오른쪽옆으로20
    'GOSUB m오른쪽옆으로20
    GOTO num곡선전진종종걸음
    '******************************************
num곡선전진종종걸음_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    IF STEPNUM <10 THEN
        GOTO ee
    ENDIF
    GOTO 진행코드


    '***************************************************

곡선전진종종걸음3:
    넘어진확인 = 0
    'ETX 4800, 103
    곡선방향 = 2
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 곡선전진종종걸음3
    ENDIF
    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 곡선전진종종걸음3_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 곡선전진종종걸음3_4
    ENDIF



    '**********************

곡선전진종종걸음3_1:
    SPEED 9
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


곡선전진종종걸음3_3:
    SPEED 9
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,곡선전진종종걸음3_4_0

    GOSUB 적외선거리센서확인
    IF 미션수행=1 AND 적외선거리값>100 THEN
        GOTO 곡선전진종종걸음3_3멈춤
    ELSEIF 미션수행=2 AND 적외선거리값 >70 THEN
        GOTO 곡선전진종종걸음3_3멈춤
    ELSEIF A= 102 THEN
        GOTO 곡선전진종종걸음좌회전3_3멈춤
    ELSEIF A = 153 THEN
        '곡선방향 = 3
        'GOTO 곡선전진종종걸음우3_3멈춤
        GOTO 곡선전진종종걸음작은우회전3_3멈춤
    ELSEIF A = 103 THEN
        '곡선방향 = 1
        'GOTO 곡선전진종종걸음좌3_3멈춤
        GOTO 곡선전진종종걸음작은좌회전3_3멈춤
    ELSEIF A = 128 THEN
        곡선방향 = 2
    ELSEIF A = 150 THEN
        GOTO 곡선전진종종걸음좌3_3멈춤
    ELSEIF A = 130 THEN
        GOTO 곡선전진종종걸음우3_3멈춤
    ELSEIF A=154 THEN
        GOTO 곡선전진종종걸음우회전3_3멈춤
    ELSE  '정지
        GOTO 곡선전진종종걸음3_3멈춤

    ENDIF

곡선전진종종걸음3_4_0:

    IF  곡선방향 = 1 THEN'왼쪽

    ELSEIF  곡선방향 = 3 THEN'오른쪽
        HIGHSPEED SETOFF
        SPEED 9
        'MOVE G6D,103,  71, 140, 105,  100
        'MOVE G6A, 95,  82, 146,  87, 102
        MOVE G6D,103,  73, 140, 100,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO 곡선전진종종걸음3_1

    ENDIF



    '*********************************

곡선전진종종걸음3_4:
    SPEED 9
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


곡선전진종종걸음3_6:
    SPEED 9
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT



    ERX 4800, A ,곡선전진종종걸음3_1_0

    GOSUB 적외선거리센서확인
    IF 미션수행=1 AND 적외선거리값>150 THEN
        GOTO 곡선전진종종걸음3_6멈춤
    ELSEIF 미션수행=2 AND 적외선거리값 >70 THEN
        GOTO 곡선전진종종걸음3_6멈춤
    ELSEIF A= 102 THEN
        GOTO 곡선전진종종걸음좌회전3_6멈춤
    ELSEIF A = 153 THEN
        '곡선방향 = 3
        'GOTO 곡선전진종종걸음우3_6멈춤
        GOTO 곡선전진종종걸음작은우회전3_6멈춤
    ELSEIF A = 103 THEN
        '곡선방향 = 1
        'GOTO 곡선전진종종걸음좌3_6멈춤
        GOTO 곡선전진종종걸음작은좌회전3_6멈춤
    ELSEIF A = 128 THEN
        곡선방향 = 2
    ELSEIF A = 150 THEN
        GOTO 곡선전진종종걸음좌3_6멈춤
    ELSEIF A = 130 THEN
        GOTO 곡선전진종종걸음우3_6멈춤
    ELSEIF A=154 THEN
        GOTO 곡선전진종종걸음우회전3_6멈춤
    ELSE  '정지
        GOTO 곡선전진종종걸음3_6멈춤
    ENDIF

곡선전진종종걸음3_1_0:

    IF  곡선방향 = 1 THEN'왼쪽
        HIGHSPEED SETOFF
        SPEED 9
        'MOVE G6A,103,   71, 140, 105,  100
        'MOVE G6D, 95,  82, 146,  87, 102
        MOVE G6A,103,   73, 140, 100,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO 곡선전진종종걸음3_4
    ELSEIF 곡선방향 = 3 THEN'오른쪽


    ENDIF



    GOTO 곡선전진종종걸음3_1
    '******************************************
    '******************************************
    '*********************************
곡선전진종종걸음3_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    'GOSUB 팩치우기
    GOTO 진행코드 	
    '******************************************
곡선전진종종걸음좌3_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m왼쪽옆으로20
    'GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음3	
    '*************************  ********
곡선전진종종걸음좌회전3_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m왼쪽턴20
    'GOSUB 왼쪽턴10
    'GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음3	
    '*************************  ********
곡선전진종종걸음작은좌회전3_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    'GOSUB m왼쪽턴20
    GOSUB 왼쪽턴10
    'GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음3	
    '*************************  ********
곡선전진종종걸음우3_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m오른쪽옆으로20
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음3
    '*******************************************88
곡선전진종종걸음우회전3_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m오른쪽턴20
    'GOSUB 오른쪽턴10
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음3
    '******************************************
곡선전진종종걸음작은우회전3_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    'GOSUB m오른쪽턴20
    GOSUB 오른쪽턴10
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음3
    '******************************************
곡선전진종종걸음3_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세
    'GOSUB 팩치우기
    GOTO 진행코드
    '************************************
곡선전진종종걸음좌3_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m왼쪽옆으로20
    ' GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음3
    '******************************************
곡선전진종종걸음좌회전3_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m왼쪽턴20
    'GOSUB 왼쪽턴10
    ' GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음3
    '******************************************
곡선전진종종걸음작은좌회전3_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    'GOSUB m왼쪽턴20
    GOSUB 왼쪽턴10
    ' GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음3
    '******************************************
곡선전진종종걸음우3_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m오른쪽옆으로20
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음3
    '************************************
곡선전진종종걸음우회전3_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m오른쪽턴20
    'GOSUB 오른쪽턴10
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음3
    '**********************
곡선전진종종걸음작은우회전3_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    ' GOSUB m오른쪽턴20
    GOSUB 오른쪽턴10
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음3
    '******************************************
곡선전진종종걸음4:
    넘어진확인 = 0
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 곡선전진종종걸음4
    ENDIF
    GOSUB 적외선거리센서확인
    ETX 4800, 103
    곡선방향 = 2
    SPEED 10
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 곡선전진종종걸음4_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO 곡선전진종종걸음4_4
    ENDIF



    '**********************

곡선전진종종걸음4_1:
    SPEED 9
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


곡선전진종종걸음4_3:
    ETX 4800, 103
    SPEED 9
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,곡선전진종종걸음4_4_0

    GOSUB 적외선거리센서확인
    IF 적외선거리값>60  THEN
        GOTO 곡선전진종종걸음4_3멈춤
    ELSEIF A= 102 THEN
        GOTO 곡선전진종종걸음좌회전4_3멈춤
    ELSEIF A = 153 THEN
        곡선방향 = 3
    ELSEIF A = 103 THEN
        곡선방향 = 1
    ELSEIF A = 128 THEN
        곡선방향 = 2
    ELSEIF A = 150 THEN
        GOTO 곡선전진종종걸음좌4_3멈춤
    ELSEIF A = 130 THEN
        GOTO 곡선전진종종걸음우4_3멈춤
    ELSEIF A=154 THEN
        GOTO 곡선전진종종걸음우회전4_3멈춤
    ELSE  '정지
        GOTO 곡선전진종종걸음4

    ENDIF

곡선전진종종걸음4_4_0:

    IF  곡선방향 = 1 THEN'왼쪽

    ELSEIF  곡선방향 = 3 THEN'오른쪽
        HIGHSPEED SETOFF
        SPEED 9
        'MOVE G6D,103,  71, 140, 105,  100
        'MOVE G6A, 95,  82, 146,  87, 102
        MOVE G6D,103,  73, 140, 100,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO 곡선전진종종걸음4_1

    ENDIF



    '*********************************

곡선전진종종걸음4_4:
    SPEED 9
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


곡선전진종종걸음4_6:
    ETX 4800, 103
    SPEED 9
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT

    ERX 4800, A ,곡선전진종종걸음4_1_0

    GOSUB 적외선거리센서확인
    IF 적외선거리값>60  THEN
        GOTO 곡선전진종종걸음4_6멈춤
    ELSEIF A= 102 THEN
        GOTO 곡선전진종종걸음좌회전4_6멈춤
    ELSEIF A = 153 THEN
        곡선방향 = 3
    ELSEIF A = 103 THEN
        곡선방향 = 1
    ELSEIF A = 128 THEN
        곡선방향 = 2
    ELSEIF A = 150 THEN
        GOTO 곡선전진종종걸음좌4_6멈춤
    ELSEIF A = 130 THEN
        GOTO 곡선전진종종걸음우4_6멈춤
    ELSEIF A=154 THEN
        GOTO 곡선전진종종걸음우회전4_6멈춤
    ELSE  '정지
        GOTO 곡선전진종종걸음4
    ENDIF

곡선전진종종걸음4_1_0:

    IF  곡선방향 = 1 THEN'왼쪽
        HIGHSPEED SETOFF
        SPEED 9
        'MOVE G6A,103,   71, 140, 105,  100
        'MOVE G6D, 95,  82, 146,  87, 102
        MOVE G6A,103,   73, 140, 100,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO 곡선전진종종걸음4_4
    ELSEIF 곡선방향 = 3 THEN'오른쪽


    ENDIF



    GOTO 곡선전진종종걸음4_1
    '******************************************
    '******************************************
    '*********************************
곡선전진종종걸음4_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    'GOSUB 팩치우기
    GOTO ee	
    '******************************************
곡선전진종종걸음좌4_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m왼쪽옆으로20
    'GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음4	
    '*************************  ********
곡선전진종종걸음좌회전4_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    'GOSUB m왼쪽턴20
    GOSUB 왼쪽턴10
    'GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음4	
    '*************************  ********
곡선전진종종걸음우4_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m오른쪽옆으로20
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음4
    '*******************************************88
곡선전진종종걸음우회전4_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    'GOSUB m오른쪽턴20
    GOSUB 오른쪽턴10
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음4
    '******************************************
곡선전진종종걸음4_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 10
    GOSUB 기본자세
    'GOSUB 팩치우기
    GOTO ee
    '************************************
곡선전진종종걸음좌4_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m왼쪽옆으로20
    ' GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음4
    '******************************************
곡선전진종종걸음좌회전4_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    'GOSUB m왼쪽턴20
    GOSUB 왼쪽턴10
    ' GOSUB m왼쪽옆으로20
    GOTO 곡선전진종종걸음4
    '******************************************
곡선전진종종걸음우4_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    GOSUB m오른쪽옆으로20
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음4
    '************************************
곡선전진종종걸음우회전4_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB 안정화자세
    SPEED 7
    GOSUB 기본자세
    'GOSUB m오른쪽턴20
    GOSUB 오른쪽턴10
    'GOSUB m오른쪽옆으로20
    GOTO 곡선전진종종걸음4

    '******************************************
터널2:
    SPEED 12
    GOSUB 자이로OFF

    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,   80, , 130
    WAIT
    MOVE G6A, 100,  97, 125,  88, 100,
    MOVE G6D, 100,  97, 125,  88, 100,
    MOVE G6D, 100, 117, 105,  88, 100,
    MOVE G6A, 100, 117, 105,  88, 100,

    MOVE G6A, 100, 132,  85,  93, 100,
    MOVE G6D, 100, 132,  85,  93, 100,

    MOVE G6D, 100, 147,  60, 103, 100,
    MOVE G6A, 100, 147,  60, 103, 100,


    MOVE G6A, 100, 152,  55, 103, 100,
    MOVE G6D, 100, 152,  55, 103, 100,

    MOVE G6A, 100, 157,  50, 103, 100,
    MOVE G6D, 100, 157,  50, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 162,  45, 103, 100,
    MOVE G6D, 100, 162,  45, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 167,  40, 103, 100,
    MOVE G6D, 100, 167,  40, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 172,  35, 108, 100,
    MOVE G6D, 100, 172,  35, 108, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 172,  35,  43, 100,
    MOVE G6D, 100, 172,  35,  43, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 112,  85,  43, 100,
    MOVE G6D, 100, 112,  85,  43, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    SPEED 6

    '*******************************************
    FOR i=0 TO 10

        MOVE G6A, 100, 150,  55,  33, 100,
        MOVE G6D, 100, 150,  55,  33, 100,
        MOVE G6B,  27,  55,  30,  ,  ,
        MOVE G6C,  27,  55,  30,  ,  ,

        MOVE G6A, 100, 150,  55,  33, 100,
        MOVE G6D, 100, 150,  55,  33, 100,
        MOVE G6B,  27,  35,  50,  ,  ,
        MOVE G6C,  27,  35,  50,  ,  ,

        MOVE G6A, 100, 150,  55,  33, 100,
        MOVE G6D, 100, 150,  55,  33, 100,
        MOVE G6B,  10,  25,  70,  ,  ,
        MOVE G6C,  10,  25,  70,  ,  ,

        MOVE G6A, 100, 150,  55,  33, 100,
        MOVE G6D, 100, 150,  55,  33, 100,
        MOVE G6B,  10,  55,  40,  ,  ,
        MOVE G6C,  10,  55,  40,  ,  ,

        '*'*'*'*'*'*'*'*'*'*'*'*'*'*

        MOVE G6A, 100, 150,  55,  33, 100,
        MOVE G6D, 100, 150,  55,  33, 100,
        MOVE G6B,  27,  55,  30,  ,  ,
        MOVE G6C,  27,  55,  30,  ,  ,

        MOVE G6A, 100, 150,  55,  33, 100,
        MOVE G6D, 100, 150,  55,  33, 100,
        MOVE G6B,  27,  35,  50,  ,  ,
        MOVE G6C,  27,  35,  50,  ,  ,

        MOVE G6A, 100, 150,  55,  33, 100,
        MOVE G6D, 100, 150,  55,  33, 100,
        MOVE G6B,  10,  25,  70,  ,  ,
        MOVE G6C,  10,  25,  70,  ,  ,

        MOVE G6A, 100, 150,  55,  33, 100,
        MOVE G6D, 100, 150,  55,  33, 100,
        MOVE G6B,  10,  55,  40,  ,  ,
        MOVE G6C,  10,  55,  40,  ,  ,

    NEXT


    '*************************************************
    MOVE G6A, 100, 150,  55,  33, 100,
    MOVE G6D, 100, 150,  55,  33, 100,
    MOVE G6B,  10,  45,  50,  ,  ,
    MOVE G6C,  10,  45,  50,  ,  ,

    MOVE G6A, 100, 150,  55,  33, 100,
    MOVE G6D, 100, 150,  55,  33, 100,
    MOVE G6B,  10,  15,  90,  ,  ,
    MOVE G6C,  10,  15,  90,  ,  ,

    MOVE G6A, 100, 150,  75,  33, 100,
    MOVE G6D, 100, 150,  75,  33, 100,
    MOVE G6B,  10,  15,  90,  ,  ,
    MOVE G6C,  10,  15,  90,  ,  ,

    MOVE G6A, 100, 150,  75,  53, 100,
    MOVE G6D, 100, 150,  75,  53, 100,
    MOVE G6B,  10,  15,  90,  ,  ,
    MOVE G6C,  10,  15,  90,  ,  ,

    MOVE G6A, 100, 150,  75,  53, 100,
    MOVE G6D, 100, 150,  75,  53, 100,
    MOVE G6B,  10,  30,  90,  ,  ,
    MOVE G6C,  10,  30,  90,  ,  ,

    MOVE G6A, 100, 150,  75,  53, 100,
    MOVE G6D, 100, 150,  75,  53, 100,
    MOVE G6B,  100,  30,  90,  ,  ,
    MOVE G6C,  100,  30,  90,  ,  ,

    MOVE G6A, 100, 150,  75,  83, 100,
    MOVE G6D, 100, 150,  75,  83, 100,
    MOVE G6B,  100,  30,  90,  ,  ,
    MOVE G6C,  100,  30,  90,  ,  ,

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,

    RETURN
    '*******************************************



터널가기:
    SPEED 6
    GOSUB 자이로OFF
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,   80, , 130
    WAIT
    MOVE G6A, 100,  97, 125,  88, 100,
    MOVE G6D, 100,  97, 125,  88, 100,
    MOVE G6D, 100, 117, 105,  88, 100,
    MOVE G6A, 100, 117, 105,  88, 100,

    MOVE G6A, 100, 132,  85,  93, 100,
    MOVE G6D, 100, 132,  85,  93, 100,

    MOVE G6D, 100, 147,  60, 103, 100,
    MOVE G6A, 100, 147,  60, 103, 100,


    MOVE G6A, 100, 152,  55, 103, 100,
    MOVE G6D, 100, 152,  55, 103, 100,

    MOVE G6A, 100, 157,  50, 103, 100,
    MOVE G6D, 100, 157,  50, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 162,  45, 103, 100,
    MOVE G6D, 100, 162,  45, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 167,  40, 103, 100,
    MOVE G6D, 100, 167,  40, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 172,  35, 108, 100,
    MOVE G6D, 100, 172,  35, 108, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 172,  35,  43, 100,
    MOVE G6D, 100, 172,  35,  43, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 112,  85,  43, 100,
    MOVE G6D, 100, 112,  85,  43, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 100, 105,  15, 100,
    MOVE G6D, 100, 100, 105,  15, 100,
    MOVE G6B,  10,  45,  50,  ,  ,
    MOVE G6C,  10,  45,  50,  ,  ,

    SPEED 12

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  10,  65,  50,  ,  ,
    MOVE G6C,  10,  65,  50,  ,  ,

    MOVE G6A, 100, 150, 55,  25, 100,
    MOVE G6D, 100, 150, 55,  25, 100,
    MOVE G6B,  35,  65,  50,  ,  ,
    MOVE G6C,  35,  65,  50,  ,  ,

    RETURN


    '***********************************
터널진행:
    GOSUB 자이로OFF
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,   80, , 130
    WAIT
    MOVE G6A, 100,  97, 125,  88, 100,
    MOVE G6D, 100,  97, 125,  88, 100,
    MOVE G6D, 100, 117, 105,  88, 100,
    MOVE G6A, 100, 117, 105,  88, 100,

    MOVE G6A, 100, 132,  85,  93, 100,
    MOVE G6D, 100, 132,  85,  93, 100,

    MOVE G6D, 100, 147,  60, 103, 100,
    MOVE G6A, 100, 147,  60, 103, 100,


    MOVE G6A, 100, 152,  55, 103, 100,
    MOVE G6D, 100, 152,  55, 103, 100,

    MOVE G6A, 100, 157,  50, 103, 100,
    MOVE G6D, 100, 157,  50, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 162,  45, 103, 100,
    MOVE G6D, 100, 162,  45, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 167,  40, 103, 100,
    MOVE G6D, 100, 167,  40, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 172,  35, 108, 100,
    MOVE G6D, 100, 172,  35, 108, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 172,  35,  43, 100,
    MOVE G6D, 100, 172,  35,  43, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 112,  85,  43, 100,
    MOVE G6D, 100, 112,  85,  43, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 100, 105,  15, 100,
    MOVE G6D, 100, 100, 105,  15, 100,
    MOVE G6B,  10,  45,  50,  ,  ,
    MOVE G6C,  10,  45,  50,  ,  ,
    WAIT

    RETURN

    '****************************************8
터널:
    SPEED 12
    GOSUB 자이로OFF

    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,   80, , 130
    WAIT
    MOVE G6A, 100,  97, 125,  88, 100,
    MOVE G6D, 100,  97, 125,  88, 100,
    MOVE G6D, 100, 117, 105,  88, 100,
    MOVE G6A, 100, 117, 105,  88, 100,

    MOVE G6A, 100, 132,  85,  93, 100,
    MOVE G6D, 100, 132,  85,  93, 100,

    MOVE G6D, 100, 147,  60, 103, 100,
    MOVE G6A, 100, 147,  60, 103, 100,


    MOVE G6A, 100, 152,  55, 103, 100,
    MOVE G6D, 100, 152,  55, 103, 100,

    MOVE G6A, 100, 157,  50, 103, 100,
    MOVE G6D, 100, 157,  50, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 162,  45, 103, 100,
    MOVE G6D, 100, 162,  45, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 167,  40, 103, 100,
    MOVE G6D, 100, 167,  40, 103, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 172,  35, 108, 100,
    MOVE G6D, 100, 172,  35, 108, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 172,  35,  43, 100,
    MOVE G6D, 100, 172,  35,  43, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    MOVE G6A, 100, 112,  85,  43, 100,
    MOVE G6D, 100, 112,  85,  43, 100,
    MOVE G6B,  10,  45,  49,  ,  ,
    MOVE G6C,  10,  45,  49,  ,  ,

    SPEED 6


    FOR i=0 TO 10

        MOVE G6A, 100, 145,  60,  30, 100,
        MOVE G6D, 100, 145,  60,  30, 100,
        MOVE G6B,  10,  40,  70,  ,  ,
        MOVE G6C,  10,  40,  70,  ,120 ,

        MOVE G6A, 100, 145,  60,  30, 100,
        MOVE G6D, 100, 145,  60,  30, 100,
        MOVE G6B,  10,  80,  50,  ,  ,
        MOVE G6C,  10,  80,  50,  ,120 ,

        MOVE G6A, 100, 145,  60,  30, 100,
        MOVE G6D, 100, 145,  60,  30, 100,
        MOVE G6B,  30,  80,  50,  ,  ,
        MOVE G6C,  30,  80,  50,  ,120 ,

        MOVE G6A, 100, 145,  60,  30, 100,
        MOVE G6D, 100, 145,  60,  30, 100,
        MOVE G6B,  30,  40,  70,  ,  ,
        MOVE G6C,  30,  40,  70,  ,120 ,


    NEXT

    '    MOVE G6A, 100, 150,  55,  33, 100,
    '    MOVE G6D, 100, 150,  55,  33, 100,
    '    MOVE G6B,  10,  75,  30,  ,  ,
    '    MOVE G6C,  10,  75,  30,  ,  ,

    '    MOVE G6A, 100, 150,  55,  33, 100,
    '    MOVE G6D, 100, 150,  55,  33, 100,
    '    MOVE G6B,  10,  85,  30,  ,  ,
    '   MOVE G6C,  10,  85,  30,  ,  ,

    '    MOVE G6A, 100, 150,  55,  33, 100,
    '    MOVE G6D, 100, 150,  55,  33, 100,
    '    MOVE G6B,  30,  85,  30,  ,  ,
    '    MOVE G6C,  30,  85,  30,  ,  ,

    '    MOVE G6A, 100, 150,  55,  33, 100,
    '    MOVE G6D, 100, 150,  55,  33, 100,
    '    MOVE G6B,  30,  55,  30,  ,  ,
    '    MOVE G6C,  30,  55,  30,  ,  ,

    '    MOVE G6A, 100, 150,  55,  33, 100,
    '   MOVE G6D, 100, 150,  55,  33, 100,
    '   MOVE G6B,  10,  45,  50,  ,  ,
    '   MOVE G6C,  10,  45,  50,  ,  ,

    '*******************************************

    MOVE G6A, 100, 150,  55,  33, 100,
    MOVE G6D, 100, 150,  55,  33, 100,
    MOVE G6B,  10,  15,  90,  ,  ,
    MOVE G6C,  10,  15,  90,  ,  ,

    MOVE G6A, 100, 150,  75,  33, 100,
    MOVE G6D, 100, 150,  75,  33, 100,
    MOVE G6B,  10,  15,  90,  ,  ,
    MOVE G6C,  10,  15,  90,  ,  ,

    MOVE G6A, 100, 150,  75,  53, 100,
    MOVE G6D, 100, 150,  75,  53, 100,
    MOVE G6B,  10,  15,  90,  ,  ,
    MOVE G6C,  10,  15,  90,  ,  ,

    MOVE G6A, 100, 150,  75,  53, 100,
    MOVE G6D, 100, 150,  75,  53, 100,
    MOVE G6B,  10,  30,  90,  ,  ,
    MOVE G6C,  10,  30,  90,  ,  ,

    MOVE G6A, 100, 150,  75,  53, 100,
    MOVE G6D, 100, 150,  75,  53, 100,
    MOVE G6B,  100,  30,  90,  ,  ,
    MOVE G6C,  100,  30,  90,  ,  ,

    MOVE G6A, 100, 150,  75,  83, 100,
    MOVE G6D, 100, 150,  75,  83, 100,
    MOVE G6B,  100,  30,  90,  ,  ,
    MOVE G6C,  100,  30,  90,  ,  ,

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,



    RETURN




    '******************************************************
mm연속전진:
    보행속도 = 15
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 15

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 15'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO mm연속전진_1	
    ELSE
        보행순서 = 0

        SPEED 15

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 15

        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO mm연속전진_2	

    ENDIF


    '*************************************************************************

mm연속전진_1:
    'ETX 4800,100 '

    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    ETX 4800,100 '

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 진행코드
    ENDIF
    ERX 4800,A, mm연속전진_2
    'ERX 4800,A, mm연속전진_2
    IF A >LOW  AND A < HIGH THEN
        GOTO mm연속전진_2
    ELSEIF A=0 THEN
        GOTO 진행코드
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B,100
        MOVE G6C, 100
        WAIT	

        SPEED 2
        GOSUB 기본자세2

        DELAY delayy
        IF A >= HIGH THEN   '158 98
            GOSUB 오른쪽턴3
        ELSEIF A <= LOW AND A>0 THEN
            GOSUB 왼쪽턴3
        ENDIF
        'GOTO m연속전진
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF
    '**********

mm연속전진_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

mm연속전진_3:

    ' ETX 4800,100 '
    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT
    'ERX 4800,A, mm연속전진_4
    ETX 4800,100 '진행코드를 보냄
    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 진행코드
    ENDIF

    ERX 4800,A, mm연속전진_4
    IF A > LOW AND A < HIGH THEN
        GOTO mm연속전진_4
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT	
        SPEED 2
        GOSUB 기본자세2

        DELAY delayy
        IF A >= HIGH THEN
            GOSUB 오른쪽턴3
        ELSEIF A <= LOW THEN   '0이어도 왼쪽턴 해
            GOSUB 왼쪽턴3
        ENDIF
        'GOTO m연속전진
        '		
        '        GOTO RX_EXIT
    ENDIF

mm연속전진_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO mm연속전진_1
    '**********************************************************************

mm3연속전진:
    보행속도 = 15
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 15

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        MOVE G6B,100
        MOVE G6C,100,,,,60''터널 지나기전 코너에선 고개를 많이 숙여야 좋나?  몇 도가 가장 좋을까 50?
        WAIT

        SPEED 15'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO mm3연속전진_1	
    ELSE
        보행순서 = 0

        SPEED 15

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 15

        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO mm3연속전진_2	

    ENDIF


mm3연속전진_1:
    'ETX 4800,100 '
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    'ERX 4800,A, mm3연속전진_2
    ETX 4800,100 '

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 진행코드
    ENDIF

    ERX 4800,A, mm3연속전진_2
    GOSUB 적외선거리센서확인
    IF 미션수행=1 AND 적외선거리값>150 THEN
        GOTO 진행코드
    ELSEIF 미션수행=2 AND 적외선거리값 >70 THEN
        GOTO 진행코드
    ELSEIF A > LOW AND A < HIGH THEN
        GOTO mm3연속전진_2
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 2
        GOSUB 기본자세

        DELAY delayy
        IF A >= HIGH THEN
            GOSUB 오른쪽턴3
        ELSEIF A <= LOW  THEN 'A=0이여도 왼쪽턴해
            GOSUB 왼쪽턴3
        ENDIF
        'GOTO m연속전진
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF


mm3연속전진_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

mm3연속전진_3:
    'ETX 4800,100

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT
    'ERX 4800,A, mm3연속전진_4
    ETX 4800,100 '진행코드를 보냄
    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO  진행코드
    ENDIF

    ERX 4800,A, mm3연속전진_4
    GOSUB 적외선거리센서확인
    IF 미션수행=1 AND 적외선거리값>150 THEN ' 문 열기
        GOTO 진행코드
    ELSEIF 미션수행=2 AND 적외선거리값 >70 THEN ' 터널 지나기
        GOTO 진행코드
    ELSEIF A >LOW AND A < HIGH THEN   'HIGH, LOW 변수를 사용하면 한번에 범위들 바꿀수 있다
        GOTO mm3연속전진_4
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT	
        SPEED 2
        GOSUB 기본자세

        DELAY delayy
        IF A >= HIGH THEN
            GOSUB 오른쪽턴3
        ELSEIF A <= LOW THEN   'A=0이여도 왼쪽턴해
            GOSUB 왼쪽턴3
        ENDIF
        'GOTO m연속전진
        '		
        '        GOTO RX_EXIT
    ENDIF

mm3연속전진_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO mm3연속전진_1
    '*******************************************************************

다섯걸음:
    L=9
다섯걸음_:

    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 15

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 15'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO 다섯걸음_1
    ELSE
        보행순서 = 0

        SPEED 15

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 15

        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 다섯걸음_2

    ENDIF


다섯걸음_1:

    L= L-1
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    ETX 4800,100 '

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 다섯걸음_
    ENDIF

    ERX 4800,A, 다섯걸음_2
    IF L<4 THEN
        RETURN
    ELSEIF A > LOW AND A < HIGH THEN
        GOTO 다섯걸음_2
    ELSEIF A=0 THEN
        GOTO 다섯걸음_ ''??진
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B,100
        MOVE G6C, 100
        WAIT	

        SPEED 2
        GOSUB 기본자세2

        DELAY delayy
        IF L<4  THEN
            RETURN
        ELSEIF A >= HIGH THEN
            GOSUB 오른쪽턴3
        ELSEIF A <= LOW AND A>0 THEN
            GOSUB 왼쪽턴3
        ENDIF
        'GOTO m연속전진
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF

다섯걸음_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT


다섯걸음_3:

    L=L-1
    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    ETX 4800,100 '진행코드를 보냄
    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 다섯걸음_
    ENDIF

    ERX 4800,A, 다섯걸음_4
    IF L<4 THEN
        RETURN
    ELSEIF A > LOW AND A < HIGH THEN
        GOTO 다섯걸음_4
    ELSEIF A=0 THEN
        GOTO 다섯걸음_
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT	
        SPEED 2
        GOSUB 기본자세2

        DELAY delayy
        IF L<4 THEN
            RETURN
        ELSEIF A >= HIGH THEN
            GOSUB 오른쪽턴3
        ELSEIF A <= LOW THEN
            GOSUB 왼쪽턴3
        ENDIF
        'GOTO m연속전진
        '		
        '        GOTO RX_EXIT
    ENDIF

다섯걸음_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO 다섯걸음_1
    '*******************************************************************
mmL연속전진:
    L=10
mmL_연속전진:

    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 15

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 15'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO mmL연속전진_1	
    ELSE
        보행순서 = 0

        SPEED 15

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 15

        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO mmL연속전진_2	

    ENDIF


mmL연속전진_1:

    L= L-1
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    ETX 4800,100'

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO mmL_연속전진
    ENDIF

    ERX 4800,A, mmL연속전진_2
    IF A > LOW AND A < HIGH THEN
        GOTO mmL연속전진_2
    ELSEIF A=0 THEN
        lookL1: MOVE G6B,,,,,,60
        MOVE G6C,,,,,50 '고개 좀 들고 좌우를 봐
        DELAY  600
        ETX 4800, 100
        ERX 4800, A, lookL1
        IF A>0 THEN
            turn=1
        ENDIF

        lookR1: MOVE G6B,,,,,,140
        DELAY 600
        ETX 4800, 100
        ERX 4800, A, lookR1
        IF A>0 THEN
            turn =2
        ENDIF

        IF turn =2 THEN
            GOSUB 왼쪽턴3
            GOSUB 왼쪽턴3
        ELSEIF turn =1 THEN
            GOSUB 오른쪽턴3
            GOSUB 오른쪽턴3
        ENDIF
        DELAY 500
        MOVE G6B,,,,,,100  '고개 다시 중앙으로
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B,100
        MOVE G6C, 100
        WAIT	

        SPEED 2
        GOSUB 기본자세2

        DELAY delayy
        IF L<4  THEN
            GOTO ee
        ELSEIF A >= HIGH THEN
            GOSUB 오른쪽턴3
        ELSEIF A <= LOW AND A>0 THEN
            GOSUB 왼쪽턴3
        ENDIF
        'GOTO m연속전진
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF


mmL연속전진_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT
    IF L<4 THEN
        GOTO ee
    ENDIF

mmL연속전진_3:

    L=L-1
    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    ETX 4800,103 '진행코드를 보냄
    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO mmL_연속전진
    ENDIF

    ERX 4800,A, mmL연속전진_4
    IF A > LOW AND A < HIGH THEN
        GOTO mmL연속전진_4
    ELSEIF A=0 THEN
        lookL2: MOVE G6B,,,,,,60
        MOVE G6C,,,,,50 '고개 좀 들고 좌우를 봐
        DELAY 600
        ETX 4800, 100
        ERX 4800, A, lookL2
        IF A>0 THEN
            turn=1
        ENDIF

        lookR2:	MOVE G6B,,,,,,140
        DELAY 600
        ETX 4800, 100
        ERX 4800, A, lookR2
        IF A>0 THEN
            turn =2
        ENDIF

        IF turn =2 THEN
            GOSUB 왼쪽턴3
            GOSUB 왼쪽턴3
        ELSEIF turn =1 THEN
            GOSUB 오른쪽턴3
            GOSUB 오른쪽턴3
        ENDIF
        DELAY 500
        MOVE G6B,,,,,,100  '고개 다시 중앙으로
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT	
        SPEED 2
        GOSUB 기본자세2

        DELAY delayy
        IF L<4 THEN
            GOTO ee
        ELSEIF A >= HIGH THEN
            GOSUB 오른쪽턴3
        ELSEIF A <= LOW THEN
            GOSUB 왼쪽턴3
        ENDIF
        'GOTO m연속전진
        '		
        '        GOTO RX_EXIT
    ENDIF

mmL연속전진_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO mmL연속전진_1
    '**************************************************************************

mmLL연속전진:
    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0
    SERVO 16, 100
    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 15

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        MOVE G6B,100
        MOVE G6C,100,,,,100
        WAIT

        SPEED 15'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110,,,,100
        WAIT


        GOTO mmLL연속전진_1	
    ELSE
        보행순서 = 0

        SPEED 15

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100,,,,100
        MOVE G6B, 100
        WAIT

        SPEED 15

        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        MOVE G6C,90,,,,100
        MOVE G6B,110
        WAIT


        GOTO mmLL연속전진_2	

    ENDIF




mmLL연속전진_1:
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    ETX 4800,101

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO mmLL연속전진
    ENDIF

    ERX 4800,A, mmLL연속전진_2
    IF A > LOW AND A < HIGH THEN
        GOTO mmLL연속전진_2
    ELSEIF A=0 THEN
        GOTO mmLL연속전진 '진행코드 ''''
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90,,,,100
        WAIT
        HIGHSPEED SETOFF

        SPEED 8
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B,100
        MOVE G6C, 100,,,,100
        WAIT	

        SPEED 6
        GOSUB 기본자세3
        'DELAY delayy
        GOSUB 적외선거리센서확인
        IF 적외선거리값>95 THEN
            GOSUB 레버내리기
        ELSEIF A >= HIGH THEN
            GOSUB 오른쪽턴4
        ELSEIF A <= LOW AND A>0 THEN
            GOSUB 왼쪽턴4
        ENDIF
        DELAY 50
        'GOTO m연속전진
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF


mmLL연속전진_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90,,,,100
    WAIT

mmLL연속전진_3:


    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    ETX 4800,101
    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO mmLL연속전진
    ENDIF

    ERX 4800,A, mmLL연속전진_4
    IF A > LOW AND A < HIGH THEN
        GOTO mmLL연속전진_4
        'ELSEIF A=0 THEN
        '   GOTO 진행코드  고개좌우로
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110,,,,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 8

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100,,,,100
        MOVE G6B, 100
        WAIT	
        SPEED 6
        GOSUB 기본자세3

        'DELAY delayy
        GOSUB 적외선거리센서확인
        IF 적외선거리값>100 THEN
            GOSUB 레버내리기
        ELSEIF A >= HIGH THEN
            GOSUB 오른쪽턴4
        ELSEIF A <= LOW THEN
            GOSUB 왼쪽턴4
        ENDIF
        DELAY 50
        'GOTO m연속전진
        '		
        '        GOTO RX_EXIT
    ENDIF

mmLL연속전진_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110,,,,100
    WAIT

    GOTO mmLL연속전진_1
    '*********************************************************************

mmmLL연속전진:
    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0
    SERVO 16, 100
    GOSUB Leg_motor_mode3

    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 12

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        MOVE G6B,100
        MOVE G6C,100,,,,100
        WAIT

        SPEED 12

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110,,,,100
        WAIT


        GOTO mmmLL연속전진_1	
    ELSE
        보행순서 = 0

        SPEED 12

        MOVE G6D,  88,  74, 144,  95, 110
        MOVE G6A, 108,  76, 146,  93,  96
        MOVE G6C, 100,,,,100
        MOVE G6B, 100
        WAIT

        SPEED 12

        MOVE G6D, 90, 90, 120, 105, 110,100
        MOVE G6A,110,  76, 147,  93,  96,100
        MOVE G6C,90,,,,100
        MOVE G6B,110
        WAIT


        GOTO mmmLL연속전진_2	

    ENDIF




mmmLL연속전진_1:
    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    ETX 4800,106

    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO mmmLL연속전진
    ENDIF

    ERX 4800,A, mmmLL연속전진_1
    IF A=128 THEN
        GOTO mmmLL연속전진_2
    ELSEIF A=0 THEN
        GOSUB 한발뒤로가기
        GOTO mmmLL연속전진 '진행코드 ''''
    ELSE
        ' GOSUB Leg_motor_mode3

        MOVE G6A,112,  76, 146,  93, 96,100
        MOVE G6D,90, 100, 100, 115, 110,100
        MOVE G6B,110
        MOVE G6C,90,,,,100
        WAIT
        HIGHSPEED SETOFF

        SPEED 12
        MOVE G6A, 106,  76, 146,  93,  96,100		
        MOVE G6D,  88,  71, 152,  91, 106,100
        MOVE G6B,100
        MOVE G6C, 100,,,,100
        WAIT	

        SPEED 12
        GOSUB 기본자세3
        'DELAY delayy
        GOSUB 적외선거리센서확인
        IF 적외선거리값>110 THEN
            GOSUB mm레버내리기
        ELSEIF A =130 THEN
            GOSUB mm오른쪽옆으로20
        ELSEIF A = 150 THEN
            GOSUB mm왼쪽옆으로20
        ENDIF
        DELAY 50
        'GOTO m연속전진
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF


mmmLL연속전진_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90,,,,100
    WAIT

mmmLL연속전진_3:


    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    ETX 4800,106
    SPEED 보행속도

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO mmmLL연속전진
    ENDIF

    ERX 4800,A, mmmLL연속전진_4
    IF A =128 THEN
        GOTO mmmLL연속전진_4
        'ELSEIF A=0 THEN
        '   GOTO 진행코드  고개좌우로
    ELSE

        MOVE G6A, 90, 100, 100, 115, 110,100
        MOVE G6D,112,  76, 146,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110,,,,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 12

        MOVE G6D, 106,  76, 146,  93,  96,100		
        MOVE G6A,  88,  71, 152,  91, 106,100
        MOVE G6C, 100,,,,100
        MOVE G6B, 100
        WAIT	
        SPEED 12
        GOSUB 기본자세3

        'DELAY delayy
        GOSUB 적외선거리센서확인
        IF 적외선거리값>110 THEN
            GOSUB mm레버내리기
        ELSEIF A =130 THEN
            GOSUB mm오른쪽옆으로20
        ELSEIF A =150 THEN
            GOSUB mm왼쪽옆으로20
        ENDIF
        DELAY 50
        'GOTO m연속전진
        '		
        '        GOTO RX_EXIT
    ENDIF

mmmLL연속전진_4:
    '왼발들기10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110,,,,100
    WAIT

    GOTO mmmLL연속전진_1
    '*********************************************************************

mm빠른걸음:
    넘어진확인 = 0

    곡선방향 = 2
    SPEED 5 '10
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO mm빠른걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO mm빠른걸음_4
    ENDIF



    '**********************

mm빠른걸음_1:
    SPEED 4 '8
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


mm빠른걸음_3:

    ETX 4800,100 '

    SPEED 4 '8
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT

    ERX 4800, A ,mm빠른걸음_4_0

    IF A=0 THEN
        GOTO mm빠른걸음_6멈춤
    ELSEIF A >LOW  AND A < HIGH THEN
        곡선방향=2
    ELSEIF A<LOW THEN '왼쪽
        곡선방향=1
    ELSEIF A>HIGH THEN '오른쪽
        곡선방향=3


    ENDIF
mm빠른걸음_4_0:

    IF  곡선방향 = 1 THEN'왼쪽

    ELSEIF  곡선방향 = 3 THEN'오른쪽
        HIGHSPEED SETOFF
        SPEED 4'8
        ''GOSUB m오른쪽턴10
        MOVE G6D,103,   71, 140, 95,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO mm빠른걸음_1

    ENDIF



    '*********************************

mm빠른걸음_4:
    SPEED 4 '8
    MOVE G6D,95,  85, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


mm빠른걸음_6:

    ETX 4800,100 '
    SPEED 4 '8
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,mm빠른걸음_1_0
    IF A=0 THEN
        GOTO mm빠른걸음_6멈춤
    ELSEIF A >LOW  AND A < HIGH THEN
        곡선방향=2
    ELSEIF A<LOW THEN '왼쪽
        곡선방향=1
    ELSEIF A>HIGH THEN '오른쪽
        곡선방향=3


    ENDIF


mm빠른걸음_1_0:

    IF  곡선방향 = 1 THEN'왼쪽
        HIGHSPEED SETOFF
        SPEED 4 '8
        MOVE G6A,103,   71, 140, 95,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO mm빠른걸음_4
    ELSEIF 곡선방향 = 3 THEN'오른쪽


    ENDIF



    GOTO mm빠른걸음_1
    '******************************************
    '******************************************
    '*********************************
mm빠른걸음_3멈춤:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 8 '15
    GOSUB 안정화자세
    SPEED 5' 10
    GOSUB 기본자세
    GOTO 진행코드
    '******************************************
mm빠른걸음_6멈춤:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 8 '15
    GOSUB 안정화자세
    SPEED 5 '10
    GOSUB 기본자세
    GOTO 진행코드
    '******************************************
계단끝나고:
    SERVO 16, 30
    넘어진확인 = 0
    ETX 4800, 103
    GOSUB All_motor_mode3


    ff = 0
bbbb:

    ERX 4800, A , 계단끝나고
    IF A = 153 THEN
        GOSUB 오른쪽턴10
    ELSEIF A = 103 THEN  '왼쪽턴
        GOSUB 왼쪽턴10
    ELSEIF A = 128 THEN
        RETURN
    ELSEIF A = 150 THEN ' 왼쪽으로 게걸음
        GOSUB m왼쪽옆으로20
    ELSEIF A = 130 THEN ' 오른쪽으로 게걸음
        GOSUB m오른쪽옆으로20
    ELSEIF A=0 THEN
        GOSUB 한발앞으로가기
    ENDIF
    DELAY 300
    GOTO bbbb

    '********************************
문앞에서:
    SERVO 16, 30
    넘어진확인 = 0
    ETX 4800, 103
    GOSUB All_motor_mode3


    ff = 0
aaaa:
    ETX 4800, 103
    ERX 4800, A , aaaa
    IF A = 153 THEN
        GOSUB 오른쪽턴10
    ELSEIF A = 103 THEN  '왼쪽턴
        GOSUB 왼쪽턴10
    ELSEIF A = 128 THEN
        RETURN
    ELSEIF A = 150 THEN ' 왼쪽으로 게걸음
        GOSUB m왼쪽옆으로20
    ELSEIF A = 130 THEN ' 오른쪽으로 게걸음
        GOSUB m오른쪽옆으로20
    ELSEIF A=0 THEN
        ff = ff + 1
        IF ff > 3 THEN
            GOSUB 한발뒤로가기
            ff=0
        ENDIF

        GOTO aaaa

        '
        ' ELSE

        'ENDIF
    ENDIF
    DELAY 300
    GOTO aaaa




레버앞에서2:
    SERVO 16, 100
    넘어진확인 = 0

    GOSUB All_motor_mode3


    ff = 0
cccc2:
    ETX 4800, 106
    ERX 4800, A , cccc2
    IF A = 128 THEN  '중간red x 범위
        GOTO mm레버내리기
    ELSEIF A = 150 THEN ' x가 왼쪽
        GOSUB 고개들고_왼쪽옆으로20
    ELSEIF A = 130 THEN ' x가 오른쪽
        GOSUB 고개들고_오른쪽옆으로20
    ELSE   '0이다.
        ff = ff + 1
        DELAY 10
        IF ff > 5 THEN

            'GOTO mmmLL연속전
            GOSUB 한발뒤로가기
            'GOSUB 한발뒤로가기

        ELSE
            GOTO cccc2
            ' GOSUB 팩치우기
            'GOSUB 한발뒤로가기

        ENDIF
    ENDIF
    DELAY 50
    GOTO cccc2






레버앞에서:
    SERVO 16, 30
    넘어진확인 = 0
    ETX 4800, 103
    GOSUB All_motor_mode3


    ff = 0
cccc:
    ETX 4800, 103
    ERX 4800, A , cccc
    IF A = 153 THEN
        GOSUB 오른쪽턴10
    ELSEIF A = 103 THEN  '왼쪽턴
        GOSUB 왼쪽턴10
    ELSEIF A = 128 THEN
        RETURN
    ELSEIF A = 150 THEN ' 왼쪽으로 게걸음
        GOSUB m왼쪽옆으로20
    ELSEIF A = 130 THEN ' 오른쪽으로 게걸음
        GOSUB m오른쪽옆으로20
    ELSE
        ff = ff + 1
        IF ff > 3 THEN
            'GOTO mmmLL연속전진
            GOSUB 팩치우기
            GOTO cccc
        ELSE
            'GOSUB 팩치우기
            'GOSUB 한발뒤로가기
            GOTO cccc

        ENDIF
    ENDIF
    DELAY 300
    GOTO cccc


    '********************************************
새문열기:
    ETX 4800,105

    'GOSUB 팩치우기
    GOSUB 기본자세

    GOSUB 왼쪽턴60
    GOSUB 왼쪽턴60
    GOSUB 왼쪽턴45

    MOVE G6C, 100,  85,  21,  ,  ,
    WAIT


    GOSUB 오른쪽옆으로70연속'오른쪽팔도 고쳤음
    GOSUB 오른쪽옆으로70연속
    GOSUB 오른쪽옆으로70연속
    GOSUB 오른쪽옆으로70연속
    GOSUB 오른쪽옆으로70연속
    GOSUB 오른쪽옆으로70연속
    GOSUB 오른쪽옆으로70연속
    GOSUB 오른쪽옆으로70연속
    GOSUB 오른쪽옆으로70연속
abcd:
    ETX 4800, 105
    DELAY 10
    ERX 4800,A,abcd
    IF A=170 THEN
        RETURN
    ELSEIF A=0 THEN
        GOSUB 오른쪽옆으로70연속
        GOTO abcd
    ELSE
        RETURN

    ENDIF

    '*******************************************8

mm콜라캔치우기:

    SPEED 6


    MOVE G6A, 100,  77, 145,  93, 100,
    MOVE G6D, 100,  77, 145,  93, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 170,  30,  80,  ,  ,

    MOVE G6A, 100,  77, 145,  93, 100,
    MOVE G6D, 100,  77, 145,  93, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 170,  15,  15,  ,  ,



    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100

    WAIT
    MOVE G6A, 100,  97, 125,  88, 100,
    MOVE G6D, 100,  97, 125,  88, 100,

    MOVE G6D, 100, 117, 105,  88, 100,
    MOVE G6A, 100, 117, 105,  88, 100,


    MOVE G6A, 100, 132,  85,  93, 100,
    MOVE G6D, 100, 132,  85,  93, 100,



    MOVE G6D, 100, 147,  60, 103, 100,
    MOVE G6A, 100, 147,  60, 103, 100,


    MOVE G6A, 100, 152,  55, 103, 100,
    MOVE G6D, 100, 152,  55, 103, 100,


    MOVE G6A, 100, 157,  50, 103, 100,
    MOVE G6D, 100, 157,  50, 103, 100,

    MOVE G6A, 100, 162,  45, 103, 100,
    MOVE G6D, 100, 162,  45, 103, 100,

    MOVE G6A, 100, 167,  45, 103, 100,
    MOVE G6D, 100, 167,  45, 103, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 170,  15,  15,  ,  ,

    MOVE G6A, 100, 167,  45, 103, 100,
    MOVE G6D, 100, 167,  45, 103, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 170,  15, 130,  ,  ,

    MOVE G6A, 100, 167,  45, 103, 100,
    MOVE G6D, 100, 167,  45, 103, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,

    GOSUB 기본자세

    RETURN

    '************************************************
연속후진:
    넘어진확인 = 0
    보행속도 = 12
    좌우속도 = 4
    GOSUB Leg_motor_mode3



    IF 보행순서 = 0 THEN
        보행순서 = 1

        SPEED 4
        MOVE G6A, 88,  71, 152,  91, 110
        MOVE G6D,108,  76, 145,  93,  96
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 10
        MOVE G6A, 90, 100, 100, 115, 110
        MOVE G6D,110,  76, 145,  93,  96
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO 연속후진_1	
    ELSE
        보행순서 = 0

        SPEED 4
        MOVE G6D,  88,  71, 152,  91, 110
        MOVE G6A, 108,  76, 145,  93,  96
        MOVE G6C, 100
        MOVE G6B, 100
        WAIT

        SPEED 10
        MOVE G6D, 90, 100, 100, 115, 110
        MOVE G6A,110,  76, 145,  93,  96
        MOVE G6C,90
        MOVE G6B,110
        WAIT


        GOTO 연속후진_2

    ENDIF


연속후진_1:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED 좌우속도
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, 연속후진_2
    IF A <> A_old THEN
연속후진_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세2
        GOTO RX_EXIT
    ENDIF
    '**********

연속후진_2:
    ETX 4800,12 '진행코드를 보냄
    SPEED 보행속도
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED 좌우속도
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT


    ERX 4800,A, 연속후진_1
    IF A <> A_old THEN
연속후진_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세2
        GOTO RX_EXIT
    ENDIF  	

    GOTO 연속후진_1
    '**********************************************
한발앞으로가기:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON


    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT


    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세2
    RETURN

    '*******************************************
고개들고_한발앞으로가기:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON


    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100,,,,100  '고개들
    WAIT


    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT

    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 고개들고_안정화자세
    SPEED 5
    GOSUB 기본자세3 '고개들어
    RETURN

    '******************************************
횟수_전진종종걸음:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 횟수_전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 횟수_전진종종걸음_4
    ENDIF


    '**********************

횟수_전진종종걸음_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


횟수_전진종종걸음_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_전진종종걸음_2_stop

    ERX 4800,A, 횟수_전진종종걸음_4
    IF A <> A_old THEN
횟수_전진종종걸음_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

횟수_전진종종걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


횟수_전진종종걸음_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_전진종종걸음_5_stop

    ERX 4800,A, 횟수_전진종종걸음_1
    IF A <> A_old THEN
횟수_전진종종걸음_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

    GOTO 횟수_전진종종걸음_1

    '******************************************

횟수_전진종종걸음m:
    GOSUB All_motor_mode3
    보행횟수=6
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 횟수_전진종종걸음m_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 횟수_전진종종걸음m_4
    ENDIF



    '**********************

횟수_전진종종걸음m_1:
    MOVE G6A,95,  80, 135, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


횟수_전진종종걸음m_2:
    보행횟수=6
    MOVE G6D,  95,  85, 147,  85, 102,
    MOVE G6A, 103,  73, 140,  98, 100,

    'MOVE G6A,103,   73, 140, 103,  100
    'MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        RETURN
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_전진종종걸음m_2_stop

    'ERX 4800,A, 횟수_전진종종걸음m_4
    GOTO 횟수_전진종종걸음m_4
    IF A <> A_old THEN
횟수_전진종종걸음m_2_stop:
        MOVE G6D,95,  80, 135, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        RETURN
    ENDIF

    '*********************************

횟수_전진종종걸음m_4:
    MOVE G6D,95,  80, 135, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


횟수_전진종종걸음m_5:
    MOVE G6A,  95,  85, 147,  85, 102,
    MOVE G6D, 103,  73, 140,  98, 100,

    'MOVE G6D,103,    73, 140, 103,  100
    'MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 횟수_전진종종걸음m_5_stop

    'ERX 4800,A, 횟수_전진종종걸음m_1

    GOTO 횟수_전진종종걸음m_1
    IF A <> A_old THEN
횟수_전진종종걸음m_5_stop:
        MOVE G6A,95,  80, 135, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        RETURN
    ENDIF

    '*********************************

    GOTO 횟수_전진종종걸음m_1
    '******************************************

전진종종걸음:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음_4
    ENDIF


    '**********************

전진종종걸음_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


전진종종걸음_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_2_stop

    ERX 4800,A, 전진종종걸음_4
    IF A <> A_old THEN
전진종종걸음_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

전진종종걸음_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


전진종종걸음_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_5_stop

    ERX 4800,A, 전진종종걸음_1
    IF A <> A_old THEN
전진종종걸음_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

    GOTO 전진종종걸음_1

    '******************************************

한발뒤로가기:
    GOSUB All_motor_mode3
    넘어진확인 = 0
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    MOVE G6D,95,  85, 130, 100, 104
    MOVE G6A,104,  77, 146,  93,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    MOVE G6D,95,  85, 130, 100, 104
    MOVE G6A,104,  77, 146,  93,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT

    'SPEED 15
    GOSUB 안정화자세
    HIGHSPEED SETOFF
    SPEED 5
    GOSUB 기본자세2

    RETURN
    '******************************************
고개들고_왼쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6C ,,,,,100
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세3
    GOSUB All_motor_mode3
    RETURN

고개들고_오른쪽옆으로20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6C ,,,,,100
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세3 '바꿈
    GOSUB All_motor_mode3
    RETURN

    '******************************************
고개들고_한발뒤로가기:
    GOSUB All_motor_mode3
    넘어진확인 = 0
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON

    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100,,,,100 '고개들어
    WAIT

    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    MOVE G6D,95,  85, 130, 100, 104
    MOVE G6A,104,  77, 146,  93,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT

    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    MOVE G6D,95,  85, 130, 100, 104
    MOVE G6A,104,  77, 146,  93,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT

    'SPEED 15
    GOSUB 고개들고_안정화자세
    HIGHSPEED SETOFF
    SPEED 5
    GOSUB 기본자세3 '고개들어

    RETURN

    '******************************************
후진종종걸음:
    GOSUB All_motor_mode3
    넘어진확인 = 0
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 후진종종걸음_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 후진종종걸음_4
    ENDIF


    '**********************

후진종종걸음_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT



후진종종걸음_3:
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF
    ' 보행COUNT = 보행COUNT + 1
    ' IF 보행COUNT > 보행횟수 THEN  GOTO 후진종종걸음_3_stop
    ERX 4800,A, 후진종종걸음_4
    IF A <> A_old THEN
후진종종걸음_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        'SPEED 15
        GOSUB 안정화자세
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

후진종종걸음_4:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6C,115
    MOVE G6B,85
    WAIT


후진종종걸음_6:
    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO RX_EXIT
    ENDIF

    ' 보행COUNT = 보행COUNT + 1
    'IF 보행COUNT > 보행횟수 THEN  GOTO 후진종종걸음_6_stop

    ERX 4800,A, 후진종종걸음_1
    IF A <> A_old THEN  'GOTO 후진종종걸음_멈춤
후진종종걸음_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT

        'SPEED 15
        GOSUB 안정화자세
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB 기본자세2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO 후진종종걸음_1
    '************************************************
m오른쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    GOSUB All_motor_mode3
    RETURN
    '*************
mm오른쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세3
    GOSUB All_motor_mode3
    RETURN
    '*************
오른쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6D, 95,  90, 125, 100, 104, 100
    MOVE G6A,105,  76, 146,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6D, 102,  77, 145, 93, 100, 100
    MOVE G6A,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    GOSUB All_motor_mode3
    GOTO RX_EXIT
    '*************
m왼쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    GOSUB All_motor_mode3
    RETURN
    '**********************************************
mm왼쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세3
    GOSUB All_motor_mode3
    RETURN
    '**********************************************
왼쪽옆으로20: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 12
    MOVE G6A, 95,  90, 125, 100, 104, 100
    MOVE G6D,105,  76, 145,  93, 104, 100
    WAIT

    SPEED 12
    MOVE G6A, 102,  77, 145, 93, 100, 100
    MOVE G6D,90,  80, 140,  95, 107, 100
    WAIT

    SPEED 10
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    GOSUB All_motor_mode3
    GOTO RX_EXIT

    '**********************************************
    '******************************************
오른쪽옆으로70연속:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

오른쪽옆으로70연속_loop:
    DELAY  10

    SPEED 10
    MOVE G6D, 90,  90, 120, 105, 110, 100
    MOVE G6A,100,  76, 145,  93, 107, 100
    MOVE G6C, 100,  85,  21,  ,  ,
    'MOVE G6B,100,  40
    WAIT

    SPEED 13
    MOVE G6D, 102,  76, 145, 93, 100, 100
    MOVE G6A,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6D,98,  76, 145,  93, 100, 100
    MOVE G6A,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT


    '  ERX 4800, A ,오른쪽옆으로70연속_loop
    '    IF A = A_OLD THEN  GOTO 오른쪽옆으로70연속_loop
    '오른쪽옆으로70연속_stop:
    GOSUB 기본자세2

    RETURN
    '**********************************************

왼쪽옆으로70연속:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽옆으로70연속_loop:
    DELAY  10

    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
    WAIT

    SPEED 13
    MOVE G6A, 102,  76, 145, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    '   ERX 4800, A ,왼쪽옆으로70연속_loop	
    '    IF A = A_OLD THEN  GOTO 왼쪽옆으로70연속_loop
    '왼쪽옆으로70연속_stop:

    GOSUB 기본자세2

    RETURN
    '*********************************************
왼쪽턴4:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴4_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6D,100,  84, 145,  78, 100, 100
        MOVE G6A,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6D,100,  88, 145,  78, 100, 100
        MOVE G6A,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT



    ENDIF

    SPEED 12
    GOSUB 기본자세3


    RETURN

    '**********************************************
오른쪽턴4:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

오른쪽턴4_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,90,  85, 130, 98, 104
        MOVE G6A,105,  77, 146,  93,  100
        WAIT

    ENDIF
    SPEED 12
    GOSUB 기본자세3

    RETURN

    '******************************************************
    '**********************************************
왼쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴3_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT

        SPEED 6
        MOVE G6D,100,  84, 145,  78, 100, 100
        MOVE G6A,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,90,  90, 145,  78, 102, 100
        MOVE G6A,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6D,90,  80, 130, 102, 104
        MOVE G6A,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6D,100,  73, 145,  93, 100, 100
        MOVE G6A,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6D,100,  88, 145,  78, 100, 100
        MOVE G6A,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6D,104,  86, 146,  80, 100, 100
        MOVE G6A,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6A,90,  85, 130, 98, 104
        MOVE G6D,105,  77, 146,  93,  100
        WAIT



    ENDIF

    SPEED 12
    GOSUB 기본자세2


    RETURN

    '**********************************************
오른쪽턴3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

오른쪽턴3_LOOP:

    IF 보행순서 = 0 THEN
        보행순서 = 1
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  84, 145,  78, 100, 100
        MOVE G6D,100,  68, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,90,  90, 145,  78, 102, 100
        MOVE G6D,104,  71, 145,  105, 100, 100
        WAIT
        SPEED 7
        MOVE G6A,90,  80, 130, 102, 104
        MOVE G6D,105,  76, 146,  93,  100
        WAIT



    ELSE
        보행순서 = 0
        SPEED 15
        MOVE G6A,100,  73, 145,  93, 100, 100
        MOVE G6D,100,  79, 145,  93, 100, 100
        WAIT


        SPEED 6
        MOVE G6A,100,  88, 145,  78, 100, 100
        MOVE G6D,100,  65, 145,  108, 100, 100
        WAIT

        SPEED 9
        MOVE G6A,104,  86, 146,  80, 100, 100
        MOVE G6D,90,  58, 145,  110, 100, 100
        WAIT

        SPEED 7
        MOVE G6D,90,  85, 130, 98, 104
        MOVE G6A,105,  77, 146,  93,  100
        WAIT

    ENDIF
    SPEED 12
    GOSUB 기본자세2

    RETURN

    '******************************************************
    '**********************************************
왼쪽턴10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  86, 145,  83, 103, 100
    MOVE G6D,97,  66, 145,  103, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  83, 101, 100
    MOVE G6D,94,  66, 145,  103, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2
    RETURN
    '**********************************************
오른쪽턴10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2

    RETURN
    '**********************************************
    '**********************************************
m오른쪽턴10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 5
    MOVE G6A,97,  66, 145,  103, 103, 100
    MOVE G6D,97,  86, 145,  83, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  103, 101, 100
    MOVE G6D,94,  86, 145,  83, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100
    WAIT

    GOSUB 기본자세2

    RETURN
    '**********************************************
왼쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세2

    RETURN
    '**********************************************
m왼쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세2

    RETURN
    '**********************************************

오른쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세2

    RETURN

    '**********************************************
m오른쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  113, 105, 100
    MOVE G6D,93,  96, 145,  73, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세2

    RETURN

    '**********************************************

왼쪽턴45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴45_LOOP:

    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    'DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,왼쪽턴45_LOOP
    '    IF A_old = A THEN GOTO 왼쪽턴45_LOOP
    '
    RETURN
    '**********************************************
오른쪽턴45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
오른쪽턴45_LOOP:

    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    ' DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,오른쪽턴45_LOOP
    '    IF A_old = A THEN GOTO 오른쪽턴45_LOOP
    '
    RETURN
    '**********************************************
왼쪽턴60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴60_LOOP:

    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    GOSUB 기본자세2
    '  DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,왼쪽턴60_LOOP
    '    IF A_old = A THEN GOTO 왼쪽턴60_LOOP

    RETURN

    '**********************************************
오른쪽턴60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
오른쪽턴60_LOOP:

    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
    GOSUB 기본자세2
    ' DELAY 50
    '    GOSUB 앞뒤기울기측정
    '    IF 넘어진확인 = 1 THEN
    '        넘어진확인 = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,오른쪽턴60_LOOP
    '    IF A_old = A THEN GOTO 오른쪽턴60_LOOP

    RETURN
    '************************************************

뒤로일어나기:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB 자이로OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB 기본자세

    MOVE G6A,90, 130, ,  80, 110, 100
    MOVE G6D,90, 130, 120,  80, 110, 100
    MOVE G6B,150, 160,  10, 100, 100, 100
    MOVE G6C,150, 160,  10, 100, 100, 100
    WAIT

    MOVE G6B,170, 140,  10, 100, 100, 100
    MOVE G6C,170, 140,  10, 100, 100, 100
    WAIT

    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT
    SPEED 10
    MOVE G6A, 80, 155,  85, 150, 150, 100
    MOVE G6D, 80, 155,  85, 150, 150, 100
    MOVE G6B,185,  20, 70,  100, 100, 100
    MOVE G6C,185,  20, 70,  100, 100, 100
    WAIT



    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    MOVE G6B,188,  10, 100, 100, 100, 100
    MOVE G6C,188,  10, 100, 100, 100, 100
    WAIT

    SPEED 10
    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    GOSUB Leg_motor_mode3	
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10
    GOSUB 기본자세

    넘어진확인 = 1

    DELAY 200
    GOSUB 자이로ON

    RETURN


    '**********************************************
앞으로일어나기:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 15,  70, 140, 100,
    MOVE G6D,100, 15,  70, 140, 100,
    MOVE G6B,20,  140,  15
    MOVE G6C,20,  140,  15
    WAIT

    SPEED 12
    MOVE G6A,100, 136,  35, 80, 100,
    MOVE G6D,100, 136,  35, 80, 100,
    MOVE G6B,20,  30,  80
    MOVE G6C,20,  30,  80
    WAIT

    SPEED 12
    MOVE G6A,100, 165,  70, 30, 100,
    MOVE G6D,100, 165,  70, 30, 100,
    MOVE G6B,30,  20,  95
    MOVE G6C,30,  20,  95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165,  45, 90, 100,
    MOVE G6D,100, 165,  45, 90, 100,
    MOVE G6B,130,  50,  60
    MOVE G6C,130,  50,  60
    WAIT

    SPEED 6
    MOVE G6A,100, 145,  45, 130, 100,
    MOVE G6D,100, 145,  45, 130, 100,
    WAIT


    SPEED 8
    GOSUB All_motor_mode2
    GOSUB 기본자세
    넘어진확인 = 1

    '******************************
    DELAY 200
    GOSUB 자이로ON
    RETURN

    '**************************************************



레버내리기:
    SPEED 8
    ETX 4800, 106
좌우앞뒤:

    DELAY 100
    ERX 4800, A, 레버내리기' 0-255 중간 122

    IF A<73 THEN '93
        GOSUB 고개들고_오른쪽옆으로20
    ELSEIF A>172 THEN '152
        GOSUB  고개들고_왼쪽옆으로20
    ENDIF

    DELAY 100
    GOSUB 적외선거리센서확인
    IF 적외선거리값>110 THEN 'CLOSE
        GOSUB 고개들고_한발뒤로가기
        GOTO 좌우앞뒤
    ELSEIF 적외선거리값<80 THEN 'far
        GOSUB 고개들고_한발앞으로가기
        GOTO 좌우앞뒤

    ENDIF    	


    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 30, 80,
    MOVE G6C,100, 30, 80, ,
    WAIT

    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C,  60, 160, 150,  ,  ,
    WAIT


    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
    WAIT

    SPEED 13
    MOVE G6A, 102,  76, 145, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    SPEED 6
    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C,  60, 160, 150,  ,  ,
    WAIT

    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C,  50, 185, 150,  ,  ,
    WAIT

    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C,  25, 190, 165,  ,  ,
    WAIT

    RETURN

    '********************************************
mm레버내리기:
    SPEED 8
    ETX 4800, 106
mm좌우앞뒤:
    ETX 4800, 106
    GOSUB 적외선거리센서확인
    DELAY 500
    ERX 4800, A, mm좌우앞뒤' 0-255 중간 122
    ff=0
    IF A=128 THEN
        IF 적외선거리값 <140 AND 적외선거리값>100 THEN
            GOSUB final

        ELSEIF 적외선거리값<80 THEN 'far
            GOSUB 고개들고_한발앞으로가기
            'GOSUB 적외선거리센서확인

        ELSEIF 적외선거리값>140 THEN 'CLOSE
            GOSUB 고개들고_한발뒤로가기
            'GOSUB 적외선거리센서확인
        ELSE
            GOSUB 고개들고_한발앞으로가기
        ENDIF

    ELSEIF A=130 THEN '93
        GOSUB 고개들고_오른쪽옆으로20

    ELSEIF A=150 THEN '152
        GOSUB  고개들고_왼쪽옆으로20
    ELSE
        ff=ff+1
        IF ff>5 THEN
            GOSUB 고개들고_한발뒤로가기
        ELSE
            GOTO mm좌우앞뒤
        ENDIF

    ENDIF

    GOSUB 적외선거리센서확인
    DELAY 500


    GOTO mm좌우앞뒤
final:
    GOSUB 고개들고_한발앞으로가기
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 30, 80,
    MOVE G6C,100, 30, 80, ,
    WAIT

    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C,  60, 160, 150,  ,  ,
    WAIT


    SPEED 10
    MOVE G6A, 90,  90, 120, 105, 110, 100	
    MOVE G6D,100,  76, 145,  93, 107, 100	
    'MOVE G6C,100,  40
    'MOVE G6B,100,  40
    WAIT

    SPEED 13
    MOVE G6A, 102,  76, 145, 93, 100, 100
    MOVE G6D,83,  78, 140,  96, 115, 100
    WAIT

    SPEED 13
    MOVE G6A,98,  76, 145,  93, 100, 100
    MOVE G6D,98,  76, 145,  93, 100, 100
    WAIT

    SPEED 12
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6A,100,  76, 145,  93, 100, 100
    WAIT

    SPEED 6
    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C,  60, 160, 150,  ,  ,
    WAIT

    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C,  50, 185, 150,  ,  ,
    WAIT

    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C,  25, 190, 165,  ,  ,
    WAIT

    RETURN


    '**********************************************

머리왼쪽30도:
    SPEED 머리이동속도
    SERVO 11,70
    GOTO MAIN

머리왼쪽45도:
    SPEED 머리이동속도
    SERVO 11,55
    GOTO MAIN

머리왼쪽60도:
    SPEED 머리이동속도
    SERVO 11,40
    GOTO MAIN

머리왼쪽90도:
    SPEED 머리이동속도
    SERVO 11,10
    GOTO MAIN

머리오른쪽30도:
    SPEED 머리이동속도
    SERVO 11,130
    GOTO MAIN

머리오른쪽45도:
    SPEED 머리이동속도
    SERVO 11,145
    GOTO MAIN	

머리오른쪽60도:
    SPEED 머리이동속도
    SERVO 11,160
    GOTO MAIN

머리오른쪽90도:
    SPEED 머리이동속도
    SERVO 11,190
    GOTO MAIN

머리좌우중앙:
    SPEED 머리이동속도
    SERVO 11,100
    GOTO MAIN

머리상하정면:
    SPEED 머리이동속도
    SERVO 11,100	
    SPEED 5
    GOSUB 기본자세
    GOTO MAIN

    '******************************************
전방하향80도:

    SPEED 3
    SERVO 16, 80
    ETX 4800,35
    RETURN
    '******************************************
전방하향60도:

    SPEED 3
    SERVO 16, 65
    ETX 4800,36
    RETURN

    '******************************************
    '******************************************
앞뒤기울기측정:
    FOR i = 0 TO COUNT_MAX
        A = AD(앞뒤기울기AD포트)	'기울기 앞뒤
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF A < MIN THEN
        GOSUB 기울기앞
    ELSEIF A > MAX THEN
        GOSUB 기울기뒤
    ENDIF

    RETURN
    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN
        ' ETX  4800,16
        GOSUB 뒤로일어나기

    ENDIF
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN
        '  ETX  4800,15
        GOSUB 앞으로일어나기
    ENDIF
    RETURN
    '**************************************************
좌우기울기측정:
    FOR i = 0 TO COUNT_MAX
        B = AD(좌우기울기AD포트)	'기울기 좌우
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY 기울기확인시간
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB 기본자세	
    ENDIF
    RETURN
    '******************************************
    '************************************************
SOUND_PLAY_CHK:
    DELAY 60
    SOUND_BUSY = IN(46)
    IF SOUND_BUSY = 1 THEN GOTO SOUND_PLAY_CHK
    DELAY 50

    RETURN
    '************************************************

    '************************************************
NUM_1_9:
    IF NUM = 1 THEN
        PRINT "1"
    ELSEIF NUM = 2 THEN
        PRINT "2"
    ELSEIF NUM = 3 THEN
        PRINT "3"
    ELSEIF NUM = 4 THEN
        PRINT "4"
    ELSEIF NUM = 5 THEN
        PRINT "5"
    ELSEIF NUM = 6 THEN
        PRINT "6"
    ELSEIF NUM = 7 THEN
        PRINT "7"
    ELSEIF NUM = 8 THEN
        PRINT "8"
    ELSEIF NUM = 9 THEN
        PRINT "9"
    ELSEIF NUM = 0 THEN
        PRINT "0"
    ENDIF

    RETURN
    '************************************************
    '************************************************
NUM_TO_ARR:

    NO_4 =  BUTTON_NO / 10000
    TEMP_INTEGER = BUTTON_NO MOD 10000

    NO_3 =  TEMP_INTEGER / 1000
    TEMP_INTEGER = BUTTON_NO MOD 1000

    NO_2 =  TEMP_INTEGER / 100
    TEMP_INTEGER = BUTTON_NO MOD 100

    NO_1 =  TEMP_INTEGER / 10
    TEMP_INTEGER = BUTTON_NO MOD 10

    NO_0 =  TEMP_INTEGER

    RETURN
    '************************************************
Number_Play: '  BUTTON_NO = 숫자대입


    GOSUB NUM_TO_ARR

    PRINT "NPL "
    '*************

    NUM = NO_4
    GOSUB NUM_1_9

    '*************
    NUM = NO_3
    GOSUB NUM_1_9

    '*************
    NUM = NO_2
    GOSUB NUM_1_9
    '*************
    NUM = NO_1
    GOSUB NUM_1_9
    '*************
    NUM = NO_0
    GOSUB NUM_1_9
    PRINT " !"

    GOSUB SOUND_PLAY_CHK
    PRINT "SND 16 !"
    GOSUB SOUND_PLAY_CHK
    RETURN
    '************************************************

    RETURN

    ' ************************************************
적외선거리센서확인:

    적외선거리값 = AD(5)

    ' IF 적외선거리값 > 50 THEN '50 = 적외선거리값 = 25cm
    '    MUSIC "C"
    '    DELAY 3
    ' ENDIF




    RETURN

    '******************************************

    '**********************************************
집고왼쪽턴10:

    SPEED 5
    MOVE G6A,97,  86, 145,  75, 103, 100
    MOVE G6D,97,  66, 145,  95, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  86, 145,  75, 101, 100
    MOVE G6D,94,  66, 145,  95, 101, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOTO RX_EXIT
    '**********************************************
    '************************************************
계단왼발내리기3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 115, 105, 114
    MOVE G6D,118,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6A,  80, 30, 155, 150, 114,
    MOVE G6D,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6A,  80, 30, 175, 150, 114,
    MOVE G6D,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6A,90, 20, 150, 150, 110
    MOVE G6D,110,  155, 35,  120,94
    MOVE G6B,100,50
    MOVE G6C,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6A,100, 30, 150, 150, 100
    MOVE G6D,100,  155, 70,  100,100
    MOVE G6B,140,50
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 140,  85,114
    MOVE G6B,170,50
    MOVE G6C,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6A,114, 70, 130, 150, 94
    MOVE G6D,80,  125, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6A,114, 75, 130, 120, 94
    MOVE G6D,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6A,112, 80, 130, 110, 94
    MOVE G6D,80,  75,130,  115,114
    MOVE G6B,130,50
    MOVE G6C,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB 기본자세

    GOTO RX_EXIT
    '****************************************
    '************************************************
계단오른발내리기3cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,108,  76, 145,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 115, 105, 114
    MOVE G6A,113,  76, 145,  93,  94
    WAIT

    GOSUB Leg_motor_mode2


    SPEED 12
    MOVE G6D,  80, 30, 155, 150, 114,
    MOVE G6A,113,  65, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 7
    MOVE G6D,  80, 30, 175, 150, 114,
    MOVE G6A,113,  115, 65,  140,  94
    MOVE G6B,70,50
    MOVE G6C,70,40
    WAIT

    GOSUB Leg_motor_mode3
    SPEED 5
    MOVE G6D,90, 20, 150, 150, 110
    MOVE G6A,110,  155, 35,  120,94
    MOVE G6C,100,50
    MOVE G6B,140,40
    WAIT

    '****************************

    SPEED 8
    MOVE G6D,100, 30, 150, 150, 100
    MOVE G6A,100,  155, 70,  100,100
    MOVE G6C,140,50
    MOVE G6B,100,40
    WAIT

    SPEED 10
    MOVE G6D,114, 70, 130, 150, 94
    MOVE G6A,80,  125, 140,  85,114
    MOVE G6C,170,50
    MOVE G6B,100,40
    WAIT

    GOSUB Leg_motor_mode2	
    SPEED 10
    MOVE G6D,114, 70, 130, 150, 94
    MOVE G6A,80,  125, 50,  150,114
    WAIT

    SPEED 9
    MOVE G6D,114, 75, 130, 120, 94
    MOVE G6A,80,  85, 90,  150,114
    WAIT

    SPEED 8
    MOVE G6D,112, 80, 130, 110, 94
    MOVE G6A,80,  75,130,  115,114
    MOVE G6C,130,50
    MOVE G6B,100,40
    WAIT

    SPEED 6
    MOVE G6D, 98, 80, 130, 105,99,
    MOVE G6A,98,  80, 130,  105, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 4
    GOSUB 기본자세

    GOTO RX_EXIT
    '************************************************
덤블링:
    GOSUB Leg_motor_mode3

    SPEED 6
    MOVE G6A,100, 77, 145, 93, 100, 100
    MOVE G6D,100, 77, 145, 93, 100, 100
    MOVE G6B,100, 30, 80
    MOVE G6C,100, 30, 80
    WAIT

    MOVE G6A, 100, 97, 125, 88, 100,
    MOVE G6D, 100, 97, 125, 88, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6D, 100, 117, 105, 88, 100,
    MOVE G6A, 100, 117, 105, 88, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 132, 85, 93, 100,
    MOVE G6D, 100, 132, 85, 93, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6D, 100, 147, 60, 103, 100,
    MOVE G6A, 100, 147, 60, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 152, 55, 103, 100,
    MOVE G6D, 100, 152, 55, 103, 100,

    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 157, 50, 103, 100,
    MOVE G6D, 100, 157, 50, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A, 100, 162, 45, 103, 100,
    MOVE G6D, 100, 162, 45, 103, 100,
    MOVE G6B, 100, 30, 80, , ,
    MOVE G6C, 100, 30, 80, , ,

    MOVE G6A,100, 145, 28, 145, 100, 100
    MOVE G6D,100, 145, 28, 145, 100, 100
    MOVE G6B,100, 30, 80,
    MOVE G6C,100, 30, 80

    MOVE G6B, 170, 30, 80, , ,
    MOVE G6C, 170, 30, 80, , ,

    MOVE G6A,100, 145, 60, 145, 100, 100
    MOVE G6D,100, 145, 60, 145, 100, 100
    MOVE G6B,160, 30, 80,
    MOVE G6C,160, 30, 80

    MOVE G6A,100, 135, 60, 145, 100, 100
    MOVE G6D,100, 135, 60, 145, 100, 100
    MOVE G6B,140, 40, 60,
    MOVE G6C,140, 40, 60

    MOVE G6A,100, 145, 60, 115, 100, 100
    MOVE G6D,100, 145, 60, 115, 100, 100
    MOVE G6B,150, 40, 60,
    MOVE G6C,150, 40, 60

    MOVE G6A,100, 145, 60, 65, 100, 100
    MOVE G6D,100, 145, 60, 65, 100, 100
    MOVE G6B,160, 40, 60,
    MOVE G6C,160, 40, 60

    MOVE G6A,100, 145, 100, 25, 100, 100
    MOVE G6D,100, 145, 100, 25, 100, 100
    MOVE G6B,180, 40, 60,
    MOVE G6C,180, 40, 60, , 10

    MOVE G6A,100, 120, 80, 10, 100, 100
    MOVE G6D,100, 120, 80, 10, 100, 100
    MOVE G6B,190, 15, 100,
    MOVE G6C,190, 15, 100, , 10

    MOVE G6A,100, 120, 80, 10, 100, 100
    MOVE G6D,100, 120, 80, 10, 100, 100
    MOVE G6B,190, 15, 100,
    MOVE G6C,190, 15, 100, , 10

    MOVE G6A,100, 70, 130, 10, 100, 100
    MOVE G6D,100, 70, 130, 10, 100, 100
    MOVE G6B,190, 15, 100,
    MOVE G6C,190, 15, 100, , 10

    MOVE G6A,100, 70, 140, 10, 120, 100
    MOVE G6D,100, 70, 140, 10, 120, 100
    MOVE G6B,190, 15, 100,
    MOVE G6C,190, 15, 100, , 10

    DELAY 500


    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

    SPEED 15
    MOVE G6A,100, 15, 70, 140, 100,
    MOVE G6D,100, 15, 70, 140, 100,
    MOVE G6B,20, 140, 15
    MOVE G6C,20, 140, 15
    WAIT

    SPEED 12
    MOVE G6A,100, 136, 35, 80, 100,
    MOVE G6D,100, 136, 35, 80, 100,
    MOVE G6B,20, 30, 80
    MOVE G6C,20, 30, 80
    WAIT

    SPEED 12
    MOVE G6A,100, 165, 70, 30, 100,
    MOVE G6D,100, 165, 70, 30, 100,
    MOVE G6B,30, 20, 95
    MOVE G6C,30, 20, 95
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 10
    MOVE G6A,100, 165, 45, 90, 100,
    MOVE G6D,100, 165, 45, 90, 100,
    MOVE G6B,130, 50, 60
    MOVE G6C,130, 50, 60
    WAIT

    SPEED 6
    MOVE G6A,100, 145, 45, 130, 100,
    MOVE G6D,100, 145, 45, 130, 100,
    WAIT

    SPEED 8
    GOSUB All_motor_mode2

    DELAY 200
    GOSUB 자이로ON
    GOSUB 기본자세
    RETURN
    '**********************************************


계단오르기mm:
    보행횟수=6
    GOSUB 횟수_전진종종걸음m
    GOSUB 계단오른발오르기1cmm
    보행횟수=6
    GOSUB 횟수_전진종종걸음m
    GOSUB 계단오른발오르기1cmm

    RETURN

    '************************************************
mmm문열기:


    보행횟수=6

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT

    mode = 0


    SPEED 8
    GOSUB 횟수_전진종종걸음m
    GOSUB mmm문


    RETURN

mmm문:
    MOVE G6A, 100,  76, 145,  93, 100,
    MOVE G6D, 100,  76, 145,  93, 100,
    MOVE G6B, 100,  36,  86,  ,  ,
    MOVE G6C, 135,  17,  92,  ,  ,

    MOVE G6A, 100,  76, 145,  93, 100,
    MOVE G6D, 100,  76, 145,  93, 100,
    MOVE G6B, 100,  36,  86,  ,  ,
    MOVE G6C, 135,  10,  72,  ,  ,

    MOVE G6A, 100,  76, 145,  93, 100,
    MOVE G6D, 100,  76, 145,  93, 100,
    MOVE G6B, 100,  36,  86,  ,  ,
    MOVE G6C, 145,  10,  72,  ,  ,

    MOVE G6A, 100,  76, 145,  93, 100,
    MOVE G6D, 100,  76, 145,  93, 100,
    MOVE G6B, 100,  36,  86,  ,  ,
    MOVE G6C, 145,  10,  42,  ,  ,
    WAIT

    MOVE G6A, 100,  76, 145,  93, 100,
    MOVE G6D, 100,  76, 145,  93, 100,
    MOVE G6B, 100,  36,  86,  ,  ,
    MOVE G6C, 160,  10,  42,  ,  ,

    MOVE G6A, 100,  76, 145,  93, 100,
    MOVE G6D, 100,  76, 145,  93, 100,
    MOVE G6B, 100,  36,  86,  ,  ,
    MOVE G6C, 160,  10,  27,  ,  ,

    MOVE G6A, 100,  76, 145,  93, 100,
    MOVE G6D, 100,  76, 145,  93, 100,
    MOVE G6B, 100,  36,  86,  ,  ,
    MOVE G6C, 170,  10,  27,  ,  ,

    MOVE G6A, 100,  76, 145,  93, 100,
    MOVE G6D, 100,  76, 145,  93, 100,
    MOVE G6B, 100,  36,  86,  ,  ,
    MOVE G6C, 170,  10,  17,  ,  ,

    MOVE G6A, 100,  76, 145,  93, 100,
    MOVE G6D, 100,  76, 145,  93, 100,
    MOVE G6B, 100,  36,  86,  ,  ,
    MOVE G6C, 190,  10,  17,  ,  ,

    MOVE G6A, 100,  76, 145,  93, 100,
    MOVE G6D, 100,  76, 145,  93, 100,
    MOVE G6B, 100,  36,  86,  ,  ,
    MOVE G6C, 190,  10,  10,  ,  ,
    '***************************************88
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON


    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6C, 190,  10,  15,  ,  ,
    WAIT


    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6C, 190,  10,  20,  ,  ,

    WAIT


    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    MOVE G6C, 190,  10,  25,  ,  ,
    WAIT

    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 190,  10,  30,  ,  ,

    WAIT

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6C, 190,  10,  35,  ,  ,

    WAIT

    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6C, 190,  10,  40,  ,  ,
    WAIT


    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6C, 190,  10,  45,  ,  ,

    WAIT


    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    MOVE G6C, 190,  10,  50,  ,  ,
    WAIT

    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 190,  10,  55,  ,  ,

    WAIT

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6C, 190,  10,  60,  ,  ,

    WAIT

    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6C, 190,  10,  65,  ,  ,
    WAIT


    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6C, 190,  10,  70,  ,  ,

    WAIT


    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    MOVE G6C, 190,  10,  75,  ,  ,
    WAIT

    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 190,  10,  80,  ,  ,

    WAIT

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6C, 190,  10,  95,  ,  ,

    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6C, 190,  10,  100,  ,  ,
    WAIT


    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6C, 190,  10,  105,  ,  ,

    WAIT


    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    MOVE G6C, 190,  10,  110,  ,  ,
    WAIT

    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 190,  10,  115,  ,  ,

    WAIT

    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6C, 190,  10,  120,  ,  ,

    WAIT

    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세2
    RETURN



    '************************************************

계단왼발오르기1cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,112,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6A, 85, 100, 110, 100, 114
    MOVE G6D,114,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6A, 90, 140, 35, 130, 114
    MOVE G6D,114,  71, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6A,  80, 55, 130, 140, 114,
    MOVE G6D,114,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6A, 105, 75, 100, 155, 100,
    MOVE G6D,95,  90, 165,  70, 100
    MOVE G6B,160,50
    MOVE G6C,160,40
    WAIT

    SPEED 6
    MOVE G6A, 114, 90, 90, 155,100,
    MOVE G6D,95,  100, 165,  65, 105
    MOVE G6B,180,50
    MOVE G6C,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,95,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6A, 114, 90, 100, 150,95,
    MOVE G6D,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6A, 114, 90, 110, 130,95,
    MOVE G6D,90,  95, 90,  145, 108
    MOVE G6B,140,50
    MOVE G6C,140,30
    WAIT

    SPEED 10
    MOVE G6A, 110, 90, 110, 130,95,
    MOVE G6D,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6D, 98, 90, 110, 125,99,
    MOVE G6A,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOTO RX_EXIT
    '****************************************

계단오른발오르기1cm:
    GOSUB All_motor_mode3

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,112,  77, 146,  93,  94
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 8
    MOVE G6D, 85, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,113,  71, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6D,  80, 55, 130, 140, 114,
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 75, 100, 155, 100,
    MOVE G6A,95,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 113, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,95,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6D, 114, 90, 110, 130,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 125,99,
    MOVE G6D,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    GOTO RX_EXIT
    '********************************************
계단오른발오르기1cmm:
    GOSUB All_motor_mode3
    GOSUB All_motor_mode3

    MOVE G6B, 100,  25,  80,  ,  ,
    MOVE G6C, 100,  60,  90,  ,  ,
    MOVE G6D,  88,  71, 152,  91, 110,
    MOVE G6A, 112,  77, 146,  93,  94,


    SPEED 8
    MOVE G6D, 85, 100, 110, 100, 114
    MOVE G6A,113,  78, 146,  93,  94
    WAIT

    GOSUB Leg_motor_mode2

    SPEED 8
    MOVE G6D, 90, 140, 35, 130, 114
    MOVE G6A,113,  71, 155,  90,  94
    WAIT


    SPEED 12
    MOVE G6D,  80, 55, 130, 140, 114,
    MOVE G6A,113,  70, 155,  90,  94
    WAIT

    GOSUB Leg_motor_mode3

    SPEED 7
    MOVE G6D, 105, 75, 100, 155, 100,
    MOVE G6A,95,  90, 165,  70, 100
    MOVE G6C,160,50
    MOVE G6B,160,40
    WAIT

    SPEED 6
    MOVE G6D, 113, 90, 90, 155,100,
    MOVE G6A,95,  100, 165,  65, 105
    MOVE G6C,180,50
    MOVE G6B,180,30
    WAIT

    '****************************
    GOSUB Leg_motor_mode2	
    SPEED 8
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,95,  90, 165,  70, 105
    WAIT

    SPEED 12
    MOVE G6D, 114, 90, 100, 150,95,
    MOVE G6A,90,  120, 40,  140, 108
    WAIT

    SPEED 10
    MOVE G6D, 114, 90, 110, 130,95,
    MOVE G6A,90,  95, 90,  145, 108
    MOVE G6C,140,50
    MOVE G6B,140,30
    WAIT

    SPEED 10
    MOVE G6D, 110, 90, 110, 130,95,
    MOVE G6A,80,  85, 110,  135, 108
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 5
    MOVE G6A, 98, 90, 110, 125,99,
    MOVE G6D,98,  90, 110,  125, 99
    MOVE G6B,110,40
    MOVE G6C,110,40
    WAIT

    SPEED 6
    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,  80
    WAIT

    RETURN

    '******************************************	
MAIN: '라벨설정

    ETX 4800, 38 ' 동작 멈춤 확인 송신 값

MAIN_2:

    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인

    ERX 4800,A,MAIN_2	

    A_old = A

    '**** 입력된 A값이 0 이면 MAIN 라벨로 가고
    '**** 1이면 KEY1 라벨, 2이면 key2로... 가는문
    ON A GOTO MAIN,KEY1,KEY2,KEY3,KEY4,KEY5,KEY6,KEY7,KEY8,KEY9,KEY10,KEY11,KEY12,KEY13,KEY14,KEY15,KEY16,KEY17,KEY18 ,KEY19,KEY20,KEY21,KEY22,KEY23,KEY24,KEY25,KEY26,KEY27,KEY28 ,KEY29,KEY30,KEY31,KEY32

    IF A > 100 AND A < 110 THEN
        BUTTON_NO = A - 100
        GOSUB Number_Play
        GOSUB SOUND_PLAY_CHK
        GOSUB GOSUB_RX_EXIT


    ELSEIF A = 250 THEN
        GOSUB All_motor_mode3
        SPEED 4
        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  40,  90,
        MOVE G6C,100,  40,  90,
        WAIT
        DELAY 500
        SPEED 6
        GOSUB 기본자세

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN 라벨로 가기
    '*******************************************

KEY1:
    ETX  4800,106

    미션수행=3
    GOTO 진행코드_5
    DELAY 10000
    '***************	
KEY2:
    ETX  4800,2
test:

    GOSUB 적외선거리센서확인
    IF 적외선거리값>140 THEN 'CLOSE
        GOSUB 고개들고_한발뒤로가기
        GOTO test
    ELSEIF 적외선거리값<120 THEN 'far
        GOSUB 고개들고_한발앞으로가기
        GOTO test
    ENDIF



    DELAY 4000
    '***************
KEY3:
    ETX  4800,106



    RETURN
    '***************
KEY4:
    ETX  4800,104


    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5

    J = AD(5)	'적외선거리값 읽기
    BUTTON_NO = J
    GOSUB Number_Play
    GOSUB SOUND_PLAY_CHK
    GOSUB GOSUB_RX_EXIT

    GOTO RX_EXIT
    '***************
KEY6:
    ETX  4800,107
    ' 미션수행 =2
    ' GOTO 진행코드_4



    GOTO RX_EXIT
    '***************
KEY7:
    ETX  4800,7
    GOSUB 왼쪽턴20

    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOTO 한발앞으로가기

    GOTO RX_EXIT
    '***************
KEY9:
    ETX  4800,9
    GOTO 오른쪽턴20


    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10
    ''GOTO 전진달리기50
    GOSUB 계단오르기mm
    GOTO RX_EXIT
    '***************
KEY11: ' ▲
    ETX  4800,11
    미션수행=0
    'GOTO 연속전진
    GOTO 진행코드

    GOTO RX_EXIT
    '***************
KEY12: ' ▼
    ETX  4800,12
    GOTO 전진종종걸음

    GOTO RX_EXIT
    '***************
KEY13: '▶
    ETX  4800,13
    GOTO 오른쪽옆으로70연속


    GOTO RX_EXIT
    '***************
KEY14: ' ◀
    ETX  4800,14
    GOTO 왼쪽옆으로70연속


    GOTO RX_EXIT
    '***************
KEY15: ' A
    ETX  4800,15
    GOTO 왼쪽옆으로20


    GOTO RX_EXIT
    '***************
KEY16: ' POWER
    ETX  4800,16

    GOSUB Leg_motor_mode3
    IF MODE = 0 THEN
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
    ENDIF
    SPEED 4
    GOSUB 앉은자세	
    GOSUB 종료음

    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF 모터ONOFF = 1  THEN
        OUT 52,1
        DELAY 200
        OUT 52,0
        DELAY 200
    ENDIF
    ERX 4800,A,KEY16_1
    ETX  4800,A
    IF  A = 16 THEN 	'다시 파워버튼을 눌러야만 복귀
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
        GOSUB Leg_motor_mode2
        GOSUB 기본자세2
        GOSUB 자이로ON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1



    GOTO RX_EXIT
    '***************
KEY17: ' C
    GOSUB m왼쪽옆으로20


    DELAY 10000
    '***************
KEY18: ' E
    ETX  4800,18	

    GOSUB 자이로OFF
    GOSUB 에러음
KEY18_wait:

    ERX 4800,A,KEY18_wait	

    IF  A = 26 THEN
        GOSUB 시작음
        GOSUB 자이로ON
        GOTO RX_EXIT
    ENDIF

    GOTO KEY18_wait


    GOTO RX_EXIT
    '***************
KEY19: ' P2
    ETX  4800,19
    GOTO 계단오른발내리기3cm

    GOTO RX_EXIT
    '***************
KEY20: ' B	
    ETX  4800,20
    GOTO 오른쪽옆으로20


    GOTO RX_EXIT
    '***************
KEY21: ' △
    ETX  4800,21
    GOTO 진행코드

    GOTO RX_EXIT
    '***************
KEY22: ' *	
    ETX  4800,22
    GOTO 계단왼발오르기1cm

    GOTO RX_EXIT
    '***************
KEY23: ' G
    GOSUB 레버내리기
    DELAY 3000
    GOSUB 레버내리기
    DELAY 3000
    GOSUB 레버내리기
    DELAY 3000
    GOSUB 레버내리기
    DELAY 3000
    GOTO RX_EXIT
KEY23_wait:


    ERX 4800,A,KEY23_wait	

    IF  A = 26 THEN
        GOSUB 시작음
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOTO KEY23_wait


    GOTO RX_EXIT
    '***************
KEY24: ' #
    ETX  4800,24
    GOTO 계단오른발오르기1cm

    GOTO RX_EXIT
    '***************
KEY25: ' P1
    ETX  4800,25
    GOTO 계단왼발내리기3cm

    GOTO RX_EXIT
    '***************
KEY26: ' ■
    ETX  4800,26

    SPEED 5
    GOSUB 기본자세2	
    TEMPO 220
    MUSIC "ff"
    GOSUB 기본자세
    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX  4800,27
    GOTO 머리오른쪽90도


    GOTO RX_EXIT
    '***************
KEY28: ' ◁
    ETX  4800,28
    'GOTO 머리왼쪽45도
    'SERVO 11, 10
    SPEED 15
    MOVE G6B, , , , , , 10
    WAIT

    GOTO RX_EXIT
    '***************
KEY29: ' □
    미션수행 =3
    GOTO 진행코드_5
    GOTO RX_EXIT
    '***************
KEY30: ' ▷
    ETX  4800,30
    'GOTO 머리오른쪽45도

    'SERVO 11, 190
    SPEED 15
    MOVE G6B, , , , , , 190
    WAIT


    GOTO RX_EXIT
    '***************
KEY31: ' ▽
    ETX  4800,31
    GOSUB 적외선거리센서확인
    IF 적외선거리값<60 THEN
        MUSIC "C"
    ENDIF
    GOTO MAIN
    '***************

KEY32: ' F
    ETX  4800,32
    미션수행 =1
    GOTO 진행코드_3
    GOTO RX_EXIT
    '***************
