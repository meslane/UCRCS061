;=================================================
; Name: Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 1, ex 0
; Lab section: 025
; TA: Ethan Valdez
; 
;=================================================

.ORIG x3000

	LEA R0, MSG_TO_PRINT
	PUTS
	
	HALT

	MSG_TO_PRINT.STRINGZ "Hello World!\n"
	
.END
