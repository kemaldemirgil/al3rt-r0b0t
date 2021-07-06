

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;<<Robotics and Controls<<<<Robotics and Controls<<<<Robotics and Controls<<<<Robotics and Controls<<<<Robotics and Controls<<
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;<<gameface<<<<gameface<<<<gameface<<<<gameface<<<<gameface<<<<gameface<<<<gameface<<<<gameface<<<<gameface<<<<gameface<<
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;<<bykemaldemirgil<<<<bykemaldemirgil<<<<bykemaldemirgil<<<<bykemaldemirgil<<<<bykemaldemirgil<<<<bykemaldemirgil<<<<bykemaldemirgil<<
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~THEMAZE~~~~THEMAZE~~~~THEMAZE~~~~THEMAZE~~~~THEMAZE~~~~THEMAZE~~~~THEMAZE~~~~THEMAZE~~~~THEMAZE~~~~THEMAZE~~~~THEMAZE~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>Symbols>>>>Symbols>>>>Symbols>>>>Symbols>>>>Symbols>>>>Symbols>>>>Symbols>>>>>>Symbols>>>>Symbols>>>>Symbols>>>>Symbols>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

#picaxe 28x1
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
symbol Beep = b4 ; Variable holding the beep tone value
symbol Speed = 3
symbol IRLeft = pinC.7 ; connects to pin B.1 for interfacing Left IR detector
symbol IRRight = pinC.6 ; connects to pin B.3 for interfacing Right IR detector
VeerValue = 15

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>Initialization>>>>Initialization>>>>Initialization>>>>Initialization>>>>Initialization>>>>Initialization>>>>Initialization>>>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

Initialization:
	pwmout pwmdiv16, LeftMotDrv, 249, 0 ; Period = 4 ms (motor2)
	pwmout pwmdiv16, RightMotDrv, 249, 0 ; Period = 4 ms (motor1)
	LeftPower = 700 : RightPower = 650 ; Initial drive power
	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>MainProgram>>>>MainProgram>>>>MainProgram>>>>MainProgram>>>>MainProgram>>>>MainProgram>>>>MainProgram>>>>MainProgram>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

maze:

	if IRLeft = 0 and IRRight = 0 then
		gosub DriveForward

	elseif IRLeft = 1 and IRRight = 0 then
		gosub kiwi
		gosub dolphin
		gosub banana 
			
	elseif IRLeft = 0 and IRRight = 1 then
		gosub kiwi
		gosub dolphin
		gosub banana 
		
	elseif IRLeft = 1 and IRRight = 1 then
		gosub dolphin
		gosub banana
		
		endif
		
	goto maze
	
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;>>Subroutines>>>>Subroutines>>>>Subroutines>>>>Subroutines>>>>Subroutines>>>>Subroutines>>>>Subroutines>>>>Subroutines>>
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

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
LeftPower = 610 : RightPower = 620
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
