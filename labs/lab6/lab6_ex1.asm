;=================================================
; Name: Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 6, ex 1
; Lab section: 025
; TA: Ethan Valdez
; 
;=================================================

;main loop
.orig x3000
	LEA R0, prompt
	PUTS ;output prompt 
	
	LD R1, strarrayptr ;set array location
	LD R2, sub3100ptr
	JSRR R2
	
	LD R0, strarrayptr
	PUTS

HALT

strarrayptr .FILL x4000
sub3100ptr  .FILL x3100
prompt .STRINGZ "Enter a string followed by [ENTER]:\n"


;start 3100 sub
.orig x3100
SUB_GET_STRING
	ST R0, R0BACKUP3100
	ST R2, R2BACKUP3100
	ST R3, R3BACKUP3100
	ST R4, R4BACKUP3100
	ST R5, R5BACKUP3100
	ST R6, R6BACKUP3100
	ST R7, R7BACKUP3100
	;end stores
	
	;R1 = loop pointer
	
	loop3100
	GETC
	OUT
	ADD R3, R0, #-10 ;test R0
	BRz end3100 ;goto end if newline
	STR R0, R1, #0 ;store to array
	ADD R1, R1, #1 ;inc R1
	BR loop3100
	
	end3100
	AND R0, R0, #0 ;set to zero
	STR R0, R1, #0 ;null terminate
	
	;start restores
	LD R0, R0BACKUP3100
	LD R2, R2BACKUP3100
	LD R3, R3BACKUP3100 
	LD R4, R4BACKUP3100 
	LD R5, R5BACKUP3100 
	LD R6, R6BACKUP3100 
	LD R7, R7BACKUP3100 
	
	ret ;leave 

R0BACKUP3100 .blkw #1
R2BACKUP3100 .blkw #1
R3BACKUP3100 .blkw #1
R4BACKUP3100 .blkw #1
R5BACKUP3100 .blkw #1
R6BACKUP3100 .blkw #1
R7BACKUP3100 .blkw #1
;END 3100 SUB



.orig x4000
stringarray .blkw #100

.end
