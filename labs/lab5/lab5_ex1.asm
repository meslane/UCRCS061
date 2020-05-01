;=================================================
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 5, ex 1
; Lab section: 025 
; TA: Ethan Valdez
; 
;=================================================

.orig x3000

AND R1, R1, #0 ;set to zero
ADD R1, R1, #1 ;add 1
AND R3, R3, #0
ADD R3, R3, #10 
LD R2, ARRPTR

loop
	STR R1, R2, #0
	ADD R1, R1, R1
	ADD R2, R2, #1
	
	ADD R3, R3, #-1 ;loop if not zero
	BRp loop
	
LDR R2, R2, #-4 ;grab seventh value

LD R2, ARRPTR
AND R3, R3, #0
ADD R3, R3, #10 
LD R4, OFFSET

LD R0, OUTSUBPTR

outloop
	LDR R1, R2, #0
	ADD R2, R2, #1
	
	JSRR R0
	
	ADD R3, R3, #-1 
	BRp outloop

HALT
ARRPTR .FILL x4000
OFFSET .FILL #0
OUTSUBPTR .FILL x3200


;start of subroutine
.orig x3200 
OUTSUB
	;backups
	st R0, R0BACKUP
	st R1, R1BACKUP
	st R2, R2BACKUP
	st R3, R3BACKUP
	st R4, R4BACKUP
	st R5, R5BACKUP
	st R7, R7BACKUP
	
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
	ld R0, R0BACKUP
	ld R1, R1BACKUP
	ld R2, R2BACKUP
	ld R3, R3BACKUP
	ld R4, R4BACKUP
	ld R5, R5BACKUP
	ld R7, R7BACKUP
	
	ret
	
ZERO .FILL '0'
ONE  .FILL '1'
SPACE .FILL ' '
NEWLINE .FILL '\n'

R0BACKUP .blkw #1
R1BACKUP .blkw #1
R2BACKUP .blkw #1
R3BACKUP .blkw #1
R4BACKUP .blkw #1
R5BACKUP .blkw #1
R7BACKUP .blkw #1

.orig x4000
ARRAY .BLKW #10
