;=================================================
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 3, ex 4
; Lab section: 025
; TA: Ethan Valdez 
; 
;=================================================

.ORIG x3000

LD R2, ARRPTR

LOOP
    GETC
    OUT
    STR R0, R2, #0
    ADD R2, R2, #1 ;increment to next address
    
    LD R1, NEWLINE 
    NOT R1, R1 
    ADD R1, R1, #1
    
    ADD R0, R0, R1 ;subtract newline
    BRnp LOOP ;loop if input character != 0
    
LD R0, ZERO
STR R0, R2, #0 ;null-terminate

LD R0, ARRPTR
PUTS ;print line
    
HALT

ZERO .FILL #0
NEWLINE .FILL '\n'
ARRPTR .FILL 0x4000

.orig x4000
ARRAY

.END
