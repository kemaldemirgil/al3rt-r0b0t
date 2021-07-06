#picaxe28x1
symbol ADCReadleft= b2 
symbol ADCReadCenter= b3 
symbol ADCReadRight= b4 
symbol Previous_endofLine= bit0 ; store end line previous condition
symbol Previous_corner= bit1     ; store end corner previous condition
; *********************************************

symbol DetectorL= pin2 
symbol DetectorC= pin3 
symbol DetectorR= pin4
; *********************************************
symbol EmitterL= pinc.0;B.12   ; in case we are using controlled emmiter
symbol EmitterC= pinc.1 ;B.11  ; in case we are using controlled emmiter
symbol EmitterR= pinc.2;B.10   ; in case we are using controlled emmiter
; *********************************************
symbol Led_L= output2;B.2    ;can be  useedto test your detector status
symbol Led_C= pinc.1 ;B.1    ;can be  useedto test your detector status
symbol Led_R= pinc.0;B.0     ;can be  useedto test your detector status
symbol LDR_L  = 2
symbol LDR_R = 3
symbol Light_LD = b4
symbol Light_RD = b5
symbol Diff_L = b6
symbol Diff_R = b7
symbol LDRoffsetL = B8
symbol LDRoffsetR = B9 
symbol LeftPower = w13       ; 
symbol RightPower = w12
symbol VeerValue = b12
symbol LeftMotDrv = 2
symbol RightMotDrv = 1
symbol LeftRvsCtrl = outpin7
symbol LeftFwdCtrl = outpin6
symbol RightRvsCtrl = outpin5
symbol RightFwdCtrl = outpin4
symbol LEDon = 0 ; The LED turns ON with a logic low
symbol LEDoff = 1 ; The LED turns OFF with a logic high
symbol GreenLED = outpin3 ; Port B.3 (28X1 pin#24 & header pin #20)
symbol PiezoSounder = output0 ; Port B.0 (28X1 pin#21 & header pin #14)
symbol Beep = b19 ; Variable holding the beep tone value
symbol Speed = 3
symbol IRLeft = pinC.7 ; connects to pin B.1 for interfacing Left IR detector
symbol IRRight = pinC.6 ; connects to pin B.3 for interfacing Right IR detector
symbol bigboy = b17
VeerValue = 15

; *********************************************
Initialization:
	pwmout pwmdiv16, LeftMotDrv, 249, 0 ; Period = 4 ms (motor2)
	pwmout pwmdiv16, RightMotDrv, 249, 0 ; Period = 4 ms (motor1)
	LeftPower = 550 : RightPower = 500 ; Initial drive power
	

main:
	if ADCReadleft>200 and ADCReadCenter<200 and ADCReadRight>200 then let Previous_endofLine = 1 else Previous_endofLine = 0 endif
	if ADCReadleft>200 and ADCReadCenter<200 and ADCReadRight<200 then let Previous_corner = 1 else Previous_corner = 0 endif
	readadc 1,ADCReadleft ; or hight 0:pause 1000: readadc 2,ADCReadleft:low 0
	readadc 2,ADCReadCenter ; or hight 1:pause 1000: readadc 2,ADCReadleft:low 1
	readadc 3,ADCReadRight ; or hight 2:pause 1000: readadc 2,ADCReadleft:low 2
	if ADCReadleft>200 and ADCReadCenter>200 and ADCReadRight>200 and Previous_endofLine = 1 then gosub Findblackline ; modify this line if needed
	if ADCReadleft>200 and ADCReadCenter>200 and ADCReadRight>200 and Previous_corner = 1 then gosub RightCorner ; modify this line if needed
	if ADCReadleft>200 and ADCReadCenter<200 and ADCReadRight>200 then gosub Straight
	if ADCReadleft>200 and ADCReadCenter<200 and ADCReadRight<200 then gosub VeerTurnRotateRight
	if ADCReadleft<200 and ADCReadCenter<200 and ADCReadRight>200 then gosub VeerTurnRotateLeft
	if ADCReadleft<200 and ADCReadCenter<200 and ADCReadRight<200 then gosub EndofLineintersection
	debug
	goto main
	
	EndofLineintersection:
gosub StopMotors
Return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Straight:
	gosub DriveForward
Return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

VeerTurnRotateLeft:
	do
		if LeftPower > 200 and RightPower < 800 then
    	LeftPower = LeftPower - VeerValue : RightPower = RightPower + VeerValue
    	
  endif
	
	loop while ADCReadleft<100 and ADCReadCenter<100 and ADCReadRight>100
	gosub DriveForward
Return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

VeerTurnRotateRight:
	do
		if RightPower > 200 and LeftPower < 800 then
    	RightPower = RightPower - VeerValue : LeftPower = LeftPower + VeerValue
 
  	endif
  	
	loop while ADCReadleft>100 and ADCReadCenter<100 and ADCReadRight<100
	gosub DriveForward
Return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

RightCorner:
gosub StopMotors
gosub DriveReverse pause 300
gosub RotateCW  pause 300
if ADCReadleft>100 and ADCReadCenter>100 and ADCReadRight>100 then ; checks to know which corner
	gosub RotateCCW pause 600
endif
Return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Findblackline:
gosub DriveForward pause 300
Return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

LED:
		GreenLED = LEDon
	return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

GetLDRLevels:
		readADC 0, b4
		readADC 1, b5
		Light_RD = b5 - B3
		Light_LD = b4 - B0 
	return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

kiwi:
		LeftPower = 310 : RightPower = 320
		gosub DriveForward ;
		do
		loop while IRRight = 1 and IRLeft = 1
		gosub StopMotors
	return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

dolphin:
		gosub DriveReverse
		do
		loop while IRRight = 1 or IRLeft = 1
		pause 300
		gosub StopMotors
	return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

banana:
		gosub RotateCW : pause 600; Rotate CW 90 degrees
		if IRLeft = 1 or IRRight = 1 then
		gosub RotateCCW : pause 1200 ; Rotate CCW 180 degrees
		elseif IRLeft = 0 and IRRight = 0 then
		gosub DriveForward
	endif

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

MotSpeed:
LeftPower = 700 : RightPower = 650
return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

ForwardLeft:
		LeftFwdCtrl = 1	;
		LeftRvsCtrl = 0	;
		pwmduty LeftMotDrv, LeftPower	;
	return
	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

ForwardRight:
		RightFwdCtrl = 1	;
		RightRvsCtrl = 0	;
		pwmduty RightMotDrv, RightPower	;
	return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

ReverseLeft:
		LeftFwdCtrl = 0	;
		LeftRvsCtrl = 1	;
		pwmduty LeftMotDrv, LeftPower	;
	return
	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	
ReverseRight:
		RightFwdCtrl = 0	;
		RightRvsCtrl = 1	;
		pwmduty RightMotDrv, RightPower	;
	return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	
StopMotors:
		LeftFwdCtrl = 0					;
		LeftRvsCtrl = 0					;		
		RightFwdCtrl = 0				;
		RightRvsCtrl = 0				;
		pwmduty LeftMotDrv, 0		;
		pwmduty RightMotDrv, 0

	return
	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
	
DriveForward: ; Combined action
		gosub ForwardLeft
		gosub ForwardRight
return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

DriveReverse: ; Combined action
		gosub ReverseLeft
		gosub ReverseRight
return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

VeerLeft: ;Assumes that left = 500 and right = 500 to go straight
		if LeftPower > 500 and RightPower < 650 then ;Sets limits of 300 to the veering
			LeftPower = LeftPower -VeerValue : RightPower = RightPower + VeerValue
			;The above line changes the applied motor power in a symmetrical way to veer towards the left
			gosub DriveForward ;Applies the power changes to both motors
			gosub MotSpeed
		endif
return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

VeerRight: ;Assumes that left = 500 and right = 500 to go straight
		if LeftPower > 500 and RightPower < 650 then ;Sets limits of 300 to the veering
			LeftPower = LeftPower +VeerValue : RightPower = RightPower - VeerValue
			;The above line changes the applied motor power in a symmetrical way to veer towards the left
			gosub DriveForward ;Applies the power changes to both motors
			gosub MotSpeed
		endif
return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

RotateCCW: ; Combined action
		gosub ReverseLeft
		gosub ForwardRight
return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

RotateCW: ; Combined action
		gosub ForwardLeft
		gosub ReverseRight
return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

CheckWalls:
				gosub StopMotors	
return
	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>	

ChaCha:
		gosub RotateCCW : pause 300 ; Cha
		gosub RotateCW : pause 300 ; Cha
		gosub RotateCCW : pause 300 ; Cha!
		gosub RotateCW : pause 80 ; Brakes the dance by reversing for 80ms !
return

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Finale:
	GreenLED = LEDon
	tune PiezoSounder, 4,($65,$65,$65,$EA,$C5,$43,$42,$40,$CA,$05,$43,$42,$40,$CA,$05,$43,$42,$43,$C0,$2C,$65,$65,$65,$EA,$C5,$43,$42,$40,$CA,$05,$43,$42,$40,$CA,$05,$43,$42,$43,$C0)
return

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~~~END~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
