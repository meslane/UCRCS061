;=================================================
; Name: Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 6, ex 3
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

	;calculate R5 here
	AND R5, R5, #0
	ADD R5, R5, R1
	ADD R5, R5, #-1
	LD R1, strarrayptr
	
	LD R2, sub3300ptr ;set to all caps for comp.
	JSRR R2
	;LD R1, strarrayptr ;restore array poinreer
	
	;test pal
	LD R2, sub3200ptr
	JSRR R2
	
	ADD R4, R4, #-1
	BRz palconfirmed
	BR notpalconfirmed
	
	palconfirmed
		LEA R0, ispal
		PUTS
		BR finish
	
	notpalconfirmed
		LEA R0, notpal
		PUTS
		BR finish
		
finish
HALT

strarrayptr .FILL x4000
sub3100ptr  .FILL x3100
sub3200ptr  .FILL x3200
sub3300ptr  .FILL x3300
prompt .STRINGZ "Enter a string followed by [ENTER]:\n"
ispal .STRINGZ  " IS a palindrome\n"
notpal .STRINGZ " IS NOT a palindrome\n" 


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


;start 3200 sub
.orig x3200
SUB_IS_PALINDROME
	ST R0, R0BACKUP3200
	ST R2, R2BACKUP3200
	ST R3, R3BACKUP3200
	ST R6, R6BACKUP3200
	ST R7, R7BACKUP3200
	;end stores
	;R1 = starting address
	;R4 = return value (0 if not pal, 1 if pal)
	;R5 = array size (set to ending address)
	
	AND R4, R4, #0 ;zero out R4
	;ADD R5, R1, R5 ;set R5 to address at end of array
	
	loop3200
		LDR R2, R1, #0
		LDR R3, R5, #0 ;get values
		
		NOT R3, R3
		ADD R3, R3, #1 ;invert R3 for subtraction
		
		ADD R2, R3, R2 ;test
		BRnp notpal3200 ;goto end if not equal
		
		;test if half or more than half of string traversed
		NOT R2, R1 ;set R2 to starting address for comp.
		ADD R2, R2, #1 ;convert to negative
		ADD R2, R2, R5 ;compare
		
		ADD R1, R1, #1 ;add one to front pointer
		ADD R5, R5, #-1 ;sub one from back pointer
		
		ADD R2, R2, #0 ;test R2
		BRp loop3200 ;keep doing loop if not done
		;end test
		
		ADD R4, R4, #1 ;set if loop is done and still is pal
		BR end3200 ;leave
		
	notpal3200
		BR end3200

	end3200
	;start restores
	LD R0, R0BACKUP3200
	LD R2, R2BACKUP3200
	LD R3, R3BACKUP3200 
	LD R6, R6BACKUP3200 
	LD R7, R7BACKUP3200 
	
	ret ;leave 

R0BACKUP3200 .blkw #1
R2BACKUP3200 .blkw #1
R3BACKUP3200 .blkw #1
R6BACKUP3200 .blkw #1
R7BACKUP3200 .blkw #1
;end 3200 sub


;start 3300 sub
.orig x3300
	ST R0, R0BACKUP3300
	ST R1, R1BACKUP3300
	ST R2, R2BACKUP3300
	ST R7, R7BACKUP3300
	;end restores
	
	LD R2, bitmask
	
	loop3300
		LDR R0, R1, #0
		AND R0, R0, R2
		STR R0, R1, #0
		ADD R1, R1, #1
		ADD R0, R0, #0
		BRnp loop3300 ;loop if not nul term
	
	;start restores
	LD R0, R0BACKUP3300
	LD R1, R1BACKUP3300
	LD R2, R2BACKUP3300
	LD R7, R7BACKUP3300
	
	ret
	
R0BACKUP3300 .blkw #1
R1BACKUP3300 .blkw #1
R2BACKUP3300 .blkw #1
R7BACKUP3300 .blkw #1

bitmask .FILL #223
;end 3300 sub



.orig x4000
stringarray .blkw #100

.end
