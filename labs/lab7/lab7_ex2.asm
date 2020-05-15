;=================================================
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 7, ex 2
; Lab section: 025 
; TA: Ethan Valdez
; 
;=================================================

.orig x3000
;input register = r0
;return register = r1
;begin main

LEA R0, promptstring
PUTS

GETC ;load into R0
OUT
ADD R3, R0, #0 ;backup

LD R6, countsubptr
JSRR R6

LEA R0, outstringa
PUTS

ADD R0, R3, #0
OUT

LEA R0, outstringb
PUTS

LD R2, asciioffset
ADD R0, R1, R2
OUT

LD R0, newline
OUT

;end main
HALT

asciioffset .FILL #48
newline     .FILL '\n'
countsubptr .FILL x3100

promptstring .STRINGZ "Input an ASCII character:\n"
outstringa   .STRINGZ "\nThe number of 1s in '"
outstringb   .STRINGZ "' is: "

;begin bit counting subroutine
.orig x3100
countbits
	ST R0, r0backup3100
	ST R2, r2backup3100
	ST R7, r7backup3100
	
	;r1 = bitcount
	;r2 = loop counter
	
	AND R2, R2, #0 ;zero
	ADD R2, R2, #8
	
	preloop3100 ;shift left 8
		ADD R0, R0, R0 ;shift 1
		ADD R2, R2, #-1 ;sub 1
		BRp preloop3100 ;loop if not at end
		
	AND R2, R2, #0 ;re zero
	ADD R2, R2, #8
	
	AND R1, R1, #0 ;zero out bitcount
	
	loop3100 ;start loop
		ADD R0, R0, #0 ;test
		BRzp shift3100;skip add if MSB not 1 
		ADD R1, R1, #1
		shift3100
		ADD R0, R0, R0 ;shift 1
		ADD R2, R2, #-1 ;sub 1
		BRp loop3100 ;loop if not at end
		 
	ret
	
	LD R0, r0backup3100
	LD R2, r2backup3100
	LD R7, r7backup3100
;end
r0backup3100 .BLKW #1
r2backup3100 .BLKW #1
r7backup3100 .BLKW #1

.end
