'******** 2�� ����κ� �ʱ� ���� ���α׷� ********

DIM I AS BYTE
DIM J AS BYTE
DIM MODE AS BYTE
DIM A AS BYTE
DIM A_old AS BYTE
DIM B AS BYTE
DIM C AS BYTE
DIM D AS BYTE
DIM ����ӵ� AS BYTE
DIM �¿�ӵ� AS BYTE
DIM �¿�ӵ�2 AS BYTE
DIM ������� AS BYTE
DIM �������� AS BYTE
DIM ����üũ AS BYTE
DIM ����ONOFF AS BYTE
DIM ���̷�ONOFF AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER
DIM Q AS BYTE
DIM ����� AS BYTE
DIM TEST AS INTEGER
DIM HEAD AS INTEGER
DIM REGION AS BYTE
DIM TURN AS BYTE
DIM POSITION AS BYTE
DIM FINAL_COUNT AS BYTE
DIM TURN_COUNT AS BYTE
DIM PACK_FIND AS BYTE
DIM START_NEWS AS BYTE


DIM �Ѿ���Ȯ�� AS BYTE
DIM ����Ȯ��Ƚ�� AS BYTE
DIM ����Ƚ�� AS BYTE
DIM ����COUNT AS BYTE
DIM ���⼳��Ȯ�� AS BYTE

DIM ���ܼ��Ÿ���  AS BYTE

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

'**** ���⼾����Ʈ ���� ****
CONST �յڱ���AD��Ʈ = 0
CONST �¿����AD��Ʈ = 1
CONST ����Ȯ�νð� = 20  'ms

CONST ���ܼ�AD��Ʈ  = 4


CONST min = 61	'�ڷγѾ�������
CONST max = 107	'�����γѾ�������
CONST COUNT_MAX = 3


CONST �Ӹ��̵��ӵ� = 10
'************************************************



PTP SETON 				'�����׷캰 ���������� ����
PTP ALLON				'��ü���� ������ ���� ����

DIR G6A,1,0,0,1,0,0		'����0~5��
DIR G6D,0,1,1,0,1,1		'����18~23��
DIR G6B,1,1,1,1,1,1		'����6~11��
DIR G6C,0,0,0,0,1,0		'����12~17��

'************************************************

OUT 52,0	'�Ӹ� LED �ѱ�
'***** �ʱ⼱�� '************************************************

������� = 0
����üũ = 0
����Ȯ��Ƚ�� = 0
����Ƚ�� = 1
����ONOFF = 0

'****�ʱ���ġ �ǵ��*****************************


TEMPO 230
MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
S16 = MOTORIN(16)

SERVO 11, 100
SERVO 16, S16

SERVO 16, 100


GOSUB �����ʱ��ڼ�
GOSUB �⺻�ڼ�


GOSUB ���̷�INIT
GOSUB ���̷�MID
GOSUB ���̷�ON



PRINT "VOLUME 80 !"
PRINT "SOUND 30 !" '�ȳ��ϼ���

GOSUB All_motor_mode3

ZERO G6A, 100, 99, 102,  100, 100, 100
ZERO G6B,100, 105, 102, 100, 100, 100
ZERO G6C, 98, 103,  98, 100, 100, 100
ZERO G6D, 100, 99, 105,  100, 104, 100

GOTO MAIN	'�ø��� ���� ��ƾ���� ����

'************************************************

'*********************************************
' Infrared_Distance = 60 ' About 20cm
' Infrared_Distance = 50 ' About 25cm
' Infrared_Distance = 30 ' About 45cm
' Infrared_Distance = 20 ' About 65cm
' Infrared_Distance = 10 ' About 95cm
'*********************************************
'************************************************
������:
    TEMPO 220
    MUSIC "O23EAB7EA>3#C"
    RETURN
    '************************************************
������:
    TEMPO 220
    MUSIC "O38GD<BGD<BG"
    RETURN
    '************************************************
������:
    TEMPO 250
    MUSIC "FFF"
    RETURN
    '************************************************
    '************************************************
MOTOR_ON: '����Ʈ�������ͻ�뼳��

    GOSUB MOTOR_GET

    MOTOR G6B
    DELAY 50
    MOTOR G6C
    DELAY 50
    MOTOR G6A
    DELAY 50
    MOTOR G6D

    ����ONOFF = 0
    GOSUB ������			
    RETURN

    '************************************************
    '����Ʈ�������ͻ�뼳��
MOTOR_OFF:

    MOTOROFF G6B
    MOTOROFF G6C
    MOTOROFF G6A
    MOTOROFF G6D
    ����ONOFF = 1	
    GOSUB MOTOR_GET	
    GOSUB ������	
    RETURN
    '************************************************
    '��ġ���ǵ��
MOTOR_GET:
    GETMOTORSET G6A,1,1,1,1,1,0
    GETMOTORSET G6B,1,1,1,0,0,1
    GETMOTORSET G6C,1,1,1,0,1,0
    GETMOTORSET G6D,1,1,1,1,1,0
    RETURN

    '************************************************
    '��ġ���ǵ��
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

�����ʱ��ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '************************************************
����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0

    RETURN
    '******************************************	


    '************************************************
�⺻�ڼ�:


    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    WAIT
    mode = 0

    RETURN
    '******************************************	
�⺻�ڼ�2:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT

    mode = 0
    RETURN

    '******************************************	
�⺻�ڼ�3:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    WAIT

    mode = 0
    RETURN
    '******************************************	
�����ڼ�:
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80
    WAIT
    mode = 2
    RETURN
    '******************************************
�����ڼ�:
    GOSUB ���̷�OFF
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
    '**** ���̷ΰ��� ���� ****
���̷�INIT:

    GYRODIR G6A, 0, 0, 1, 0,0
    GYRODIR G6D, 1, 0, 1, 0,0

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
    '**** ���̷ΰ��� ���� ****
���̷�MAX:

    GYROSENSE G6A,250,180,30,180,0
    GYROSENSE G6D,250,180,30,180,0

    RETURN
    '***********************************************
���̷�MID:

    GYROSENSE G6A,200,150,30,150,0
    GYROSENSE G6D,200,150,30,150,0

    RETURN
    '***********************************************
���̷�MIN:

    GYROSENSE G6A,200,100,30,100,0
    GYROSENSE G6D,200,100,30,100,0
    RETURN
    '***********************************************
���̷�ON:

    GYROSET G6A, 4, 3, 3, 3, 0
    GYROSET G6D, 4, 3, 3, 3, 0

    ���̷�ONOFF = 1

    RETURN
    '***********************************************
���̷�OFF:

    GYROSET G6A, 0, 0, 0, 0, 0
    GYROSET G6D, 0, 0, 0, 0, 0


    ���̷�ONOFF = 0
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


������������:
    GOSUB All_motor_mode3
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100
    WAIT

    GOTO ������������_1

������������_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


������������_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT


������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


������������_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT

    ����COUNT = ����COUNT + 1
    IF ����COUNT > 3 THEN
        GOTO ������������_5_stop
    ELSEIF ����COUNT <= 3 THEN
        GOTO ������������_1

������������_5_stop:
        MOVE G6A,95,  90, 125, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

    ENDIF

    RETURN

    '**********************************************



��������_�ο޹�:
    ����ӵ� = 13
    �¿�ӵ� = 4
    GOSUB Leg_motor_mode3

    SPEED 4

    MOVE G6A, 88,  74, 144,  95, 110
    MOVE G6D,108,  76, 146,  93,  96
    WAIT

    SPEED 10'

    MOVE G6A, 90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 147,  93,  96,100
    WAIT

    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    WAIT

    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�

    MOVE G6A, 90, 100, 100, 115, 110,100
    MOVE G6D,112,  76, 146,  93,  96,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 10

    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 152,  91, 106,100
    WAIT	
    SPEED 4

    GOSUB �⺻�ڼ�3

    RETURN


��������_�ο�����:
    ����ӵ� = 13
    �¿�ӵ� = 4
    GOSUB Leg_motor_mode3

    SPEED 4

    MOVE G6D, 88,  74, 144,  95, 110
    MOVE G6A,108,  76, 146,  93,  96
    WAIT

    SPEED 10'

    MOVE G6D, 90, 90, 120, 105, 110,100
    MOVE G6A,110,  76, 147,  93,  96,100
    WAIT

    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�

    MOVE G6D,110,  76, 147,  93, 96,100
    MOVE G6A,90, 90, 120, 105, 110,100
    WAIT

    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�

    MOVE G6D, 90, 100, 100, 115, 110,100
    MOVE G6A,112,  76, 146,  93,  96,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 10

    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 152,  91, 106,100
    WAIT	
    SPEED 4
    GOSUB �⺻�ڼ�3

    RETURN


��������_�ѿ�����:

    ����ӵ� = 13
    �¿�ӵ� = 4
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

    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�


    MOVE G6A, 90, 100, 100, 115, 110,100
    MOVE G6D,112,  76, 146,  93,  96,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 10

    MOVE G6D, 106,  76, 146,  93,  96,100		
    MOVE G6A,  88,  71, 152,  91, 106,100
    WAIT	
    SPEED 5

    GOSUB �⺻�ڼ�3

    RETURN


��������_�ѿ޹�:

    ����ӵ� = 13
    �¿�ӵ� = 4
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

    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�


    MOVE G6D, 90, 100, 100, 115, 110,100
    MOVE G6A,112,  76, 146,  93,  96,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 10

    MOVE G6A, 106,  76, 146,  93,  96,100		
    MOVE G6D,  88,  71, 152,  91, 106,100
    WAIT	
    SPEED 5

    GOSUB �⺻�ڼ�3

    RETURN


��������_�ι�:
    ����COUNT = 0
    ����ӵ� = 13
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3

    SPEED 4

    MOVE G6A, 88,  74, 144,  95, 110
    MOVE G6D,108,  76, 146,  93,  96
    WAIT

    SPEED 10'

    MOVE G6A, 90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 147,  93,  96,100
    WAIT

    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3
    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    WAIT

    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    SPEED ����ӵ�

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT


    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�

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
    GOSUB �⺻�ڼ�3

    RETURN



    '************************************************
��������_0:
    �Ѿ���Ȯ�� = 0
    ����ӵ� = 12
    �¿�ӵ� = 4
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


    GOTO ��������_2


��������:
    �Ѿ���Ȯ�� = 0
    ����ӵ� = 12
    �¿�ӵ� = 4

    GOSUB Leg_motor_mode3



    IF ������� = 0 THEN
        ������� = 1

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

        GOTO ��������_1	
    ELSE
        ������� = 0

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


        GOTO ��������_2

    ENDIF


��������_1:
    SPEED ����ӵ�

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    'GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    '  MOVE G6B,110
    '   MOVE G6C,90
    WAIT

    ERX 4800,A, ��������_2
    IF A <> A_old THEN
��������_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        '   MOVE G6B, 100
        '    MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB �⺻�ڼ�3
        GOTO ������_2_Ȯ��

    ENDIF
    '**********

��������_2:
    SPEED ����ӵ�
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED �¿�ӵ�
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    'GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    ' MOVE G6B, 90
    '  MOVE G6C,110
    WAIT


    ERX 4800,A, ��������_3
    IF A <> A_old THEN
��������_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        '   MOVE G6B, 100
        ' MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB �⺻�ڼ�3
        GOTO ������_2_Ȯ��
    ENDIF  	


��������_3:
    MOVE G6D, 106,  76, 145,  93,  96		
    MOVE G6A,  85,  72, 148,  91, 106
    '   MOVE G6B, 100
    ' MOVE G6C, 100
    WAIT	

    SPEED 3
    GOSUB �⺻�ڼ�3

    GOTO ������_2_Ȯ��

    '******************************************
    '******************************************
    '******************************************

    '************************************************
�����ʿ�����20: '****
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
    GOSUB �⺻�ڼ�3
    GOSUB All_motor_mode3
    RETURN
    '*************

���ʿ�����20: '****
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
    GOSUB �⺻�ڼ�3
    GOSUB All_motor_mode3
    RETURN

    '**********************************************
    '******************************************
�����ʿ�����70����:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

�����ʿ�����70����_loop:
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


    '  ERX 4800, A ,�����ʿ�����70����_loop
    '    IF A = A_OLD THEN  GOTO �����ʿ�����70����_loop
    '�����ʿ�����70����_stop:
    'GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************

���ʿ�����70����:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
���ʿ�����70����_loop:
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

    '   ERX 4800, A ,���ʿ�����70����_loop	
    '    IF A = A_OLD THEN  GOTO ���ʿ�����70����_loop
    '���ʿ�����70����_stop:

    GOSUB �⺻�ڼ�3

    RETURN

    '*********************************************

������3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������3_LOOP:

    IF ������� = 0 THEN
        ������� = 1
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
        ������� = 0
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
    GOSUB �⺻�ڼ�2


    RETURN

    '**********************************************
��������3:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

��������3_LOOP:

    IF ������� = 0 THEN
        ������� = 1
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
        ������� = 0
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
    GOSUB �⺻�ڼ�2

    RETURN

    '******************************************************
    '**********************************************
������10:
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

    GOSUB �⺻�ڼ�2
    GOTO RX_EXIT
    '**********************************************
��������10:
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

    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
    '**********************************************
������20:
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

    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************
��������20:
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

    GOSUB �⺻�ڼ�2

    RETURN
    '**********************************************

    '**********************************************	


    '**********************************************
������45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������45_LOOP:

    SPEED 8
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 6
    GOSUB �⺻�ڼ�2
    'DELAY 50
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,������45_LOOP
    '    IF A_old = A THEN GOTO ������45_LOOP
    '
    RETURN

    '**********************************************
��������45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
��������45_LOOP:

    SPEED 8
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 10
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 6
    GOSUB �⺻�ڼ�2
    ' DELAY 50
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '
    '    ERX 4800,A,��������45_LOOP
    '    IF A_old = A THEN GOTO ��������45_LOOP
    '
    RETURN
    '**********************************************
������60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������60_LOOP:

    SPEED 8
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 7
    GOSUB �⺻�ڼ�2
    '  DELAY 50
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,������60_LOOP
    '    IF A_old = A THEN GOTO ������60_LOOP

    RETURN

    '**********************************************
��������60:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
��������60_LOOP:

    SPEED 8
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 8
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 7
    GOSUB �⺻�ڼ�2
    ' DELAY 50
    '    GOSUB �յڱ�������
    '    IF �Ѿ���Ȯ�� = 1 THEN
    '        �Ѿ���Ȯ�� = 0
    '        GOTO RX_EXIT
    '    ENDIF
    '    ERX 4800,A,��������60_LOOP
    '    IF A_old = A THEN GOTO ��������60_LOOP

    RETURN
    '****************************************
    '************************************************
    '**********************************************


    '************************************************

    ''************************************************
    '************************************************
    '************************************************
�ڷ��Ͼ��:

    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON		

    GOSUB ���̷�OFF

    GOSUB All_motor_Reset

    SPEED 15
    GOSUB �⺻�ڼ�

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
    GOSUB �⺻�ڼ�

    �Ѿ���Ȯ�� = 1

    DELAY 200
    GOSUB ���̷�ON

    RETURN


    '**********************************************
�������Ͼ��:


    HIGHSPEED SETOFF
    PTP SETON 				
    PTP ALLON

    GOSUB ���̷�OFF

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
    GOSUB �⺻�ڼ�
    �Ѿ���Ȯ�� = 1

    '******************************
    DELAY 200
    GOSUB ���̷�ON
    RETURN

    '******************************************
    '******************************************
    '******************************************
    '**************************************************

    '******************************************
    '******************************************	
    '**********************************************

�Ӹ�����30��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,70
    GOTO MAIN

�Ӹ�����45��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,55
    GOTO MAIN

�Ӹ�����60��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,40
    GOTO MAIN

�Ӹ�����90��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,10
    GOTO MAIN

�Ӹ�������30��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,130
    GOTO MAIN

�Ӹ�������45��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,145
    GOTO MAIN	

�Ӹ�������60��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,160
    GOTO MAIN

�Ӹ�������90��:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,190
    GOTO MAIN

�Ӹ��¿��߾�:
    SPEED �Ӹ��̵��ӵ�
    SERVO 11,100
    GOTO MAIN

�Ӹ���������:
    SPEED �Ӹ��̵��ӵ�
    SERVO 16,100
    SERVO 11,100	
    SPEED 5
    GOSUB �⺻�ڼ�
    GOTO MAIN

    '******************************************
��������80��:

    SPEED 3
    SERVO 16, 60
    ETX 4800,35
    RETURN
    '******************************************
��������60��:

    SPEED 3
    SERVO 16, 65
    ETX 4800,36
    RETURN

�Ӹ��ִ�����:
    SPEED 3
    Q=30
    SERVO 16, Q
    RETURN
    '******************************************
    '******************************************
�յڱ�������:
    FOR i = 0 TO COUNT_MAX
        A = AD(�յڱ���AD��Ʈ)	'���� �յ�
        IF A > 250 OR A < 5 THEN RETURN
        IF A > MIN AND A < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF A < MIN THEN
        GOSUB �����
    ELSEIF A > MAX THEN
        GOSUB �����
    ENDIF

    RETURN
    '**************************************************
�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A < MIN THEN GOSUB �������Ͼ��
    IF A < MIN THEN
        ETX  4800,16
        GOSUB �ڷ��Ͼ��

    ENDIF
    RETURN

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A > MAX THEN GOSUB �ڷ��Ͼ��
    IF A > MAX THEN
        ETX  4800,15
        GOSUB �������Ͼ��
    ENDIF
    RETURN
    '**************************************************
�¿��������:
    FOR i = 0 TO COUNT_MAX
        B = AD(�¿����AD��Ʈ)	'���� �¿�
        IF B > 250 OR B < 5 THEN RETURN
        IF B > MIN AND B < MAX THEN RETURN
        DELAY ����Ȯ�νð�
    NEXT i

    IF B < MIN OR B > MAX THEN
        SPEED 8
        MOVE G6B,140,  40,  80
        MOVE G6C,140,  40,  80
        WAIT
        GOSUB �⺻�ڼ�	
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
Number_Play: '  BUTTON_NO = ���ڴ���


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
���ܼ��Ÿ�����Ȯ��:

    ' ���ܼ��Ÿ��� = AD(���ܼ�AD��Ʈ)

    'IF ���ܼ��Ÿ��� > 46 THEN '50 = ���ܼ��Ÿ��� = 25cm
    ' MUSIC "C"

    'DELAY 200
    ' ENDIF




    RETURN

���ܼ��Ÿ�����Ȯ��_2:
    ���ܼ��Ÿ��� = AD(���ܼ�AD��Ʈ)

    IF ���ܼ��Ÿ��� > 46 THEN '50 = ���ܼ��Ÿ��� = 25cm
        ���⼳��Ȯ��= 1

    ENDIF

    RETURN

    '******************************************

    '**********************************************
���������10:

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
�����������10:

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
���������20:

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

    GOSUB �⺻�ڼ�3

    RETURN
    '**********************************************
�����������20:

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

    GOSUB �⺻�ڼ�2
    RETURN
    '**********************************************
���������45:

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
�����������45:

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
���������60:

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
�����������60:

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
��������_TEST:
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

    SPEED ����ӵ�
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED �¿�ӵ�
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT

    MOVE G6D, 106,  76, 145,  93,  96		
    MOVE G6A,  85,  72, 148,  91, 106
    '   MOVE G6B, 100
    ' MOVE G6C, 100
    WAIT	

    SPEED 3
    GOSUB �⺻�ڼ�3

    RETURN


    'GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    ' MOVE G6B, 90
    '  MOVE G6C,110
    WAIT

    '****************************

��������_�ѹ�:

    ����ӵ� = 12
    �¿�ӵ� = 4
    GOSUB Leg_motor_mode3

    SPEED 4
    MOVE G6A, 88,  71, 152,  91, 110
    MOVE G6D,108,  76, 145,  93,  96
    WAIT

    SPEED 10
    MOVE G6A, 90, 100, 100, 115, 110
    MOVE G6D,110,  76, 145,  93,  96
    WAIT

    SPEED ����ӵ�

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT

    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    WAIT

    SPEED ����ӵ�
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED �¿�ӵ�
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
    GOSUB �⺻�ڼ�3

    RETURN



�̼�_1_0:
    START_NEWS=0




�̼�_1:

    ETX 4800, 110
    SERVO 16,70
    SERVO 11,120


�̼�_1_1:


    DELAY 500
    ERX 4800, A, �̼�_1


    IF A=150 THEN
        SPEED 10
        MOVE G6C, 189,  11,  93, 100,  98, 100
        WAIT
        PRINT "VOLUME 200 !"
        PRINT "SOUND 57 !" '��
    ELSEIF A=151 THEN
        SPEED 10
        MOVE G6B, 189,  11,  93, 100,  98, 100
        WAIT
        PRINT "VOLUME 200 !"
        PRINT "SOUND 58 !" '��
    ELSEIF A=152 THEN
        SPEED 10
        MOVE G6B,  14,  16,  92, 100, 100, 100
        MOVE G6C,  14,  16,  92, 100, 100, 100
        WAIT
        PRINT "VOLUME 200 !"
        PRINT "SOUND 59 !" '��
    ELSEIF A=153 THEN
        SPEED 10
        MOVE G6C, 189,  11,  93, 100,  98, 100
        MOVE G6B, 189,  11,  93, 100,  98, 100
        WAIT
        PRINT "VOLUME 200 !"
        PRINT "SOUND 60 !" '��
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
        GOTO �̼�_1

    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO �̼�_1_1
        DELAY 500
    ENDIF

    DELAY 200

    GOSUB �⺻�ڼ�

    GOSUB ��������_�ο�����


    GOSUB ��������

    DELAY 200
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
    ENDIF
    DELAY 300

    SPEED �Ӹ��̵��ӵ�
    SERVO 16,30	
    SPEED 5
    GOSUB �⺻�ڼ�


    GOTO �������_������



    GOTO RX_EXIT

    '************************************************
��������:
    ETX 4800,105


    GOSUB �⺻�ڼ�

    GOSUB ������60
    DELAY 300
    GOSUB ������45

    MOVE G6C, 100,  85,  21,  ,  ,
    MOVE G6B, 101,  93, 104, 100, 100, 100
    WAIT


    GOSUB �����ʿ�����70����'�������ȵ� ������
    DELAY 200
    GOSUB �����ʿ�����70����
    DELAY 200
    GOSUB �����ʿ�����70����
    DELAY 200
    GOSUB �����ʿ�����70����
    DELAY 200
    GOSUB �����ʿ�����70����
    DELAY 200
    GOSUB �����ʿ�����70����
    DELAY 200


    GOSUB �⺻�ڼ�2

    GOSUB ��������60
    DELAY 300

    GOSUB ��������45

    SPEED �Ӹ��̵��ӵ�
    SERVO 16,30	
    SPEED 5
    GOSUB �⺻�ڼ�

    RETURN

    '************************************************

��������_TEST:

    GOSUB �⺻�ڼ�

    IF D=1 THEN


        MOVE G6B, 100,  85,  21,  ,  ,
        MOVE G6C, 101,  93, 104, 100, 100, 100
        WAIT

        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200

        GOSUB �⺻�ڼ�2

        GOSUB ������45
        GOSUB ������60

    ELSEIF D=2 THEN

        MOVE G6C, 100,  85,  21,  ,  ,
        MOVE G6B, 101,  93, 104, 100, 100, 100
        WAIT

        GOSUB �����ʿ�����70����'�������ȵ� ������
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200

        GOSUB �⺻�ڼ�2

        GOSUB ��������45
        DELAY 300
        GOSUB ��������60

    ENDIF

    RETURN





�������_������:

    ETX 4800,194
    DELAY 500
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
    ENDIF
    DELAY 300

�������_������_2:
    ERX 4800,A,�������_������_2

    IF A=163 THEN
        GOSUB ���ʿ�����20
        DELAY 1000
        GOTO �������_������


    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        DELAY 1000
        GOTO �������_������

    ELSEIF A=161 THEN
        GOSUB ������3
        DELAY 1000
        GOTO �������_������

    ELSEIF A=162 THEN
        GOSUB ��������3
        DELAY 1000
        GOTO �������_������

    ELSEIF A=160 THEN
        GOSUB ��������_�ѿ�����
        DELAY 1000
        GOTO �������_������


    ELSEIF A=170 THEN
        GOTO ���⼳��


    ELSEIF A = 26 THEN
        GOTO MAIN

    ELSE
        GOTO �������_������_2

    ENDIF
    GOTO RX_EXIT


���⼳��:
    GOSUB ��������_�ѹ�
    DELAY 300
    GOSUB ��������_�ѹ�
    DELAY 500
    SPEED �Ӹ��̵��ӵ�
    SERVO 16,90	
    SPEED 5
    GOSUB �⺻�ڼ�
    DELAY 2000

���⼳��_1:



    ETX 4800, 180

    DELAY 500

    ERX 4800,A,���⼳��_1

    IF A=155 THEN
        D=1
        GOSUB ��������_�ѿ�����
        GOSUB ��������_�ѿ�����
        GOSUB ��������_�ѿ�����
        DELAY 500
        GOSUB ������45
        GOSUB ������45

    ELSEIF A=156 THEN
        D=2
        GOSUB �⺻�ڼ�

        SPEED �Ӹ��̵��ӵ�
        SERVO 16,30	
        SPEED 5

        GOSUB ��������_�ѿ�����
        GOSUB ��������_�ѿ�����
        GOSUB ��������_�ѿ�����
        DELAY 500
        GOSUB ��������45
        GOSUB ��������45
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO ���⼳��_1


    ENDIF


    DELAY 200
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
    ENDIF
    DELAY 300

    SPEED �Ӹ��̵��ӵ�
    SERVO 16,30	
    SPEED 5

    GOTO �������_MAIN
    'GOTO �������_MAIN


�������_MAIN:


    ETX 4800,190
    DELAY 500
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
    ENDIF
    DELAY 300

�������_MAIN_2:
    ERX 4800,A,�������_MAIN
    IF A=163 THEN
        GOSUB ���ʿ�����20
        DELAY 300
        GOTO �������_MAIN

    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        DELAY 300
        GOTO �������_MAIN

    ELSEIF A=161 THEN
        GOSUB ������3
        DELAY 300
        GOTO �������_MAIN

    ELSEIF A=162 THEN
        GOSUB ��������3
        DELAY 300
        GOTO �������_MAIN

    ELSEIF A=160 THEN
        GOSUB ������������
        DELAY 300
        GOTO �������_MAIN_3
    ELSEIF A=170 THEN
        GOSUB ������������
        DELAY 300
        GOTO �������_MAIN_3
    ELSEIF A=210 THEN
        GOSUB ������������
        DELAY 300
        GOTO �������_MAIN_3

    ELSEIF A=26 THEN
        GOTO MAIN


    ELSE
        GOTO �������_MAIN


    ENDIF
    GOTO RX_EXIT

�������_MAIN_3:

    ETX 4800,190
    DELAY 500
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
    ENDIF
    DELAY 300

�������_MAIN_4:
    ERX 4800,A,�������_MAIN_3
    IF A=163 THEN
        GOSUB ���ʿ�����20
        DELAY 300
        GOTO �������_MAIN_3

    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        DELAY 300
        GOTO �������_MAIN_3

    ELSEIF A=161 THEN
        GOSUB ������3
        DELAY 300
        GOTO �������_MAIN_3

    ELSEIF A=162 THEN
        GOSUB ��������3
        DELAY 300
        GOTO �������_MAIN_3

    ELSEIF A=160 THEN
        DELAY 300
        GOSUB ������������
        GOTO �������_MAIN_3

    ELSEIF A=170 THEN
        GOTO �̼�_2_START

    ELSEIF A=210 THEN
        GOTO �������_FINAL_0

    ELSEIF A=26 THEN
        GOTO MAIN


    ELSE
        GOTO �������_MAIN_3


    ENDIF
    GOTO RX_EXIT

�������_FINAL_0:
    ETX 4800,190
    DELAY 500
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
    ENDIF
    DELAY 300

�������_FINAL:

    ERX 4800,A,�������_FINAL_0
    IF A=163 THEN
        GOSUB ���ʿ�����20
        DELAY 300
        GOTO �������_FINAL_0

    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        DELAY 300
        GOTO �������_FINAL_0

    ELSEIF A=161 THEN
        GOSUB ������3
        DELAY 300
        GOTO �������_FINAL_0

    ELSEIF A=162 THEN
        GOSUB ��������3
        DELAY 300
        GOTO �������_FINAL_0

    ELSEIF A=210 THEN
        DELAY 300
        GOSUB ��������_�ѿ޹�
        GOTO �������_FINAL_0

    ELSEIF A=172 THEN
        GOTO FINAL

    ELSEIF A=26 THEN
        GOTO MAIN


    ELSE
        GOTO �������_FINAL_0


    ENDIF
    GOTO RX_EXIT







�̼�_2_START: '�Ӹ�������



    IF D=1 THEN
        SERVO 16,60
        SERVO 11,40
        DELAY 1500
    ELSEIF D=2 THEN
        SERVO 16,60
        SERVO 11,160
        DELAY 1500
    ENDIF

�̼�_2_START_1: '�����ν�

    ETX 4800, 181
    ERX 4800,A,�̼�_2_START_1
    IF A=201 THEN
        REGION= 1 '��������
        PRINT "SOUND 61 !"
        DELAY 300
        SPEED �Ӹ��̵��ӵ�
        SERVO 16,100
        SERVO 11,100	
        SPEED 5
        GOSUB �⺻�ڼ�
        GOTO �̼�_2_START_2
    ELSEIF A=202 THEN
        REGION=2 'Ȯ������
        PRINT "SOUND 62 !"
        DELAY 300
        SPEED �Ӹ��̵��ӵ�
        SERVO 16,100
        SERVO 11,100	
        SPEED 5
        GOSUB �⺻�ڼ�
        GOTO �̼�_2_START_2
    ELSE
        GOTO �̼�_2_START_1
    ENDIF

    GOTO RX_EXIT

�̼�_2_START_2:
    DELAY 500

    ETX 4800, 182

    ERX 4800,A,�̼�_2_START_2

    IF A=171 THEN '�����ν� �Ϸ��  ����


        GOTO �̼�_2_START_3

    ELSEIF A=26 THEN
        GOTO MAIN

    ELSE
        GOTO �̼�_2_START_2

    ENDIF

�̼�_2_START_3:

    IF D=1 THEN
        GOSUB ������60
        DELAY 500
    ELSEIF D=2 THEN
        GOSUB ��������60
        DELAY 500
    ENDIF
    GOTO �̼�_2_FIND

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

�̼�_2_FIND:
    SPEED �Ӹ��̵��ӵ�
    SERVO 16,60
    SERVO 11,100	
    SPEED 5
    GOSUB �⺻�ڼ�
    PACK_FIND=0
    DELAY 1500 'Delay Fix'


�̼�_2_FIND_1_1: '��ü�߰�

    ETX 4800,160
    DELAY 2000 'Delay Fix'
    '�̼�_2_FIND_1_1:


    ERX 4800,A,�̼�_2_FIND_1_1

    IF A=203 THEN '��ü�̹߽߰� ����Ȯ��
        SPEED �Ӹ��̵��ӵ�
        SERVO 11,50
        SPEED 5
        GOSUB �⺻�ڼ�
        A=200

        GOTO �̼�_2_FIND_2_1

    ELSEIF A=130 THEN '��ü�߰�
        IF PACK_FIND=0 THEN
            TURN=0
            GOSUB CHECK_POSITION
        ENDIF

        SPEED �Ӹ��̵��ӵ�
        SERVO 16,60
        SERVO 11,100	
        SPEED 5
        GOSUB �⺻�ڼ�
        ����COUNT=0
        GOTO �̼�_2_MAIN

    ELSEIF A=26 THEN
        GOTO MAIN

    ELSE
        GOTO �̼�_2_FIND_1_1

    ENDIF

    GOTO RX_EXIT

�̼�_2_FIND_2_1:

    ETX 4800,161
    DELAY 2000 'Delay Fix'
    '�̼�_2_FIND_2_1:
    ERX 4800,A,�̼�_2_FIND_2_1

    IF A=204 THEN '��ü�̹߽߰� ������Ȯ��
        SPEED �Ӹ��̵��ӵ�
        SERVO 11,150
        SPEED 5
        GOSUB �⺻�ڼ�
        DELAY 1000
        A=200
        GOTO �̼�_2_FIND_3_1

    ELSEIF A=131 THEN '��ü�߽߰�
        IF PACK_FIND=0 THEN
            GOSUB ������45
            TURN=1
        ELSEIF PACK_FIND=1 THEN
            GOSUB ���ʿ�����70����
            DELAY 500
            GOSUB ���ʿ�����70����
            DELAY 500
        ENDIF

        SPEED �Ӹ��̵��ӵ�
        SERVO 16,60
        SERVO 11,100	
        SPEED 5
        GOSUB �⺻�ڼ�
        PACK_FIND=1
        DELAY 1500 'Delay Fix'

        GOTO �̼�_2_FIND_1_1

    ELSEIF A=26 THEN
        GOTO MAIN

    ELSE
        GOTO �̼�_2_FIND_2_1

    ENDIF

    GOTO RX_EXIT

�̼�_2_FIND_3_1:


    ETX 4800,162
    DELAY 2000 'Delay Fix'
    ERX 4800,A,�̼�_2_FIND_3_1

    IF A=205 THEN '��ü�̹߽߰� �߾�Ȯ��

        SPEED �Ӹ��̵��ӵ�
        SERVO 11,100
        SPEED 5
        GOSUB �⺻�ڼ�
        A=200
        DELAY 1000
        GOTO �̼�_2_FIND_1_1


    ELSEIF A=132 THEN '��ü�߽߰�
        IF PACK_FIND=0 THEN
            GOSUB ��������45
            TURN=2
        ELSEIF PACK_FIND=1 THEN
            GOSUB �����ʿ�����70����
            DELAY 500
            GOSUB �����ʿ�����70����
            DELAY 500
        ENDIF
        SPEED �Ӹ��̵��ӵ�
        SERVO 16,60
        SERVO 11,100	
        SPEED 5
        GOSUB �⺻�ڼ�
        PACK_FIND=1
        DELAY 1500 'Delay Fix'

        GOTO �̼�_2_FIND_1_1

    ELSEIF A=26 THEN
        GOTO MAIN

    ELSE
        GOTO �̼�_2_FIND_3_1

    ENDIF

    GOTO RX_EXIT



�̼�_2_MAIN: '��ü����
    ETX 4800,184
    DELAY 500
    ERX 4800,A,�̼�_2_MAIN
    IF A=163 THEN
        GOSUB ���ʿ�����20
        'DELAY 500
        GOTO �̼�_2_MAIN

    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        ' DELAY 500
        GOTO �̼�_2_MAIN

    ELSEIF A=161 THEN
        GOSUB ������3
        'DELAY 500
        GOTO �̼�_2_MAIN

    ELSEIF A=162 THEN
        GOSUB ��������3
        'DELAY 500
        GOTO �̼�_2_MAIN

    ELSEIF A=160 THEN
        'DELAY 500
        GOSUB ��������_�ѿ�����
        ����COUNT=����COUNT+1
        GOTO �̼�_2_MAIN



    ELSEIF A=165 THEN
        'DELAY 500
        SPEED 3

        SERVO 16, 10
        DELAY 500
        GOTO �̼�_2_MAIN    	

    ELSEIF A=125 THEN '��ü��ġ������
    	DELAY 500
        GOTO ������_1

    ELSEIF A=206 THEN '�þ߿� ���� �ȵ�������
        GOSUB ��������_�ѹ�
        GOTO �̼�_2_MAIN


    ELSEIF A=26 THEN
        GOTO MAIN

    ELSE
        GOTO �̼�_2_MAIN


    ENDIF
    GOTO RX_EXIT



������_1:
    ETX 4800, 101

    GOSUB �⺻�ڼ�

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
        IF ����COUNT<9 THEN
            GOSUB ��������_�ѿ�����
            DELAY 500
            ����COUNT=����COUNT+1
            IF ����COUNT<9 THEN
                GOTO COUNT_CHECK
            ELSE
                IF TURN=2 THEN
                    GOSUB ���ʿ�����70����
                    DELAY 200
                    GOSUB ���ʿ�����70����
                    DELAY 200
                    GOSUB ���ʿ�����70����
                    DELAY 200
                    GOSUB ���ʿ�����70����
                    DELAY 200
                    GOSUB ���ʿ�����70����
                    DELAY 200
                    GOTO ������_2_����
                ELSEIF TURN=1 THEN
                    GOSUB �����ʿ�����70����
                    DELAY 200
                    GOSUB �����ʿ�����70����
                    DELAY 200
                    GOSUB �����ʿ�����70����
                    DELAY 200
                    GOSUB �����ʿ�����70����
                    DELAY 200
                    GOSUB �����ʿ�����70����
                    DELAY 200
                    GOTO ������_2_����
                ELSEIF TURN=0 THEN
                    GOTO ������_2_����
                ENDIF


            ENDIF
        ENDIF
    ELSEIF REGION=2 THEN

        IF TURN=1 THEN
            GOSUB �����������45
            DELAY 500
        ELSEIF TURN=2 THEN
            GOSUB ���������45
            DELAY 500
        ENDIF

        GOSUB ���������60
        DELAY 500
        GOSUB ���������60
        DELAY 500
        GOSUB ���������60
        DELAY 500

        SERVO 16,60
        DELAY 1500
        TURN_COUNT=0
        GOTO ������_2_Ȯ��_TEST
    ENDIF


������_2_����:

    ETX 4800,186
    DELAY 500
    ERX 4800,A,������_2_����

    IF A=160 THEN
        IF TURN=2 THEN
            GOSUB ���ʿ�����70����
        ELSEIF TURN=1 THEN
            GOSUB �����ʿ�����70����
        ELSEIF TURN=0 THEN
            IF POSITION=1 THEN 'LEFT
                GOSUB �����ʿ�����70����
            ELSEIF POSITION=2 THEN 'RIGHT
                GOSUB ���ʿ�����70����
            ENDIF
        ENDIF


        GOTO ������_2_����
    ELSEIF A=165 THEN

        GOSUB �ѳ���
        GOSUB ��������_TEST
        IF TURN=1 THEN
            GOSUB ��������45
            DELAY 300
        ELSEIF TURN=2 THEN
            GOSUB ������45
            DELAY 300
        ENDIF
        GOSUB ������60
        DELAY 500
        GOSUB ������60
        DELAY 500
        GOSUB ������60
        DELAY 500
        SERVO 16,60
        DELAY 500
        GOTO �ѳ���_����_����


    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO ������_2_����

    ENDIF
    GOTO RX_EXIT

������_2_Ȯ��_TEST:
    ETX 4800,191
    DELAY 500
    ERX 4800,A,������_2_Ȯ��_TEST
    IF A=163 THEN
        GOSUB ���ʿ�����20
        TURN_COUNT=TURN_COUNT+1
        'DELAY 500
        IF TURN_COUNT>=5 THEN
            GOTO ������_2_Ȯ��_TEST_2
        ELSE
            GOTO ������_2_Ȯ��_TEST
        ENDIF

    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        ' DELAY 500
        TURN_COUNT=TURN_COUNT+1
        'DELAY 500
        IF TURN_COUNT>=5 THEN
            GOTO ������_2_Ȯ��_TEST_2
        ELSE
            GOTO ������_2_Ȯ��_TEST
        ENDIF

    ELSEIF A=161 THEN
        GOSUB ������3
        'DELAY 500
        TURN_COUNT=TURN_COUNT+1
        'DELAY 500
        IF TURN_COUNT>=5 THEN
            GOTO ������_2_Ȯ��_TEST_2
        ELSE
            GOTO ������_2_Ȯ��_TEST
        ENDIF

    ELSEIF A=162 THEN
        GOSUB ��������3
        'DELAY 500
        TURN_COUNT=TURN_COUNT+1
        'DELAY 500
        IF TURN_COUNT>=5 THEN
            GOTO ������_2_Ȯ��_TEST_2
        ELSE
            GOTO ������_2_Ȯ��_TEST
        ENDIF
    ELSEIF A=160 THEN
        GOSUB ��������_�ο�����
        TURN_COUNT=TURN_COUNT+1
        'DELAY 500
        IF TURN_COUNT>=5 THEN
            GOTO ������_2_Ȯ��_TEST_2
        ELSE
            GOTO ������_2_Ȯ��_TEST
        ENDIF
    ELSEIF A=165 THEN
        GOTO �ѳ���_0

    ELSEIF A=169 THEN
        SERVO 16,50
        DELAY 2000
        GOTO ������_2_Ȯ��_TEST_2
    ELSEIF A=173 THEN
        GOSUB ���������20
        DELAY 3000
        GOTO ������_2_Ȯ��_TEST
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO ������_2_Ȯ��_TEST
    ENDIF


    GOTO RX_EXIT

������_2_Ȯ��_TEST_2:
    ETX 4800,191
    DELAY 500
    ERX 4800,A,������_2_Ȯ��_TEST_2
    IF A=163 THEN
        GOSUB ���ʿ�����20
        'DELAY 500
        GOTO ������_2_Ȯ��_TEST_2

    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        ' DELAY 500
        GOTO ������_2_Ȯ��_TEST_2

    ELSEIF A=161 THEN
        GOSUB ������3
        'DELAY 500
        GOTO ������_2_Ȯ��_TEST_2
    ELSEIF A=162 THEN
        GOSUB ��������3
        'DELAY 500
        GOTO ������_2_Ȯ��_TEST_2
    ELSEIF A=160 THEN
        GOSUB ��������_�ο�����
        GOTO ������_2_Ȯ��_TEST_2
    ELSEIF A=165 THEN
        GOSUB �ѳ���_0
        GOTO ������_2_Ȯ��_TEST_2
    ELSEIF A=169 THEN
        SERVO 16,45
        DELAY 2000
        GOTO ������_2_Ȯ��_TEST_2
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO ������_2_Ȯ��_TEST_2
    ENDIF


    GOTO RX_EXIT


�ѳ���_0:

    IF D=1 THEN
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �ѳ���
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200

    ELSEIF D=2 THEN

        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB ���ʿ�����70����
        DELAY 200
        GOSUB �ѳ���
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200
        GOSUB �����ʿ�����70����
        DELAY 200

    ENDIF

    SERVO 16,20
    DELAY 500

    GOTO �ѳ���_����



������_2_Ȯ��:

    ETX 4800,185
    DELAY 500
    ERX 4800,A,������_2_Ȯ��
    IF A=160 THEN
        GOTO ��������_0
    ELSEIF A=165 THEN
        GOTO �ѳ���
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO ������_2_Ȯ��
    ENDIF


    GOTO RX_EXIT


�ѳ���:
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

    GOSUB �⺻�ڼ�

    RETURN

�ѳ���_����_����:


    ETX 4800,191
    DELAY 500
    ERX 4800,A,�ѳ���_����_����

    IF A=163 THEN
        GOSUB ���ʿ�����20
        'DELAY 500
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO �ѳ���_����_����_2
        ELSE
            GOTO �ѳ���_����_����
        ENDIF


    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        ' DELAY 500
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO �ѳ���_����_����_2
        ELSE
            GOTO �ѳ���_����_����
        ENDIF

    ELSEIF A=161 THEN
        GOSUB ������3
        'DELAY 500
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO �ѳ���_����_����_2
        ELSE
            GOTO �ѳ���_����_����
        ENDIF

    ELSEIF A=162 THEN
        GOSUB ��������3
        'DELAY 500
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO �ѳ���_����_����_2
        ELSE
            GOTO �ѳ���_����_����
        ENDIF
    ELSEIF A=160 THEN
        GOSUB ��������_�ο�����
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO �ѳ���_����_����_2
        ELSE
            GOTO �ѳ���_����_����
        ENDIF
    ELSEIF A=165 THEN
        SERVO 16,30
        DELAY 2000
        GOTO �ѳ���_����
    ELSEIF A=169 THEN
        SERVO 16,45
        DELAY 2000
        TURN_COUNT=TURN_COUNT+1
        IF TURN_COUNT>=5 THEN
            GOTO �ѳ���_����_����_2
        ELSE
            GOTO �ѳ���_����_����
        ENDIF
    ELSEIF A=173 THEN
        GOSUB ���������20
        DELAY 3000
        GOTO �ѳ���_����_����
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO �ѳ���_����_����
    ENDIF


�ѳ���_����_����_2:

    ETX 4800,191
    DELAY 500
    ERX 4800,A,�ѳ���_����_����

    IF A=163 THEN
        GOSUB ���ʿ�����20
        'DELAY 500
        GOTO �ѳ���_����_����_2

    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        ' DELAY 500
        GOTO �ѳ���_����_����_2

    ELSEIF A=161 THEN
        GOSUB ������3
        'DELAY 500
        GOTO �ѳ���_����_����_2

    ELSEIF A=162 THEN
        GOSUB ��������3
        'DELAY 500
        GOTO �ѳ���_����_����_2
    ELSEIF A=160 THEN
        GOSUB ��������_�ο�����
        GOTO �ѳ���_����_����_2
    ELSEIF A=165 THEN
        SERVO 16,30
        DELAY 2000
        GOTO �ѳ���_����
    ELSEIF A=169 THEN
        SERVO 16,45
        DELAY 2000
        GOTO �ѳ���_����_����_2
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO �ѳ���_����_����_2
    ENDIF


�ѳ���_����:

    ETX 4800,195
    DELAY 500
    ERX 4800,A,�ѳ���_����
    IF A=163 THEN
        GOSUB ���ʿ�����20
        'DELAY 500
        GOTO �ѳ���_����

    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        ' DELAY 500
        GOTO �ѳ���_����

    ELSEIF A=161 THEN
        GOSUB ������3
        'DELAY 500
        GOTO �ѳ���_����

    ELSEIF A=162 THEN
        GOSUB ��������3
        'DELAY 500
        GOTO �ѳ���_����
    ELSEIF A=160 THEN
        GOSUB ��������_�ο�����
        GOTO �ѳ���_����

    ELSEIF A=165 THEN


        IF D=1 THEN
            GOTO LINE_CHECK_LEFT_0
        ELSEIF D=2 THEN
            GOTO LINE_CHECK_RIGHT_0
        ENDIF
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO �ѳ���_����
    ENDIF
LINE_CHECK_LEFT_0:
    SERVO 16,30
    DELAY 3000

LINE_CHECK_LEFT:
    ETX 4800,192
    DELAY 500
    ERX 4800,A,LINE_CHECK_LEFT
    IF A=169 THEN '���ʸ�������
        GOTO ONE_LINE_LEFT
    ELSEIF A=159 THEN '���� 2������ ��
        GOSUB ������3
        DELAY 300
        GOTO LINE_CHECK_LEFT
    ELSEIF A=179 THEN '�¿� ��� ������
        GOSUB ������45
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
    IF A=157 THEN '���ʿ� ������
        SERVO 11,100
        SERVO 16,30
        GOTO �������_MAIN
    ELSEIF A=158 THEN '���ʿ� ������
        GOSUB ������45
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
    IF A=169 THEN '���ʸ�������
        GOTO ONE_LINE_RIGHT
    ELSEIF A=159 THEN '���� 2������ ��
        GOSUB ��������3
        DELAY 300
        GOTO LINE_CHECK_RIGHT
    ELSEIF A=179 THEN '�¿� ��� ������
        GOSUB ��������45
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
    IF A=157 THEN '�����ʿ� ������
        SERVO 11,100
        SERVO 16,30
        GOTO �������_MAIN
    ELSEIF A=158 THEN '�����ʿ� ������
        GOSUB ��������45
        SERVO 11, 100
        SERVO 16,30
        DELAY 3000
        GOTO LINE_CHECK_RIGHT
    ELSEIF A=26 THEN
        GOTO MAIN
    ELSE
        GOTO ONE_LINE_RIGHT

    ENDIF


������3_Ű:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������3_LOOP_Ű:

    IF ������� = 0 THEN
        ������� = 1
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
        ������� = 0
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
    GOSUB �⺻�ڼ�2


    GOTO RX_EXIT


���ʿ�����20_Ű: '****
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
    GOSUB �⺻�ڼ�2
    GOSUB All_motor_mode3

    GOTO RX_EXIT

�ѹ߾����ΰ���:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON

    IF �������=1 THEN

        �������= 0
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

        �������= 1
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
    GOSUB ��������_TEST
    SERVO 16,30
    GOTO FINAL_0_BEFORE
    'IF D = 1 THEN
    '        GOSUB ��������_�ѿ�����
    '        DELAY 300
    '        GOSUB ������45
    '        DELAY 500
    '        GOSUB ������60
    '        GOTO FINAL_2
    '    ELSEIF D = 2 THEN
    '        GOSUB ��������_�ѿ޹�
    '        DELAY 300
    '        GOSUB ��������45
    '        DELAY 500
    '        GOSUB ��������60
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
    '        GOSUB ���ʿ�����20
    '        DELAY 500
    '        GOTO FINAL_2
    '
    '    ELSEIF A=164 THEN
    '        GOSUB �����ʿ�����20
    '        DELAY 500
    '        GOTO FINAL_2
    '
    '    ELSEIF A=161 THEN
    '        GOSUB ������3
    '        DELAY 500
    '        GOTO FINAL_2
    '
    '    ELSEIF A=162 THEN
    '        GOSUB ��������3
    '        DELAY 500
    '        GOTO FINAL_2
    '
    '    ELSEIF A=160 THEN
    '        DELAY 500
    '        GOSUB ��������_�ο�����
    '        GOSUB ��������_�ο޹�
    '        GOSUB ��������_TEST
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
        GOSUB ���ʿ�����20
        DELAY 500
        GOTO FINAL_0_BEFORE

    ELSEIF A=164 THEN
        GOSUB �����ʿ�����20
        DELAY 500
        GOTO FINAL_0_BEFORE


    ELSEIF A=161 THEN
        GOSUB ������3
        DELAY 500
        GOTO FINAL_0_BEFORE

    ELSEIF A=162 THEN
        GOSUB ��������3
        DELAY 500
        GOTO FINAL_0_BEFORE

    ELSEIF A=160 THEN
        GOSUB ��������_�ο�����
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
MAIN: '�󺧼���


    ETX 4800, 38 ' ���� ���� Ȯ�� �۽� ��

MAIN_2:

    'GOSUB �յڱ�������
    'GOSUB �¿��������
    GOSUB ���ܼ��Ÿ�����Ȯ��


    ERX 4800,A,MAIN_2	

    A_old = A

    '**** �Էµ� A���� 0 �̸� MAIN �󺧷� ����
    '**** 1�̸� KEY1 ��, 2�̸� key2��... ���¹�
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
        GOSUB �⺻�ڼ�

    ENDIF


    GOTO MAIN	
    '*******************************************
    '		MAIN �󺧷� ����
    '*******************************************

KEY1:
    ETX  4800,1
    GOTO �̼�_1_0
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

    '����Ƚ�� = 6
    'GOTO Ƚ��_������������


    GOTO RX_EXIT
    '***************
KEY3:
    ETX  4800,3
    'SPEED 3
    '    Q=30
    '    SERVO 16, Q
    D=1

    GOTO �̼�_2_START

    GOTO RX_EXIT
    '***************
KEY4:
    ETX  4800,4
    GOSUB ��������_�ѿ޹�
    'SPEED 3
    '    Q=40
    '    SERVO 16, Q
    '    'GOSUB �̼�_2_FIND
    '
    GOTO RX_EXIT
    '***************
KEY5:
    ETX  4800,5
    GOSUB ��������_�ѿ�����
    'SPEED 3
    '    Q=50
    '    SERVO 16, Q
    '
    '    ' J = AD(���ܼ�AD��Ʈ)	'���ܼ��Ÿ��� �б�
    '    '    BUTTON_NO = J
    '    '    GOSUB Number_Play
    '    '    GOSUB SOUND_PLAY_CHK
    '    '    GOSUB GOSUB_RX_EXIT
    '    '
    GOTO RX_EXIT
    '***************
KEY6:
    ETX  4800,6
    GOSUB ��������_�ο޹�
    'SPEED 3
    '    Q=60
    '    SERVO 16, Q
    '    'GOTO ��������3
    '
    '
    GOTO RX_EXIT
    '***************
KEY7:
    ETX  4800,7
    GOSUB ��������_�ο�����
    'SPEED 3
    '    Q=70
    '    SERVO 16, Q
    '    ' GOTO ���⼳��
    '


    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOSUB ������60
    'SPEED 3
    '    Q=80
    '    SERVO 16, Q
    '    'GOTO ������������

    GOTO RX_EXIT
    '***************
KEY9:
    ETX  4800,9
    GOSUB ��������60
    'SPEED 3
    '    Q=90
    '    SERVO 16, Q
    '    'GOTO ��������20


    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10
    GOSUB ���������20
    'SPEED 3
    '    Q=100
    '    SERVO 16, Q
    '    'GOTO �ѳ���


    GOTO RX_EXIT
    '***************
KEY11: ' ��
    ETX  4800,11
    GOSUB �����������20
    '�������=0
    '
    '    GOSUB ��������_TEST

    GOTO RX_EXIT
    '***************
KEY12: ' ��
    ETX  4800,12


    GOTO ��������




    GOTO RX_EXIT
    '***************
KEY13: '��
    ETX  4800,13
    'GOTO �Ӹ���������


    GOTO RX_EXIT
    '***************
KEY14: ' ��
    ETX  4800,14
    GOTO ������_1
    'GOTO ��



    GOTO RX_EXIT
    '***************
KEY15: ' A
    ETX  4800,15
    ' GOTO ���ʿ�����20_Ű
    GOSUB ��������_�ѿ�����


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
    GOSUB �����ڼ�	
    GOSUB ������

    GOSUB MOTOR_GET
    GOSUB MOTOR_OFF


    GOSUB GOSUB_RX_EXIT
KEY16_1:

    IF ����ONOFF = 1  THEN
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


    IF  A = 16 THEN 	'�ٽ� �Ŀ���ư�� �����߸� ����
        GOSUB MOTOR_ON
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT

        GOSUB �⺻�ڼ�2
        GOSUB ���̷�ON
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOSUB GOSUB_RX_EXIT
    GOTO KEY16_1



    GOTO RX_EXIT
    '***************
KEY17: ' C
    ETX  4800,17
    'GOTO �Ӹ�����90��

    GOTO �̼�_2_START


    GOTO RX_EXIT
    '***************
KEY18: ' E
    ETX  4800,18	

    GOSUB ���̷�OFF
    GOSUB ������
KEY18_wait:

    ERX 4800,A,KEY18_wait	

    IF  A = 26 THEN
        GOSUB ������
        GOSUB ���̷�ON
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
    GOTO �����ʿ�����20


    GOTO RX_EXIT
    '***************
KEY21: ' ��
    ETX  4800,21
    GOTO �Ӹ��¿��߾�

    GOTO RX_EXIT
    '***************
KEY22: ' *	
    ETX  4800,22
    GOTO ������45

    GOTO RX_EXIT
    '***************
KEY23: ' G
    ETX  4800,23
    GOSUB ������
    GOSUB All_motor_mode2
KEY23_wait:


    ERX 4800,A,KEY23_wait	

    IF  A = 26 THEN
        GOSUB ������
        GOSUB All_motor_mode3
        GOTO RX_EXIT
    ENDIF

    GOTO KEY23_wait


    GOTO RX_EXIT
    '***************
KEY24: ' #
    ETX  4800,24
    GOSUB ������������

    GOTO RX_EXIT
    '***************
KEY25: ' P1
    ETX  4800,25
    GOTO ������60

    GOTO RX_EXIT
    '***************
KEY26: ' ��
    ETX  4800,26

    SPEED 5
    GOSUB �⺻�ڼ�2	
    TEMPO 220
    MUSIC "ff"
    GOSUB �⺻�ڼ�
    GOTO RX_EXIT
    '***************
KEY27: ' D
    ETX  4800,27
    GOTO �������_MAIN


    GOTO RX_EXIT
    '***************
KEY28: ' ��
    ETX  4800,28
    GOTO �Ӹ�����45��


    GOTO RX_EXIT
    '***************
KEY29: ' ��
    ETX  4800,29

    GOSUB ��������80��

    GOTO RX_EXIT
    '***************
KEY30: ' ��
    ETX  4800,30
    GOTO �Ӹ�������45��

    GOTO RX_EXIT
    '***************
KEY31: ' ��
    ETX  4800,31
    GOSUB �Ӹ��ִ�����


    GOTO RX_EXIT
    '***************

KEY32: ' F
    ETX  4800,32
    'GOTO �Ӹ��߰�����
    GOSUB ��������_�ѹ�
    GOTO RX_EXIT
    '***************
