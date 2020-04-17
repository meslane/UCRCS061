;=================================================
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 3, ex 2
; Lab section: 025
; TA: Ethan Valdez
; 
;=================================================

.ORIG x3000

LD R1, DEC_10
LEA R2, ARRAY_1

LOOP
    GETC
    OUT
    STR R0, R2, #0
    ADD R2, R2, #1
    ADD R1, R1, #-1
    BRnp LOOP

HALT

ARRAY     .BLKW    #10
DEC_10    .FILL    #10
.END
