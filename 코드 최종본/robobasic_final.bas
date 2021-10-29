'******** 2족 보행로봇 초기 영점 프로그램 ********

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
DIM 자이로ONOFF AS BYTE
DIM 기울기앞뒤 AS INTEGER
DIM 기울기좌우 AS INTEGER
DIM Q AS BYTE
DIM 곡선방향 AS BYTE
DIM TEST AS INTEGER
DIM HEAD AS INTEGER
DIM REGION AS BYTE
DIM TURN AS BYTE
DIM POSITION AS BYTE
DIM FINAL_COUNT AS BYTE
DIM TURN_COUNT AS BYTE
DIM PACK_FIND AS BYTE
DIM START_NEWS AS BYTE


DIM 넘어진확인 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 보행횟수 AS BYTE
DIM 보행COUNT AS BYTE
DIM 방향설정확인 AS BYTE

DIM 적외선거리값  AS BYTE

DIM S11  AS BYTE
DIM S16  AS BYTE
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
CONST 기울기확인시간 = 20  'ms

CONST 적외선AD포트  = 4


CONST min = 61	'뒤로넘어졌을때
CONST max = 107	'앞으로넘어졌을때
CONST COUNT_MAX = 3


CONST 머리이동속도 = 10
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
보행횟수 = 1
모터ONOFF = 0

'****초기위치 피드백*****************************


TEMPO 230
MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

SERVO 16, 100


GOSUB 전원초기자세
GOSUB 기본자세


GOSUB 자이로INIT
GOSUB 자이로MID
GOSUB 자이로ON



PRINT "VOLUME 80 !"
PRINT "SOUND 30 !" '안녕하세요

GOSUB All_motor_mode3

ZERO G6A, 100, 99, 102,  100, 100, 100
ZERO G6B,100, 105, 102, 100, 100, 100
ZERO G6C, 98, 103,  98, 100, 100, 100
ZERO G6D, 100, 99, 105,  100, 104, 100

GOTO MAIN	'시리얼 수신 루틴으로 가기

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

전원초기자세:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '************************************************
안정화자세:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
기본자세:


    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
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

    mode = 0
    RETURN

    '******************************************	
기본자세3:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

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
    '******************************************
    '***********************************************
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


RX_EXIT:

    ERX 4800, A, MAIN

    GOTO RX_EXIT
    '**********************************************
GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************


전진종종걸음:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    GOTO 전진종종걸음_1

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

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 3 THEN
        GOTO 전진종종걸음_5_stop
    ELSEIF 보행COUNT <= 3 THEN
        GOTO 전진종종걸음_1

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

    ENDIF

    RETURN

    '**********************************************



연속전진_두왼발:
    보행속도 = 13
    좌우속도 = 4
    GOSUB Leg_motor_mode3

    SPEED 4

    MOVE G6A, 88,  74, 144,  95, 110
    MOVE G6D,108,  76, 146,  93,  96
    WAIT

    SPEED 10'

    MOVE G6A, 90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 147,  93,  96,100
    WAIT

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

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    WAIT

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

    MOVE G6A, 90, 100, 100, 115, 110,100
    MOVE G6D,112,  76, 146,  93,  96,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 10

    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 152,  91, 106,100
    WAIT	
    SPEED 4

    GOSUB 기본자세3

    RETURN


연속전진_두오른발:
    보행속도 = 13
    좌우속도 = 4
    GOSUB Leg_motor_mode3

    SPEED 4

    MOVE G6D, 88,  74, 144,  95, 110
    MOVE G6A,108,  76, 146,  93,  96
    WAIT

    SPEED 10'

    MOVE G6D, 90, 90, 120, 105, 110,100
    MOVE G6A,110,  76, 147,  93,  96,100
    WAIT

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT


    SPEED 좌우속도
    GOSUB Leg_motor_mode3

    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

    MOVE G6D,110,  76, 147,  93, 96,100
    MOVE G6A,90, 90, 120, 105, 110,100
    WAIT

    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

    MOVE G6D, 90, 100, 100, 115, 110,100
    MOVE G6A,112,  76, 146,  93,  96,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 10

    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 152,  91, 106,100
    WAIT	
    SPEED 4
    GOSUB 기본자세3

    RETURN


연속전진_한오른발:

    보행속도 = 13
    좌우속도 = 4
    GOSUB Leg_motor_mode3

    SPEED 4

    MOVE G6D,  88,  74, 144,  95, 110
    MOVE G6A, 108,  76, 146,  93,  96
    WAIT

    SPEED 10

    MOVE G6D, 90, 90, 120, 105, 110,100
    MOVE G6A,110,  76, 147,  93,  96,100
    WAIT

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    WAIT

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도


    MOVE G6A, 90, 100, 100, 115, 110,100
    MOVE G6D,112,  76, 146,  93,  96,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 10

    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 152,  91, 106,100
    WAIT	
    SPEED 5

    GOSUB 기본자세3

    RETURN


연속전진_한왼발:

    보행속도 = 13
    좌우속도 = 4
    GOSUB Leg_motor_mode3


    SPEED 4

    MOVE G6A,  88,  74, 144,  95, 110
    MOVE G6D, 108,  76, 146,  93,  96
    WAIT

    SPEED 10

    MOVE G6A, 90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 147,  93,  96,100
    WAIT

    MOVE G6D,110,  76, 147,  93, 96,100
    MOVE G6A,90, 100, 120, 105, 110,100
    WAIT

    SPEED 보행속도

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도


    MOVE G6D, 90, 100, 100, 115, 110,100
    MOVE G6A,112,  76, 146,  93,  96,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 10

    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 152,  91, 106,100
    WAIT	
    SPEED 5

    GOSUB 기본자세3

    RETURN


연속전진_두발:
    보행COUNT = 0
    보행속도 = 13
    좌우속도 = 4
    넘어진확인 = 0

    GOSUB Leg_motor_mode3

    SPEED 4

    MOVE G6A, 88,  74, 144,  95, 110
    MOVE G6D,108,  76, 146,  93,  96
    WAIT

    SPEED 10'

    MOVE G6A, 90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 147,  93,  96,100
    WAIT

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

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    WAIT

    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

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

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT


    SPEED 보행속도

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED 좌우속도
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED 보행속도

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
    GOSUB 기본자세3

    RETURN



    '************************************************
연속후진_0:
    넘어진확인 = 0
    보행속도 = 12
    좌우속도 = 4
    SPEED 4
    MOVE G6D,  88,  71, 152,  91, 110
    MOVE G6A, 108,  76, 145,  93,  96
    '     MOVE G6C, 100
    '      MOVE G6B, 100
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 100, 115, 110
    MOVE G6A,110,  76, 145,  93,  96
    '     MOVE G6C,90
    '    MOVE G6B,110
    WAIT


    GOTO 연속후진_2


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
        '    MOVE G6B,100
        '    MOVE G6C,100
        WAIT

        SPEED 10
        MOVE G6A, 90, 100, 100, 115, 110
        MOVE G6D,110,  76, 145,  93,  96
        '    MOVE G6B,90
        '    MOVE G6C,110
        WAIT

        GOTO 연속후진_1	
    ELSE
        보행순서 = 0

        SPEED 4
        MOVE G6D,  88,  71, 152,  91, 110
        MOVE G6A, 108,  76, 145,  93,  96
        '     MOVE G6C, 100
        '      MOVE G6B, 100
        WAIT

        SPEED 10
        MOVE G6D, 90, 100, 100, 115, 110
        MOVE G6A,110,  76, 145,  93,  96
        '     MOVE G6C,90
        '    MOVE G6B,110
        WAIT


        GOTO 연속후진_2

    ENDIF


연속후진_1:
    SPEED 보행속도

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED 좌우속도
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    'GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    '  MOVE G6B,110
    '   MOVE G6C,90
    WAIT

    ERX 4800,A, 연속후진_2
    IF A <> A_old THEN
연속후진_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        '   MOVE G6B, 100
        '    MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세3
        GOTO 팩집기_2_확진

    ENDIF
    '**********

연속후진_2:
    SPEED 보행속도
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED 좌우속도
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    'GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    ' MOVE G6B, 90
    '  MOVE G6C,110
    WAIT


    ERX 4800,A, 연속후진_3
    IF A <> A_old THEN
연속후진_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        '   MOVE G6B, 100
        ' MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB 기본자세3
        GOTO 팩집기_2_확진
    ENDIF  	


연속후진_3:
    MOVE G6D, 106,  76, 145,  93,  96		
    MOVE G6A,  85,  72, 148,  91, 106
    '   MOVE G6B, 100
    ' MOVE G6C, 100
    WAIT	

    SPEED 3
    GOSUB 기본자세3

    GOTO 팩집기_2_확진

    '******************************************
    '******************************************
    '******************************************

    '************************************************
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
    GOSUB 기본자세3
    GOSUB All_motor_mode3
    RETURN
    '*************

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
    GOSUB 기본자세3
    GOSUB All_motor_mode3
    RETURN

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
    'MOVE G6C,100,  40
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
    'GOSUB 기본자세2

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

    GOSUB 기본자세3

    RETURN

    '*********************************************

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
    GOTO RX_EXIT
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

    '**********************************************	


    '**********************************************
왼쪽턴45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴45_LOOP:

    SPEED 8
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 6
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

    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 6
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

    SPEED 8
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 7
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

    SPEED 8
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 7
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
    '****************************************
    '************************************************
    '**********************************************


    '************************************************

    ''************************************************
    '************************************************
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

    '******************************************
    '******************************************
    '******************************************
    '**************************************************

    '******************************************
    '******************************************	
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
    SERVO 16,100
    SERVO 11,100	
    SPEED 5
    GOSUB 기본자세
    GOTO MAIN

    '******************************************
전방하향80도:

    SPEED 3
    SERVO 16, 60
    ETX 4800,35
    RETURN
    '******************************************
전방하향60도:

    SPEED 3
    SERVO 16, 65
    ETX 4800,36
    RETURN

머리최대하향:
    SPEED 3
    Q=30
    SERVO 16, Q
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
        ETX  4800,16
        GOSUB 뒤로일어나기

    ENDIF
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN
        ETX  4800,15
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


    '******************************************

    ' ************************************************
적외선거리센서확인:

    ' 적외선거리값 = AD(적외선AD포트)

    'IF 적외선거리값 > 46 THEN '50 = 적외선거리값 = 25cm
    ' MUSIC "C"

    'DELAY 200
    ' ENDIF




    RETURN

적외선거리센서확인_2:
    적외선거리값 = AD(적외선AD포트)

    IF 적외선거리값 > 46 THEN '50 = 적외선거리값 = 25cm
        방향설정확인= 1

    ENDIF

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
    RETURN
    '**********************************************
집고오른쪽턴10:

    SPEED 5
    MOVE G6A,97,  66, 145,  95, 103, 100
    MOVE G6D,97,  86, 145,  75, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  95, 101, 100
    MOVE G6D,94,  86, 145,  75, 101, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  85, 98, 100
    MOVE G6D,101,  76, 146,  85, 98, 100
    WAIT

    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    RETURN
    '**********************************************
    '**********************************************
집고왼쪽턴20:

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  96, 145,  73, 105, 100
    MOVE G6D,95,  56, 145,  113, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  73, 105, 100
    MOVE G6D,93,  56, 145,  113, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세3

    RETURN
    '**********************************************
집고오른쪽턴20:

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  56, 145,  113, 105, 100
    MOVE G6D,95,  96, 145,  73, 105, 100
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
집고왼쪽턴45:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  106, 145,  55, 105, 100
    MOVE G6D,95,  46, 145,  115, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  106, 145,  55, 105, 100
    MOVE G6D,93,  46, 145,  115, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOSUB Leg_motor_mode1
    RETURN

    '**********************************************
집고오른쪽턴45:

    GOSUB Leg_motor_mode2
    SPEED 8
    MOVE G6A,95,  46, 145,  115, 105, 100
    MOVE G6D,95,  106, 145,  55, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  115, 105, 100
    MOVE G6D,93,  106, 145,  55, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    GOSUB Leg_motor_mode1
    RETURN
    '**********************************************
집고왼쪽턴60:

    SPEED 8
    MOVE G6A,95,  116, 145,  45, 105, 100
    MOVE G6D,95,  36, 145,  125, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,90,  116, 145,  45, 105, 100
    MOVE G6D,90,  36, 145,  125, 105, 100
    WAIT

    SPEED 7
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT

    RETURN

    '**********************************************
집고오른쪽턴60:

    SPEED 8
    MOVE G6A,95,  36, 145,  125, 105, 100
    MOVE G6D,95,  116, 145,  45, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,90,  36, 145,  125, 105, 100
    MOVE G6D,90,  116, 145,  45, 105, 100
    WAIT

    SPEED 7
    MOVE G6A,100,  76, 145,  85, 100
    MOVE G6D,100,  76, 145,  85, 100
    WAIT
    RETURN







    '*********************************
연속후진_TEST:
    SPEED 4
    MOVE G6D,  88,  71, 152,  91, 110
    MOVE G6A, 108,  76, 145,  93,  96
    '     MOVE G6C, 100
    '      MOVE G6B, 100
    WAIT

    SPEED 10
    MOVE G6D, 90, 100, 100, 115, 110
    MOVE G6A,110,  76, 145,  93,  96
    '     MOVE G6C,90
    '    MOVE G6B,110
    WAIT

    SPEED 보행속도
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED 좌우속도
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT

    MOVE G6D, 106,  76, 145,  93,  96		
    MOVE G6A,  85,  72, 148,  91, 106
    '   MOVE G6B, 100
    ' MOVE G6C, 100
    WAIT	

    SPEED 3
    GOSUB 기본자세3

    RETURN


    'GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    ' MOVE G6B, 90
    '  MOVE G6C,110
    WAIT

    '****************************

연속후진_한발:

    보행속도 = 12
    좌우속도 = 4
    GOSUB Leg_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  96
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 100, 115, 110
    MOVE G6D,110,  76, 145,  93,  96
    WAIT

    SPEED 보행속도

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED 좌우속도
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT

    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    WAIT

    SPEED 보행속도
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED 좌우속도
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT

    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    WAIT

    HIGHSPEED SETOFF
    SPEED 5

    MOVE G6D, 106,  76, 145,  93,  96		
    MOVE G6A,  85,  72, 148,  91, 106
    WAIT	

    SPEED 3
    GOSUB 기본자세3

    RETURN



미션_1_0:
    START_NEWS=0




미션_1:

    ETX 4800, 110
    SERVO 16,70
    SERVO 11,120


미션_1_1:


    DELAY 500
    ERX 4800, A, 미션_1


    IF A=150 THEN
        SPEED 10
        MOVE G6C, 189,  11,  93, 100,  98, 100
        WAIT
        PRINT "VOLUME 200 !"
        PRINT "SOUND 57 !" '동
    ELSEIF A=151 THEN
        SPEED 10
        MOVE G6B, 189,  11,  93, 100,  98, 100
        WAIT
        PRINT "VOLUME 200 !"
        PRINT "SOUND 58 !" '서
    ELSEIF A=152 THEN
        SPEED 10
        MOVE G6B,  14,  16,  92, 100, 100, 100
        MOVE G6C,  14,  16,  92, 100, 100, 100
        WAIT
        PRINT "VOLUME 200 !"
        PRINT "SOUND 59 !" '남
    ELSEIF A=153 THEN
        SPEED 10
        MOVE G6C, 189,  11,  93, 100,  98, 100
        MOVE G6B, 189,  11,  93, 100,  98, 100
        WAIT
        PRINT "VOLUME 200 !"
        PRINT "SOUND 60 !" '북
    ELSEIF A=254 THEN
        IF START_NEWS=0 THEN
            SERVO 11,80
            START_NEWS=1
            DELAY 1500
        ELSEIF START_NEWS=1 THEN
            SERVO 11,100
            START_NEWS=2
            DELAY 1500
        ELSEIF START_NEWS=2 THEN
            SERVO 11,120
            START_NEWS=0
            DELAY 1500
        ENDIF
        GOTO 미션_1

    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO 미션_1_1
        DELAY 500
    ENDIF

    DELAY 200

    GOSUB 기본자세

    GOSUB 연속전진_두오른발


    GOSUB 새문열기

    DELAY 200
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
    ENDIF
    DELAY 300

    SPEED 머리이동속도
    SERVO 16,30	
    SPEED 5
    GOSUB 기본자세


    GOTO 라인잡기_방향전



    GOTO RX_EXIT

    '************************************************
새문열기:
    ETX 4800,105


    GOSUB 기본자세

    GOSUB 왼쪽턴60
    DELAY 300
    GOSUB 왼쪽턴45

    MOVE G6C, 100,  85,  21,  ,  ,
    MOVE G6B, 101,  93, 104, 100, 100, 100
    WAIT


    GOSUB 오른쪽옆으로70연속'오른쪽팔도 고쳤음
    DELAY 200
    GOSUB 오른쪽옆으로70연속
    DELAY 200
    GOSUB 오른쪽옆으로70연속
    DELAY 200
    GOSUB 오른쪽옆으로70연속
    DELAY 200
    GOSUB 오른쪽옆으로70연속
    DELAY 200
    GOSUB 오른쪽옆으로70연속
    DELAY 200


    GOSUB 기본자세2

    GOSUB 오른쪽턴60
    DELAY 300

    GOSUB 오른쪽턴45

    SPEED 머리이동속도
    SERVO 16,30	
    SPEED 5
    GOSUB 기본자세

    RETURN

    '************************************************

새문열기_TEST:

    GOSUB 기본자세

    IF D=1 THEN


        MOVE G6B, 100,  85,  21,  ,  ,
        MOVE G6C, 101,  93, 104, 100, 100, 100
        WAIT

        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200

        GOSUB 기본자세2

        GOSUB 왼쪽턴45
        GOSUB 왼쪽턴60

    ELSEIF D=2 THEN

        MOVE G6C, 100,  85,  21,  ,  ,
        MOVE G6B, 101,  93, 104, 100, 100, 100
        WAIT

        GOSUB 오른쪽옆으로70연속'오른쪽팔도 고쳤음
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200

        GOSUB 기본자세2

        GOSUB 오른쪽턴45
        DELAY 300
        GOSUB 오른쪽턴60

    ENDIF

    RETURN





라인잡기_방향전:

    ETX 4800,194
    DELAY 500
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
    ENDIF
    DELAY 300

라인잡기_방향전_2:
    ERX 4800,A,라인잡기_방향전_2

    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        DELAY 1000
        GOTO 라인잡기_방향전


    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        DELAY 1000
        GOTO 라인잡기_방향전

    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        DELAY 1000
        GOTO 라인잡기_방향전

    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        DELAY 1000
        GOTO 라인잡기_방향전

    ELSEIF A=160 THEN
        GOSUB 연속전진_한오른발
        DELAY 1000
        GOTO 라인잡기_방향전


    ELSEIF A=170 THEN
        GOTO 방향설정


    ELSEIF A = 26 THEN
        GOTO MAIN

    ELSE
        GOTO 라인잡기_방향전_2

    ENDIF
    GOTO RX_EXIT


방향설정:
    GOSUB 연속후진_한발
    DELAY 300
    GOSUB 연속후진_한발
    DELAY 500
    SPEED 머리이동속도
    SERVO 16,90	
    SPEED 5
    GOSUB 기본자세
    DELAY 2000

방향설정_1:



    ETX 4800, 180

    DELAY 500

    ERX 4800,A,방향설정_1

    IF A=155 THEN
        D=1
        GOSUB 연속전진_한오른발
        GOSUB 연속전진_한오른발
        GOSUB 연속전진_한오른발
        DELAY 500
        GOSUB 왼쪽턴45
        GOSUB 왼쪽턴45

    ELSEIF A=156 THEN
        D=2
        GOSUB 기본자세

        SPEED 머리이동속도
        SERVO 16,30	
        SPEED 5

        GOSUB 연속전진_한오른발
        GOSUB 연속전진_한오른발
        GOSUB 연속전진_한오른발
        DELAY 500
        GOSUB 오른쪽턴45
        GOSUB 오른쪽턴45
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO 방향설정_1


    ENDIF


    DELAY 200
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
    ENDIF
    DELAY 300

    SPEED 머리이동속도
    SERVO 16,30	
    SPEED 5

    GOTO 라인잡기_MAIN
    'GOTO 라인잡기_MAIN


라인잡기_MAIN:


    ETX 4800,190
    DELAY 500
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
    ENDIF
    DELAY 300

라인잡기_MAIN_2:
    ERX 4800,A,라인잡기_MAIN
    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        DELAY 300
        GOTO 라인잡기_MAIN

    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        DELAY 300
        GOTO 라인잡기_MAIN

    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        DELAY 300
        GOTO 라인잡기_MAIN

    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        DELAY 300
        GOTO 라인잡기_MAIN

    ELSEIF A=160 THEN
        GOSUB 전진종종걸음
        DELAY 300
        GOTO 라인잡기_MAIN_3
    ELSEIF A=170 THEN
        GOSUB 전진종종걸음
        DELAY 300
        GOTO 라인잡기_MAIN_3
    ELSEIF A=210 THEN
        GOSUB 전진종종걸음
        DELAY 300
        GOTO 라인잡기_MAIN_3

    ELSEIF A=26 THEN
        GOTO MAIN


    ELSE
        GOTO 라인잡기_MAIN


    ENDIF
    GOTO RX_EXIT

라인잡기_MAIN_3:

    ETX 4800,190
    DELAY 500
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
    ENDIF
    DELAY 300

라인잡기_MAIN_4:
    ERX 4800,A,라인잡기_MAIN_3
    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        DELAY 300
        GOTO 라인잡기_MAIN_3

    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        DELAY 300
        GOTO 라인잡기_MAIN_3

    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        DELAY 300
        GOTO 라인잡기_MAIN_3

    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        DELAY 300
        GOTO 라인잡기_MAIN_3

    ELSEIF A=160 THEN
        DELAY 300
        GOSUB 전진종종걸음
        GOTO 라인잡기_MAIN_3

    ELSEIF A=170 THEN
        GOTO 미션_2_START

    ELSEIF A=210 THEN
        GOTO 라인잡기_FINAL_0

    ELSEIF A=26 THEN
        GOTO MAIN


    ELSE
        GOTO 라인잡기_MAIN_3


    ENDIF
    GOTO RX_EXIT

라인잡기_FINAL_0:
    ETX 4800,190
    DELAY 500
    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
    ENDIF
    DELAY 300

라인잡기_FINAL:

    ERX 4800,A,라인잡기_FINAL_0
    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        DELAY 300
        GOTO 라인잡기_FINAL_0

    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        DELAY 300
        GOTO 라인잡기_FINAL_0

    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        DELAY 300
        GOTO 라인잡기_FINAL_0

    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        DELAY 300
        GOTO 라인잡기_FINAL_0

    ELSEIF A=210 THEN
        DELAY 300
        GOSUB 연속전진_한왼발
        GOTO 라인잡기_FINAL_0

    ELSEIF A=172 THEN
        GOTO FINAL

    ELSEIF A=26 THEN
        GOTO MAIN


    ELSE
        GOTO 라인잡기_FINAL_0


    ENDIF
    GOTO RX_EXIT







미션_2_START: '머리돌리기



    IF D=1 THEN
        SERVO 16,60
        SERVO 11,40
        DELAY 1500
    ELSEIF D=2 THEN
        SERVO 16,60
        SERVO 11,160
        DELAY 1500
    ENDIF

미션_2_START_1: '지역인식

    ETX 4800, 181
    ERX 4800,A,미션_2_START_1
    IF A=201 THEN
        REGION= 1 '안전지역
        PRINT "SOUND 61 !"
        DELAY 300
        SPEED 머리이동속도
        SERVO 16,100
        SERVO 11,100	
        SPEED 5
        GOSUB 기본자세
        GOTO 미션_2_START_2
    ELSEIF A=202 THEN
        REGION=2 '확진지역
        PRINT "SOUND 62 !"
        DELAY 300
        SPEED 머리이동속도
        SERVO 16,100
        SERVO 11,100	
        SPEED 5
        GOSUB 기본자세
        GOTO 미션_2_START_2
    ELSE
        GOTO 미션_2_START_1
    ENDIF

    GOTO RX_EXIT

미션_2_START_2:
    DELAY 500

    ETX 4800, 182

    ERX 4800,A,미션_2_START_2

    IF A=171 THEN '글자인식 완료시  돌기


        GOTO 미션_2_START_3

    ELSEIF A=26 THEN
        GOTO MAIN

    ELSE
        GOTO 미션_2_START_2

    ENDIF

미션_2_START_3:

    IF D=1 THEN
        GOSUB 왼쪽턴60
        DELAY 500
    ELSEIF D=2 THEN
        GOSUB 오른쪽턴60
        DELAY 500
    ENDIF
    GOTO 미션_2_FIND

CHECK_POSITION:
    ETX 4800,131
    DELAY 1500
    ERX 4800, A, CHECK_POSITION

    IF A=155 THEN
        POSITION=1 'LEFT
    ELSEIF A=156 THEN
        POSITION=2
    ELSE
        GOTO CHECK_POSITION
    ENDIF
    RETURN

미션_2_FIND:
    SPEED 머리이동속도
    SERVO 16,60
    SERVO 11,100	
    SPEED 5
    GOSUB 기본자세
    PACK_FIND=0
    DELAY 1500 'Delay Fix'


미션_2_FIND_1_1: '객체발견

    ETX 4800,160
    DELAY 2000 'Delay Fix'
    '미션_2_FIND_1_1:


    ERX 4800,A,미션_2_FIND_1_1

    IF A=203 THEN '객체미발견시 왼쪽확인
        SPEED 머리이동속도
        SERVO 11,50
        SPEED 5
        GOSUB 기본자세
        A=200

        GOTO 미션_2_FIND_2_1

    ELSEIF A=130 THEN '객체발견
        IF PACK_FIND=0 THEN
            TURN=0
            GOSUB CHECK_POSITION
        ENDIF

        SPEED 머리이동속도
        SERVO 16,60
        SERVO 11,100	
        SPEED 5
        GOSUB 기본자세
        보행COUNT=0
        GOTO 미션_2_MAIN

    ELSEIF A=26 THEN
        GOTO MAIN

    ELSE
        GOTO 미션_2_FIND_1_1

    ENDIF

    GOTO RX_EXIT

미션_2_FIND_2_1:

    ETX 4800,161
    DELAY 2000 'Delay Fix'
    '미션_2_FIND_2_1:
    ERX 4800,A,미션_2_FIND_2_1

    IF A=204 THEN '객체미발견시 오른쪽확인
        SPEED 머리이동속도
        SERVO 11,150
        SPEED 5
        GOSUB 기본자세
        DELAY 1000
        A=200
        GOTO 미션_2_FIND_3_1

    ELSEIF A=131 THEN '객체발견시
        IF PACK_FIND=0 THEN
            GOSUB 왼쪽턴45
            TURN=1
        ELSEIF PACK_FIND=1 THEN
            GOSUB 왼쪽옆으로70연속
            DELAY 500
            GOSUB 왼쪽옆으로70연속
            DELAY 500
        ENDIF

        SPEED 머리이동속도
        SERVO 16,60
        SERVO 11,100	
        SPEED 5
        GOSUB 기본자세
        PACK_FIND=1
        DELAY 1500 'Delay Fix'

        GOTO 미션_2_FIND_1_1

    ELSEIF A=26 THEN
        GOTO MAIN

    ELSE
        GOTO 미션_2_FIND_2_1

    ENDIF

    GOTO RX_EXIT

미션_2_FIND_3_1:


    ETX 4800,162
    DELAY 2000 'Delay Fix'
    ERX 4800,A,미션_2_FIND_3_1

    IF A=205 THEN '객체미발견시 중앙확인

        SPEED 머리이동속도
        SERVO 11,100
        SPEED 5
        GOSUB 기본자세
        A=200
        DELAY 1000
        GOTO 미션_2_FIND_1_1


    ELSEIF A=132 THEN '객체발견시
        IF PACK_FIND=0 THEN
            GOSUB 오른쪽턴45
            TURN=2
        ELSEIF PACK_FIND=1 THEN
            GOSUB 오른쪽옆으로70연속
            DELAY 500
            GOSUB 오른쪽옆으로70연속
            DELAY 500
        ENDIF
        SPEED 머리이동속도
        SERVO 16,60
        SERVO 11,100	
        SPEED 5
        GOSUB 기본자세
        PACK_FIND=1
        DELAY 1500 'Delay Fix'

        GOTO 미션_2_FIND_1_1

    ELSEIF A=26 THEN
        GOTO MAIN

    ELSE
        GOTO 미션_2_FIND_3_1

    ENDIF

    GOTO RX_EXIT



미션_2_MAIN: '객체추적
    ETX 4800,184
    DELAY 500
    ERX 4800,A,미션_2_MAIN
    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        'DELAY 500
        GOTO 미션_2_MAIN

    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        ' DELAY 500
        GOTO 미션_2_MAIN

    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        'DELAY 500
        GOTO 미션_2_MAIN

    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        'DELAY 500
        GOTO 미션_2_MAIN

    ELSEIF A=160 THEN
        'DELAY 500
        GOSUB 연속전진_한오른발
        보행COUNT=보행COUNT+1
        GOTO 미션_2_MAIN



    ELSEIF A=165 THEN
        'DELAY 500
        SPEED 3

        SERVO 16, 10
        DELAY 500
        GOTO 미션_2_MAIN    	

    ELSEIF A=125 THEN '객체위치고정시
    	DELAY 500
        GOTO 팩집기_1

    ELSEIF A=206 THEN '시야에 팩이 안들어왔을때
        GOSUB 연속후진_한발
        GOTO 미션_2_MAIN


    ELSEIF A=26 THEN
        GOTO MAIN

    ELSE
        GOTO 미션_2_MAIN


    ENDIF
    GOTO RX_EXIT



팩집기_1:
    ETX 4800, 101

    GOSUB 기본자세

    SPEED 3

    GOSUB All_motor_mode3



    MOVE G6A, 100, 140,  37, 143,  98, 100
    MOVE G6D, 100, 140,  37, 143, 98, 100
    MOVE G6B, 100,  100,  100, 100, 100, 100
    MOVE G6C, 100,  100,  100, 100, 40, 100
    WAIT



    MOVE G6A, 100, 166,  24, 145,  96, 100
    MOVE G6D, 100, 166,  24, 145,  96, 100
    MOVE G6B, 155,  15,  60, 100, 100, 100
    MOVE G6C, 155,  15,  60, 100, , 100
    WAIT

    MOVE G6A, 100, 166,  25, 125,  97, 100
    MOVE G6D, 100, 166,  22, 126,  95, 100
    MOVE G6B, 155,  15,  60, 100, 100, 101
    MOVE G6C, 155,  15,  60, 100, , 100
    WAIT



    MOVE G6A, 100,  76, 145,  93,  100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6B, 175,  10,  60, 100, 100, 100
    MOVE G6C, 175,  10,  60, 100,  , 100
    WAIT

    MOVE G6A, 100,  76, 145,  93,  100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    MOVE G6B, 140,  10,  60, 100, 100, 100
    MOVE G6C, 140,  10,  60, 100,  , 100
    WAIT

    DELAY 500


    IF REGION=1 THEN
        SERVO 16, 20
        DELAY 500
COUNT_CHECK:
        IF 보행COUNT<9 THEN
            GOSUB 연속전진_한오른발
            DELAY 500
            보행COUNT=보행COUNT+1
            IF 보행COUNT<9 THEN
                GOTO COUNT_CHECK
            ELSE
                IF TURN=2 THEN
                    GOSUB 왼쪽옆으로70연속
                    DELAY 200
                    GOSUB 왼쪽옆으로70연속
                    DELAY 200
                    GOSUB 왼쪽옆으로70연속
                    DELAY 200
                    GOSUB 왼쪽옆으로70연속
                    DELAY 200
                    GOSUB 왼쪽옆으로70연속
                    DELAY 200
                    GOTO 팩집기_2_안전
                ELSEIF TURN=1 THEN
                    GOSUB 오른쪽옆으로70연속
                    DELAY 200
                    GOSUB 오른쪽옆으로70연속
                    DELAY 200
                    GOSUB 오른쪽옆으로70연속
                    DELAY 200
                    GOSUB 오른쪽옆으로70연속
                    DELAY 200
                    GOSUB 오른쪽옆으로70연속
                    DELAY 200
                    GOTO 팩집기_2_안전
                ELSEIF TURN=0 THEN
                    GOTO 팩집기_2_안전
                ENDIF


            ENDIF
        ENDIF
    ELSEIF REGION=2 THEN

        IF TURN=1 THEN
            GOSUB 집고오른쪽턴45
            DELAY 500
        ELSEIF TURN=2 THEN
            GOSUB 집고왼쪽턴45
            DELAY 500
        ENDIF

        GOSUB 집고왼쪽턴60
        DELAY 500
        GOSUB 집고왼쪽턴60
        DELAY 500
        GOSUB 집고왼쪽턴60
        DELAY 500

        SERVO 16,60
        DELAY 1500
        TURN_COUNT=0
        GOTO 팩집기_2_확진_TEST
    ENDIF


팩집기_2_안전:

    ETX 4800,186
    DELAY 500
    ERX 4800,A,팩집기_2_안전

    IF A=160 THEN
        IF TURN=2 THEN
            GOSUB 왼쪽옆으로70연속
        ELSEIF TURN=1 THEN
            GOSUB 오른쪽옆으로70연속
        ELSEIF TURN=0 THEN
            IF POSITION=1 THEN 'LEFT
                GOSUB 오른쪽옆으로70연속
            ELSEIF POSITION=2 THEN 'RIGHT
                GOSUB 왼쪽옆으로70연속
            ENDIF
        ENDIF


        GOTO 팩집기_2_안전
    ELSEIF A=165 THEN

        GOSUB 팩놓기
        GOSUB 연속후진_TEST
        IF TURN=1 THEN
            GOSUB 오른쪽턴45
            DELAY 300
        ELSEIF TURN=2 THEN
            GOSUB 왼쪽턴45
            DELAY 300
        ENDIF
        GOSUB 왼쪽턴60
        DELAY 500
        GOSUB 왼쪽턴60
        DELAY 500
        GOSUB 왼쪽턴60
        DELAY 500
        SERVO 16,60
        DELAY 500
        GOTO 팩놓기_이후_안전


    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO 팩집기_2_안전

    ENDIF
    GOTO RX_EXIT

팩집기_2_확진_TEST:
    ETX 4800,191
    DELAY 500
    ERX 4800,A,팩집기_2_확진_TEST
    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        TURN_COUNT=TURN_COUNT+1
        'DELAY 500
        IF TURN_COUNT>=5 THEN
            GOTO 팩집기_2_확진_TEST_2
        ELSE
            GOTO 팩집기_2_확진_TEST
        ENDIF

    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        ' DELAY 500
        TURN_COUNT=TURN_COUNT+1
        'DELAY 500
        IF TURN_COUNT>=5 THEN
            GOTO 팩집기_2_확진_TEST_2
        ELSE
            GOTO 팩집기_2_확진_TEST
        ENDIF

    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        'DELAY 500
        TURN_COUNT=TURN_COUNT+1
        'DELAY 500
        IF TURN_COUNT>=5 THEN
            GOTO 팩집기_2_확진_TEST_2
        ELSE
            GOTO 팩집기_2_확진_TEST
        ENDIF

    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        'DELAY 500
        TURN_COUNT=TURN_COUNT+1
        'DELAY 500
        IF TURN_COUNT>=5 THEN
            GOTO 팩집기_2_확진_TEST_2
        ELSE
            GOTO 팩집기_2_확진_TEST
        ENDIF
    ELSEIF A=160 THEN
        GOSUB 연속전진_두오른발
        TURN_COUNT=TURN_COUNT+1
        'DELAY 500
        IF TURN_COUNT>=5 THEN
            GOTO 팩집기_2_확진_TEST_2
        ELSE
            GOTO 팩집기_2_확진_TEST
        ENDIF
    ELSEIF A=165 THEN
        GOTO 팩놓기_0

    ELSEIF A=169 THEN
        SERVO 16,50
        DELAY 2000
        GOTO 팩집기_2_확진_TEST_2
    ELSEIF A=173 THEN
        GOSUB 집고왼쪽턴20
        DELAY 3000
        GOTO 팩집기_2_확진_TEST
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO 팩집기_2_확진_TEST
    ENDIF


    GOTO RX_EXIT

팩집기_2_확진_TEST_2:
    ETX 4800,191
    DELAY 500
    ERX 4800,A,팩집기_2_확진_TEST_2
    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        'DELAY 500
        GOTO 팩집기_2_확진_TEST_2

    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        ' DELAY 500
        GOTO 팩집기_2_확진_TEST_2

    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        'DELAY 500
        GOTO 팩집기_2_확진_TEST_2
    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        'DELAY 500
        GOTO 팩집기_2_확진_TEST_2
    ELSEIF A=160 THEN
        GOSUB 연속전진_두오른발
        GOTO 팩집기_2_확진_TEST_2
    ELSEIF A=165 THEN
        GOSUB 팩놓기_0
        GOTO 팩집기_2_확진_TEST_2
    ELSEIF A=169 THEN
        SERVO 16,45
        DELAY 2000
        GOTO 팩집기_2_확진_TEST_2
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO 팩집기_2_확진_TEST_2
    ENDIF


    GOTO RX_EXIT


팩놓기_0:

    IF D=1 THEN
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 팩놓기
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200

    ELSEIF D=2 THEN

        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 왼쪽옆으로70연속
        DELAY 200
        GOSUB 팩놓기
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200
        GOSUB 오른쪽옆으로70연속
        DELAY 200

    ENDIF

    SERVO 16,20
    DELAY 500

    GOTO 팩놓기_이후



팩집기_2_확진:

    ETX 4800,185
    DELAY 500
    ERX 4800,A,팩집기_2_확진
    IF A=160 THEN
        GOTO 연속후진_0
    ELSEIF A=165 THEN
        GOTO 팩놓기
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO 팩집기_2_확진
    ENDIF


    GOTO RX_EXIT


팩놓기:
    SPEED 3

    MOVE G6A, 100, 140,  37, 143,  98, 100
    MOVE G6D, 100, 140,  37, 143, 98, 100
    MOVE G6B, 175,  10,  60, 100, 100, 100
    MOVE G6C, 175,  10,  60, 100,  100, 100
    WAIT



    MOVE G6A, 100, 166,  25, 125,  97, 100
    MOVE G6D, 100, 166,  22, 126,  95, 100

    WAIT


    MOVE G6B, 155,
    MOVE G6C, 155,
    WAIT

    MOVE G6B, ,  10,  100, 100, 100, 100
    MOVE G6C, ,  10,  100, 100,  100, 100
    WAIT



    MOVE G6A, 100,  76, 145,  93,  100, 100
    MOVE G6D, 100,  76, 145,  93, 100, 100
    WAIT

    GOSUB 기본자세

    RETURN

팩놓기_이후_안전:


    ETX 4800,191
    DELAY 500
    ERX 4800,A,팩놓기_이후_안전

    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        'DELAY 500
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO 팩놓기_이후_안전_2
        ELSE
            GOTO 팩놓기_이후_안전
        ENDIF


    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        ' DELAY 500
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO 팩놓기_이후_안전_2
        ELSE
            GOTO 팩놓기_이후_안전
        ENDIF

    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        'DELAY 500
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO 팩놓기_이후_안전_2
        ELSE
            GOTO 팩놓기_이후_안전
        ENDIF

    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        'DELAY 500
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO 팩놓기_이후_안전_2
        ELSE
            GOTO 팩놓기_이후_안전
        ENDIF
    ELSEIF A=160 THEN
        GOSUB 연속전진_두오른발
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO 팩놓기_이후_안전_2
        ELSE
            GOTO 팩놓기_이후_안전
        ENDIF
    ELSEIF A=165 THEN
        SERVO 16,30
        DELAY 2000
        GOTO 팩놓기_이후
    ELSEIF A=169 THEN
        SERVO 16,45
        DELAY 2000
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO 팩놓기_이후_안전_2
        ELSE
            GOTO 팩놓기_이후_안전
        ENDIF
    ELSEIF A=173 THEN
        GOSUB 집고왼쪽턴20
        DELAY 3000
        GOTO 팩놓기_이후_안전
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO 팩놓기_이후_안전
    ENDIF


팩놓기_이후_안전_2:

    ETX 4800,191
    DELAY 500
    ERX 4800,A,팩놓기_이후_안전

    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        'DELAY 500
        GOTO 팩놓기_이후_안전_2

    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        ' DELAY 500
        GOTO 팩놓기_이후_안전_2

    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        'DELAY 500
        GOTO 팩놓기_이후_안전_2

    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        'DELAY 500
        GOTO 팩놓기_이후_안전_2
    ELSEIF A=160 THEN
        GOSUB 연속전진_두오른발
        GOTO 팩놓기_이후_안전_2
    ELSEIF A=165 THEN
        SERVO 16,30
        DELAY 2000
        GOTO 팩놓기_이후
    ELSEIF A=169 THEN
        SERVO 16,45
        DELAY 2000
        GOTO 팩놓기_이후_안전_2
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO 팩놓기_이후_안전_2
    ENDIF


팩놓기_이후:

    ETX 4800,195
    DELAY 500
    ERX 4800,A,팩놓기_이후
    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        'DELAY 500
        GOTO 팩놓기_이후

    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        ' DELAY 500
        GOTO 팩놓기_이후

    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        'DELAY 500
        GOTO 팩놓기_이후

    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        'DELAY 500
        GOTO 팩놓기_이후
    ELSEIF A=160 THEN
        GOSUB 연속전진_두오른발
        GOTO 팩놓기_이후

    ELSEIF A=165 THEN


        IF D=1 THEN
            GOTO LINE_CHECK_LEFT_0
        ELSEIF D=2 THEN
            GOTO LINE_CHECK_RIGHT_0
        ENDIF
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO 팩놓기_이후
    ENDIF
LINE_CHECK_LEFT_0:
    SERVO 16,30
    DELAY 3000

LINE_CHECK_LEFT:
    ETX 4800,192
    DELAY 500
    ERX 4800,A,LINE_CHECK_LEFT
    IF A=169 THEN '한쪽만있을때
        GOTO ONE_LINE_LEFT
    ELSEIF A=159 THEN '선이 2개있을 때
        GOSUB 왼쪽턴3
        DELAY 300
        GOTO LINE_CHECK_LEFT
    ELSEIF A=179 THEN '좌우 모두 없을때
        GOSUB 왼쪽턴45
        DELAY 300
        GOTO LINE_CHECK_LEFT
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO LINE_CHECK_LEFT
    ENDIF

    GOTO RX_EXIT

ONE_LINE_LEFT:
    SERVO 11,10
    SERVO 16,50
    DELAY 3000
    ETX 4800,193
    DELAY 500
    ERX 4800,A,ONE_LINE_LEFT
    IF A=157 THEN '왼쪽에 선없음
        SERVO 11,100
        SERVO 16,30
        GOTO 라인잡기_MAIN
    ELSEIF A=158 THEN '왼쪽에 선있음
        GOSUB 왼쪽턴45
        SERVO 11, 100
        SERVO 16,30
        DELAY 3000
        GOTO LINE_CHECK_LEFT
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO ONE_LINE_LEFT

    ENDIF

LINE_CHECK_RIGHT_0:
    SERVO 16,30
    DELAY 3000

LINE_CHECK_RIGHT:

    ETX 4800,192
    DELAY 500
    ERX 4800,A,LINE_CHECK_RIGHT
    IF A=169 THEN '한쪽만있을때
        GOTO ONE_LINE_RIGHT
    ELSEIF A=159 THEN '선이 2개있을 때
        GOSUB 오른쪽턴3
        DELAY 300
        GOTO LINE_CHECK_RIGHT
    ELSEIF A=179 THEN '좌우 모두 없을때
        GOSUB 오른쪽턴45
        DELAY 300
        GOTO LINE_CHECK_RIGHT
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO LINE_CHECK_RIGHT
    ENDIF

    GOTO RX_EXIT

ONE_LINE_RIGHT:
    SERVO 11,170
    SERVO 16,50
    DELAY 3000
    ETX 4800,193
    DELAY 500
    ERX 4800,A,ONE_LINE_RIGHT
    IF A=157 THEN '오른쪽에 선없음
        SERVO 11,100
        SERVO 16,30
        GOTO 라인잡기_MAIN
    ELSEIF A=158 THEN '오른쪽에 선있음
        GOSUB 오른쪽턴45
        SERVO 11, 100
        SERVO 16,30
        DELAY 3000
        GOTO LINE_CHECK_RIGHT
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO ONE_LINE_RIGHT

    ENDIF


왼쪽턴3_키:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴3_LOOP_키:

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


    GOTO RX_EXIT


왼쪽옆으로20_키: '****
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

한발앞으로가기:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON

    IF 보행순서=1 THEN

        보행순서= 0
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100,,,,
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

        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  30,  80,
        MOVE G6C,100,  30,  80
        WAIT

        HIGHSPEED SETOFF

    ELSE

        보행순서= 1
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6C,100
        MOVE G6B,100,,,,
        WAIT

        MOVE G6D,95,  90, 125, 100, 104
        MOVE G6A,104,  77, 147,  93,  102
        MOVE G6C, 85
        MOVE G6B,115
        WAIT


        MOVE G6D,103,   73, 140, 103,  100
        MOVE G6A, 95,  85, 147,  85, 102
        WAIT

        MOVE G6A,95,  95, 120, 100, 104
        MOVE G6D,104,  77, 147,  93,  102
        MOVE G6B, 85
        MOVE G6C,115
        WAIT

        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        MOVE G6A,100,  76, 145,  93, 100, 100
        MOVE G6D,100,  76, 145,  93, 100, 100
        MOVE G6B,100,  30,  80,
        MOVE G6C,100,  30,  80
        WAIT
        HIGHSPEED SETOFF
    ENDIF

    GOTO RX_EXIT


    '*****************************************************

FINAL:
    GOSUB 새문열기_TEST
    SERVO 16,30
    GOTO FINAL_0_BEFORE
    'IF D = 1 THEN
    '        GOSUB 연속전진_한오른발
    '        DELAY 300
    '        GOSUB 왼쪽턴45
    '        DELAY 500
    '        GOSUB 왼쪽턴60
    '        GOTO FINAL_2
    '    ELSEIF D = 2 THEN
    '        GOSUB 연속전진_한왼발
    '        DELAY 300
    '        GOSUB 오른쪽턴45
    '        DELAY 500
    '        GOSUB 오른쪽턴60
    '        GOTO FINAL_2
    '    ENDIF
    '
    '
    'FINAL_2:
    '    ETX 4800, 190
    '    DELAY 500
    '    ERX 4800, A, FINAL_2
    '
    '    IF A=163 THEN
    '        GOSUB 왼쪽옆으로20
    '        DELAY 500
    '        GOTO FINAL_2
    '
    '    ELSEIF A=164 THEN
    '        GOSUB 오른쪽옆으로20
    '        DELAY 500
    '        GOTO FINAL_2
    '
    '    ELSEIF A=161 THEN
    '        GOSUB 왼쪽턴3
    '        DELAY 500
    '        GOTO FINAL_2
    '
    '    ELSEIF A=162 THEN
    '        GOSUB 오른쪽턴3
    '        DELAY 500
    '        GOTO FINAL_2
    '
    '    ELSEIF A=160 THEN
    '        DELAY 500
    '        GOSUB 연속전진_두오른발
    '        GOSUB 연속전진_두왼발
    '        GOSUB 새문열기_TEST
    '        DELAY 500
    '        GOTO FINAL_0_BEFORE
    '
    '    ELSEIF A=26 THEN
    '        GOTO MAIN
    '
    '
    '    ELSE
    '        GOTO FINAL_2
    '
    '
    '    ENDIF
    '    GOTO RX_EXIT


FINAL_0_BEFORE:
    ETX 4800, 190
    DELAY 500
    ERX 4800, A, FINAL_0_BEFORE

    IF A=163 THEN
        GOSUB 왼쪽옆으로20
        DELAY 500
        GOTO FINAL_0_BEFORE

    ELSEIF A=164 THEN
        GOSUB 오른쪽옆으로20
        DELAY 500
        GOTO FINAL_0_BEFORE


    ELSEIF A=161 THEN
        GOSUB 왼쪽턴3
        DELAY 500
        GOTO FINAL_0_BEFORE

    ELSEIF A=162 THEN
        GOSUB 오른쪽턴3
        DELAY 500
        GOTO FINAL_0_BEFORE

    ELSEIF A=160 THEN
        GOSUB 연속전진_두오른발
        FINAL_COUNT= FINAL_COUNT+1
        IF FINAL_COUNT>=3 THEN
            GOTO FINAL_0_TEST
        ENDIF

        GOTO FINAL_0_BEFORE

    ELSEIF A=26 THEN
        GOTO MAIN


    ELSE
        GOTO FINAL_0_BEFORE


    ENDIF
    GOTO RX_EXIT




FINAL_0_TEST:
    ETX 4800, 130
FINAL_0_TEST_2:

	DELAY 800
    ERX 4800, A, FINAL_0_TEST_2
    IF A=150 THEN
        PRINT "VOLUME 200 !"
        PRINT "SOUND 63 !"
        A=200
        ETX 4800,130
        GOTO FINAL_0_TEST_2
    ELSEIF A=151 THEN
        PRINT "VOLUME 200 !"
        PRINT "SOUND 64 !"
        A=200
        ETX 4800,130
        GOTO FINAL_0_TEST_2
    ELSEIF A=152 THEN
        PRINT "VOLUME 200 !"
        PRINT "SOUND 65 !"
        A=200
        ETX 4800,130
        GOTO FINAL_0_TEST_2
    ELSEIF A=153 THEN
        PRINT "VOLUME 200 !"
        PRINT "SOUND 66 !"
        A=200
        ETX 4800,130
        GOTO FINAL_0_TEST_2
    ELSEIF A=154 THEN
        MUSIC "gfedc"
    ELSE
        GOTO FINAL_0_TEST_2
    ENDIF

    GOTO RX_EXIT

FINAL_0_TEST_KEY:
    ETX 4800, 130
FINAL_0_TEST_2_KEY:

	DELAY 800
    ERX 4800, A, FINAL_0_TEST_2_KEY
    IF A=150 THEN
        PRINT "VOLUME 200 !"
        PRINT "SOUND 63 !"
        A=200
        ETX 4800,130
        GOTO FINAL_0_TEST_2_KEY
    ELSEIF A=151 THEN
        PRINT "VOLUME 200 !"
        PRINT "SOUND 64 !"
        A=200
        ETX 4800,130
        GOTO FINAL_0_TEST_2_KEY
    ELSEIF A=152 THEN
        PRINT "VOLUME 200 !"
        PRINT "SOUND 65 !"
        A=200
        ETX 4800,130
        GOTO FINAL_0_TEST_2_KEY
    ELSEIF A=153 THEN
        PRINT "VOLUME 200 !"
        PRINT "SOUND 66 !"
        A=200
        ETX 4800,130
        GOTO FINAL_0_TEST_2_KEY
    ELSEIF A=154 THEN
        MUSIC "gfedc"
    ELSE
        GOTO FINAL_0_TEST_2_KEY
    ENDIF

    RETURN


    '******************************************	
MAIN: '라벨설정


    ETX 4800, 38 ' 동작 멈춤 확인 송신 값

MAIN_2:

    'GOSUB 앞뒤기울기측정
    'GOSUB 좌우기울기측정
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
    ETX  4800,1
    GOTO 미션_1_0
    'SPEED 3
    '    Q=10
    '    SERVO 16, Q




    GOTO RX_EXIT
    '***************	
KEY2:
    ETX  4800,2
    GOSUB FINAL_0_TEST_KEY

    '    SPEED 3
    '    Q=20
    '    SERVO 16, Q

    '보행횟수 = 6
    'GOTO 횟수_전진종종걸음


    GOTO RX_EXIT
    '***************
KEY3:
    ETX  4800,3
    'SPEED 3
    '    Q=30
    '    SERVO 16, Q
    D=1

    GOTO 미션_2_START

    GOTO RX_EXIT
    '***************
KEY4:
    ETX  4800,4
    GOSUB 연속전진_한왼발
    'SPEED 3
    '    Q=40
    '    SERVO 16, Q
    '    'GOSUB 미션_2_FIND
    '
    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5
    GOSUB 연속전진_한오른발
    'SPEED 3
    '    Q=50
    '    SERVO 16, Q
    '
    '    ' J = AD(적외선AD포트)	'적외선거리값 읽기
    '    '    BUTTON_NO = J
    '    '    GOSUB Number_Play
    '    '    GOSUB SOUND_PLAY_CHK
    '    '    GOSUB GOSUB_RX_EXIT
    '    '
    GOTO RX_EXIT
    '***************
KEY6:
    ETX  4800,6
    GOSUB 연속전진_두왼발
    'SPEED 3
    '    Q=60
    '    SERVO 16, Q
    '    'GOTO 오른쪽턴3
    '
    '
    GOTO RX_EXIT
    '***************
KEY7:
    ETX  4800,7
    GOSUB 연속전진_두오른발
    'SPEED 3
    '    Q=70
    '    SERVO 16, Q
    '    ' GOTO 방향설정
    '


    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOSUB 왼쪽턴60
    'SPEED 3
    '    Q=80
    '    SERVO 16, Q
    '    'GOTO 전진종종걸음

    GOTO RX_EXIT
    '***************
KEY9:
    ETX  4800,9
    GOSUB 오른쪽턴60
    'SPEED 3
    '    Q=90
    '    SERVO 16, Q
    '    'GOTO 오른쪽턴20


    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10
    GOSUB 집고왼쪽턴20
    'SPEED 3
    '    Q=100
    '    SERVO 16, Q
    '    'GOTO 팩놓기


    GOTO RX_EXIT
    '***************
KEY11: ' ▲
    ETX  4800,11
    GOSUB 집고오른쪽턴20
    '보행순서=0
    '
    '    GOSUB 연속전진_TEST

    GOTO RX_EXIT
    '***************
KEY12: ' ▼
    ETX  4800,12


    GOTO 연속후진




    GOTO RX_EXIT
    '***************
KEY13: '▶
    ETX  4800,13
    'GOTO 머리상하정면


    GOTO RX_EXIT
    '***************
KEY14: ' ◀
    ETX  4800,14
    GOTO 팩집기_1
    'GOTO 팩



    GOTO RX_EXIT
    '***************
KEY15: ' A
    ETX  4800,15
    ' GOTO 왼쪽옆으로20_키
    GOSUB 연속전진_한오른발


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

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


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

    '**** RX DATA Number Sound ********
    BUTTON_NO = A
    GOSUB Number_Play
    GOSUB SOUND_PLAY_CHK


    IF  A = 16 THEN 	'다시 파워버튼을 눌러야만 복귀
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

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
    ETX  4800,17
    'GOTO 머리왼쪽90도

    GOTO 미션_2_START


    GOTO RX_EXIT
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
    GOTO FINAL_0_TEST

    GOTO RX_EXIT
    '***************
KEY20: ' B	
    ETX  4800,20
    GOTO 오른쪽옆으로20


    GOTO RX_EXIT
    '***************
KEY21: ' △
    ETX  4800,21
    GOTO 머리좌우중앙

    GOTO RX_EXIT
    '***************
KEY22: ' *	
    ETX  4800,22
    GOTO 왼쪽턴45

    GOTO RX_EXIT
    '***************
KEY23: ' G
    ETX  4800,23
    GOSUB 에러음
    GOSUB All_motor_mode2
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
    GOSUB 전진종종걸음

    GOTO RX_EXIT
    '***************
KEY25: ' P1
    ETX  4800,25
    GOTO 왼쪽턴60

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
    GOTO 라인잡기_MAIN


    GOTO RX_EXIT
    '***************
KEY28: ' ◁
    ETX  4800,28
    GOTO 머리왼쪽45도


    GOTO RX_EXIT
    '***************
KEY29: ' □
    ETX  4800,29

    GOSUB 전방하향80도

    GOTO RX_EXIT
    '***************
KEY30: ' ▷
    ETX  4800,30
    GOTO 머리오른쪽45도

    GOTO RX_EXIT
    '***************
KEY31: ' ▽
    ETX  4800,31
    GOSUB 머리최대하향


    GOTO RX_EXIT
    '***************

KEY32: ' F
    ETX  4800,32
    'GOTO 머리추가하향
    GOSUB 연속후진_한발
    GOTO RX_EXIT
    '***************
