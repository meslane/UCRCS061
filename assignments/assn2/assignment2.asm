;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Assignment name: Assignment 2
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

;----------------------------------------------
;output prompt
;----------------------------------------------	
LEA R0, intro			; get starting address of prompt string
PUTS			    	; Invokes BIOS routine to output string

;-------------------------------
;INSERT YOUR CODE here
;--------------------------------
GETC
ADD R1, R0, #0
OUT

LD R0, newline
OUT

GETC 
ADD R2, R0, #0
OUT

LD R0, newline
OUT

ADD R0, R1, #0
OUT 
LEA R0, minus
PUTS
ADD R0, R2, #0
OUT
LEA R0, equals
PUTS

LD R3, offset

ADD R1, R1, R3 ;remove the ascii offset to get the real number
ADD R2, R2, R3

LD R3, posoffset ;make offset positive

NOT R2, R2 ;convert to 2s compliment signed
ADD R2, R2, #1 

ADD R1, R2, R1 ;do the operation 

BRzp AFTERNEG ;skip negative management code if number is positive 
	LD R0, neg
	OUT
	
	NOT R1, R1 ;reverse negativeness
	ADD R1, R1, #1
	
	ADD R0, R1, #0

AFTERNEG ADD R0, R1, R3
OUT

LD R0, newline
OUT

HALT				; Stop execution of program

;------	
;Data
;------
; String to prompt user. Note: already includes terminating newline!
intro 	.STRINGZ	"ENTER two numbers (i.e '0'....'9')\n" 		; prompt string - use with LEA, followed by PUTS.
newline .FILL '\n'	; newline character - use with LD followed by OUT
minus   .STRINGZ " - "
neg     .FILL '-'
equals  .STRINGZ " = "
offset  .FILL #-48
posoffset .FILL #48



;---------------	
;END of PROGRAM
;---------------	
.END

