 #picaxe 28x1
symbol ADCReadleft = b2
symbol ADCReadCenter = b3
symbol ADCReadRight = b4
symbol Previous_endofLine = bit0 ; store end line previous condition
symbol Previous_corner = bit1 ; store end corner previous condition
; *********************************************
symbol DetectorL = pin2
symbol DetectorC = pin3
symbol DetectorR = pin4
; *********************************************
;symbol EmitterL = pinc.0;B.12 ; in case we are using controlled emmiter
;symbol EmitterC = pinc.1 ;B.11 ; in case we are using controlled emmiter
;symbol EmitterR = pinc.2;B.10 ; in case we are using controlled emmiter
; *********************************************
symbol Led_L = output2;B.2 ;can be useed to test your detector status
symbol Led_C = pinc.1 ;B.1 ;can be useed to test your detector status
symbol Led_R = pinc.0;B.0 ;can be useed to test your detector status
; *********************************************
symbol veervalue = b12
symbol LeftPower = w13;
symbol RightPower = w12;
symbol LeftMotDrv = 2;
symbol RightMotDrv = 1;
symbol LeftRvsCtrl = outpin7;
symbol LeftFwdCtrl = outpin6;
symbol RightRvsCtrl = outpin5
symbol RightFwdCtrl =outpin4
symbol LEDon = 0 ; The LED turns ON with a logic low
symbol LEDoff = 1 ; The LED turns OFF with a logic high
symbol GreenLED = outpin3 ; Port B.3 (28X1 pin#24 & header pin #20)
; *********************************************
Initialization:
	GreenLED = LEDoff
	pwmout pwmdiv16, LeftMotDrv, 249, 0
	pwmout pwmdiv16, RightMotDrv, 249, 0
	LeftPower = 880 : RightPower = 950

main:
	if ADCReadleft>100 and ADCReadCenter<100 and ADCReadRight>100 then let Previous_endofLine = 1 else Previous_endofLine = 0 endif
	if ADCReadleft>100 and ADCReadCenter<100 and ADCReadRight<100 then let Previous_corner = 1 else Previous_corner = 0 endif
	readadc 2,ADCReadleft ; or hight 0:pause 1000: readadc 2,ADCReadleft:low 0
	readadc 3,ADCReadCenter ; or hight 1:pause 1000: readadc 2,ADCReadleft:low 1
	readadc 4,ADCReadRight ; or hight 2:pause 1000: readadc 2,ADCReadleft:low 2
	if ADCReadleft>100 and ADCReadCenter>100 and ADCReadRight>100 and Previous_endofLine = 1 then gosub Findblackline ; modify this line if needed
	if ADCReadleft>100 and ADCReadCenter>100 and ADCReadRight>100 and Previous_corner = 1 then gosub RightCorner ; modify this line if needed
	if ADCReadleft>100 and ADCReadCenter<100 and ADCReadRight>100 then gosub Straight
	if ADCReadleft>100 and ADCReadCenter<100 and ADCReadRight<100 then gosub VeerTurnRotateRight
	if ADCReadleft<100 and ADCReadCenter<100 and ADCReadRight>100 then gosub VeerTurnRotateLeft
	if ADCReadleft<100 and ADCReadCenter<100 and ADCReadRight<100 then gosub EndofLineintersection
	goto main
	
	
	;subroutines
;//////////////////////////////////////////////////////////////////////

Findblackline:
gosub DriveForward pause 300
Return

RightCorner:
gosub StopMotors
gosub DriveReverse pause 300
gosub RotateCW  pause 300
if ADCReadleft>100 and ADCReadCenter>100 and ADCReadRight>100 then ; checks to know which corner
	gosub RotateCCW pause 600
endif
Return

VeerTurnRotateRight:
	do
		if RightPower > 200 and LeftPower < 800 then
    	RightPower = RightPower - VeerValue : LeftPower = LeftPower + VeerValue
 
  	endif
  	
	loop while ADCReadleft>100 and ADCReadCenter<100 and ADCReadRight<100
	gosub DriveForward
Return

VeerTurnRotateLeft:
	do
		if LeftPower > 200 and RightPower < 800 then
    	LeftPower = LeftPower - VeerValue : RightPower = RightPower + VeerValue
    	
  endif
	
	loop while ADCReadleft<100 and ADCReadCenter<100 and ADCReadRight>100
	gosub DriveForward
Return

Straight:
	gosub DriveForward
Return

EndofLineintersection:
gosub StopMotors
Return

; *********************************************

ForwardLeft:
	LeftFwdCtrl = 1;
	LeftRvsCtrl = 0;
	pwmduty LeftMotDrv, LeftPower;
	return
	
ForwardRight:
	RightFwdCtrl = 1;
	RightRvsCtrl = 0;
	pwmduty RightMotDrv, RightPower;
	return

ReverseLeft:
	LeftFwdCtrl = 0
	LeftRvsCtrl = 1;
	pwmduty LeftMotDrv, LeftPower;
	return

ReverseRight:
	RightFwdCtrl = 0;
	RightRvsCtrl = 1;
	pwmduty RightMotDrv, RightPower;
	return

StopMotors:
	LeftFwdCtrl = 0;
	LeftRvsCtrl = 0;
	RightFwdCtrl = 0;
	RightRvsCtrl = 0;
	pwmduty LeftMotDrv, 0;
	pwmduty RightMotDrv, 0;
	return
	
DriveForward:
	LeftPower = 880 : RightPower = 950
	gosub ForwardLeft:gosub ForwardRight
	return
	
DriveReverse:
	gosub ReverseLeft:gosub ReverseRight
	return
	
RotateCCW:
	gosub ReverseLeft:gosub ForwardRight
	return
	
RotateCW:
	gosub ReverseRight:gosub ForwardLeft
	return
	
VeerLeft:
	  if LeftPower > 200 and RightPower < 800 then
    LeftPower = LeftPower - VeerValue : RightPower = RightPower + VeerValue
    gosub DriveForward
  endif
return

VeerRight:

if RightPower > 200 and LeftPower < 800 then
    RightPower = RightPower - VeerValue : LeftPower = LeftPower + VeerValue
    gosub DriveForward
  endif
return