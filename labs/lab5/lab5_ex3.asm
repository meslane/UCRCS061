;=================================================
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 5, ex 3
; Lab section: 025 
; TA: Ethan Valdez
; 
;=================================================

.orig x3000
	LD R6, INSUBPTR
	JSRR R6 
	
	ADD R1, R2, #0
	LD R6, OUTSUBPTR
	JSRR R6

HALT
INSUBPTR .FILL x3100
OUTSUBPTR .FILL x3200


;start of input
.orig x3100
INSUB ;return value in R2
	st R0, R0BACKUP3100
	st R1, R1BACKUP3100
	st R3, R3BACKUP3100 
	st R4, R4BACKUP3100 
	st R5, R5BACKUP3100 
	st R7, R7BACKUP3100 
	
	start3100
	;set to proper values
	AND R1, R1, #0 ;counter
	ADD R1, R1, #15
	ADD R1, R1, #1 ;adds to 16
	AND R2, R2, #0 ;output value 
	LD R3, OFFSET3100
	
	;check b and test for error
	GETC ;throw out b
	OUT ;but echo
	LD R4, BOFFSET3100 
	ADD R0, R0, R4
	BRnp berror3100
	BRz binloop
	
	berror3100
		LD R0, NEWLINE3100
		OUT
		LEA R0, ERRORSTRING
		PUTS
		BR start3100
	;end check b and test for error
		
	
	binloop
		;calculate binary power
		AND R5, R5, #0
		ADD R5, R5, #1 ;set R5 to 1
		ADD R4, R1, #-1 ;load R4 with multiplicand minus 1 (15 - 0)	
		
		BRz endset3100 ;don't do loop if zero
		
		mulloop3100
			ADD R5, R5, R5 ;shift right
			ADD R4, R4, #-1 ;sub mul
			BRp mulloop3100
		
		endset3100
		;end calculate power
		
		charin3100
		GETC
		OUT
		ADD R0, R0, R3
		BRz ifzero3100
		BRp testin3100
		
		;test for valid/invalid characters
		testin3100
			ADD R0, R0, #-1 ;test if 1
			BRz ifone3100
			
			ADD R0, R0, #15 ;test if space
			ADD R0, R0, #2
			BRz ifspace3100
			
			LEA R0, ERRORSTRING2 ;if anything else
			PUTS
			BR charin3100
			
		;end test for valid/invalid characters
		
		ifzero3100
			LD R0, ZERO3100
			BR endif3100a
			
		ifspace3100
			LD R0, SPACE3100
			BR charin3100
			
		ifone3100
			ADD R2, R2, R5
			LD R0, ONE3100
			BR endif3100a
			
		endif3100a
			ADD R1, R1, #-1
			BRp binloop
	
	LD R0, NEWLINE3100
	OUT
	
	ld R0, R0BACKUP3100
	ld R1, R1BACKUP3100
	ld R3, R3BACKUP3100 
	ld R4, R4BACKUP3100 
	ld R5, R5BACKUP3100 
	ld R7, R7BACKUP3100 

	ret
	
R0BACKUP3100 .blkw #1
R1BACKUP3100 .blkw #1
R3BACKUP3100 .blkw #1
R4BACKUP3100 .blkw #1
R5BACKUP3100 .blkw #1
R7BACKUP3100 .blkw #1

OFFSET3100 .fill #-48
BOFFSET3100 .fill #-98
ZERO3100 .FILL '0'
ONE3100  .FILL '1'
SPACE3100 .FILL ' '
NEWLINE3100 .FILL '\n'
ERRORSTRING .STRINGZ "ERROR: first character must be 'b'\n"
ERRORSTRING2 .STRINGZ "\nERROR: input characters must be '0', '1', or SPACE\n"

;start of output subroutine
.orig x3200 
OUTSUB ;input value in R1
	;backups
	st R0, R0BACKUP3200
	st R1, R1BACKUP3200
	st R2, R2BACKUP3200
	st R3, R3BACKUP3200
	st R4, R4BACKUP3200
	st R5, R5BACKUP3200
	st R7, R7BACKUP3200
	
	AND R0, R0, #0
	AND R2, R2, #0
	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0
	
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
	
	;restores
	ld R0, R0BACKUP3200
	ld R1, R1BACKUP3200
	ld R2, R2BACKUP3200
	ld R3, R3BACKUP3200
	ld R4, R4BACKUP3200
	ld R5, R5BACKUP3200
	ld R7, R7BACKUP3200
	
	ret
	
ZERO .FILL '0'
ONE  .FILL '1'
SPACE .FILL ' '
NEWLINE .FILL '\n'

R0BACKUP3200 .blkw #1
R1BACKUP3200 .blkw #1
R2BACKUP3200 .blkw #1
R3BACKUP3200 .blkw #1
R4BACKUP3200 .blkw #1
R5BACKUP3200 .blkw #1
R7BACKUP3200 .blkw #1


.end
