;=================================================
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 2, ex 4
; Lab section: 025
; TA: Ethan Valdez
; 
;=================================================

.ORIG x3000

	LD R0, LOOPVAL
	LD R1, LOOPCOUNT

	LOOP
		OUT
		ADD R0, R0, #1
		ADD R1, R1, #-1
		BRp LOOP

HALT

	LOOPVAL   .FILL x61
	LOOPCOUNT .FILL x1A

.END
