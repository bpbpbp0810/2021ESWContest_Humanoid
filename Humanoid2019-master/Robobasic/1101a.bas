'******** 2족 보행로봇 초기 영점 프로그램 ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM ff  AS BYTE
DIM gg  AS BYTE
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
DIM 장애물좌우 AS INTEGER
DIM 장애물YG AS INTEGER
DIM 장애물YG_2 AS INTEGER
DIM 시야확인 AS BYTE
DIM 장애물다시 AS BYTE
DIM 곡선방향 AS BYTE
DIM 장애물개수 AS BYTE
DIM 넘어진확인 AS BYTE
DIM 기울기확인횟수 AS BYTE
DIM 코너횟수 AS BYTE
DIM 코너걸음 AS BYTE
DIM 보행횟수 AS BYTE
DIM 장애물확인 AS BYTE
DIM 터널확인 AS BYTE
DIM 셔터확인 AS BYTE
DIM 장애물유무 AS BYTE
DIM 미션수행 AS BYTE
DIM 보행COUNT AS BYTE
DIM 보행COUNT_G AS BYTE
DIM 보행횟수_G AS BYTE

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



GOSUB 전원초기자세
GOSUB 기본자세


GOSUB 자이로INIT
GOSUB 자이로MIN
GOSUB 자이로ON



PRINT "VOLUME 200 !"
PRINT "SOUND 12 !" '안녕하세요

GOSUB All_motor_mode3



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
    SERVO 16, 28
    RETURN
    '******************************************	
기본자세2:  '고개 내린것
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    'servo 16, 28
    mode = 0
    RETURN
    '******************************************
기본자세3:  '고개 올린것
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    'SERVO 16, 38
    mode = 0
    RETURN	
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


    '******************************************
    '**********************************************
    '**********************************************
RX_EXIT:

    ERX 4800, A, 진행코드

    GOTO RX_EXIT
    '**********************************************
GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************
    '**********************************************



'********************************************************************
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
'********************************************************************

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


    ETX 4800, 111
    DELAY 500
    ERX 4800, A, 전진종종걸음_4


    IF A < 108 THEN
        GOTO 전진종종걸음_2_stop

    ELSEIF A > 148 THEN
        GOTO 전진종종걸음_2_stop

    ENDIF

    ETX 4800, 112
    DELAY 500
    ERX 4800, A, 전진종종걸음_4


    IF A < 108 THEN
        GOTO 전진종종걸음_2_stop

    ELSEIF A > 138 THEN
        GOTO 전진종종걸음_2_stop

    ENDIF
    GOTO 전진종종걸음_4

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
    GOSUB 보정종합

    'DELAY 400
    '        GOTO RX_EXIT
    '    ENDIF

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

    ETX 4800, 111
    DELAY 500
    ERX 4800, A, 전진종종걸음_1


    IF A < 108 THEN
        GOTO 전진종종걸음_5_stop

    ELSEIF A > 148 THEN
        GOTO 전진종종걸음_5_stop

    ENDIF

    ETX 4800, 112
    DELAY 500
    ERX 4800, A, 전진종종걸음_1


    IF A < 108 THEN
        GOTO 전진종종걸음_5_stop

    ELSEIF A > 138 THEN
        GOTO 전진종종걸음_5_stop

    ENDIF
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
    GOSUB 보정종합

    'DELAY 400
    GOTO RX_EXIT

    '*************************************

    '*********************************

    GOTO 전진종종걸음_1
'************************************************************

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

'************************************************************

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
'************************************************************

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

'************************************************************

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

    GOTO RX_EXIT


'************************************************************

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


    GOTO RX_EXIT

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

    GOTO RX_EXIT

    '******************************************************
    '**********************************************
왼쪽턴10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    
    
    SPEED 8
    MOVE G6D,97,  66, 145,  108, 103, 100
    MOVE G6A,97,  86, 145,  88, 103, 100
    WAIT

    SPEED 12
    MOVE G6D,94,  66, 145,  108, 101, 100
    MOVE G6A,94,  86, 145,  88, 101, 100
    WAIT
    SPEED 6
    MOVE G6D,101,  76, 146,  93, 98, 100
    MOVE G6A,101,  76, 146,  93, 98, 100
    WAIT

    
    GOSUB 기본자세2
    RETURN
    '**********************************************
오른쪽턴10:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    
    SPEED 8
    MOVE G6A,97,  66, 145,  108, 103, 100
    MOVE G6D,97,  86, 145,  88, 103, 100
    WAIT

    SPEED 12
    MOVE G6A,94,  66, 145,  108, 101, 100
    MOVE G6D,94,  86, 145,  88, 101, 100
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

    GOTO RX_EXIT
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

    GOTO RX_EXIT
    '**********************************************

    '**********************************************	


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
    GOTO RX_EXIT

    '**********************************************
왼쪽턴45_G1:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴45_LOOP_G1:

    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
    DELAY 50
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

    '*******************************************************8
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
    GOTO RX_EXIT
    '**********************************************
왼쪽턴60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
왼쪽턴60_LOOP:

    SPEED 15
    MOVE G6A,  95, 116, 145,  58, 105,
    MOVE G6D,  95,  36, 145, 138, 105,
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
    DELAY 50
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

    GOTO RX_EXIT
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

    '**************************************************
기울기앞:
    A = AD(앞뒤기울기AD포트)
    'IF A < MIN THEN GOSUB 앞으로일어나기
    IF A < MIN THEN
        'ETX  4800,16
        GOSUB 뒤로일어나기

    ENDIF
    RETURN

기울기뒤:
    A = AD(앞뒤기울기AD포트)
    'IF A > MAX THEN GOSUB 뒤로일어나기
    IF A > MAX THEN
        'ETX  4800,15
        GOSUB 앞으로일어나기
    ENDIF
    RETURN
    '**************************************************

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


'**********************************************************	
MAIN: '라벨설정

    ETX 4800, 38 ' 동작 멈춤 확인 송신 값

MAIN_2:

    ZERO G6A, 99, 100, 100, 104, 101, 100
	ZERO G6B,102, 104, 102, 100, 100, 104
	ZERO G6C, 98, 103,  98, 100, 100, 100
	ZERO G6D, 97, 100, 100, 101, 103, 100

    
    SERVO 16, 28
    '''SERVO 11, 104
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
    ETX  4800,1
    보행횟수 = 3
    미션수행 = 0
    GOTO 진행코드

    GOTO MAIN
    '***************	
KEY2:
    ETX  4800,2
    보행횟수 = 3
    미션수행 = 1
    GOTO 진행코드_2
    '보행횟수 = 6

    GOTO MAIN
    '***************
KEY3:
    ETX  4800,3
    보행횟수 = 3
    미션수행 = 2
    GOTO 진행코드_3

    GOTO MAIN
    '***************
KEY4:
    ETX  4800,4
    보행횟수 = 3
    미션수행 = 3
    GOTO 진행코드_4

    GOTO MAIN
    '***************
KEY5:
    ETX  4800,5
    보행횟수 = 3
    미션수행 = 4
    GOTO 진행코드_5

    GOTO MAIN
    '***************
머리내리기18:
    SERVO 16, 18
    RETURN
KEY6:
    ETX  4800,6
    GOSUB 머리내리기18


    GOTO MAIN
    '***************
KEY7:
    ETX  4800,7
    GOTO 왼쪽턴20

    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOTO 전진종종걸음

    GOTO RX_EXIT
    '***************
KEY9:
    ETX  4800,9
    GOTO 오른쪽턴20


    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10

    GOTO RX_EXIT
    '***************
KEY11: ' ▲
    ETX  4800,11


    GOTO RX_EXIT
    '***************
KEY12: ' ▼
    ETX  4800,12

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
    ETX  4800,17
    GOTO 머리왼쪽90도


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
    GOTO 오른쪽턴60

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
    GOTO 왼쪽턴10

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
    GOTO 오른쪽턴10

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
    GOTO 머리오른쪽90도


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
    GOSUB 전방하향60도

    GOTO RX_EXIT
    '***************

KEY32: ' F
    ETX  4800,32
    GOTO 후진종종걸음
    GOTO RX_EXIT
    '***************
    
코너돌기:

    FOR i=0 TO 코너횟수

        GOSUB 한발앞으로가기1
        GOSUB L한발앞으로가기1
    
    NEXT

    GOSUB 왼쪽턴60
    GOSUB 왼쪽턴60
    'GOSUB 왼쪽턴45_G1
    GOSUB 한발앞으로가기1
    GOSUB L한발앞으로가기1
    미션수행 = 미션수행 + 1
    ETX 4800, 150
    DELAY 20
    ETX 4800, 150
    DELAY 20
    ETX 4800, 150
    DELAY 20
    ETX 4800, 150
    RETURN

양발한번앞으로가기1:
    GOSUB All_motor_mode3
    SPEED 6
    HIGHSPEED SETON

    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT


    MOVE G6D, 104,  77, 147,  93, 102,
    MOVE G6A,  95,  90, 135,  90, 104,
    MOVE G6C, 115,  30,  80,  ,  ,
    MOVE G6B,  85,  30,  80,  ,  ,
    WAIT

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    MOVE G6A, 104,  77, 147,  93, 102,
    MOVE G6D,  95,  90, 135,  90, 104,
    MOVE G6B, 115,  30,  80,  ,  ,
    MOVE G6C,  85,  30,  80,  ,  ,
    WAIT

    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세3
    RETURN
    
양발한번앞으로가기2:
    GOSUB All_motor_mode3
    SPEED 6
    HIGHSPEED SETON

    MOVE G6D,95,  76, 147,  93, 101
    MOVE G6A,101,  76, 147,  93, 98
    MOVE G6C,100
    MOVE G6B,100
    WAIT

    MOVE G6A, 104,  77, 147,  93, 102,
    MOVE G6D,  95,  90, 135,  90, 104,
    MOVE G6B, 115,  30,  80,  ,  ,
    MOVE G6C,  85,  30,  80,  ,  ,
    WAIT

    MOVE G6D,103,   73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT

    MOVE G6D, 104,  77, 147,  93, 102,
    MOVE G6A,  95,  90, 135,  90, 104,
    MOVE G6C, 115,  30,  80,  ,  ,
    MOVE G6B,  85,  30,  80,  ,  ,
    WAIT

    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세3
    RETURN

한발앞으로가기1:
    GOSUB All_motor_mode3
    SPEED 6
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

    'MOVE G6A,95,  90, 125, 95, 104
    'MOVE G6D,104,  76, 145,  91,  102
    'MOVE G6B, 100
    'MOVE G6C,100
    'WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세3
    RETURN

L한발앞으로가기1:
    GOSUB All_motor_mode3
    SPEED 6
    HIGHSPEED SETON


    MOVE G6D,95,  76, 147,  93, 101
    MOVE G6A,101,  76, 147,  93, 98
    MOVE G6C,100
    MOVE G6B,100
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

    'MOVE G6D,95,  90, 125, 95, 104
    'MOVE G6A,104,  76, 145,  91,  102
    'MOVE G6C, 100
    'MOVE G6B,100
    'WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세3
    RETURN

한발앞으로가기2:
    GOSUB All_motor_mode3
    SPEED 6
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

    'MOVE G6A,95,  90, 125, 95, 104
    'MOVE G6D,104,  76, 145,  91,  102
    'MOVE G6B, 100
    'MOVE G6C,100
    'WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세2
    RETURN

L한발앞으로가기2:
    GOSUB All_motor_mode3
    SPEED 6
    HIGHSPEED SETON


    MOVE G6D,95,  76, 147,  93, 101
    MOVE G6A,101,  76, 147,  93, 98
    MOVE G6C,100
    MOVE G6B,100
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

    'MOVE G6D,95,  90, 125, 95, 104
    'MOVE G6A,104,  76, 145,  91,  102
    'MOVE G6C, 100
    'MOVE G6B,100
    'WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB 안정화자세
    SPEED 5
    GOSUB 기본자세2
    RETURN
'**************************************************************
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
    '***************************************************
한발뒤로가기1:
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
    GOSUB 기본자세3

    RETURN
    '******************************************

한발뒤로가기2:
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

m왼쪽턴20:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  96, 145,  85, 105, 100
    MOVE G6D,95,  56, 145,  125, 105, 100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    SPEED 12
    MOVE G6A,93,  96, 145,  85, 105, 100
    MOVE G6D,93,  56, 145,  125, 105, 100
    WAIT
    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세2
    RETURN

m오른쪽턴20:
    

    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
    SPEED 8
    MOVE G6A,95,  56, 145,  125, 105, 100
    MOVE G6D,95,  96, 145,  85, 105, 100
    MOVE G6B,90
    MOVE G6C,110
    WAIT

    SPEED 12
    MOVE G6A,93,  56, 145,  125, 105, 100
    MOVE G6D,93,  96, 145,  85, 105, 100
    WAIT

    SPEED 6
    MOVE G6A,101,  76, 146,  93, 98, 100
    MOVE G6D,101,  76, 146,  93, 98, 100

    WAIT

    GOSUB 기본자세2
    RETURN
'*********************************************************

m오른쪽옆으로10: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 4
    MOVE G6D, 88,  71, 152,  91, 110
    MOVE G6A,103,  77, 146,  93,  93
    MOVE G6B,100,40
    MOVE G6C,100,40
    WAIT

    SPEED 4
    MOVE G6A, 113,  78, 146,  93,  94,
    MOVE G6D,  90,  85, 125, 100, 114,
    WAIT


    SPEED 4
    MOVE G6D,95,  76, 145,  93, 102, 100
    MOVE G6A,95,  76, 145,  93, 102, 100
    WAIT


    SPEED 8
    GOSUB 기본자세2
    DELAY 200
    GOSUB ALL_motor_mode3
    RETURN

m왼쪽옆으로10: '****
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

    SPEED 4
    MOVE G6A,  88,  71, 152,  91, 110,
    MOVE G6D, 103,  77, 146,  93,  93,
    MOVE G6B, 100,  40,  80,  ,  ,
    MOVE G6C, 100,  40,  80,  ,  ,
    WAIT

    SPEED 4
    MOVE G6D, 116,  78, 146,  93,  91,
    MOVE G6A,  90,  85, 120, 105, 114,
    WAIT

    SPEED 4
    MOVE G6A,95,  76, 145,  93, 102, 100
    MOVE G6D,95,  76, 145,  93, 102, 100
    WAIT

    SPEED 8
    GOSUB 기본자세2
    DELAY 200
    GOSUB ALL_motor_mode3
    RETURN
    '**********************************************
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

m왼쪽옆으로70:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
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

    GOSUB 기본자세2

    RETURN


m오른쪽옆으로70:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
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
    GOSUB 기본자세2

    RETURN
'**********************************************

기울기보정:
    SERVO 16, 28
    넘어진확인 = 0
    ETX 4800, 111
    GOSUB All_motor_mode3
aaaaa:    
    ff = 0
    코너횟수 = 0
    A = 0
aaaa:
    ff = ff + 1
    IF ff > 10 THEN GOTO 기울기보정
    DELAY 1
    ERX 4800, A , aaaa

    IF A >= 138  AND A <= 158 THEN
        GOSUB 왼쪽턴10
    ELSEIF A <= 118 AND A >=98 THEN  '
        GOSUB 오른쪽턴10
    ELSEIF A > 158 AND A < 253 THEN
        GOSUB m왼쪽턴20
    ELSEIF 0 < A AND A < 98 THEN
        GOSUB m오른쪽턴20
    ELSEIF A = 253 THEN    '두발짝 가고 돌기
        'GOSUB 미션끝내고보정
        코너걸음 = 1
        RETURN
    ELSEIF A = 254 THEN    '두발짝 가고 돌기
        코너횟수 = 3
        GOSUB 코너돌기
        GOSUB 미션끝내고보정
        RETURN
    ELSEIF A = 255 THEN   '바로돌기
        코너횟수 = 2
        GOSUB 코너돌기
        GOSUB 미션끝내고보정
        RETURN
    ELSEIF A > 118 AND A < 138  THEN
        DELAY 50
        RETURN
    
 
    ENDIF
    DELAY 50
    GOTO aaaaa


기울기보정1:
    SERVO 16, 28
    넘어진확인 = 0
    ETX 4800, 111
    GOSUB All_motor_mode3
a11:    
    ff = 0
    코너횟수 = 0
    A = 0
a111:
    ff = ff + 1
    IF ff > 10 THEN GOTO 기울기보정1
    DELAY 1
    ERX 4800, A , a111

    IF A >= 138  AND A <= 158 THEN
        GOSUB 왼쪽턴10
    ELSEIF A <= 118 AND A >=98 THEN  '
        GOSUB 오른쪽턴10
    ELSEIF A > 158 AND A < 253 THEN
        GOSUB m왼쪽턴20
    ELSEIF 0 < A AND A < 98 THEN
        GOSUB m오른쪽턴20
    ELSEIF A > 118 AND A < 138  THEN
        DELAY 50
        RETURN
    ELSEIF A = 255 OR A = 254 THEN
        MUSIC "E"
    ELSE
        GOSUB 한발뒤로가기
        GOSUB 한발뒤로가기
 
    ENDIF
    DELAY 50
    GOTO 기울기보정1

기울기보정코너지남:
    SERVO 16, 28
    넘어진확인 = 0
    ETX 4800, 111
    GOSUB All_motor_mode3
    ff = 0
    A = 0
accc:
    ff = ff + 1
    IF ff > 10 THEN GOTO 기울기보정코너지남
    DELAY 1
    ERX 4800, A , accc

    IF A >= 138  AND A <= 158 THEN
        GOSUB 왼쪽턴10
    ELSEIF A <= 118 AND A >=98 THEN 
        GOSUB 오른쪽턴10
    ELSEIF A > 158 AND A < 255 THEN
        GOSUB m왼쪽턴20
    ELSEIF A>0 AND A < 98 THEN
        GOSUB m오른쪽턴20
    ELSEIF A > 118 AND A < 138  THEN
        DELAY 50
        RETURN
    ELSE 
        GOSUB 미션끝내고보정
    ENDIF
    DELAY 50
    GOTO 기울기보정코너지남
    
기울기보정_G1:
    SERVO 16, 28
    DELAY 100
    넘어진확인 = 0
    ETX 4800, 111
    GOSUB All_motor_mode3
    ff = 0
    A = 0
abcd:
    ff = ff + 1
    IF ff > 10 THEN GOTO 기울기보정_G1
    DELAY 1
    ERX 4800, A , abcd

    IF A >= 138  AND A <= 158 THEN
        GOSUB 왼쪽턴10
    ELSEIF A <= 118 AND A >=98 THEN  '
        GOSUB 오른쪽턴10
    ELSEIF A > 158 AND A < 255 THEN
        GOSUB m왼쪽턴20
    ELSEIF A < 98 THEN
        GOSUB m오른쪽턴20
    ELSEIF A > 118 AND A < 138  THEN
        DELAY 50
        RETURN
    ENDIF
    SERVO 16, 28
    DELAY 50
    GOTO 기울기보정_G1

기울기보정_G2:
    SERVO 16, 28
    넘어진확인 = 0
    ETX 4800, 111
    GOSUB All_motor_mode3
    ff = 0
    A = 0
aaaa_G2:
    ff = ff + 1
    IF ff > 10 THEN GOTO 기울기보정
    DELAY 1
    ERX 4800, A , aaaa_G2

    IF A >= 138  AND A <= 158 THEN
        GOSUB 왼쪽턴10
    ELSEIF A <= 118 AND A >=98 THEN  '
        GOSUB 오른쪽턴10
    ELSEIF A > 158 AND A < 255 THEN
        GOSUB m왼쪽턴20
    ELSEIF A < 98 THEN
        GOSUB m오른쪽턴20
    ELSEIF A > 118 AND A < 138  THEN
        DELAY 200
        RETURN
    ENDIF
    DELAY 200
    GOTO 기울기보정_G2


장애물좌우확인:
    ETX 4800, 113
    ff = 0
gggg:
    ff= ff + 1
    IF ff > 10 THEN GOTO 장애물좌우확인
    DELAY 10
    ERX 4800, A , gggg

    장애물좌우 = A
    RETURN



좌우보정:
    SERVO 16, 28
    넘어진확인 = 0
    ETX 4800, 112               'yellow x
    GOSUB All_motor_mode3
    ff = 0
bbbb:
    ff= ff + 1
    IF ff > 10 THEN GOTO 좌우보정
    DELAY 10
    ERX 4800, A , bbbb
    IF A > 108 AND A < 148 THEN
        DELAY 100
        RETURN
    ELSEIF A >= 148 AND A <= 168 THEN
        GOSUB m오른쪽옆으로20
    ELSEIF A <= 108 AND A >= 88 THEN
        GOSUB m왼쪽옆으로20
    ELSEIF A >168 THEN
        GOSUB m오른쪽옆으로20
    ELSEIF A > 0 AND A < 88 THEN
        GOSUB m왼쪽옆으로20
    ELSE
        GOSUB 미션끝내고보정
    ENDIF
    DELAY 100
    GOTO 좌우보정
    


장애물Y_G:
    SERVO 16, 28
    넘어진확인 = 0
    ETX 4800, 122       'green y
    장애물YG = 0
    ff=0
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
ygyg:
    ff= ff + 1
    IF ff > 10 THEN GOTO 장애물Y_G
    DELAY 10
    ERX 4800, A , ygyg  
    IF A>70 AND A<=255 THEN 
        장애물YG = 1     '가까운거
    ELSEIF A = 0 THEN 
        장애물YG = 0      '안보이는거
    ELSE                  
        장애물YG = 2        '먼거
    ENDIF
    RETURN
    
장애물Y_G_2:
    SERVO 16, 40
    넘어진확인 = 0
    ETX 4800, 122       'green y
    장애물YG_2 = 0
    ff=0
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
ygyg2:
    ff= ff + 1
    IF ff > 10 THEN GOTO 장애물Y_G_2
    DELAY 10
    ERX 4800, A , ygyg2  
    IF A>70 AND A<=255 THEN 
        장애물YG_2 = 1     '가까운거
    ELSEIF A = 0 THEN 
        장애물YG_2 = 0      '안보이는거
    ELSE
                  
        장애물YG = 2        '먼거
    ENDIF
    RETURN


먼거확인:
    SERVO 16, 40
    DELAY 100
    넘어진확인 = 0
    ETX 4800, 121       'green x
    장애물YG = 0
    ff=0
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
far:
    ff= ff + 1
    IF ff > 10 THEN GOTO 먼거확인
    DELAY 10
    ERX 4800, A , far

    IF A > 108 AND A < 148 THEN             'A가 완전 중앙일때
        장애물유무 = 1
        SERVO 16, 28
        RETURN
    ELSEIF A >= 148 AND A <= 168 THEN
        GOSUB m오른쪽옆으로20
        장애물유무 = 1
    ELSEIF A <= 108 AND A >= 88 THEN
        GOSUB m왼쪽옆으로20
        장애물유무 = 1
    ELSEIF A >168 AND A < 255 THEN
        GOSUB m오른쪽옆으로20
        장애물유무 = 1
    ELSEIF A < 88 AND A > 0 THEN
        GOSUB m왼쪽옆으로20
        장애물유무 = 1
    ELSEIF A = 0 THEN
        장애물유무 = 1
        GOSUB 양발한번앞으로가기1
        GOSUB 양발한번앞으로가기2
        DELAY 100
        GOTO 먼거확인
    ENDIF
    DELAY 100
    GOTO 먼거확인
    



좌우보정_G1:                          
    SERVO 16, 28                  
    넘어진확인 = 0
    ETX 4800, 121                   'green x
    GOSUB All_motor_mode3
    ff = 0
baba:
    ff= ff + 1
    IF ff > 10 THEN GOTO 좌우보정_G1
    DELAY 10
    ERX 4800, A , baba                      'A 초록색 중앙값, 없을때는 0
    IF A > 108 AND A < 148 THEN             'A가 완전 중앙일때
        장애물유무 = 1
        RETURN
    ELSEIF A >= 148 AND A <= 168 THEN
        GOSUB m오른쪽옆으로20
        장애물유무 = 1
    ELSEIF A <= 108 AND A >= 88 THEN
        GOSUB m왼쪽옆으로20
        장애물유무 = 1
    ELSEIF A >168 AND A < 255 THEN
        GOSUB m오른쪽옆으로20
        장애물유무 = 1
    ELSEIF A < 88 AND A > 0 THEN
        GOSUB m왼쪽옆으로20
        장애물유무 = 1
    ELSEIF A = 0 THEN
        장애물유무 = 1
        GOSUB 양발한번앞으로가기1
        GOSUB 양발한번앞으로가기2
        DELAY 100
        GOTO 좌우보정_G1
    ENDIF
    DELAY 100
    GOTO 좌우보정_G1



좌우보정_G2:
    SERVO 16, 40
    넘어진확인 = 0
    ETX 4800, 121               'green x
    GOSUB All_motor_mode3
    ff = 0
babaa:
    ff= ff + 1
    IF ff > 10 THEN GOTO 좌우보정_G2
    DELAY 10
    ERX 4800, A , babaa
    IF A > 108 AND A < 148 THEN
        장애물유무 = 1
        DELAY 200
        RETURN
    ELSEIF A >= 148 AND A <= 168 THEN
        GOSUB m오른쪽옆으로20
        장애물유무 = 1
    ELSEIF A <= 108 AND A >= 88 THEN
        GOSUB m왼쪽옆으로20
        장애물유무 = 1
    ELSEIF A >168 AND A < 255 THEN
        GOSUB m오른쪽옆으로20
        장애물유무 = 1
    ELSEIF A < 88 AND A > 0 THEN
        GOSUB m왼쪽옆으로20
        장애물유무 = 1
    ELSEIF A = 0 THEN
        장애물유무 = 1
        GOSUB 양발한번앞으로가기1
        GOSUB 양발한번앞으로가기2
        DELAY 200
        GOTO 좌우보정_G2
    ENDIF
    DELAY 200
    GOTO 좌우보정_G2



장애물거리_G1:
    SERVO 16, 28
    DELAY 100
    넘어진확인 = 0
    ETX 4800, 122               'green y
    GOSUB All_motor_mode3
    ff = 0
    A=0
caca:
    ff= ff + 1
    IF ff > 10 THEN GOTO 장애물거리_G1
    DELAY 10
    ERX 4800, A , caca
    IF A >= 0 AND A < 130 THEN
        GOSUB 양발한번앞으로가기1
        GOSUB 양발한번앞으로가기2
        'GOSUB 기울기보정1
    ELSEIF A >= 130 AND A <= 240 THEN
        RETURN
    ELSEIF A > 240 THEN
        GOSUB 한발뒤로가기
    ENDIF
    DELAY 10
    GOTO 장애물거리_G1


장애물거리_G2:              'green y
    SERVO 16, 18
    넘어진확인 = 0
    ETX 4800, 122
    GOSUB All_motor_mode3
    ff = 0
    A=0
dada:
    ff= ff + 1
    IF ff > 10 THEN GOTO 장애물거리_G2
    DELAY 10
    ERX 4800, A , dada
    IF A >= 0 AND A < 130 THEN
        GOSUB 양발한번앞으로가기1
        GOSUB 양발한번앞으로가기2
        GOSUB 기울기보정1
    ELSEIF A >= 130 AND A <= 255 THEN
        RETURN
    ENDIF
    DELAY 10
    GOTO 장애물거리_G2

'********************************************************************
장애물들어왼쪽치우기:
    HIGHSPEED SETOFF
    PTP SETON
    PTP ALLON

    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    SPEED 6

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


    MOVE G6A, 100, 152,  53, 113, 100,
    MOVE G6D, 100, 152,  53, 113, 100,


    MOVE G6A, 100, 152,  48, 123, 100,
    MOVE G6D, 100, 152,  48, 123, 100,

    MOVE G6A, 100, 152,  40, 133, 100,
    MOVE G6D, 100, 152,  40, 133, 100,


    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 190,  10, 100,  ,  ,
    MOVE G6C, 190,  10, 100,  ,  ,
    WAIT
    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 190,  10,  65,  ,  ,
    MOVE G6C, 190,  10,  65,  ,  ,
    WAIT

    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 160,  10,  60,  ,  ,
    MOVE G6C, 160,  10,  60,  ,  ,
    WAIT

    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 155,  10,  60,  ,  ,
    MOVE G6C, 155,  10,  60,  ,  ,
    WAIT

    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT

    DELAY 500

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 155,  45,  35,  ,  ,
    MOVE G6C, 155,  45,  35,  ,  ,
    WAIT

    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 155,  30,  35,  ,  ,
    MOVE G6C, 155,  30,  35,  ,  ,
    WAIT

    'MOVE G6A,  60, 162,  30, 162, 145,
    'MOVE G6D,  60, 162,  30, 162, 145,
    'MOVE G6B, 170,  10,  60,  ,  ,
    'MOVE G6C, 170,  10,  60,  ,  ,
    'WAIT

    MOVE G6B, 170,  10,  60,  ,  ,
    MOVE G6C, 170,  10,  60,  ,  ,
    WAIT

    SPEED 10
    GOSUB Leg_motor_mode3
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10

    SPEED 8
    GOSUB All_motor_mode2
    넘어진확인 = 1

    DELAY 100


    '******************************
    DELAY 100
    GOSUB 자이로ON
    GOSUB 적외선거리센서확인
    DELAY 100

    SPEED 6
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G

    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,   77, 145,  93, 100, 100

    WAIT
    MOVE G6A, 100,  97, 125,  88, 100,
    MOVE G6D, 100,  97, 125,  88, 100,

    MOVE G6D, 100, 117, 105,  88, 100,
    MOVE G6A, 100, 117, 105,  88, 100,


    MOVE G6A, 100, 132,  85,  93, 100,
    MOVE G6D, 100, 132,  85,  93, 100,

    MOVE G6D, 100, 147,  60, 103, 100,
    MOVE G6A, 100, 147,  60, 103, 100,

    MOVE G6A, 100, 152,  53, 113, 100,
    MOVE G6D, 100, 152,  53, 113, 100,

    MOVE G6A, 100, 152,  48, 123, 100,
    MOVE G6D, 100, 152,  48, 123, 100,

    MOVE G6A, 100, 152,  40, 133, 100,
    MOVE G6D, 100, 152,  40, 133, 100,

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    MOVE G6A, 100, 150,  33, 140, 100,
    MOVE G6D, 100, 150,  33, 140, 100,
    MOVE G6B, 150,  10,  60,  ,  ,
    MOVE G6C, 150,  10,  60,  ,  ,
    WAIT
    
    MOVE G6A, 100, 150,  33, 140, 100,
    MOVE G6D, 100, 150,  33, 140, 100,
    MOVE G6B, 150,  45,  60,  ,  ,
    MOVE G6C, 150,  10,  60,  ,  ,
    WAIT

    MOVE G6A, 100, 150,  33, 140, 100,
    MOVE G6D, 100, 150,  33, 140, 100,
    MOVE G6B, 150,  45,  60,  ,  ,
    MOVE G6C, 150,  45,  60,  ,  ,
    WAIT


    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    SPEED 8
    GOSUB All_motor_mode2

    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G

    장애물개수 = 장애물개수 - 1
    GOSUB 기본자세2
    GOSUB 기울기보정
    IF 장애물개수 = 0 THEN
        미션수행 = 미션수행 + 1
        ETX 4800, 140
        ETX 4800, 140
        ETX 4800, 140
    ENDIF
    GOSUB ALL_motor_mode3
    HIGHSPEED SETON
    RETURN

장애물들어오른쪽치우기:
    HIGHSPEED SETOFF
    PTP SETON
    PTP ALLON

    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    SPEED 6

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


    MOVE G6A, 100, 152,  53, 113, 100,
    MOVE G6D, 100, 152,  53, 113, 100,


    MOVE G6A, 100, 152,  48, 123, 100,
    MOVE G6D, 100, 152,  48, 123, 100,

    MOVE G6A, 100, 152,  40, 133, 100,
    MOVE G6D, 100, 152,  40, 133, 100,


    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT
    '''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 190,  10, 100,  ,  ,
    MOVE G6C, 190,  10, 100,  ,  ,
    WAIT
    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 190,  10,  65,  ,  ,
    MOVE G6C, 190,  10,  65,  ,  ,
    WAIT

    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 160,  10,  60,  ,  ,
    MOVE G6C, 160,  10,  60,  ,  ,
    WAIT

    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 155,  10,  60,  ,  ,
    MOVE G6C, 155,  10,  60,  ,  ,
    WAIT

    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT

    DELAY 500

    ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''
    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 155,  45,  35,  ,  ,
    MOVE G6C, 155,  45,  35,  ,  ,
    WAIT

    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 155,  30,  35,  ,  ,
    MOVE G6C, 155,  30,  35,  ,  ,
    WAIT



    'MOVE G6A,  60, 162,  30, 162, 145,
    'MOVE G6D,  60, 162,  30, 162, 145,
    'MOVE G6B, 170,  10,  60,  ,  ,
    'MOVE G6C, 170,  10,  60,  ,  ,
    'WAIT





    MOVE G6B, 170,  10,  60,  ,  ,
    MOVE G6C, 170,  10,  60,  ,  ,
    WAIT

    SPEED 10
    GOSUB Leg_motor_mode3
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10

    SPEED 8
    GOSUB All_motor_mode2
    넘어진확인 = 1

    DELAY 100

    '******************************
    DELAY 100
    GOSUB 자이로ON

    GOSUB 적외선거리센서확인

    SPEED 6
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G
    GOSUB m오른쪽옆으로20_G


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

    MOVE G6A, 100, 152,  53, 113, 100,
    MOVE G6D, 100, 152,  53, 113, 100,

    MOVE G6A, 100, 152,  48, 123, 100,
    MOVE G6D, 100, 152,  48, 123, 100,

    MOVE G6A, 100, 152,  40, 133, 100,
    MOVE G6D, 100, 152,  40, 133, 100,

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    MOVE G6A, 100, 150,  33, 140, 100,
    MOVE G6D, 100, 150,  33, 140, 100,
    MOVE G6B, 150,  10,  60,  ,  ,
    MOVE G6C, 150,  10,  60,  ,  ,
    WAIT
    
    MOVE G6A, 100, 150,  33, 140, 100,
    MOVE G6D, 100, 150,  33, 140, 100,
    MOVE G6B, 150,  10,  60,  ,  ,
    MOVE G6C, 150,  45,  60,  ,  ,
    WAIT

    MOVE G6A, 100, 150,  33, 140, 100,
    MOVE G6D, 100, 150,  33, 140, 100,
    MOVE G6B, 150,  45,  60,  ,  ,
    MOVE G6C, 150,  45,  60,  ,  ,
    WAIT


    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    SPEED 8
    GOSUB All_motor_mode2

    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G
    GOSUB m왼쪽옆으로20_G

    장애물개수 = 장애물개수 - 1
    GOSUB 기본자세2
    GOSUB 기울기보정
    IF 장애물개수 = 0 THEN
        미션수행 = 미션수행 + 1
        ETX 4800, 140
        ETX 4800, 140
        ETX 4800, 140
    ENDIF
    GOSUB ALL_motor_mode3
    HIGHSPEED SETON
    RETURN


m오른쪽옆으로20_G: '****
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
    GOSUB 다리기본자세
    DELAY 5
    GOSUB All_motor_mode3
    RETURN

m왼쪽옆으로20_G: '****
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
    GOSUB 다리기본자세
    DELAY 5
    GOSUB All_motor_mode3
    RETURN

다리기본자세:

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT
    mode = 0

    RETURN
'********************************************************************

'********************************************************************    
장애물치우기:

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


    MOVE G6A, 100, 152,  53, 113, 100,
    MOVE G6D, 100, 152,  53, 113, 100,


    MOVE G6A, 100, 152,  48, 123, 100,
    MOVE G6D, 100, 152,  48, 123, 100,

    MOVE G6A, 100, 152,  40, 133, 100,
    MOVE G6D, 100, 152,  40, 133, 100,


    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A, 60, 162,  30, 162, 145, 100
    MOVE G6D, 60, 162,  30, 162, 145, 100
    MOVE G6B,170,  10, 100, 100, 100, 100
    MOVE G6C,170,  10, 100, 100, 100, 100
    WAIT

    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 170,  10,  39,  ,  ,
    MOVE G6C, 170,  90, 100,  ,  ,
    WAIT


    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 170,  10, 100,  ,  ,
    MOVE G6C,  10, 190, 190,  ,  ,
    WAIT

    MOVE G6A, 75, 162,  55, 162, 155, 100
    MOVE G6D, 75, 162,  59, 162, 155, 100
    WAIT

    MOVE G6A,  75, 162,  55, 162, 155,
    MOVE G6D,  75, 162,  59, 162, 155,
    MOVE G6B, 170,  10, 100,  ,  ,
    MOVE G6C,  10, 132,  65,  ,  ,
    WAIT

    MOVE G6A,  75, 162,  55, 162, 155,
    MOVE G6D,  75, 162,  59, 162, 155,
    MOVE G6B, 170,  10, 100,  ,  ,
    MOVE G6C, 170, 100, 100,  ,  ,
    WAIT
    
    MOVE G6A,  75, 162,  55, 162, 155,
    MOVE G6D,  75, 162,  59, 162, 155,
    MOVE G6B, 170,  10, 100,  ,  ,
    MOVE G6C, 190,  90, 100,  ,  ,
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
    GOSUB 기본자세2
'********************************************************************    



'********************************************************************
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

'*************************************************************
터널지나가기:
    SPEED 5
    GOSUB 자이로OFF

    MOVE G6A,100,  77, 145,  93, 100, 100
    MOVE G6D,100,  77, 145,  93, 100, 100
    MOVE G6B,100,  30,  80
    MOVE G6C,100,  30,   80, , 120
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
    MOVE G6B,  10,  40,  70,  ,  ,
    MOVE G6C,  10,  40,  70,  ,120 ,


	DELAY 100
    SPEED 7


    FOR i=0 TO 12

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

    HIGHSPEED SETOFF

    GOSUB All_motor_Reset

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
    
    
    GOSUB 기본자세2
    RETURN
    
    

'***************************************************************************************
'진행코드
'***************************************************************************************
진행코드:
    장애물확인 = 0
    터널확인 = 0
    셔터확인 = 0
    코너걸음 = 0
    넘어진확인 = 0
    장애물개수 = 2
    PRINT "VOLUME 200!"

진행코드_1: '앞으로3발 걷기 + 초록색 찾기
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인
    
    장애물확인 = 장애물확인 + 1

    IF 미션수행 >= 1 THEN GOTO 진행코드_2
    IF 장애물확인 > 1 THEN
        ETX 4800, 120                   '파이썬 초록색 켜기
        보행횟수_G = 4
        장애물유무 = 0                   '보이면 1 없으면 0
        
        GOTO 전진종종걸음2
    ENDIF


    보행횟수 = 6            '3번 걷기
    GOTO 전진종종걸음1
    
진행코드_2:                 '걷다가 코너돌기
    ETX 4800, 202
    SERVO 16, 28
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    

    IF 미션수행 >= 2 THEN GOTO 진행코드_3
    IF 코너걸음 = 0 THEN
        보행횟수 = 6
    ELSEIF 코너걸음 = 3 THEN
        보행횟수 = 4
    ELSEIF 코너걸음 = 1 THEN
        보행횟수 = 2
    ENDIF
    GOTO 전진종종걸음_우유다음      '코너돌고 미션수행+1


진행코드_3:                 '문열기
    SERVO 16, 28
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인
    
    ETX 4800, 150
    IF 미션수행 >=3 THEN GOTO 진행코드_4
    IF  적외선거리값 > 70 THEN
        MUSIC "C"
        DELAY 10
        GOSUB 문앞에서
        GOSUB 새문열기
        GOSUB 미션끝내고보정
        
        미션수행=미션수행+1
        GOTO 진행코드_4

    ELSE  ' A>0 THEN
        SERVO 16, 28
        보행횟수 = 2
        GOTO 전진종종걸음3
    ENDIF

진행코드_4:                 '걷다가 터널지나기
    ETX 4800, 202          'yellow line만 키기
    보행횟수 = 10
    SERVO 16, 28
진행코드_4_1:
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인
    터널확인 = 터널확인 + 1
    IF 미션수행 >=4 THEN GOTO 진행코드_5
    IF 적외선거리값 > 80 THEN 
        ETX 4800, 114   
        GOSUB 터널앞에서
        GOSUB 터널지나가기 
        GOSUB 미션끝내고보정
        미션수행 = 미션수행 + 1
        GOTO 진행코드_5                 
    ELSE
        IF 터널확인 >= 3 THEN
            보행횟수 = 2
            GOTO 전진종종걸음4
        ELSE
            보행횟수 = 10
            GOTO 전진종종걸음4
        ENDIF
    ENDIF
    GOTO 진행코드_4_1

진행코드_5:                 '걷다가 문열기
    ETX 4800, 202          '노란색만 키기
    SERVO 16, 28
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    GOSUB 적외선거리센서확인
    셔터확인 = 셔터확인 + 1
    IF 적외선거리값 > 80 THEN 
        GOSUB 셔터들어올리기
    ELSEIF 셔터확인 > 2 THEN 
        보행횟수 = 2
        GOTO 전진종종걸음4
    ELSE
        보행횟수 = 5
        GOTO 전진종종걸음4
    ENDIF
    GOSUB 한발뒤로가기
    'GOSUB 한발뒤로가기
    GOTO 진행코드_5
    
    

'***************************************************************************************
'전진종종걸음1
'***************************************************************************************
전진종종걸음1:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON

전진종종걸음1_0:
    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT
        GOTO 전진종종걸음1_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT
        GOTO 전진종종걸음1_4
    ENDIF


'***************************************************************************************
'왼발
'***************************************************************************************
전진종종걸음1_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT
전진종종걸음1_2:
    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 진행코드_1
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음1_2_stop
    
    ERX 4800,A, 전진종종걸음1_4
    IF A <> A_old THEN
전진종종걸음1_2_stop:
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
        GOSUB 보정종합코너전
        GOTO 진행코드_1
    ENDIF

'***************************************************************************************
'오른발
'***************************************************************************************
전진종종걸음1_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT
전진종종걸음1_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 진행코드_1
    ENDIF

    보행COUNT = 보행COUNT + 1

    IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음1_5_stop
    
    
    ERX 4800,A, 전진종종걸음1_1
    IF A <> A_old THEN
전진종종걸음1_5_stop:
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
        GOSUB 보정종합코너전
        GOTO 진행코드_1
    ENDIF
'***************************************************************************************
'전진종종걸음_우유다음
'***************************************************************************************
전진종종걸음_우유다음:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON

전진종종걸음_우유다음1_0:
    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음_우유다음1_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음_우유다음1_4
    ENDIF


'***************************************************************************************
'왼발
'***************************************************************************************
전진종종걸음_우유다음1_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT
전진종종걸음_우유다음1_2:
    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 진행코드_1
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_우유다음1_2_stop
    
    ERX 4800,A, 전진종종걸음_우유다음1_4
    IF A <> A_old THEN
전진종종걸음_우유다음1_2_stop:
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
        GOSUB 보정종합
        GOTO 진행코드_1
    ENDIF

'***************************************************************************************
'오른발
'***************************************************************************************
전진종종걸음_우유다음1_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


전진종종걸음_우유다음1_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 진행코드_1
    ENDIF

    보행COUNT = 보행COUNT + 1

    IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음_우유다음1_5_stop
    
    
    ERX 4800,A, 전진종종걸음_우유다음1_1
    IF A <> A_old THEN
전진종종걸음_우유다음1_5_stop:
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
        GOSUB 보정종합
        GOTO 진행코드_1
    ENDIF
'***************************************************************************************

'***************************************************************************************
'전진종종걸음2
'***************************************************************************************
전진종종걸음2:
    보행COUNT_G = 0
    장애물유무 = 0
    

전진종종걸음2_0:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON
    GOSUB 앞뒤기울기측정
    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음2_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음2_4
    ENDIF
'********************************************************************
'왼발
'********************************************************************
전진종종걸음2_1:                                
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT
전진종종걸음2_2:
    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO 진행코드_1
    ENDIF

    보행COUNT_G = 보행COUNT_G + 1
    
    IF 보행COUNT_G > 보행횟수_G THEN        '보행횟수_G = 2  3발자국마다 stop
        GOTO 전진종종걸음2_2_stop
    ELSE
        GOTO 전진종종걸음2_4
    ENDIF    

    ERX 4800,A, 전진종종걸음2_4
    IF A <> A_old THEN
전진종종걸음2_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
K_2:
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세3
        GOSUB 장애물Y_G
        IF 장애물YG = 1 THEN            '가깝다
            GOSUB 보정종합_G
        ELSEIF 장애물YG = 2 THEN        '멀다
            보행COUNT_G = 보행COUNT_G - 2
            GOTO 전진종종걸음2_0
        ELSE
            보행COUNT_G = 보행COUNT_G - 3
            GOTO 전진종종걸음2_0
        ENDIF

        IF 장애물유무 = 1 THEN
            GOSUB 좌우보정_G2
            장애물좌우 = 1
            
            GOSUB 장애물좌우확인
            IF 장애물좌우 = 2 THEN
                GOSUB 장애물들어왼쪽치우기
                IF 장애물개수 > 0 THEN
                    GOSUB 한발뒤로가기
                    GOSUB 한발뒤로가기
                    GOSUB 장애물Y_G_2
                    IF 장애물YG_2 = 1 THEN  
                        GOSUB 보정종합_G
                    ELSEIF 장애물YG_2 = 2 THEN  
                        보행COUNT_G = 보행COUNT_G - 1
                        GOTO 전진종종걸음2_0    
                    ELSE 
                        보행COUNT_G = 보행COUNT_G - 2
                        GOTO 전진종종걸음2_0
                    ENDIF
                    '보행COUNT_G = 보행COUNT_G - 1
                    GOSUB 기본자세2
                    SERVO 16, 28
                    GOTO 전진종종걸음2_0
                ENDIF
                DELAY 100
            ELSE
                GOSUB 장애물들어오른쪽치우기
                IF 장애물개수 > 0 THEN
                    GOSUB 한발뒤로가기
                    GOSUB 한발뒤로가기
                    보행COUNT_G = 보행COUNT_G - 1
                    GOSUB 기본자세2
                    SERVO 16, 28
                    GOTO 전진종종걸음2_0
                ENDIF
                DELAY 100
            ENDIF
            GOSUB 보정종합
            GOTO 진행코드_1 
        ENDIF
	ENDIF
'***************************************************************************************
'오른발
'***************************************************************************************
전진종종걸음2_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


전진종종걸음2_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT

    'GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 진행코드_1
    ENDIF

    보행COUNT_G = 보행COUNT_G + 1
    
    IF 보행COUNT_G > 보행횟수_G THEN  
        GOTO 전진종종걸음2_5_stop
    ELSE 
        GOTO 전진종종걸음2_1
    ENDIF

    ERX 4800,A, 전진종종걸음2_1
    IF A <> A_old THEN
전진종종걸음2_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
K_5:
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB 안정화자세
        SPEED 5
        GOSUB 기본자세3
        GOSUB 장애물Y_G
        IF 장애물YG = 1 THEN  
            GOSUB 보정종합_G
        ELSEIF 장애물YG = 2 THEN  
            보행COUNT_G = 보행COUNT_G - 2
            GOTO 전진종종걸음2_0    
        ELSE 
            보행COUNT_G = 보행COUNT_G - 3
            GOTO 전진종종걸음2_0
        ENDIF

        IF 장애물유무 = 1 THEN
            GOSUB 좌우보정_G2
            장애물좌우 = 1
            
            GOSUB 장애물좌우확인
            IF 장애물좌우 = 2 THEN
                GOSUB 장애물들어왼쪽치우기
                IF 장애물개수 > 0 THEN
                    GOSUB 한발뒤로가기
                    GOSUB 한발뒤로가기
                    GOSUB 장애물Y_G_2
                    IF 장애물YG_2 = 1 THEN  
                        GOSUB 보정종합_G
                    ELSEIF 장애물YG_2 = 2 THEN  
                        보행COUNT_G = 보행COUNT_G - 1
                        GOTO 전진종종걸음2_0    
                    ELSE 
                        보행COUNT_G = 보행COUNT_G - 2
                        GOTO 전진종종걸음2_0
                    ENDIF
                    '보행COUNT_G = 보행COUNT_G - 1
                    GOSUB 기본자세2
                    SERVO 16, 28
                    GOTO 전진종종걸음2_0
                ENDIF
                DELAY 100
                    
            ELSE
                GOSUB 장애물들어오른쪽치우기
                IF 장애물개수 > 0 THEN
                    GOSUB 한발뒤로가기
                    GOSUB 한발뒤로가기 
                    보행COUNT_G = 보행COUNT_G - 1
                    GOSUB 기본자세2
                    SERVO 16, 28
                    GOTO 전진종종걸음2_0
                ENDIF

                DELAY 100
            ENDIF

            'ETX 4800, 202       '노란색만 키기
            'DELAY 400
            GOSUB 보정종합
            GOTO 진행코드_1
        ENDIF
	ENDIF
    
'***************************************************************************************
'뚱
'***************************************************************************************
'전진종종걸음3
'***************************************************************************************
전진종종걸음3:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON
    GOSUB 앞뒤기울기측정

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음3_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음3_4
    ENDIF


'***************************************************************************************
'왼발3
'***************************************************************************************
전진종종걸음3_1:        
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT
전진종종걸음3_2:
    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    'GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO 진행코드_3
    ENDIF

    
    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음3_2_stop
    
    ERX 4800,A, 전진종종걸음3_4
    IF A <> A_old THEN
전진종종걸음3_2_stop:
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
    GOSUB 적외선거리센서확인
    IF 적외선거리값 > 70 THEN GOTO 진행코드_3
    GOSUB 보정종합_3

    

    GOTO 진행코드_3
    ENDIF
'***************************************************************************************
'오른발3
'***************************************************************************************
전진종종걸음3_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT
전진종종걸음3_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    'GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 진행코드_3
    ENDIF

    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음3_5_stop
    
    
    ERX 4800,A, 전진종종걸음3_1
    IF A <> A_old THEN
전진종종걸음3_5_stop:
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
    GOSUB 적외선거리센서확인
    IF 적외선거리값 > 0 THEN GOTO 진행코드_3
    GOSUB 보정종합_3
    'DELAY 400
    '장애물확인 = 장애물확인 + 1
    
    GOTO 진행코드_3
    ENDIF

'***************************************************************************************
'전진종종걸음4
'***************************************************************************************
전진종종걸음4:
    GOSUB All_motor_mode3
    보행COUNT = 0
    SPEED 7
    HIGHSPEED SETON
    GOSUB 앞뒤기울기측정

    IF 보행순서 = 0 THEN
        보행순서 = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT
        GOTO 전진종종걸음4_1
    ELSE
        보행순서 = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO 전진종종걸음4_4
    ENDIF


'***************************************************************************************
'왼발
'***************************************************************************************
전진종종걸음4_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT
전진종종걸음4_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    'GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0

        GOTO 진행코드_4_1
    ENDIF

    
    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음4_2_stop
    
    ERX 4800,A, 전진종종걸음4_4
    IF A <> A_old THEN
전진종종걸음4_2_stop:
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
    GOSUB 적외선거리센서확인
    IF 적외선거리값 > 80 THEN GOTO 진행코드_4
    GOSUB 보정종합_3

    
    'DELAY 400
    '장애물확인 = 장애물확인 + 1
    GOTO 진행코드_4_1

    ENDIF

'***************************************************************************************
'오른발
'***************************************************************************************
전진종종걸음4_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


전진종종걸음4_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    'GOSUB 앞뒤기울기측정
    IF 넘어진확인 = 1 THEN
        넘어진확인 = 0
        GOTO 진행코드_4_1
    ENDIF

    
    보행COUNT = 보행COUNT + 1
    IF 보행COUNT > 보행횟수 THEN  GOTO 전진종종걸음4_5_stop
    
    
    ERX 4800,A, 전진종종걸음4_1
    IF A <> A_old THEN
전진종종걸음4_5_stop:
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
    GOSUB 적외선거리센서확인
    IF 적외선거리값 > 80 THEN GOTO 진행코드_4_1
    GOSUB 보정종합_3
    
    
    'DELAY 400
    '장애물확인 = 장애물확인 + 1
    GOTO 진행코드_4_1
    
    ENDIF

'***************************************************************************************
'***************************************************************************************
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
'***************************************************************************************
'좌우기울기측정
'***************************************************************************************  
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
'***************************************************************************************
'적외선거리센서확인
'***************************************************************************************
적외선거리센서확인:

    적외선거리값 = AD(5)

    IF 적외선거리값 > 150 THEN '50 = 적외선거리값 = 25cm
        MUSIC "D"
        DELAY 50
    ENDIF
    RETURN
'***************************************************************************************
터널앞에서:
    SERVO 16, 28
    넘어진확인 = 0
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    ETX 4800, 114           'Yellow detect 키기
    GOSUB All_motor_mode3
    DELAY 5
    gg = 0
tttt1:
    GOSUB 적외선거리센서확인
    IF 적외선거리값 > 100 THEN
        GOSUB 기본자세2
        DELAY 20
        RETURN
    ENDIF
    ETX 4800, 115
    ff = 0
    A = 0
ttff:
    ff = ff + 1
    IF ff > 10 THEN GOTO 터널앞에서
    DELAY 10
    ERX 4800, A , ttff
    

    IF A = 153 THEN     '오른쪽턴
        GOSUB 오른쪽턴10
    ELSEIF A = 103 THEN  '왼쪽턴
        GOSUB 왼쪽턴10
    ELSEIF A = 128 THEN
        GOSUB 적외선거리센서확인
        IF 적외선거리값 > 80 THEN
            GOSUB 기본자세2
            DELAY 20
            RETURN
        ELSE
            GOSUB 한발앞으로가기1
            GOSUB L한발앞으로가기1
        ENDIF
    ELSEIF A = 150 THEN ' 왼쪽으로 게걸음
        GOSUB m왼쪽옆으로20
    ELSEIF A = 130 THEN ' 오른쪽으로 게걸음
        GOSUB m오른쪽옆으로20
    ELSEIF A=0 THEN
        GOSUB 한발뒤로가기
    ELSE
        gg = gg + 1
    ENDIF
    IF gg > 10 THEN
        GOSUB 기본자세2
        DELAY 20
        RETURN 
    ENDIF
     
    DELAY 10
    GOTO tttt1
'***************************************************************************************

'새문열기
'***************************************************************************************

새문열기:
        GOSUB 왼쪽턴60
        GOSUB 왼쪽턴60
        GOSUB 왼쪽턴45_G1
        

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
        GOSUB 오른쪽옆으로70연속

        GOSUB 기본자세
        
        RETURN

'***************************************************************************************
문앞에서:
    SERVO 16, 28
    넘어진확인 = 0
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    ETX 4800, 114           'Yellow detect 키기
    GOSUB All_motor_mode3
    DELAY 5
    gg = 0
aaaa1:
    GOSUB 적외선거리센서확인
    IF 적외선거리값 > 100 THEN
        GOSUB 기본자세2
        DELAY 20
        RETURN
    ENDIF
    ETX 4800, 115
    ff = 0
    A = 0
ddff:
    ff = ff + 1
    IF ff > 10 THEN GOTO 문앞에서
    DELAY 10
    ERX 4800, A , ddff
    

    IF A = 153 THEN     '오른쪽턴
        GOSUB 오른쪽턴10
    ELSEIF A = 103 THEN  '왼쪽턴
        GOSUB 왼쪽턴10
    ELSEIF A = 128 THEN
        GOSUB 적외선거리센서확인
        IF 적외선거리값 > 100 THEN
            GOSUB 기본자세2
            DELAY 20
            RETURN
        ELSE
            GOSUB 한발앞으로가기1
            GOSUB L한발앞으로가기1
        ENDIF
    ELSEIF A = 150 THEN ' 왼쪽으로 게걸음
        GOSUB m왼쪽옆으로20
    ELSEIF A = 130 THEN ' 오른쪽으로 게걸음
        GOSUB m오른쪽옆으로20
    ELSEIF A=0 THEN
        GOSUB 한발뒤로가기
    ELSE
        gg = gg + 1
    ENDIF
    IF gg > 10 THEN
        GOSUB 기본자세2
        DELAY 20
        RETURN 
    ENDIF
     
    DELAY 10
    GOTO aaaa1
'***************************************************************************************
  
'***************************************************************************************


미션끝내고보정:
    넘어진확인 = 0
    GOSUB 앞뒤기울기측정
    GOSUB 좌우기울기측정
    SERVO 16, 28
    시야확인 = 0 '중앙 1 왼쪽 2 오른쪽 3
미션끝내고보정_1:
    SERVO 11, 100
    A=0
    DELAY 100
    ETX 4800, 112
    GOSUB All_motor_mode3
    ff = 0
dada1:
    ff = ff + 1
    IF ff > 10 THEN GOTO 미션끝내고보정_1
    DELAY 50
    ERX 4800, A , dada1

    IF A >0 THEN
        '시야확인 = 1
        SERVO 11, 100
        IF A < 60 THEN
        'DELAY 1000
            GOSUB m왼쪽옆으로70
        ELSEIF A > 196 THEN
            GOSUB m오른쪽옆으로70
        ENDIF 

        GOSUB 보정종합_3
        RETURN
    
    ELSE
        IF 시야확인 = 2 OR 시야확인 = 0 THEN
            GOSUB 왼쪽시야
        ENDIF
        IF 시야확인 = 3 THEN
            GOSUB 오른쪽시야
        ENDIF
    ENDIF
    GOTO 미션끝내고보정_1

왼쪽시야:
    SPEED 머리이동속도
    SERVO 11,55
    DELAY 100
    ETX 4800, 112
    GOSUB All_motor_mode3
    'DELAY 100
    ff = 0
leftff:
    ff = ff + 1
    IF ff > 10 THEN GOTO 왼쪽시야
    DELAY 50
    ERX 4800, A , leftff

    IF A >0 AND A< 255 THEN
        시야확인 = 2
        GOSUB m왼쪽옆으로70
    ELSE 
        시야확인 = 3
    ENDIF
    RETURN

오른쪽시야:
    SPEED 머리이동속도
    SERVO 11,145
    DELAY 100
    ETX 4800, 112
    GOSUB All_motor_mode3
    'DELAY 100
    ff = 0
rightff:
    ff = ff + 1
    IF ff > 10 THEN GOTO 오른쪽시야
    DELAY 50
    ERX 4800, A , rightff

    IF A >0 AND A< 2555  THEN
        시야확인 = 3
        GOSUB m오른쪽옆으로70
    ELSE 
        시야확인 = 0
    ENDIF
    RETURN

'***************************************************************************************
보정종합_G:
    ETX 4800, 120
    DELAY 100
    GOSUB 좌우보정_G1               
    GOSUB 장애물거리_G1
    RETURN


보정종합코너전:
    GOSUB 기울기보정1
    GOSUB 좌우보정    
    RETURN
    


보정종합:
    GOSUB 기울기보정
    GOSUB 좌우보정    
    RETURN


보정종합_3:
    GOSUB 기울기보정코너지남
    GOSUB 좌우보정
    RETURN
'********************************************************************

셔터들어올리기:
    GOSUB All_motor_mode3
    GOSUB 자이로OFF
    SPEED 6
    'HIGHSPEED SETON



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


    MOVE G6A, 100, 152,  53, 113, 100,
    MOVE G6D, 100, 152,  53, 113, 100,


    MOVE G6A, 100, 152,  48, 123, 100,
    MOVE G6D, 100, 152,  48, 123, 100,

    MOVE G6A, 100, 152,  40, 133, 100,
    MOVE G6D, 100, 152,  40, 133, 100,


    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    MOVE G6A, 100, 150,  33, 140, 100,
    MOVE G6D, 100, 150,  33, 140, 100,
    MOVE G6B, 190,  35,  80,  ,  ,
    MOVE G6C, 190,  35,  80,  ,  ,
    WAIT

    DELAY 500

	GOSUB 기본자세2
    GOSUB 자이로on

    RETURN


콜라캔치우기:
    HIGHSPEED SETOFF
    PTP SETON
    PTP ALLON

    GOSUB 자이로OFF

    HIGHSPEED SETOFF

    SPEED 6


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


    MOVE G6A, 100, 152,  53, 113, 100,
    MOVE G6D, 100, 152,  53, 113, 100,


    MOVE G6A, 100, 152,  48, 123, 100,
    MOVE G6D, 100, 152,  48, 123, 100,

    MOVE G6A, 100, 152,  40, 133, 100,
    MOVE G6D, 100, 152,  40, 133, 100,


    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    MOVE G6B,130,  50,  85, 100, 100, 100
    MOVE G6C,130,  50,  85, 100, 100, 100
    WAIT
    DELAY 100

    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT



    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 190, 100, 100,  ,  ,
    MOVE G6C, 190, 100, 100,  ,  ,
    WAIT


    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 190,  10,  10,  ,  ,
    MOVE G6C, 190, 100, 100,  ,  ,
    WAIT
    MOVE G6A,  60, 162,  30, 162, 145,
    MOVE G6D,  60, 162,  30, 162, 145,
    MOVE G6B, 190, 100, 100,  ,  ,
    MOVE G6C, 190,  10,  10,  ,  ,
    WAIT


    MOVE G6B,150,  60,  90, 100, 100, 100
    MOVE G6C,150,  60,  90, 100, 100, 100
    WAIT

    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    WAIT

    SPEED 10
    GOSUB Leg_motor_mode3
    MOVE G6A, 60, 150,  28, 155, 140, 100
    MOVE G6D, 60, 150,  28, 155, 140, 100
    WAIT

    MOVE G6A,100, 150,  28, 140, 100, 100
    MOVE G6D,100, 150,  28, 140, 100, 100
    WAIT
    DELAY 100

    MOVE G6A,100, 150,  33, 140, 100, 100
    MOVE G6D,100, 150,  33, 140, 100, 100
    WAIT
    SPEED 10

    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    GOSUB 기본자세2


    RETURN

