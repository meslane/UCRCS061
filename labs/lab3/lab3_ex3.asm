;=================================================
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 3, ex 3
; Lab section: 025
; TA: Ethan Valdez
; 
;=================================================

.ORIG x3000

LD R1, DEC_10
LEA R2, ARRAY

LOOP
    GETC
    OUT
    STR R0, R2, #0
    ADD R2, R2, #1
    ADD R1, R1, #-1
    BRnp LOOP

LEA R2, ARRAY
LD R1, DEC_10

OUTLOOP
	LD R0, NEWLINE
	OUT
	LDR R0, R2, #0
	OUT
	
	ADD R2, R2, #1
	
	ADD R1, R1, #-1
    BRnp OUTLOOP

HALT

NEWLINE .FILL '\n'
DEC_10  .FILL #10
ARRAY   .BLKW #10

.END
