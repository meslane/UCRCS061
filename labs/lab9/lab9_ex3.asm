;=================================================
; Name: 
; Email: 
; 
; Lab: lab 9, ex 3
; Lab section: 
; TA: 
; 
;=================================================

; test harness
					.orig x3000
					
					;load stack vals
					LD R4, baseptr
					LD R5, maxptr
					LD R6, baseptr
					
					LD R1, numoffset
					
					LEA R0, promptstart
					PUTS
					
					GETC
					OUT
					ADD R0, R0, R1
					
					LD R2, subpushptr
					JSRR R2
					
					LEA R0, space
					PUTS
					
					GETC 
					OUT
					ADD R0, R0, R1
					
					LD R2, subpushptr
					JSRR R2
					
					LEA R0, space
					PUTS
					
					GETC
					OUT
					
					LD R2, submulptr
					JSRR R2
					
					LEA R0, equals
					PUTS
					
					LD R2, subpopptr
					JSRR R2
					
					LD R2, subprintptr
					JSRR R2
					
					LD R0, newline
					OUT
				 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:

baseptr .FILL xA000
maxptr  .FILL xA005

subpushptr .FILL x3200
subpopptr .FILL x3400
submulptr .FILL x3600
subprintptr .FILL x3900

numoffset .FILL #-48

equals .STRINGZ " = "
promptstart .STRINGZ "Enter two single-digit numbers:\n"
space .STRINGZ " "
newline .FILL '\n'
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


;------------------------------------------------------------------------------------------
; Subroutine: SUB_RPN_MULTIPLY
; Parameter (R4): BASE: A pointer to the base (one less than the lowest available
;                       address) of the stack
; Parameter (R5): MAX: The "highest" available address in the stack
; Parameter (R6): TOS (Top of Stack): A pointer to the current top of the stack
; Postcondition: The subroutine has popped off the top two values of the stack,
;		    multiplied them together, and pushed the resulting value back
;		    onto the stack.
; Return Value: R6 ← updated TOS address
;------------------------------------------------------------------------------------------
					.orig x3600
					
					ST R0, r0backup3600
					ST R1, r1backup3600
					ST R2, r2backup3600
					ST R3, r3backup3600
					ST R7, r7backup3600
				 
					;R1 = mul1
					;R2 = mul2
					;R3 = product
					
					LD R3, popptr3600
					JSRR R3
					AND R1, R1, #0
					ADD R1, R0, R1 ;set R1
					
					JSRR R3
					AND R2, R2, #0
					ADD R2, R0, R2 ;set R2
					
					AND R3, R3, #0
					
					ADD R2, R2, #0 ;test if zero
					BRz zero3600
					
					;be fruitful and multiply
					mulloop3600
						ADD R3, R3, R1
						ADD R2, R2, #-1
						BRp mulloop3600
						
					zero3600
						
					AND R0, R0, #0
					ADD R0, R3, #0 ;send to R0
					
					LD R2, pushptr3600
					JSRR R2
					
					LD R0, r0backup3600
					LD R1, r1backup3600
					LD R2, r2backup3600
					LD R3, r3backup3600
					LD R7, r7backup3600
					
					ret
;-----------------------------------------------------------------------------------------------
; SUB_RPN_MULTIPLY local data

pushptr3600 .FILL x3200
popptr3600 .FILL x3400

r0backup3600 .BLKW #1
r1backup3600 .BLKW #1
r2backup3600 .BLKW #1
r3backup3600 .BLKW #1
r7backup3600 .BLKW #1
;===============================================================================================



; SUB_MULTIPLY		

; SUB_GET_NUM		

; SUB_PRINT_DECIMAL		Only needs to be able to print 1 or 2 digit numbers. 
;						You can use your lab 7 s/r.
;start output subroutine
.orig x3900

	ST R0, r0_backup_3900
	ST R2, r2_backup_3900
	ST R3, r3_backup_3900
	ST R4, r4_backup_3900
	ST R5, r5_backup_3900
	ST R6, r6_backup_3900
	ST R7, r7_backup_3900
	
	;REGISTERS:
	;R0 = array write value
	;R1 = value to be converted
	;R2 = loop counter
	;R3 = array index counter
	;R4 = temp value counter
	;R5 = offset array pointer
	;R6 = operand holder
	
	AND R1, R1, #0
	ADD R1, R0, #0

	LEA R3, digitsarray ;load array address
	
	;first test if negative and deal with 
	ADD R1, R1, #0 ;test R1
	BRn ifneg3900
	;if not neg set to dummy val
	AND R0, R0, #0
	ADD R0, R0, #1
	STR R0, R3, #0 
	BR  preloop3900
	
	ifneg3900
		LD R0, negascii
		STR R0, R3, #0 ;load neg to array
		NOT R1, R1
		ADD R1, R1, #1 ;deal with negative
		
	preloop3900
		ADD R3, R3, #1 ;inc array pointer
		
	AND R4, R4, #0 ;zero out temp	
	
	LEA R5, tenthousand
	;main loop
	
	loadr63900 
	
	LDR R6, R5, #0 ;load with next subtract value

	loop3900
		ADD R1, R1, R6
		BRn ifloopneg3900;don't add if negative
		ADD R4, R4, #1 ;add if positive
		ADD R1, R1, #0 ;test again
		BRz end3900 ;goto end if zero
		BR loop3900 ;go back if positive
		
		ifloopneg3900
			NOT R6, R6
			ADD R6, R6, #1
			ADD R1, R1, R6 ;refill register if it went negative
			BR end3900
		
		end3900
		LD R0, asciioffset
		ADD R4, R4, R0
		STR R4, R3, #0 ;store to array
		ADD R3, R3, #1 ;inc array pointer
		AND R4, R4, #0 ;zero out temp	
		ADD R5, R5, #1 ;inc subtract value pointer
		
		;test if at end of loop
		LEA R0, loopend
		NOT R0, R0
		ADD R0, R0, #1
		ADD R0, R5, R0 ;test if at end
		BRz finished3900
		
		BR loadr63900
	
	finished3900
	
	;remove leading zeros
	LEA R3, digitsarray
	LD R2, negasciioffset
	ADD R3, R3, #1 
	leadloop
		LDR R0, R3, #0
		ADD R0, R0, R2 ;add offset and test if zero
		BRz iszeroloop
		BR output3900 ;goto output if not zero
		iszeroloop
			ADD R0, R0, #1 ;add 1 if is
			;STR R0, R3, #0
			ADD R3, R3, #1 
			BR leadloop
	
	;testzero3900		
	;make end zero if all ones
	;LEA R3, digitsarray
	;ADD R3, R3, #5 ;set to end of array
	;LDR R1, R3, #0
	;ADD R1, R1, #-1 
	;BRz setzero ;set to zero if zero
	;BR output3900 ;finish if not
	;setzero
	;	LD R0, asciioffset
	;	STR R0, R3, #0
	
	output3900
	ADD R0, R3, #0
	PUTS
	
	LEA R2, digitsarray
	ADD R2, R2, #6
	NOT R2, R2
	ADD R2, R2, #1
	ADD R2, R2, R3 ;test
	BRz outputzero3900
	BR backup3900
	
	outputzero3900
		LD R0, asciioffset
		OUT
	
	backup3900
	LD R0, r0_backup_3900
	LD R2, r2_backup_3900
	LD R3, r3_backup_3900
	LD R4, r4_backup_3900
	LD R5, r5_backup_3900
	LD R6, r6_backup_3900
	LD R7, r7_backup_3900
	
	ret
;end output subroutine
;--------------------------------
;Data for subroutine print number
;--------------------------------
r0_backup_3900 .BLKW #1
r2_backup_3900 .BLKW #1
r3_backup_3900 .BLKW #1
r4_backup_3900 .BLKW #1
r5_backup_3900 .BLKW #1
r6_backup_3900 .BLKW #1
r7_backup_3900 .BLKW #1

negascii .FILL #45
asciioffset .FILL #48
negasciioffset .FILL #-48

tenthousand .FILL #-10000
onethousand .FILL #-1000
hundred     .FILL #-100
ten         .FILL #-10
one         .FILL #-1
loopend     .BLKW #1

digitsarray .BLKW #6
;end variables

