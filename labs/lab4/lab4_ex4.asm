;=================================================
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 4, ex 4
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

outloop
	LDR R0, R2, #0
	ADD R2, R2, #1
	
	ADD R0, R0, R4
	OUT
	
	ADD R3, R3, #-1 
	BRp outloop

HALT
ARRPTR .FILL x4000
OFFSET .FILL #0

.orig x4000
ARRAY .BLKW #10
