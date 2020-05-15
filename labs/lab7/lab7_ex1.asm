;=================================================
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Lab: lab 7, ex 1
; Lab section: 025
; TA: Ethan Valdez
; 
;=================================================


.orig x3000
;start main
;store value in R1
	;R1 = value register
	;R6 = jump register
	LD R6, inputsubptr
	JSRR R6
	
	ADD R1, R1, #1
	
	LD R6, outsubptr
	JSRR R6
	
	AND R0, R0, #0
	ADD R0, R0, #10
	OUT

;end main
HALT

inputsubptr .FILL x3100
outsubptr .FILL x3200


;start input subroutine
.orig x3100
sub_input_value
	ST R7, r7_backup_3100
	
	LD R1, r1_temp_val
	
	LD R7, r7_backup_3100
	ret
;end input subroutine
r7_backup_3100 .BLKW #1
r1_temp_val .FILL #-2345
;end variables


;start output subroutine
.orig x3200
output_dec
	ST R0, r0_backup_3200
	ST R2, r2_backup_3200
	ST R3, r3_backup_3200
	ST R4, r4_backup_3200
	ST R5, r5_backup_3200
	ST R6, r6_backup_3200
	ST R7, r7_backup_3200
	
	;REGISTERS:
	;R0 = array write value
	;R1 = value to be converted
	;R2 = loop counter
	;R3 = array index counter
	;R4 = temp value counter
	;R5 = offset array pointer
	;R6 = operand holder

	LEA R3, digitsarray ;load array address
	
	;first test if negative and deal with 
	ADD R1, R1, #0 ;test R1
	BRn ifneg3200
	;if not neg set to dummy val
	AND R0, R0, #0
	ADD R0, R0, #1
	STR R0, R3, #0 
	BR  preloop3200
	
	ifneg3200
		LD R0, negascii
		STR R0, R3, #0 ;load neg to array
		NOT R1, R1
		ADD R1, R1, #1 ;deal with negative
		
	preloop3200
		ADD R3, R3, #1 ;inc array pointer
		
	AND R4, R4, #0 ;zero out temp	
	
	LEA R5, tenthousand
	;main loop
	
	loadr63200 
	
	LDR R6, R5, #0 ;load with next subtract value

	loop3200
		ADD R1, R1, R6
		BRn ifloopneg3200;don't add if negative
		ADD R4, R4, #1 ;add if positive
		ADD R1, R1, #0 ;test again
		BRz end3200 ;goto end if zero
		BR loop3200 ;go back if positive
		
		ifloopneg3200
			NOT R6, R6
			ADD R6, R6, #1
			ADD R1, R1, R6 ;refill register if it went negative
			BR end3200
		
		end3200
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
		BRz finished3200
		
		BR loadr63200
	
	finished3200
	
	;remove leading zeros
	LEA R3, digitsarray
	LD R2, negasciioffset
	ADD R3, R3, #1 
	leadloop
		LDR R0, R3, #0
		ADD R0, R0, R2 ;add offset and test if zero
		BRz iszeroloop
		BR output3200 ;goto output if not zero
		iszeroloop
			ADD R0, R0, #1 ;add 1 if is
			STR R0, R3, #0
			ADD R3, R3, #1 
			BR leadloop
	
	output3200
	LEA R0, digitsarray
	PUTS
	
	LD R0, r0_backup_3200
	LD R2, r2_backup_3200
	LD R3, r3_backup_3200
	LD R4, r4_backup_3200
	LD R5, r5_backup_3200
	LD R6, r6_backup_3200
	LD R7, r7_backup_3200
	
	ret
;end output subroutine
r0_backup_3200 .BLKW #1
r2_backup_3200 .BLKW #1
r3_backup_3200 .BLKW #1
r4_backup_3200 .BLKW #1
r5_backup_3200 .BLKW #1
r6_backup_3200 .BLKW #1
r7_backup_3200 .BLKW #1

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

.end
