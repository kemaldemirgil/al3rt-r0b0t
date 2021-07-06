#picaxe 14M2
;Right IR
symbol ObstacleR= pinB.1 ;Used to transmit result to 28X1
symbol  DetectorR = pinC.1 ; Right IR detectors wired to pin C.1
symbol NewSampleR = bit0   ; Newest sample from Right detector
symbol     ScoreR = b4     ; Holds # of good scans in the fixed group
symbol  ScanCount = b5     ; Iteration counter

;Left IR
symbol ObstacleL= pinB.3 ;Used to transmit result to 28X1
symbol  DetectorL = pinB.5 ; Right IR detectors wired to pin C.1
symbol NewSampleL = bit1   ; Newest sample from Right detector
symbol     ScoreL = b6     ; Holds # of good scans in the fixed group
symbol  ScanCountL = b7     ; Iteration counter

; *********************************************
;The following program segment uses hysteresis to transmit the Right result

Initilization:
Pwmout C.0,25,52
Pwmout B.4,25,52
dirB.1 = 1 ;Make B.1 an output to transmit the result to the 28x1
dirB.3 = 1

HysteresisR:
	gosub FixedGroupScanR ;Get a scan score
	if ScoreR> 3 then
		ObstacleR= 1 ;Right obstacle detected
	else if ScoreR< 3 then
		ObstacleR= 0 ;Right obstacle NOT detected
endif
goto HysteresisL

HysteresisL:
	gosub FixedGroupScanL;Get a scan score
	if ScoreL> 3 then
		ObstacleL= 1 ;Right obstacle detected
	else if ScoreL< 3 then
		ObstacleL= 0 ;Right obstacle NOT detected
endif
goto HysteresisR

; ********************************************* Sub Routines

FixedGroupScanR:           ; Subroutine that performs 5 IR scans
  ScoreR = 0               ; Resets right scan score
  for ScanCount = 1 to 5   ; Iteration counter
    dirC.0 = 1             ; Allows PWM on right IR LED  to start IR scan
    pause 1                ; Delay of 1 ms required to give time to the                           ; detector to fully detect the IR signal.
    NewSampleR = not DetectorR ; Reads the active-low right detector
    dirC.0 = 0             ; Turns OFF right IR LED to let the detector                           ;  AGC recover to background noise level
    ScoreR = ScoreR + NewSampleR  ; Will increment the score when                                   ; good IR is detected
    pause 10  ; Delay to allow the AGC to recover to background noise level
  next ScanCount
return

FixedGroupScanL:           ; Subroutine that performs 5 IR scans
  ScoreL = 0               ; Resets right scan score
  for ScanCountL = 1 to 5   ; Iteration counter
    dirB.4 = 1             ; Allows PWM on right IR LED  to start IR scan
    pause 1                ; Delay of 1 ms required to give time to the                           ; detector to fully detect the IR signal.
    NewSampleL = not DetectorL ; Reads the active-low right detector
    dirB.4 = 0             ; Turns OFF right IR LED to let the detector                           ;  AGC recover to background noise level
    ScoreL = ScoreL + NewSampleL  ; Will increment the score when                                   ; good IR is detected
    pause 10  ; Delay to allow the AGC to recover to background noise level
  next ScanCountL
return
