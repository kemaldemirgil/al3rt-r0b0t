;Robotics and Controls
;Mr_robot v3
;Kemal Demirgil

;symbols//////////////////////////////////////////////////////////////////////
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

;////////////////////////////////////////////////////////////////////////////

Initialization:
	pwmout pwmdiv16, LeftMotDrv, 249, 0 ; Period = 4 ms (motor2)
	pwmout pwmdiv16, RightMotDrv, 249, 0 ; Period = 4 ms (motor1)
	LeftPower = 595 : RightPower = 660 ; Initial drive power
	
;////////////////////////////////////////////////////////////////////////////

Lab09:
	if IRLeft = 0 and IRRight = 0 then
		gosub DriveForward

	elseif IRLeft = 1 and IRRight = 0 then
		gosub VeerRight
		
	elseif IRLeft = 0 and IRRight = 1 then
		gosub VeerLeft
	
	endif
	
	if IRLeft = 1 and IRRight = 1 then
		gosub CheckWalls
	else
	goto Lab09
	endif

;subroutines
;//////////////////////////////////////////////////////////////////////
ForwardLeft:
		LeftFwdCtrl = 1	;
		LeftRvsCtrl = 0	;
		pwmduty LeftMotDrv, LeftPower	;
	return

ForwardRight:
		RightFwdCtrl = 1	;
		RightRvsCtrl = 0	;
		pwmduty RightMotDrv, RightPower	;
	return

ReverseLeft:
		LeftFwdCtrl = 0	;
		LeftRvsCtrl = 1	;
		pwmduty LeftMotDrv, LeftPower	;
	return
	
ReverseRight:
		RightFwdCtrl = 0	;
		RightRvsCtrl = 1	;
		pwmduty RightMotDrv, RightPower	;
	return
	
StopMotors:
		LeftFwdCtrl = 0					;
		LeftRvsCtrl = 0					;		
		RightFwdCtrl = 0				;
		RightRvsCtrl = 0				;
		pwmduty LeftMotDrv, 0		;
		pwmduty RightMotDrv, 0
		gosub DriveReverse : pause 110
	return
	
DriveForward: ; Combined action
		gosub ForwardLeft
		gosub ForwardRight
return

DriveReverse: ; Combined action
		gosub ReverseLeft
		gosub ReverseRight
return

VeerLeft: ;Assumes that left = 500 and right = 500 to go straight
		if LeftPower > 200 and RightPower < 800 then ;Sets limits of 300 to the veering
			LeftPower = LeftPower -VeerValue : RightPower = RightPower + VeerValue
			;The above line changes the applied motor power in a symmetrical way to veer towards the left
			gosub DriveForward ;Applies the power changes to both motors
		endif
return

VeerRight: ;Assumes that left = 500 and right = 500 to go straight
		if LeftPower > 200 and RightPower < 800 then ;Sets limits of 300 to the veering
			LeftPower = LeftPower +VeerValue : RightPower = RightPower - VeerValue
			;The above line changes the applied motor power in a symmetrical way to veer towards the left
			gosub DriveForward ;Applies the power changes to both motors
		endif
return

RotateCCW: ; Combined action
		gosub ReverseLeft
		gosub ForwardRight
return

RotateCW: ; Combined action
		gosub ForwardLeft
		gosub ReverseRight
return

CheckWalls:
		do 
				gosub StopMotors
				gosub DriveReverse : pause 1000 ; adjust in lab for back up
				gosub RotateCW : pause 600 ; Rotates 90 degrees CW
				if IRright = 1 and IRLeft = 1 then
					gosub RotateCCW : pause 1200 ; Rotates 180 degrees CCW
			endif
		loop while IRright = 1 and IRLeft = 1
return

ChaCha:
		gosub RotateCCW : pause 300 ; Cha
		gosub RotateCW : pause 300 ; Cha
		gosub RotateCCW : pause 300 ; Cha!
		gosub RotateCW : pause 80 ; Brakes the dance by reversing for 80ms !
return

Finale:
	GreenLED = LEDon
	tune PiezoSounder, 2,($21,$63,$24,$66,$28,$6C,$64,$2C,$27,$6C,$63,$2C,$26,$64,$2C,$21,$63,$24,$66,$28,$6C,$41,$2C,$C0,$2C,$EC,$21,$63,$64,$6C,$66,$28,$6C,$64,$2C,$27,$6C,$63,$2C,$26,$24,$21,$AC,$EC,$6C,$20,$21,$EC,$21,$63,$24,$66,$28,$6C,$64,$2C,$27,$6C,$63,$2C,$26,$64,$2C,$21,$63,$24,$66,$28,$6C,$41,$2C,$C0,$2C,$EC,$21,$63,$64,$6C,$66,$28,$6C,$64,$2C,$27,$6C,$63,$2C,$26,$24,$21,$AC,$EC,$6C,$20,$21)
return

	
;//////////////////////////////////////////////////////////////////////////////////////////
