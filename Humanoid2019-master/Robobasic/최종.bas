2'******** 2�� ����κ� �ʱ� ���� ���α׷� ********

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
DIM aaa AS BYTE
DIM ���̷�ONOFF AS BYTE
DIM ����յ� AS INTEGER
DIM �����¿� AS INTEGER

DIM ����� AS BYTE
DIM STEPNUM AS BYTE
DIM �Ѿ���Ȯ�� AS BYTE
DIM ����Ȯ��Ƚ�� AS BYTE
DIM ����Ƚ�� AS BYTE
DIM ����COUNT AS BYTE

DIM ���ܼ��Ÿ���  AS BYTE

DIM �̼Ǽ��� AS BYTE
DIM ff  AS BYTE
DIM ���� AS BYTE

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

'**** ���⼾����Ʈ ���� ****
CONST �յڱ���AD��Ʈ = 0
CONST �¿����AD��Ʈ = 1
CONST ����Ȯ�νð� = 10  'ms

CONST min = 61	'�ڷγѾ�������
CONST max = 107	'�����γѾ�������
CONST COUNT_MAX = 3


CONST �Ӹ��̵��ӵ� = 10
CONST LOW =103 ' ����� ���� �� �߽� '�����߰� 128
CONST HIGH = 153
DIM �����������ð�  AS INTEGER
�����������ð� =1000
DIM delayy AS INTEGER '�������� �߰��߰��� delay��
delayy = 50
DIM turn AS INTEGER
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
'����Ƚ�� = 1
����ONOFF = 0

'****�ʱ���ġ �ǵ��*****************************


TEMPO 230
MUSIC "cdefg"



SPEED 5
GOSUB MOTOR_ON

S11 = MOTORIN(11)
'S16 = MOTORIN(16)


S16 = 30

SERVO 11, 100
SERVO 16, S16



GOSUB �����ʱ��ڼ�
GOSUB �⺻�ڼ�


GOSUB ���̷�INIT
GOSUB ���̷�MID
GOSUB ���̷�ON



PRINT "VOLUME 200 !"

GOSUB All_motor_mode3

'DELAY 3000
'GOSUB Ƚ��_������������m


GOTO MAIN 	'�ø��� ���� ��ƾ���� ����

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
�����ʱ��ڼ�:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    WAIT
    mode = 0
    RETURN
    '************************************************
�����_����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90,,100

    WAIT
    mode = 0

    RETURN
    '******************************************	
����ȭ�ڼ�:
    MOVE G6A,98,  76, 145,  93, 101, 100
    MOVE G6D,98,  76, 145,  93, 101, 100
    MOVE G6B,100,  35,  90,
    MOVE G6C,100,  35,  90
    SERVO 16, 30
    WAIT
    mode = 0

    RETURN

    '************************************************
�⺻�ڼ�:


    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,  30,  80,
    MOVE G6C,100,  30,  80,
    SERVO 16, 30
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
    SERVO 16, 30
    mode = 0
    RETURN
    '******************************************	
�⺻�ڼ�3:
    MOVE G6A,100,  76, 145,  93, 100, 100
    MOVE G6D,100,  76, 145,  93, 100, 100
    MOVE G6B,100,30, 80
    MOVE G6C,100,30,80,,100
    WAIT
    'SERVO 16, 30
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
    '**********************************************
RX_EXIT:

    ERX 4800, A, �����ڵ�_2

    GOTO RX_EXIT
    '**********************************************

GOSUB_RX_EXIT:

    ERX 4800, A, GOSUB_RX_EXIT2

    GOTO GOSUB_RX_EXIT

GOSUB_RX_EXIT2:
    RETURN
    '**********************************************
    '**********************************************
��ġ���:

    SERVO 16, 100
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
'**************************


��������:
    ����COUNT = 0
    ����ӵ� = 13
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3

    IF ������� = 0 THEN
        ������� = 1

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


        GOTO ��������_1	
    ELSE
        ������� = 0

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


        GOTO ��������_2	

    ENDIF


    '*******************************


��������_1:

    ETX 4800,11 '�����ڵ带 ����
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

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ��������_2
    IF A = 11 THEN
        GOTO ��������_2
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
        GOSUB �⺻�ڼ�2

        GOTO RX_EXIT
    ENDIF
    '**********

��������_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

��������_3:
    ETX 4800,11 '�����ڵ带 ����

    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF

    ERX 4800,A, ��������_4
    IF A = 11 THEN
        GOTO ��������_4
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
        GOSUB �⺻�ڼ�2

        GOTO RX_EXIT
    ENDIF

��������_4:
    '�޹ߵ��10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO ��������_1
    '*******************************
    '**********************************************
    '**********************************************
����_1:
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


    GOSUB ���̷�OFF

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
    GOSUB �⺻�ڼ�
    GOSUB ���̷�ON
    RETURN

    '*********************************************
�����ڵ�:
    ETX 4800, 38
    PRINT "VOLUME 200 !"

�����ڵ�_2:
    IF �̼Ǽ���>0 THEN GOTO �����ڵ�_3
    SERVO 16, 30
    GOSUB �յڱ�������
    GOSUB �¿��������
    GOSUB ���ܼ��Ÿ�����Ȯ��
    ETX 4800,107
    GOSUB Ƚ��_������������m
    ''	GOSUB Ƚ��_������������m
    ''	GOSUB Ƚ��_������������m
    ''	GOSUB Ƚ��_������������m
    ff = 0
aa:
    ff = ff + 1
    IF ff > 5 THEN GOTO �����ڵ�_2
    DELAY 1
    ERX 4800,A,aa

    IF  A=101 THEN
        ����Ƚ��=6
        GOSUB Ƚ��_������������m
        GOSUB ����
        ''  GOSUB ��ܿ����߿�����1cmm
        '' GOSUB Ƚ��_������������m
        ''  GOSUB ��ܿ����߿�����1cmm
        ''  GOSUB �ѹ߾����ΰ���
        ''  GOSUB mm��ܳ�������
        'GOSUB mm��ܳ�����
        'GOSUB m�����ʿ�����20
        'GOSUB m�����ʿ�����20
        'GOSUB m�����ʿ�����20
        'GOSUB m�����ʿ�����20

        ETX 4800, 103

        �̼Ǽ���=�̼Ǽ���+1
        GOSUB ��ܳ�����
        GOTO �����ڵ�_2

    ELSE
        SERVO 16, 30
        GOTO �������������

    ENDIF



�����ڵ�_3:
    IF �̼Ǽ���>1 THEN GOTO �����ڵ�_4
    SERVO 16, 30
    GOSUB �յڱ�������
    GOSUB �¿��������
    GOSUB ���ܼ��Ÿ�����Ȯ��
    ETX 4800,103

    ff = 0
bb:
    DELAY 1
    ERX 4800, A, bb
    ff = ff + 1
    IF ff > 5 THEN GOTO �����ڵ�_3

    DELAY 10

    IF  ���ܼ��Ÿ��� > 100 THEN
        MUSIC "C"

        GOSUB ���տ���
        GOSUB ��������
        'GOSUB �ѹ߾����ΰ���
        'GOSUB �ѹ߾����ΰ���
        'GOSUB �ѹ߾����ΰ���
        �̼Ǽ���=�̼Ǽ���+1
        GOTO �����ڵ�_3
    ENDIF
    IF A=0 THEN
        GOSUB �ѹߵڷΰ���
        GOTO �����ڵ�_3
    ELSE  ' A>0 THEN
        SERVO 16, 30
        GOTO �������������3

    ENDIF

�����ڵ�_4:
    IF �̼Ǽ���>2 THEN GOTO �����ڵ�_5
    SERVO 16, 30
    GOSUB �յڱ�������
    GOSUB �¿��������
    GOSUB ���ܼ��Ÿ�����Ȯ��
    ETX 4800,103

    ff = 0
cc:
    ff = ff + 1
    IF ff > 5 THEN GOTO �����ڵ�_4
    DELAY 1
    ERX 4800,A,cc

    IF A=0 THEN
        GOSUB �����ʿ�����70����
        GOTO �����ڵ�_4
    ENDIF

    IF ���ܼ��Ÿ��� > 70 THEN
        GOSUB �ͳ�
        'GOSUB gggg
        IF ���ܼ��Ÿ��� > 100 THEN
            'GOSUB �ͳ�
            GOSUB �ͳ�
            '        GOSUB �ͳξ�����
            '       GOSUB �ͳξ�����
        ENDIF
        ' GOSUB �ͳξ�����
        'GOSUB �ͳξ�����
        'GOSUB �⺻�ڼ�
        '2->3
        GOSUB �⺻�ڼ�2
        �̼Ǽ���=�̼Ǽ���+1
        GOSUB ��ܳ�����
        GOTO �����ڵ�_4
    ELSEIF A>0 THEN
        GOTO �������������3
    ENDIF



�����ڵ�_5:
    IF �̼Ǽ��� <3 THEN
        GOTO �����ڵ�_4
    ENDIF
    SERVO 16, 30
    GOSUB �յڱ�������
    GOSUB �¿��������
    GOSUB ���ܼ��Ÿ�����Ȯ��
    ETX 4800,103

    ff = 0
dd:
    ff = ff + 1
    IF ff > 5 THEN GOTO �����ڵ�_5
    DELAY 1
    ERX 4800,A,dd
    GOTO �������������4
    'STEPNUM = 18
    'GOTO num�������������
ee:
    ETX 4800, 103
    SERVO 16, 30
    GOSUB �����տ���
ffff:
    ETX 4800, 106
    GOTO �����տ���2
    GOTO ffff
    'ETX 4800, 106
    'GOTO mmmLL��������


�������������:
    SERVO 16, 30
    �Ѿ���Ȯ�� = 0
    'ETX 4800, 103
    ����� = 2
    SPEED 7
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO �������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO �������������_4
    ENDIF



    '**********************

�������������_1:
    SPEED 6
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


�������������_3:
    SPEED 6
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,�������������_4_0
    IF A= 102 THEN
        GOTO ���������������ȸ��_3����
    ELSEIF A = 153 THEN
        '����� = 3
        GOTO ���������������_3����
    ELSEIF A = 103 THEN  '������
        '����� = 1
        GOTO ���������������_3����
    ELSEIF A = 128 THEN
        ����� = 2
    ELSEIF A = 150 THEN
        GOTO ���������������_3����
    ELSEIF A = 130 THEN
        GOTO ���������������_3����
    ELSEIF A=154 THEN
        GOTO ���������������ȸ��_3����
    ELSE  '����
        GOTO �������������_3����
    ENDIF

�������������_4_0:

    IF  ����� = 1 THEN'����

    ELSEIF  ����� = 3 THEN'������
        HIGHSPEED SETOFF
        SPEED 6
        'MOVE G6D,103,  71, 140, 105,  100
        'MOVE G6A, 95,  82, 146,  87, 102
        MOVE G6D,103,  73, 140, 100,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO �������������_1

    ENDIF



    '*********************************

�������������_4:
    SPEED 6
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


�������������_6:
    SPEED 6
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT



    ERX 4800, A ,�������������_1_0
    IF A= 102 THEN
        GOTO ���������������ȸ��_6����
    ELSEIF A = 153 THEN
        '����� = 3
        GOTO ���������������_6����
    ELSEIF A = 103 THEN
        '����� = 1
        GOTO ���������������_6����
    ELSEIF A = 128 THEN
        ����� = 2
    ELSEIF A = 150 THEN
        GOTO ���������������_6����
    ELSEIF A = 130 THEN
        GOTO ���������������_6����
    ELSEIF A=154 THEN
        GOTO ���������������ȸ��_6����
    ELSE  '����
        GOTO �������������_6����
    ENDIF

�������������_1_0:

    IF  ����� = 1 THEN'����
        HIGHSPEED SETOFF
        SPEED 6
        'MOVE G6A,103,   71, 140, 105,  100
        'MOVE G6D, 95,  82, 146,  87, 102
        MOVE G6A,103,   73, 140, 100,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO �������������_4
    ELSEIF ����� = 3 THEN'������


    ENDIF



    GOTO �������������_1
    '******************************************
    '******************************************
    '*************************  ********
�������������_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOTO �����ڵ� 	
    '*************************  ********
���������������_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m���ʿ�����20
    'GOSUB m���ʿ�����20
    GOTO �������������	
    '*************************  ********
���������������ȸ��_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m������20
    'GOSUB m���ʿ�����20
    GOTO �������������	
    '*************************  ********
���������������_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m�����ʿ�����20
    'GOSUB m�����ʿ�����20
    GOTO �������������
    '******************************************
���������������ȸ��_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m��������20
    'GOSUB m�����ʿ�����20
    GOTO �������������
    '******************************************
���������������_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m���ʿ�����20
    ' GOSUB m���ʿ�����20
    GOTO �������������
    '******************************************
���������������ȸ��_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m������20
    DELAY 1000
    ' GOSUB m���ʿ�����20
    GOTO �������������
    '******************************************
���������������_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m�����ʿ�����20
    'GOSUB m�����ʿ�����20
    GOTO �������������
    '******************************************
���������������ȸ��_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m��������20
    DELAY 1000
    'GOSUB m�����ʿ�����20
    GOTO �������������
    '******************************************
�������������_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOTO �����ڵ�
    '***************************************************
num�������������:

    SERVO 16, 30
    �Ѿ���Ȯ�� = 0
    ETX 4800, 103
    ����� = 2
    SPEED 7
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    ' STEPNUM = STEPNUM-1

    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO num�������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO num�������������_4
    ENDIF



    '**********************

num�������������_1:
    SPEED 6
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


num�������������_3:
    SPEED 6
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,num�������������_4_0

    STEPNUM = STEPNUM-1
    IF A = 153 THEN
        ����� = 3
    ELSEIF A = 103 THEN  '������
        ����� = 1
    ELSEIF A = 128 THEN
        ����� = 2
    ELSEIF A = 150 THEN
        GOTO num���������������_3����
    ELSEIF A = 130 THEN
        GOTO num���������������_3����
    ELSE  '����
        GOTO num�������������_3����
    ENDIF

num�������������_4_0:

    IF  ����� = 1 THEN'����

    ELSEIF  ����� = 3 THEN'������
        HIGHSPEED SETOFF
        SPEED 6
        'MOVE G6D,103,  71, 140, 105,  100
        'MOVE G6A, 95,  82, 146,  87, 102
        MOVE G6D,103,  73, 140, 100,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO num�������������_1

    ENDIF



    '*********************************

num�������������_4:
    SPEED 6
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


num�������������_6:
    SPEED 6
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT



    ERX 4800, A ,num�������������_1_0
    STEPNUM = STEPNUM -1
    IF A = 153 THEN
        ����� = 3
    ELSEIF A = 103 THEN
        ����� = 1
    ELSEIF A = 128 THEN
        ����� = 2
    ELSEIF A = 150 THEN
        GOTO num���������������_6����
    ELSEIF A = 130 THEN
        GOTO num���������������_6����
    ELSE  '����
        GOTO num�������������_6����
    ENDIF

num�������������_1_0:

    IF  ����� = 1 THEN'����
        HIGHSPEED SETOFF
        SPEED 6
        'MOVE G6A,103,   71, 140, 105,  100
        'MOVE G6D, 95,  82, 146,  87, 102
        MOVE G6A,103,   73, 140, 100,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO num�������������_4
    ELSEIF ����� = 3 THEN'������


    ENDIF



    GOTO num�������������_1
    '******************************************
    '******************************************
    '*************************  ********
num�������������_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    IF STEPNUM <10 THEN   '-�� �Ǹ� �̻�����
        GOTO ee
    ENDIF
    GOTO �����ڵ� 	
    '*************************  ********
num���������������_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    IF STEPNUM <10 THEN
        GOTO ee
    ENDIF
    GOSUB m���ʿ�����20
    'GOSUB m���ʿ�����20
    GOTO num�������������	
    '*************************  ********
num���������������_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    IF STEPNUM <10 THEN
        GOTO ee
    ENDIF
    GOSUB m�����ʿ�����20
    'GOSUB m�����ʿ�����20
    GOTO num�������������
    '******************************************
num���������������_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    IF STEPNUM <10 THEN
        GOTO ee
    ENDIF
    GOSUB m���ʿ�����20
    ' GOSUB m���ʿ�����20
    GOTO num�������������
    '******************************************
num���������������_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    IF STEPNUM <10 THEN
        GOTO ee
    ENDIF
    GOSUB m�����ʿ�����20
    'GOSUB m�����ʿ�����20
    GOTO num�������������
    '******************************************
num�������������_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    IF STEPNUM <10 THEN
        GOTO ee
    ENDIF
    GOTO �����ڵ�


    '***************************************************

�������������3:
    �Ѿ���Ȯ�� = 0
    'ETX 4800, 103
    ����� = 2
    SPEED 9
    HIGHSPEED SETON
    GOSUB All_motor_mode3

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO �������������3
    ENDIF
    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO �������������3_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO �������������3_4
    ENDIF



    '**********************

�������������3_1:
    SPEED 8
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


�������������3_3:
    SPEED 8
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,�������������3_4_0

    GOSUB ���ܼ��Ÿ�����Ȯ��
    IF �̼Ǽ���=1 AND ���ܼ��Ÿ���>100 THEN
        GOTO �������������3_3����
    ELSEIF �̼Ǽ���=2 AND ���ܼ��Ÿ��� >70 THEN
        GOTO �������������3_3����
    ELSEIF A= 102 THEN
        GOTO ���������������ȸ��3_3����
    ELSEIF A = 153 THEN
        '����� = 3
        'GOTO ���������������3_3����
        GOTO �������������������ȸ��3_3����
    ELSEIF A = 103 THEN
        '����� = 1
        'GOTO ���������������3_3����
        GOTO �������������������ȸ��3_3����
    ELSEIF A = 128 THEN
        ����� = 2
    ELSEIF A = 150 THEN
        GOTO ���������������3_3����
    ELSEIF A = 130 THEN
        GOTO ���������������3_3����
    ELSEIF A=154 THEN
        GOTO ���������������ȸ��3_3����
    ELSE  '����
        GOTO �������������3_3����

    ENDIF

�������������3_4_0:

    IF  ����� = 1 THEN'����

    ELSEIF  ����� = 3 THEN'������
        HIGHSPEED SETOFF
        SPEED 8
        'MOVE G6D,103,  71, 140, 105,  100
        'MOVE G6A, 95,  82, 146,  87, 102
        MOVE G6D,103,  73, 140, 100,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO �������������3_1

    ENDIF



    '*********************************

�������������3_4:
    SPEED 8
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


�������������3_6:
    SPEED 8
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT



    ERX 4800, A ,�������������3_1_0

    GOSUB ���ܼ��Ÿ�����Ȯ��
    IF �̼Ǽ���=1 AND ���ܼ��Ÿ���>150 THEN
        GOTO �������������3_6����
    ELSEIF �̼Ǽ���=2 AND ���ܼ��Ÿ��� >70 THEN
        GOTO �������������3_6����
    ELSEIF A= 102 THEN
        GOTO ���������������ȸ��3_6����
    ELSEIF A = 153 THEN
        '����� = 3
        'GOTO ���������������3_6����
        GOTO �������������������ȸ��3_6����
    ELSEIF A = 103 THEN
        '����� = 1
        'GOTO ���������������3_6����
        GOTO �������������������ȸ��3_6����
    ELSEIF A = 128 THEN
        ����� = 2
    ELSEIF A = 150 THEN
        GOTO ���������������3_6����
    ELSEIF A = 130 THEN
        GOTO ���������������3_6����
    ELSEIF A=154 THEN
        GOTO ���������������ȸ��3_6����
    ELSE  '����
        GOTO �������������3_6����
    ENDIF

�������������3_1_0:

    IF  ����� = 1 THEN'����
        HIGHSPEED SETOFF
        SPEED 8
        'MOVE G6A,103,   71, 140, 105,  100
        'MOVE G6D, 95,  82, 146,  87, 102
        MOVE G6A,103,   73, 140, 100,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO �������������3_4
    ELSEIF ����� = 3 THEN'������


    ENDIF



    GOTO �������������3_1
    '******************************************
    '******************************************
    '*********************************
�������������3_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    'GOSUB ��ġ���
    GOTO �����ڵ� 	
    '******************************************
���������������3_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m���ʿ�����20
    'GOSUB m���ʿ�����20
    GOTO �������������3	
    '*************************  ********
���������������ȸ��3_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m������20
    'GOSUB ������10
    'GOSUB m���ʿ�����20
    GOTO �������������3	
    '*************************  ********
�������������������ȸ��3_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    'GOSUB m������20
    GOSUB ������10
    'GOSUB m���ʿ�����20
    GOTO �������������3	
    '*************************  ********
���������������3_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m�����ʿ�����20
    'GOSUB m�����ʿ�����20
    GOTO �������������3
    '*******************************************88
���������������ȸ��3_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m��������20
    'GOSUB ��������10
    'GOSUB m�����ʿ�����20
    GOTO �������������3
    '******************************************
�������������������ȸ��3_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    'GOSUB m��������20
    GOSUB ��������10
    'GOSUB m�����ʿ�����20
    GOTO �������������3
    '******************************************
�������������3_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 15
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�
    'GOSUB ��ġ���
    GOTO �����ڵ�
    '************************************
���������������3_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m���ʿ�����20
    ' GOSUB m���ʿ�����20
    GOTO �������������3
    '******************************************
���������������ȸ��3_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m������20
    'GOSUB ������10
    ' GOSUB m���ʿ�����20
    GOTO �������������3
    '******************************************
�������������������ȸ��3_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    'GOSUB m������20
    GOSUB ������10
    ' GOSUB m���ʿ�����20
    GOTO �������������3
    '******************************************
���������������3_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m�����ʿ�����20
    'GOSUB m�����ʿ�����20
    GOTO �������������3
    '************************************
���������������ȸ��3_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m��������20
    'GOSUB ��������10
    'GOSUB m�����ʿ�����20
    GOTO �������������3
    '**********************
�������������������ȸ��3_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    ' GOSUB m��������20
    GOSUB ��������10
    'GOSUB m�����ʿ�����20
    GOTO �������������3
    '******************************************
�������������4:
    �Ѿ���Ȯ�� = 0
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO �������������4
    ENDIF
    GOSUB ���ܼ��Ÿ�����Ȯ��
    ETX 4800, 103
    ����� = 2
    SPEED 9
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO �������������4_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO �������������4_4
    ENDIF



    '**********************

�������������4_1:
    SPEED 8
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


�������������4_3:
    ETX 4800, 103
    SPEED 8
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,�������������4_4_0

    GOSUB ���ܼ��Ÿ�����Ȯ��
    IF ���ܼ��Ÿ���>60  THEN
        GOTO �������������4_3����
    ELSEIF A= 102 THEN
        GOTO ���������������ȸ��4_3����
    ELSEIF A = 153 THEN
        GOTO �������������������ȸ��4_3����
        '����� = 3
    ELSEIF A = 103 THEN
        ' ����� = 1
        GOTO �������������������ȸ��4_3����
    ELSEIF A = 128 THEN
        ����� = 2
    ELSEIF A = 150 THEN
        GOTO ���������������4_3����
    ELSEIF A = 130 THEN
        GOTO ���������������4_3����
    ELSEIF A=154 THEN
        GOTO ���������������ȸ��4_3����
    ELSE  '����
        GOTO �������������4

    ENDIF

�������������4_4_0:

    IF  ����� = 1 THEN'����

    ELSEIF  ����� = 3 THEN'������
        HIGHSPEED SETOFF
        SPEED 8
        'MOVE G6D,103,  71, 140, 105,  100
        'MOVE G6A, 95,  82, 146,  87, 102
        MOVE G6D,103,  73, 140, 100,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO �������������4_1

    ENDIF



    '*********************************

�������������4_4:
    SPEED 8
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


�������������4_6:
    ETX 4800, 103
    SPEED 8
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT

    ERX 4800, A ,�������������4_1_0

    GOSUB ���ܼ��Ÿ�����Ȯ��
    IF ���ܼ��Ÿ���>60  THEN
        GOTO �������������4_6����
    ELSEIF A= 102 THEN
        GOTO ���������������ȸ��4_6����
    ELSEIF A = 153 THEN
        '����� = 3
        GOTO �������������������ȸ��4_6����
    ELSEIF A = 103 THEN
        '����� = 1
        GOTO �������������������ȸ��4_6����
    ELSEIF A = 128 THEN
        ����� = 2
    ELSEIF A = 150 THEN
        GOTO ���������������4_6����
    ELSEIF A = 130 THEN
        GOTO ���������������4_6����
    ELSEIF A=154 THEN
        GOTO ���������������ȸ��4_6����
    ELSE  '����
        GOTO �������������4
    ENDIF

�������������4_1_0:

    IF  ����� = 1 THEN'����
        HIGHSPEED SETOFF
        SPEED 8
        'MOVE G6A,103,   71, 140, 105,  100
        'MOVE G6D, 95,  82, 146,  87, 102
        MOVE G6A,103,   73, 140, 100,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO �������������4_4
    ELSEIF ����� = 3 THEN'������


    ENDIF



    GOTO �������������4_1
    '******************************************
    '******************************************
    '*********************************
�������������4_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    'GOSUB ��ġ���
    GOTO ee	
    '******************************************
���������������4_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m���ʿ�����20
    'GOSUB m���ʿ�����20
    GOTO �������������4	
    '*************************  ********
���������������ȸ��4_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m������20
    'GOSUB ������10
    'GOSUB m���ʿ�����20
    GOTO �������������4	
    '*************************  ********
�������������������ȸ��4_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    'GOSUB m������20
    GOSUB ������10
    'GOSUB m���ʿ�����20
    GOTO �������������4	
    '*************************  ********
���������������4_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m�����ʿ�����20
    'GOSUB m�����ʿ�����20
    GOTO �������������4
    '*******************************************88
���������������ȸ��4_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m��������20
    'GOSUB ��������10
    'GOSUB m�����ʿ�����20
    GOTO �������������4
    '******************************************
�������������������ȸ��4_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    'GOSUB m��������20
    GOSUB ��������10
    'GOSUB m�����ʿ�����20
    GOTO �������������4
    '******************************************
�������������4_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 10
    GOSUB �⺻�ڼ�
    'GOSUB ��ġ���
    GOTO ee
    '************************************
���������������4_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m���ʿ�����20
    ' GOSUB m���ʿ�����20
    GOTO �������������4
    '******************************************
���������������ȸ��4_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m������20
    'GOSUB ������10
    ' GOSUB m���ʿ�����20
    GOTO �������������4
    '******************************************
�������������������ȸ��4_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    'GOSUB m������20
    GOSUB ������10
    ' GOSUB m���ʿ�����20
    GOTO �������������4
    '******************************************
���������������4_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m�����ʿ�����20
    'GOSUB m�����ʿ�����20
    GOTO �������������4
    '************************************
���������������ȸ��4_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    GOSUB m��������20
    'GOSUB ��������10
    'GOSUB m�����ʿ�����20
    GOTO �������������4

    '******************************************
�������������������ȸ��4_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 12
    GOSUB ����ȭ�ڼ�
    SPEED 7
    GOSUB �⺻�ڼ�
    ' GOSUB m��������20
    GOSUB ��������10
    'GOSUB m�����ʿ�����20
    GOTO �������������4
    '******************************************
�ͳ�2:
    SPEED 12
    GOSUB ���̷�OFF

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



�ͳΰ���:
    SPEED 6
    GOSUB ���̷�OFF
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
�ͳ�����:
    GOSUB ���̷�OFF
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
�ͳ�:
    SPEED 12
    GOSUB ���̷�OFF

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
    MOVE G6A, 100, 145,  60,  30, 100,
    MOVE G6D, 100, 145,  60,  30, 100,
    MOVE G6B,  10,  50,  70,  ,  ,
    MOVE G6C,  10,  50,  70,  ,120 ,

    MOVE G6A, 100, 145,  60,  30, 100,
    MOVE G6D, 100, 145,  60,  30, 100,
    MOVE G6B,  10,  40,  70,  ,  ,
    MOVE G6C,  10,  40,  70,  ,120 ,

    MOVE G6A, 100, 150,  55,  33, 100,
    MOVE G6D, 100, 150,  55,  33, 100,
    MOVE G6B,  10,  45,  50,  ,  ,
    MOVE G6C,  10,  45,  50,  ,  ,


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
    MOVE G6A, 100, 145,  60,  30, 100,
    MOVE G6D, 100, 145,  60,  30, 100,
    MOVE G6B,  10,  50,  70,  ,  ,
    MOVE G6C,  10,  50,  70,  ,120 ,

    MOVE G6A, 100, 145,  60,  30, 100,
    MOVE G6D, 100, 145,  60,  30, 100,
    MOVE G6B,  10,  40,  70,  ,  ,
    MOVE G6C,  10,  40,  70,  ,120 ,

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




    '******************************************************
mm��������:
    ����ӵ� = 15
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3

    IF ������� = 0 THEN
        ������� = 1

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


        GOTO mm��������_1	
    ELSE
        ������� = 0

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


        GOTO mm��������_2	

    ENDIF


    '*************************************************************************

mm��������_1:
    'ETX 4800,100 '

    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT


    ETX 4800,100 '

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO �����ڵ�
    ENDIF
    ERX 4800,A, mm��������_2
    'ERX 4800,A, mm��������_2
    IF A >LOW  AND A < HIGH THEN
        GOTO mm��������_2
    ELSEIF A=0 THEN
        GOTO �����ڵ�
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
        GOSUB �⺻�ڼ�2

        DELAY delayy
        IF A >= HIGH THEN   '158 98
            GOSUB ��������3
        ELSEIF A <= LOW AND A>0 THEN
            GOSUB ������3
        ENDIF
        'GOTO m��������
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF
    '**********

mm��������_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

mm��������_3:

    ' ETX 4800,100 '
    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT
    'ERX 4800,A, mm��������_4
    ETX 4800,100 '�����ڵ带 ����
    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO �����ڵ�
    ENDIF

    ERX 4800,A, mm��������_4
    IF A > LOW AND A < HIGH THEN
        GOTO mm��������_4
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
        GOSUB �⺻�ڼ�2

        DELAY delayy
        IF A >= HIGH THEN
            GOSUB ��������3
        ELSEIF A <= LOW THEN   '0�̾ ������ ��
            GOSUB ������3
        ENDIF
        'GOTO m��������
        '		
        '        GOTO RX_EXIT
    ENDIF

mm��������_4:
    '�޹ߵ��10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO mm��������_1
    '**********************************************************************

mm3��������:
    ����ӵ� = 15
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3

    IF ������� = 0 THEN
        ������� = 1

        SPEED 15

        MOVE G6A, 88,  74, 144,  95, 110
        MOVE G6D,108,  76, 146,  93,  96
        MOVE G6B,100
        MOVE G6C,100,,,,60''�ͳ� �������� �ڳʿ��� ���� ���� ������ ����?  �� ���� ���� ������ 50?
        WAIT

        SPEED 15'

        MOVE G6A, 90, 90, 120, 105, 110,100
        MOVE G6D,110,  76, 147,  93,  96,100
        MOVE G6B,90
        MOVE G6C,110
        WAIT


        GOTO mm3��������_1	
    ELSE
        ������� = 0

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


        GOTO mm3��������_2	

    ENDIF


mm3��������_1:
    'ETX 4800,100 '
    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    'ERX 4800,A, mm3��������_2
    ETX 4800,100 '

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO �����ڵ�
    ENDIF

    ERX 4800,A, mm3��������_2
    GOSUB ���ܼ��Ÿ�����Ȯ��
    IF �̼Ǽ���=1 AND ���ܼ��Ÿ���>150 THEN
        GOTO �����ڵ�
    ELSEIF �̼Ǽ���=2 AND ���ܼ��Ÿ��� >70 THEN
        GOTO �����ڵ�
    ELSEIF A > LOW AND A < HIGH THEN
        GOTO mm3��������_2
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
        GOSUB �⺻�ڼ�

        DELAY delayy
        IF A >= HIGH THEN
            GOSUB ��������3
        ELSEIF A <= LOW  THEN 'A=0�̿��� ��������
            GOSUB ������3
        ENDIF
        'GOTO m��������
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF


mm3��������_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT

mm3��������_3:
    'ETX 4800,100

    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT
    'ERX 4800,A, mm3��������_4
    ETX 4800,100 '�����ڵ带 ����
    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO  �����ڵ�
    ENDIF

    ERX 4800,A, mm3��������_4
    GOSUB ���ܼ��Ÿ�����Ȯ��
    IF �̼Ǽ���=1 AND ���ܼ��Ÿ���>150 THEN ' �� ����
        GOTO �����ڵ�
    ELSEIF �̼Ǽ���=2 AND ���ܼ��Ÿ��� >70 THEN ' �ͳ� ������
        GOTO �����ڵ�
    ELSEIF A >LOW AND A < HIGH THEN   'HIGH, LOW ������ ����ϸ� �ѹ��� ������ �ٲܼ� �ִ�
        GOTO mm3��������_4
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
        GOSUB �⺻�ڼ�

        DELAY delayy
        IF A >= HIGH THEN
            GOSUB ��������3
        ELSEIF A <= LOW THEN   'A=0�̿��� ��������
            GOSUB ������3
        ENDIF
        'GOTO m��������
        '		
        '        GOTO RX_EXIT
    ENDIF

mm3��������_4:
    '�޹ߵ��10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO mm3��������_1
    '*******************************************************************

�ټ�����:
    L=9
�ټ�����_:

    ����ӵ� = 13
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3

    IF ������� = 0 THEN
        ������� = 1

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


        GOTO �ټ�����_1
    ELSE
        ������� = 0

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


        GOTO �ټ�����_2

    ENDIF


�ټ�����_1:

    L= L-1
    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    ETX 4800,100 '

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO �ټ�����_
    ENDIF

    ERX 4800,A, �ټ�����_2
    IF L<4 THEN
        RETURN
    ELSEIF A > LOW AND A < HIGH THEN
        GOTO �ټ�����_2
    ELSEIF A=0 THEN
        GOTO �ټ�����_ ''??��
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
        GOSUB �⺻�ڼ�2

        DELAY delayy
        IF L<4  THEN
            RETURN
        ELSEIF A >= HIGH THEN
            GOSUB ��������3
        ELSEIF A <= LOW AND A>0 THEN
            GOSUB ������3
        ENDIF
        'GOTO m��������
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF

�ټ�����_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT


�ټ�����_3:

    L=L-1
    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    ETX 4800,100 '�����ڵ带 ����
    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO �ټ�����_
    ENDIF

    ERX 4800,A, �ټ�����_4
    IF L<4 THEN
        RETURN
    ELSEIF A > LOW AND A < HIGH THEN
        GOTO �ټ�����_4
    ELSEIF A=0 THEN
        GOTO �ټ�����_
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
        GOSUB �⺻�ڼ�2

        DELAY delayy
        IF L<4 THEN
            RETURN
        ELSEIF A >= HIGH THEN
            GOSUB ��������3
        ELSEIF A <= LOW THEN
            GOSUB ������3
        ENDIF
        'GOTO m��������
        '		
        '        GOTO RX_EXIT
    ENDIF

�ټ�����_4:
    '�޹ߵ��10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO �ټ�����_1
    '*******************************************************************
mmL��������:
    L=10
mmL_��������:

    ����ӵ� = 13
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0

    GOSUB Leg_motor_mode3

    IF ������� = 0 THEN
        ������� = 1

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


        GOTO mmL��������_1	
    ELSE
        ������� = 0

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


        GOTO mmL��������_2	

    ENDIF


mmL��������_1:

    L= L-1
    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    ETX 4800,100'

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO mmL_��������
    ENDIF

    ERX 4800,A, mmL��������_2
    IF A > LOW AND A < HIGH THEN
        GOTO mmL��������_2
    ELSEIF A=0 THEN
        lookL1: MOVE G6B,,,,,,60
        MOVE G6C,,,,,50 '�� �� ��� �¿츦 ��
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
            GOSUB ������3
            GOSUB ������3
        ELSEIF turn =1 THEN
            GOSUB ��������3
            GOSUB ��������3
        ENDIF
        DELAY 500
        MOVE G6B,,,,,,100  '�� �ٽ� �߾�����
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
        GOSUB �⺻�ڼ�2

        DELAY delayy
        IF L<4  THEN
            GOTO ee
        ELSEIF A >= HIGH THEN
            GOSUB ��������3
        ELSEIF A <= LOW AND A>0 THEN
            GOSUB ������3
        ENDIF
        'GOTO m��������
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF


mmL��������_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90
    WAIT
    IF L<4 THEN
        GOTO ee
    ENDIF

mmL��������_3:

    L=L-1
    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    ETX 4800,103 '�����ڵ带 ����
    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO mmL_��������
    ENDIF

    ERX 4800,A, mmL��������_4
    IF A > LOW AND A < HIGH THEN
        GOTO mmL��������_4
    ELSEIF A=0 THEN
        lookL2: MOVE G6B,,,,,,60
        MOVE G6C,,,,,50 '�� �� ��� �¿츦 ��
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
            GOSUB ������3
            GOSUB ������3
        ELSEIF turn =1 THEN
            GOSUB ��������3
            GOSUB ��������3
        ENDIF
        DELAY 500
        MOVE G6B,,,,,,100  '�� �ٽ� �߾�����
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
        GOSUB �⺻�ڼ�2

        DELAY delayy
        IF L<4 THEN
            GOTO ee
        ELSEIF A >= HIGH THEN
            GOSUB ��������3
        ELSEIF A <= LOW THEN
            GOSUB ������3
        ENDIF
        'GOTO m��������
        '		
        '        GOTO RX_EXIT
    ENDIF

mmL��������_4:
    '�޹ߵ��10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110
    WAIT

    GOTO mmL��������_1
    '**************************************************************************

mmLL��������:
    ����ӵ� = 13
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0
    SERVO 16, 100
    GOSUB Leg_motor_mode3

    IF ������� = 0 THEN
        ������� = 1

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


        GOTO mmLL��������_1	
    ELSE
        ������� = 0

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


        GOTO mmLL��������_2	

    ENDIF




mmLL��������_1:
    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    ETX 4800,101

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO mmLL��������
    ENDIF

    ERX 4800,A, mmLL��������_2
    IF A > LOW AND A < HIGH THEN
        GOTO mmLL��������_2
    ELSEIF A=0 THEN
        GOTO mmLL�������� '�����ڵ� ''''
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
        GOSUB �⺻�ڼ�3
        'DELAY delayy
        GOSUB ���ܼ��Ÿ�����Ȯ��
        IF ���ܼ��Ÿ���>95 THEN
            GOSUB ����������
        ELSEIF A >= HIGH THEN
            GOSUB ��������4
        ELSEIF A <= LOW AND A>0 THEN
            GOSUB ������4
        ENDIF
        DELAY 50
        'GOTO m��������
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF


mmLL��������_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90,,,,100
    WAIT

mmLL��������_3:


    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    ETX 4800,101
    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO mmLL��������
    ENDIF

    ERX 4800,A, mmLL��������_4
    IF A > LOW AND A < HIGH THEN
        GOTO mmLL��������_4
        'ELSEIF A=0 THEN
        '   GOTO �����ڵ�  ���¿��
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
        GOSUB �⺻�ڼ�3

        'DELAY delayy
        GOSUB ���ܼ��Ÿ�����Ȯ��
        IF ���ܼ��Ÿ���>100 THEN
            GOSUB ����������
        ELSEIF A >= HIGH THEN
            GOSUB ��������4
        ELSEIF A <= LOW THEN
            GOSUB ������4
        ENDIF
        DELAY 50
        'GOTO m��������
        '		
        '        GOTO RX_EXIT
    ENDIF

mmLL��������_4:
    '�޹ߵ��10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110,,,,100
    WAIT

    GOTO mmLL��������_1
    '*********************************************************************

mmmLL��������:
    ����ӵ� = 13
    �¿�ӵ� = 4
    �Ѿ���Ȯ�� = 0
    SERVO 16, 100
    GOSUB Leg_motor_mode3

    IF ������� = 0 THEN
        ������� = 1

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


        GOTO mmmLL��������_1	
    ELSE
        ������� = 0

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


        GOTO mmmLL��������_2	

    ENDIF




mmmLL��������_1:
    SPEED ����ӵ�

    MOVE G6A, 86,  56, 145, 115, 110
    MOVE G6D,108,  76, 147,  93,  96
    WAIT


    SPEED �¿�ӵ�
    GOSUB Leg_motor_mode3

    MOVE G6A,110,  76, 147, 93,  96
    MOVE G6D,86, 100, 145,  69, 110
    WAIT

    ETX 4800,106

    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO mmmLL��������
    ENDIF

    ERX 4800,A, mmmLL��������_1
    IF A=128 THEN
        GOTO mmmLL��������_2
    ELSEIF A=0 THEN
        'GOSUB �ѹߵڷΰ���
        GOTO mmmLL�������� '�����ڵ� ''''
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
        GOSUB �⺻�ڼ�3
        'DELAY delayy
        GOSUB ���ܼ��Ÿ�����Ȯ��
        IF ���ܼ��Ÿ���>110 THEN
            GOSUB final
            GOSUB �����_�ѹߵڷΰ���
        ELSEIF A =130 THEN
            GOSUB mm�����ʿ�����20
        ELSEIF A = 150 THEN
            GOSUB mm���ʿ�����20
        ENDIF
        DELAY 10
        'GOTO m��������
        '		
        '		
        '        GOTO RX_EXIT
    ENDIF


mmmLL��������_2:

    MOVE G6A,110,  76, 147,  93, 96,100
    MOVE G6D,90, 90, 120, 105, 110,100
    MOVE G6B,110
    MOVE G6C,90,,,,100
    WAIT

mmmLL��������_3:


    SPEED ����ӵ�

    MOVE G6D, 86,  56, 145, 115, 110
    MOVE G6A,108,  76, 147,  93,  96
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D,110,  76, 147, 93,  96
    MOVE G6A,86, 100, 145,  69, 110
    WAIT

    ETX 4800,106
    SPEED ����ӵ�

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO mmmLL��������
    ENDIF

    ERX 4800,A, mmmLL��������_4
    IF A =128 THEN
        GOTO mmmLL��������_4
        'ELSEIF A=0 THEN
        '   GOTO �����ڵ�  ���¿��
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
        GOSUB �⺻�ڼ�3

        'DELAY delayy
        GOSUB ���ܼ��Ÿ�����Ȯ��
        IF ���ܼ��Ÿ���>105 THEN
            GOSUB final
            GOSUB �����_�ѹߵڷΰ���
        ELSEIF A =130 THEN
            GOSUB mm�����ʿ�����20
        ELSEIF A =150 THEN
            GOSUB mm���ʿ�����20
        ENDIF
        DELAY 10
        'GOTO m��������
        '		
        '        GOTO RX_EXIT
    ENDIF

mmmLL��������_4:
    '�޹ߵ��10
    MOVE G6A,90, 90, 120, 105, 110,100
    MOVE G6D,110,  76, 146,  93,  96,100
    MOVE G6B, 90
    MOVE G6C,110,,,,100
    WAIT

    GOTO mmmLL��������_1
    '*********************************************************************

mm��������:
    �Ѿ���Ȯ�� = 0

    ����� = 2
    SPEED 5 '10
    HIGHSPEED SETON
    GOSUB All_motor_mode3


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO mm��������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  77, 145,  93, 98
        MOVE G6B,100,  35
        MOVE G6C,100,  35
        WAIT

        GOTO mm��������_4
    ENDIF



    '**********************

mm��������_1:
    SPEED 4 '8
    MOVE G6A,95,  95, 120, 100, 104
    MOVE G6D,104,  77, 146,  91,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


mm��������_3:

    ETX 4800,100 '

    SPEED 4 '8
    MOVE G6A,103,   71, 140, 105,  100
    MOVE G6D, 95,  82, 146,  87, 102
    WAIT

    ERX 4800, A ,mm��������_4_0

    IF A=0 THEN
        GOTO mm��������_6����
    ELSEIF A >LOW  AND A < HIGH THEN
        �����=2
    ELSEIF A<LOW THEN '����
        �����=1
    ELSEIF A>HIGH THEN '������
        �����=3


    ENDIF
mm��������_4_0:

    IF  ����� = 1 THEN'����

    ELSEIF  ����� = 3 THEN'������
        HIGHSPEED SETOFF
        SPEED 4'8
        ''GOSUB m��������10
        MOVE G6D,103,   71, 140, 95,  100
        MOVE G6A, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO mm��������_1

    ENDIF



    '*********************************

mm��������_4:
    SPEED 4 '8
    MOVE G6D,95,  85, 120, 100, 104
    MOVE G6A,104,  77, 146,  91,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


mm��������_6:

    ETX 4800,100 '
    SPEED 4 '8
    MOVE G6D,103,   71, 140, 105,  100
    MOVE G6A, 95,  82, 146,  87, 102
    WAIT


    ERX 4800, A ,mm��������_1_0
    IF A=0 THEN
        GOTO mm��������_6����
    ELSEIF A >LOW  AND A < HIGH THEN
        �����=2
    ELSEIF A<LOW THEN '����
        �����=1
    ELSEIF A>HIGH THEN '������
        �����=3


    ENDIF


mm��������_1_0:

    IF  ����� = 1 THEN'����
        HIGHSPEED SETOFF
        SPEED 4 '8
        MOVE G6A,103,   71, 140, 95,  100
        MOVE G6D, 95,  82, 146,  87, 102
        WAIT
        HIGHSPEED SETON
        GOTO mm��������_4
    ELSEIF ����� = 3 THEN'������


    ENDIF



    GOTO mm��������_1
    '******************************************
    '******************************************
    '*********************************
mm��������_3����:
    MOVE G6D,95,  90, 125, 95, 104
    MOVE G6A,104,  76, 145,  91,  102
    MOVE G6C, 100
    MOVE G6B,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 8 '15
    GOSUB ����ȭ�ڼ�
    SPEED 5' 10
    GOSUB �⺻�ڼ�
    GOTO �����ڵ�
    '******************************************
mm��������_6����:
    MOVE G6A,95,  90, 125, 95, 104
    MOVE G6D,104,  76, 145,  91,  102
    MOVE G6B, 100
    MOVE G6C,100
    WAIT
    HIGHSPEED SETOFF
    SPEED 8 '15
    GOSUB ����ȭ�ڼ�
    SPEED 5 '10
    GOSUB �⺻�ڼ�
    GOTO �����ڵ�
    '******************************************
��ܳ�����:
    SERVO 16, 30
    �Ѿ���Ȯ�� = 0
    ETX 4800, 103
    GOSUB All_motor_mode3


    ff = 0
bbbb:

    ERX 4800, A , ��ܳ�����
    IF A = 153 THEN
        GOSUB ��������10
    ELSEIF A = 103 THEN  '������
        GOSUB ������10
    ELSEIF A = 128 THEN
        RETURN
    ELSEIF A = 150 THEN ' �������� �԰���
        GOSUB m���ʿ�����20
    ELSEIF A = 130 THEN ' ���������� �԰���
        GOSUB m�����ʿ�����20
    ELSEIF A=0 THEN
        GOSUB �ѹ߾����ΰ���
    ENDIF
    DELAY 300
    GOTO bbbb

    '********************************
���տ���:
    SERVO 16, 30
    �Ѿ���Ȯ�� = 0
    ETX 4800, 103
    GOSUB All_motor_mode3


    ff = 0
aaaa:
    ETX 4800, 103
    ERX 4800, A , aaaa
    IF A = 153 THEN
        GOSUB ��������10
    ELSEIF A = 103 THEN  '������
        GOSUB ������10
    ELSEIF A = 128 THEN
        RETURN
    ELSEIF A = 150 THEN ' �������� �԰���
        GOSUB m���ʿ�����20
    ELSEIF A = 130 THEN ' ���������� �԰���
        GOSUB m�����ʿ�����20
    ELSEIF A=0 THEN
        ff = ff + 1
        IF ff > 3 THEN
            GOSUB �ѹߵڷΰ���
            ff=0
        ENDIF

        GOTO aaaa

        '
        ' ELSE

        'ENDIF
    ENDIF
    DELAY 300
    GOTO aaaa




�����տ���2:
    SERVO 16, 100
    �Ѿ���Ȯ�� = 0

    GOSUB All_motor_mode3


    ff = 0
cccc2:
    SERVO 16, 100
    ETX 4800, 106
    ERX 4800, A , cccc2
    IF A = 128 THEN  '�߰�red x ����
        GOTO mm����������
    ELSEIF A = 150 THEN ' x�� ����
        GOSUB �����_���ʿ�����20
    ELSEIF A = 130 THEN ' x�� ������
        GOSUB �����_�����ʿ�����20
    ELSE   '0�̴�.
        ff = ff + 1
        DELAY 10
        IF ff > 5 THEN
            GOSUB ��ġ���
            'GOTO mmmLL������
            GOSUB �ѹߵڷΰ���
            'GOSUB �ѹߵڷΰ���

        ELSE
            GOTO cccc2
            '
            'GOSUB �ѹߵڷΰ���

        ENDIF
    ENDIF
    DELAY 50
    GOTO cccc2






�����տ���:
    SERVO 16, 30
    �Ѿ���Ȯ�� = 0
    ETX 4800, 103
    GOSUB All_motor_mode3


    ff = 0
cccc:
    ETX 4800, 103
    ERX 4800, A , cccc
    IF A = 153 THEN
        GOSUB ��������10
    ELSEIF A = 103 THEN  '������
        GOSUB ������10
    ELSEIF A = 128 THEN
        RETURN
    ELSEIF A = 150 THEN ' �������� �԰���
        GOSUB m���ʿ�����20
    ELSEIF A = 130 THEN ' ���������� �԰���
        GOSUB m�����ʿ�����20
    ELSE
        ff = ff + 1
        IF ff > 3 THEN
            'GOTO mmmLL��������
            GOSUB ��ġ���
            GOTO cccc
        ELSE
            'GOSUB ��ġ���
            'GOSUB �ѹߵڷΰ���
            GOTO cccc

        ENDIF
    ENDIF
    DELAY 300
    GOTO cccc


    '********************************************
��������:
    ETX 4800,105

    'GOSUB ��ġ���
    GOSUB �⺻�ڼ�

    GOSUB ������60
    GOSUB ������60
    GOSUB ������45

    MOVE G6C, 100,  85,  21,  ,  ,
    WAIT


    GOSUB �����ʿ�����70����'�������ȵ� ������
    GOSUB �����ʿ�����70����
    GOSUB �����ʿ�����70����
    GOSUB �����ʿ�����70����
    GOSUB �����ʿ�����70����
    GOSUB �����ʿ�����70����
    GOSUB �����ʿ�����70����
    GOSUB �����ʿ�����70����
    GOSUB �����ʿ�����70����
abcd:
    ETX 4800, 105
    DELAY 10
    ERX 4800,A,abcd
    IF A=170 THEN
        RETURN
    ELSEIF A=0 THEN
        GOSUB �����ʿ�����70����
        GOTO abcd
    ELSE
        RETURN

    ENDIF

    '*******************************************8

mm�ݶ�ĵġ���:

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

    GOSUB �⺻�ڼ�

    RETURN

    '************************************************
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
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        SPEED 10
        MOVE G6A, 90, 100, 100, 115, 110
        MOVE G6D,110,  76, 145,  93,  96
        MOVE G6B,90
        MOVE G6C,110
        WAIT

        GOTO ��������_1	
    ELSE
        ������� = 0

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


        GOTO ��������_2

    ENDIF


��������_1:
    ETX 4800,12 '�����ڵ带 ����
    SPEED ����ӵ�

    MOVE G6D,110,  76, 145, 93,  96
    MOVE G6A,90, 98, 145,  69, 110
    WAIT

    SPEED �¿�ӵ�
    MOVE G6D, 90,  60, 137, 120, 110
    MOVE G6A,107,  85, 137,  93,  96
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    SPEED 11

    MOVE G6D,90, 90, 120, 105, 110
    MOVE G6A,112,  76, 146,  93, 96
    MOVE G6B,110
    MOVE G6C,90
    WAIT

    ERX 4800,A, ��������_2
    IF A <> A_old THEN
��������_1_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6A, 106,  76, 145,  93,  96		
        MOVE G6D,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB �⺻�ڼ�2
        GOTO RX_EXIT
    ENDIF
    '**********

��������_2:
    ETX 4800,12 '�����ڵ带 ����
    SPEED ����ӵ�
    MOVE G6A,110,  76, 145, 93,  96
    MOVE G6D,90, 98, 145,  69, 110
    WAIT


    SPEED �¿�ӵ�
    MOVE G6A, 90,  60, 137, 120, 110
    MOVE G6D,107  85, 137,  93,  96
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO MAIN
    ENDIF


    SPEED 11
    MOVE G6A,90, 90, 120, 105, 110
    MOVE G6D,112,  76, 146,  93,  96
    MOVE G6B, 90
    MOVE G6C,110
    WAIT


    ERX 4800,A, ��������_1
    IF A <> A_old THEN
��������_2_EXIT:
        HIGHSPEED SETOFF
        SPEED 5

        MOVE G6D, 106,  76, 145,  93,  96		
        MOVE G6A,  85,  72, 148,  91, 106
        MOVE G6B, 100
        MOVE G6C, 100
        WAIT	

        SPEED 3
        GOSUB �⺻�ڼ�2
        GOTO RX_EXIT
    ENDIF  	

    GOTO ��������_1
    '**********************************************
�ѹ߾����ΰ���:
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
    GOSUB ����ȭ�ڼ�
    SPEED 5
    GOSUB �⺻�ڼ�2
    RETURN

    '*******************************************
m�����_�ѹ߾����ΰ���:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON


    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100,,,,100  '����
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
    '****************************************************

    MOVE G6D,95,  76, 147,  93, 101
    MOVE G6A,101,  76, 147,  93, 98
    MOVE G6C,100
    MOVE G6B,100,,,,100  '����
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

    HIGHSPEED SETOFF
    SPEED 15
    GOSUB �����_����ȭ�ڼ�
    SPEED 5
    GOSUB �⺻�ڼ�3 '�����
    RETURN

    '*******************************************************
�����_�ѹ߾����ΰ���:
    GOSUB All_motor_mode3
    SPEED 7
    HIGHSPEED SETON


    MOVE G6A,95,  76, 147,  93, 101
    MOVE G6D,101,  76, 147,  93, 98
    MOVE G6B,100
    MOVE G6C,100,,,,100  '����
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
    GOSUB �����_����ȭ�ڼ�
    SPEED 5
    GOSUB �⺻�ڼ�3 '�����
    RETURN

    '******************************************
Ƚ��_������������:
    GOSUB All_motor_mode3
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO Ƚ��_������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO Ƚ��_������������_4
    ENDIF


    '**********************

Ƚ��_������������_1:
    MOVE G6A,95,  90, 125, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


Ƚ��_������������_2:

    MOVE G6A,103,   73, 140, 103,  100
    MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO Ƚ��_������������_2_stop

    ERX 4800,A, Ƚ��_������������_4
    IF A <> A_old THEN
Ƚ��_������������_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

Ƚ��_������������_4:
    MOVE G6D,95,  95, 120, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


Ƚ��_������������_5:
    MOVE G6D,103,    73, 140, 103,  100
    MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO Ƚ��_������������_5_stop

    ERX 4800,A, Ƚ��_������������_1
    IF A <> A_old THEN
Ƚ��_������������_5_stop:
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

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

    GOTO Ƚ��_������������_1

    '******************************************

Ƚ��_������������m:
    GOSUB All_motor_mode3
    ����Ƚ��=6
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO Ƚ��_������������m_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO Ƚ��_������������m_4
    ENDIF



    '**********************

Ƚ��_������������m_1:
    MOVE G6A,95,  80, 135, 100, 104
    MOVE G6D,104,  77, 147,  93,  102
    MOVE G6B, 85
    MOVE G6C,115
    WAIT


Ƚ��_������������m_2:
    ����Ƚ��=6
    MOVE G6D,  95,  85, 147,  85, 102,
    MOVE G6A, 103,  73, 140,  98, 100,

    'MOVE G6A,103,   73, 140, 103,  100
    'MOVE G6D, 95,  85, 147,  85, 102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        RETURN
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO Ƚ��_������������m_2_stop

    'ERX 4800,A, Ƚ��_������������m_4
    GOTO Ƚ��_������������m_4
    IF A <> A_old THEN
Ƚ��_������������m_2_stop:
        MOVE G6D,95,  80, 135, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        RETURN
    ENDIF

    '*********************************

Ƚ��_������������m_4:
    MOVE G6D,95,  80, 135, 100, 104
    MOVE G6A,104,  77, 147,  93,  102
    MOVE G6C, 85
    MOVE G6B,115
    WAIT


Ƚ��_������������m_5:
    MOVE G6A,  95,  85, 147,  85, 102,
    MOVE G6D, 103,  73, 140,  98, 100,

    'MOVE G6D,103,    73, 140, 103,  100
    'MOVE G6A, 95,  85, 147,  85, 102
    WAIT


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ����COUNT = ����COUNT + 1
    IF ����COUNT > ����Ƚ�� THEN  GOTO Ƚ��_������������m_5_stop

    'ERX 4800,A, Ƚ��_������������m_1

    GOTO Ƚ��_������������m_1
    IF A <> A_old THEN
Ƚ��_������������m_5_stop:
        MOVE G6A,95,  80, 135, 95, 104
        MOVE G6D,104,  76, 145,  91,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        RETURN
    ENDIF

    '*********************************

    GOTO Ƚ��_������������m_1
    '******************************************

������������:
    GOSUB All_motor_mode3
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 147,  93, 101
        MOVE G6D,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 147,  93, 101
        MOVE G6A,101,  76, 147,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_4
    ENDIF


    '**********************

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

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0

        GOTO RX_EXIT
    ENDIF

    ' ����COUNT = ����COUNT + 1
    'IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_2_stop

    ERX 4800,A, ������������_4
    IF A <> A_old THEN
������������_2_stop:
        MOVE G6D,95,  90, 125, 95, 104
        MOVE G6A,104,  76, 145,  91,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT
        HIGHSPEED SETOFF
        SPEED 15
        GOSUB ����ȭ�ڼ�
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

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


    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ' ����COUNT = ����COUNT + 1
    ' IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_5_stop

    ERX 4800,A, ������������_1
    IF A <> A_old THEN
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

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    '*********************************

    GOTO ������������_1

    '******************************************

�ѹߵڷΰ���:
    GOSUB All_motor_mode3
    �Ѿ���Ȯ�� = 0
    ����COUNT = 0
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
    GOSUB ����ȭ�ڼ�
    HIGHSPEED SETOFF
    SPEED 5
    GOSUB �⺻�ڼ�2

    RETURN
    '******************************************
�����_���ʿ�����20: '****
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
    GOSUB �⺻�ڼ�3
    GOSUB All_motor_mode3
    RETURN

�����_�����ʿ�����20:
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
    GOSUB �⺻�ڼ�3 '�ٲ�
    GOSUB All_motor_mode3
    RETURN

    '******************************************
�����_�ѹߵڷΰ���:
    GOSUB All_motor_mode3
    �Ѿ���Ȯ�� = 0
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON

    MOVE G6A,95,  76, 145,  93, 101
    MOVE G6D,101,  76, 145,  93, 98
    MOVE G6B,100
    MOVE G6C,100,,,,100 '�����
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
    GOSUB �����_����ȭ�ڼ�
    HIGHSPEED SETOFF
    SPEED 5
    GOSUB �⺻�ڼ�3 '�����

    RETURN

    '******************************************
������������:
    GOSUB All_motor_mode3
    �Ѿ���Ȯ�� = 0
    ����COUNT = 0
    SPEED 7
    HIGHSPEED SETON


    IF ������� = 0 THEN
        ������� = 1
        MOVE G6A,95,  76, 145,  93, 101
        MOVE G6D,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_1
    ELSE
        ������� = 0
        MOVE G6D,95,  76, 145,  93, 101
        MOVE G6A,101,  76, 145,  93, 98
        MOVE G6B,100
        MOVE G6C,100
        WAIT

        GOTO ������������_4
    ENDIF


    '**********************

������������_1:
    MOVE G6D,104,  76, 147,  93,  102
    MOVE G6A,95,  95, 120, 95, 104
    MOVE G6B,115
    MOVE G6C,85
    WAIT



������������_3:
    MOVE G6A, 103,  79, 147,  89, 100
    MOVE G6D,95,   65, 147, 103,  102
    WAIT

    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF
    ' ����COUNT = ����COUNT + 1
    ' IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_3_stop
    ERX 4800,A, ������������_4
    IF A <> A_old THEN
������������_3_stop:
        MOVE G6D,95,  85, 130, 100, 104
        MOVE G6A,104,  77, 146,  93,  102
        MOVE G6C, 100
        MOVE G6B,100
        WAIT

        'SPEED 15
        GOSUB ����ȭ�ڼ�
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF
    '*********************************

������������_4:
    MOVE G6A,104,  76, 147,  93,  102
    MOVE G6D,95,  95, 120, 95, 104
    MOVE G6C,115
    MOVE G6B,85
    WAIT


������������_6:
    MOVE G6D, 103,  79, 147,  89, 100
    MOVE G6A,95,   65, 147, 103,  102
    WAIT
    GOSUB �յڱ�������
    IF �Ѿ���Ȯ�� = 1 THEN
        �Ѿ���Ȯ�� = 0
        GOTO RX_EXIT
    ENDIF

    ' ����COUNT = ����COUNT + 1
    'IF ����COUNT > ����Ƚ�� THEN  GOTO ������������_6_stop

    ERX 4800,A, ������������_1
    IF A <> A_old THEN  'GOTO ������������_����
������������_6_stop:
        MOVE G6A,95,  85, 130, 100, 104
        MOVE G6D,104,  77, 146,  93,  102
        MOVE G6B, 100
        MOVE G6C,100
        WAIT

        'SPEED 15
        GOSUB ����ȭ�ڼ�
        HIGHSPEED SETOFF
        SPEED 5
        GOSUB �⺻�ڼ�2

        'DELAY 400
        GOTO RX_EXIT
    ENDIF

    GOTO ������������_1
    '************************************************
m�����ʿ�����20: '****
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
    GOSUB �⺻�ڼ�2
    GOSUB All_motor_mode3
    RETURN
    '*************
mm�����ʿ�����20: '****
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
    GOSUB �⺻�ڼ�2
    GOSUB All_motor_mode3
    GOTO RX_EXIT
    '*************
m���ʿ�����20: '****
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
    RETURN
    '**********************************************
mm���ʿ�����20: '****
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
    GOSUB �⺻�ڼ�2
    GOSUB All_motor_mode3
    GOTO RX_EXIT

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


    '  ERX 4800, A ,�����ʿ�����70����_loop
    '    IF A = A_OLD THEN  GOTO �����ʿ�����70����_loop
    '�����ʿ�����70����_stop:
    GOSUB �⺻�ڼ�2

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

    GOSUB �⺻�ڼ�2

    RETURN
    '*********************************************
������4:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������4_LOOP:

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
    GOSUB �⺻�ڼ�3


    RETURN

    '**********************************************
��������4:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2

��������4_LOOP:

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
    GOSUB �⺻�ڼ�3

    RETURN

    '******************************************************
    '**********************************************
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
    RETURN
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
m��������10:
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
m������20:
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
m��������20:
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

������45:
    MOTORMODE G6A,3,3,3,3,2
    MOTORMODE G6D,3,3,3,3,2
������45_LOOP:

    SPEED 10
    MOVE G6A,95,  106, 145,  63, 105, 100
    MOVE G6D,95,  46, 145,  123, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  106, 145,  63, 105, 100
    MOVE G6D,93,  46, 145,  123, 105, 100
    WAIT

    SPEED 8
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

    SPEED 10
    MOVE G6A,95,  46, 145,  123, 105, 100
    MOVE G6D,95,  106, 145,  63, 105, 100
    WAIT

    SPEED 12
    MOVE G6A,93,  46, 145,  123, 105, 100
    MOVE G6D,93,  106, 145,  63, 105, 100
    WAIT

    SPEED 8
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

    SPEED 15
    MOVE G6A,95,  116, 145,  53, 105, 100
    MOVE G6D,95,  36, 145,  133, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  116, 145,  53, 105, 100
    MOVE G6D,90,  36, 145,  133, 105, 100
    WAIT

    SPEED 10
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

    SPEED 15
    MOVE G6A,95,  36, 145,  133, 105, 100
    MOVE G6D,95,  116, 145,  53, 105, 100
    WAIT

    SPEED 15
    MOVE G6A,90,  36, 145,  133, 105, 100
    MOVE G6D,90,  116, 145,  53, 105, 100

    WAIT

    SPEED 10
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

    '**************************************************



����������:
    SPEED 8
    ETX 4800, 106
�¿�յ�:

    DELAY 100
    ERX 4800, A, ����������' 0-255 �߰� 122

    IF A<73 THEN '93
        GOSUB �����_�����ʿ�����20
    ELSEIF A>172 THEN '152
        GOSUB  �����_���ʿ�����20
    ENDIF

    DELAY 100
    GOSUB ���ܼ��Ÿ�����Ȯ��
    IF ���ܼ��Ÿ���>110 THEN 'CLOSE
        GOSUB �����_�ѹߵڷΰ���
        GOTO �¿�յ�
    ELSEIF ���ܼ��Ÿ���<80 THEN 'far
        GOSUB m�����_�ѹ߾����ΰ���
        GOTO �¿�յ�

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
mm����������:
    SPEED 8
    ETX 4800, 106
mm�¿�յ�:
    ETX 4800, 106
    GOSUB ���ܼ��Ÿ�����Ȯ��
    DELAY 500
    ERX 4800, A, mm�¿�յ�' 0-255 �߰� 122
    ff=0
    IF A=128 THEN
        IF ���ܼ��Ÿ��� <160 AND ���ܼ��Ÿ���>95 THEN
            GOSUB final2

        ELSEIF ���ܼ��Ÿ���<80 THEN 'far
            GOSUB �����_�ѹ߾����ΰ���
            'GOSUB ���ܼ��Ÿ�����Ȯ��

        ELSEIF ���ܼ��Ÿ���>160 THEN 'CLOSE
            GOSUB �����_�ѹߵڷΰ���
            'GOSUB ���ܼ��Ÿ�����Ȯ��
        ELSE
            GOSUB m�����_�ѹ߾����ΰ���
        ENDIF

    ELSEIF A=130 THEN '93
        GOSUB �����_�����ʿ�����20

    ELSEIF A=150 THEN '152
        GOSUB  �����_���ʿ�����20
    ELSE	
        GOSUB final2

        ff=ff+1
        IF ff>5 THEN
            GOSUB �����_�ѹߵڷΰ���
        ELSE
            GOTO mm�¿�յ�
        ENDIF

    ENDIF

    GOSUB ���ܼ��Ÿ�����Ȯ��
    DELAY 250


    GOTO mm�¿�յ�
final:
    GOSUB ��ġ���
    GOSUB �����_�ѹ߾����ΰ���
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

final2:
    GOSUB ��ġ���
    GOSUB �����_�ѹ߾����ΰ���
    
    MOVE G6A,100, 56, 182, 76, 100, 100
    MOVE G6D,100, 56, 182, 76, 100, 100
    MOVE G6B,100, 30, 80,
    MOVE G6C,100, 30, 80, ,120
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

    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C,  60, 190, 165,  ,  ,
    WAIT
    
    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C,  80, 135, 165,  ,  ,
    WAIT
    
    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  95, 165,  ,  ,
    WAIT
    
    MOVE G6A, 100,  56, 182,  76, 100,
    MOVE G6D, 100,  56, 182,  76, 100,
    MOVE G6B, 100,  30,  80,  ,  ,
    MOVE G6C, 100,  30,  80,  ,  ,
    WAIT
    
    RETURN




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
    SERVO 11,100	
    SPEED 5
    GOSUB �⺻�ڼ�
    GOTO MAIN

    '******************************************
��������80��:

    SPEED 3
    SERVO 16, 80
    ETX 4800,35
    RETURN
    '******************************************
��������60��:

    SPEED 3
    SERVO 16, 65
    ETX 4800,36
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
        ' ETX  4800,16
        GOSUB �ڷ��Ͼ��

    ENDIF
    RETURN

�����:
    A = AD(�յڱ���AD��Ʈ)
    'IF A > MAX THEN GOSUB �ڷ��Ͼ��
    IF A > MAX THEN
        '  ETX  4800,15
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

    ' ************************************************
���ܼ��Ÿ�����Ȯ��:

    ���ܼ��Ÿ��� = AD(5)

    ' IF ���ܼ��Ÿ��� > 50 THEN '50 = ���ܼ��Ÿ��� = 25cm
    '    MUSIC "C"
    '    DELAY 3
    ' ENDIF




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
    GOTO RX_EXIT
    '**********************************************
    '************************************************
��ܿ޹߳�����3cm:
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
    GOSUB �⺻�ڼ�

    GOTO RX_EXIT
    '****************************************
    '************************************************
��ܿ����߳�����3cm:
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
    GOSUB �⺻�ڼ�

    GOTO RX_EXIT
    '************************************************
����:
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


    GOSUB ���̷�OFF

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
    GOSUB ���̷�ON
    GOSUB �⺻�ڼ�
    RETURN
    '**********************************************


��ܿ�����mm:
    ����Ƚ��=6
    GOSUB Ƚ��_������������m
    GOSUB ��ܿ����߿�����1cmm
    ����Ƚ��=6
    GOSUB Ƚ��_������������m
    GOSUB ��ܿ����߿�����1cmm

    RETURN

    '************************************************
mmm������:


    ����Ƚ��=6

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
    GOSUB Ƚ��_������������m
    GOSUB mmm��


    RETURN

mmm��:
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
    GOSUB ����ȭ�ڼ�
    SPEED 5
    GOSUB �⺻�ڼ�2
    RETURN



    '************************************************

��ܿ޹߿�����1cm:
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

��ܿ����߿�����1cm:
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
��ܿ����߿�����1cmm:
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
MAIN: '�󺧼���

    ETX 4800, 38 ' ���� ���� Ȯ�� �۽� ��

MAIN_2:

    GOSUB �յڱ�������
    GOSUB �¿��������
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
    ETX  4800,106

    �̼Ǽ���=3
    GOTO �����ڵ�_5
    DELAY 10000
    '***************	
KEY2:
    ETX  4800,2
test:

    GOSUB ���ܼ��Ÿ�����Ȯ��
    IF ���ܼ��Ÿ���>140 THEN 'CLOSE
        GOSUB �����_�ѹߵڷΰ���
        GOTO test
    ELSEIF ���ܼ��Ÿ���<120 THEN 'far
        GOSUB �����_�ѹ߾����ΰ���
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

    J = AD(5)	'���ܼ��Ÿ��� �б�
    BUTTON_NO = J
    GOSUB Number_Play
    GOSUB SOUND_PLAY_CHK
    GOSUB GOSUB_RX_EXIT

    GOTO RX_EXIT
    '***************
KEY6:
    ETX  4800,107
    ' �̼Ǽ��� =2
    ' GOTO �����ڵ�_4



    GOTO RX_EXIT
    '***************
KEY7:
    ETX  4800,7
    GOSUB ������20

    GOTO RX_EXIT
    '***************
KEY8:
    ETX  4800,8
    GOTO �ѹ߾����ΰ���

    GOTO RX_EXIT
    '***************
KEY9:
    ETX  4800,9
    GOTO ��������20


    GOTO RX_EXIT
    '***************
KEY10: '0
    ETX  4800,10
    ''GOTO �����޸���50
    GOSUB ��ܿ�����mm
    GOTO RX_EXIT
    '***************
KEY11: ' ��
    ETX  4800,11
    �̼Ǽ���=0
    'GOTO ��������
    GOTO �����ڵ�

    GOTO RX_EXIT
    '***************
KEY12: ' ��
    ETX  4800,12
    GOTO ������������

    GOTO RX_EXIT
    '***************
KEY13: '��
    ETX  4800,13
    GOTO �����ʿ�����70����


    GOTO RX_EXIT
    '***************
KEY14: ' ��
    ETX  4800,14
    GOTO ���ʿ�����70����


    GOTO RX_EXIT
    '***************
KEY15: ' A
    ETX  4800,15
    GOTO ���ʿ�����20


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
    IF  A = 16 THEN 	'�ٽ� �Ŀ���ư�� �����߸� ����
        SPEED 10
        MOVE G6A,100, 140,  37, 145, 100, 100
        MOVE G6D,100, 140,  37, 145, 100, 100
        WAIT
        GOSUB Leg_motor_mode2
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
    GOSUB m���ʿ�����20


    DELAY 10000
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
    GOTO ��ܿ����߳�����3cm

    GOTO RX_EXIT
    '***************
KEY20: ' B	
    ETX  4800,20
    GOTO �����ʿ�����20


    GOTO RX_EXIT
    '***************
KEY21: ' ��
    ETX  4800,21
    GOTO �����ڵ�

    GOTO RX_EXIT
    '***************
KEY22: ' *	
    ETX  4800,22
    GOTO ��ܿ޹߿�����1cm

    GOTO RX_EXIT
    '***************
KEY23: ' G
    GOSUB ����������
    DELAY 3000
    GOSUB ����������
    DELAY 3000
    GOSUB ����������
    DELAY 3000
    GOSUB ����������
    DELAY 3000
    GOTO RX_EXIT
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
    GOTO ��ܿ����߿�����1cm

    GOTO RX_EXIT
    '***************
KEY25: ' P1
    ETX  4800,25
    GOTO ��ܿ޹߳�����3cm

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
    GOTO �Ӹ�������90��


    GOTO RX_EXIT
    '***************
KEY28: ' ��
    ETX  4800,28
    'GOTO �Ӹ�����45��
    'SERVO 11, 10
    SPEED 15
    MOVE G6B, , , , , , 10
    WAIT

    GOTO RX_EXIT
    '***************
KEY29: ' ��
    �̼Ǽ��� =3
    GOTO �����ڵ�_5
    GOTO RX_EXIT
    '***************
KEY30: ' ��
    ETX  4800,30
    'GOTO �Ӹ�������45��

    'SERVO 11, 190
    SPEED 15
    MOVE G6B, , , , , , 190
    WAIT


    GOTO RX_EXIT
    '***************
KEY31: ' ��
    ETX  4800,31
    GOSUB ���ܼ��Ÿ�����Ȯ��
    IF ���ܼ��Ÿ���<60 THEN
        MUSIC "C"
    ENDIF
    GOTO MAIN
    '***************

KEY32: ' F
    ETX  4800,32
    �̼Ǽ��� =1
    GOTO �����ڵ�_3
    GOTO RX_EXIT
    '***************
