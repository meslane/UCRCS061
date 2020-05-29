;=================================================
; Name: 
; Email: 
; 
; Lab: lab 9, ex 1 & 2
; Lab section: 
; TA: 
; 
;=================================================

; test harness
					.orig x3000
				 
					LD R4, baseptr
					LD R5, maxptr
					LD R6, baseptr
					
					ADD R0, R0, #15
					
					LD R2, subpushptr
					JSRR R2
					JSRR R2
					JSRR R2
					
					LD R2, subpopptr
					JSRR R2
					JSRR R2
					JSRR R2
					
					ADD R0, R0, #-3
					
					LD R2, subpushptr
					JSRR R2

				 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:

baseptr .FILL xA000
maxptr  .FILL xA005

subpushptr .FILL x3200
subpopptr .FILL x3400

;===============================================================================================


; subroutines:

;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_PUSH
; Parameter (R0): The value to push onto the stack
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has pushed (R0) onto the stack (i.e to address TOS+1). 
;		    If the stack was already full (TOS = MAX), the subroutine has printed an
;		    overflow error message and terminated.
; Return Value: R6 ← updated TOS
;------------------------------------------------------------------------------------------
					.orig x3200
				 
					;stores
					ST R0, r0backup3200
					ST R5, r5backup3200
					;ST R6, r6backup3200
					ST R7, r7backup3200
				 
					ADD R6, R6, #1 ;inc TOS
					
					NOT R5, R5
					ADD R5, R5, #1
					ADD R5, R5, R6 ;test if TOS is at top
					BRzp overflow3200
					
					STR R0, R6, #0 ;push to top of stack if valid
					BR end3200
				 
					overflow3200 ;overflow if not
					ADD R6, R6, #-1 ;restore
					LEA R0, overflowmsg3200
					PUTS
					BR end3200
					
					end3200
					
					;loads
					LD R0, r0backup3200
					LD R5, r5backup3200
					;LD R6, r6backup3200 DONT BACKUP R6
					LD R7, r7backup3200
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_PUSH local data

r0backup3200 .BLKW #1
r4backup3200 .BLKW #1
r5backup3200 .BLKW #1
;r6backup3200 .BLKW #1
r7backup3200 .BLKW #1

overflowmsg3200 .STRINGZ "ERROR: stack overflow\n"

;===============================================================================================


;------------------------------------------------------------------------------------------
; Subroutine: SUB_STACK_POP
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available                      
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped MEM[TOS] off of the stack.
;		    If the stack was already empty (TOS = BASE), the subroutine has printed
;                an underflow error message and terminated.
; Return Value: R0 ← value popped off the stack
;		   R6 ← updated TOS
;------------------------------------------------------------------------------------------
					.orig x3400
					
					;stores
					ST R1, r1backup3400
					ST R4, r4backup3400
					ST R5, r5backup3400
					ST R7, r7backup3400
					
					LDR R1, R6, #0 ;get data
					ADD R6, R6, #-1 ;decrement tos
					
					NOT R4, R4
					ADD R4, R4, #1
					ADD R4, R4, R6
					BRn underflow3400
					BR end3400
					
					underflow3400
					ADD R6, R6, #1 ;restore pointer if error
					LEA R0, underflowmsg3400
					PUTS
					BR end3400
					
					end3400
					AND R0, R0, #0
					ADD R0, R1, #0 ;ld R0 with popped value
				 
					;restores
					LD R1, r1backup3400
					LD R4, r4backup3400
					LD R5, r5backup3400
					LD R7, r7backup3400
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_STACK_POP local data

r1backup3400 .BLKW #1
r4backup3400 .BLKW #1
r5backup3400 .BLKW #1
r7backup3400 .BLKW #1

underflowmsg3400 .STRINGZ "ERROR: stack underflow\n"
;===============================================================================================

