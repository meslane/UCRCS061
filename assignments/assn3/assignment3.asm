;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Assignment name: Assignment 3
; Lab section: 025
; TA: Ethan Valdez
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
LD R6, Value_ptr		; R6 <-- pointer to value to be displayed as binary
LDR R1, R6, #0			; R1 <-- value to be displayed as binary 
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
ADD R5, R5, #15
ADD R4, R4, #0
ADD R3, R3, #-4

MASTERLOOP
	ADD R1, R1, #0 ;inspect number
	BRn IFONE
	BRzp IFZERO
	
	IFONE
		LD R0, ONE
		OUT
		BR SHIFT
		
	IFZERO
		LD R0, ZERO
		OUT
		BR SHIFT
		
	SHIFT
	ADD R1, R1, R1
	
	ADD R4, R4, #1
	ADD R2, R4, R3
	BRz dospace
	BR final
	
	dospace
		ADD R2, R5, #0
		BRz donewline
		LD R0, SPACE
		OUT
		ADD R4, R4, #-4
		BR final
		
		donewline
			LD R0, NEWLINE
			OUT
			
	
	final
	ADD R5, R5, #-1
	BRzp MASTERLOOP

HALT
;---------------	
;Data
;---------------
Value_ptr	.FILL xB270; The address where value to be displayed is stored
ZERO .FILL '0'
ONE  .FILL '1'
SPACE .FILL ' '
NEWLINE .FILL '\n'

.ORIG xB270					; Remote data
Value .FILL xABCD			; <----!!!NUMBER TO BE DISPLAYED AS BINARY!!! Note: label is redundant.
;---------------	
;END of PROGRAM
;---------------	
.END
