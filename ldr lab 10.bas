#picaxe 28x1

symbol LDR_L  = 2
symbol LDR_R = 3
symbol Light_LD = b4
symbol Light_RD = b5
symbol Diff_L = b6
symbol Diff_R = b7
symbol LDRoffsetL = B0
symbol LDRoffsetR = B3 
symbol veervalue = b12
symbol LeftPower = w13;
symbol RightPower = w12;
symbol LeftMotDrv = 2;
symbol RightMotDrv = 1;
symbol LeftRvsCtrl = outpin7;
symbol LeftFwdCtrl = outpin6;
symbol RightRvsCtrl = outpin5
symbol RightFwdCtrl =outpin4


Initialization:

pwmout pwmdiv16, LeftMotDrv, 249, 0
pwmout pwmdiv16, RightMotDrv, 249, 0

LeftPower = 780 : RightPower = 850
LDRoffsetL = 0
LDRoffsetR = 0
outpin0 = 1

gosub GetLDRLevels
	if Light_RD > Light_LD then
		LDRoffsetR = Light_RD - Light_LD
	else
		LDRoffsetL = Light_LD - Light_RD
	endif

drive:

SetFreq m8
settimer 65224

timer = 0

do
readADC 0, b4
readADC 1, b5
Light_RD = b5 - B3
Light_LD = b4 - B0

if Light_RD > Light_LD then
Diff_R = Light_RD - Light_LD : Diff_L = 0

else Diff_L = Light_LD - Light_RD : Diff_R = 0
endif


gosub DriveForward 

if Diff_L > 4 then ; to get difference take highest number subtract lowest from debug program shining light
 gosub RotateCCW
 
 elseif Diff_R > 2 then ; to get difference take highest number subtract lowest from debug program shining light 
 gosub RotateCW ; CLOCKWISE
 end if
 
 loop until timer > 2003 ; 20 seconds = 2003
 
 gosub StopMotors
 
 gosub LED
 
end


GetLDRLevels:
readADC 0, b4
readADC 1, b5
Light_RD = b5 - B3
Light_LD = b4 - B0 
return

LED:
outpin0 = 0
return


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
