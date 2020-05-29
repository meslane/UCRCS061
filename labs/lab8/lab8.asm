;=================================================
; Name: 
; Email: 
; 
; Lab: lab 8, ex 1 & 2
; Lab section: 
; TA: 
; 
;=================================================

; test harness
					.orig x3000
				 
					LD R6, printtableptr
					JSRR R6
					
					LD R6, getopcodeptr
					JSRR R6
				 
					halt
;-----------------------------------------------------------------------------------------------
; test harness local data:
printtableptr  .FILL x3200
getopcodeptr    .FILL x3600

teststring .BLKW #16
;===============================================================================================


; subroutines:
;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE_TABLE
; Parameters: None
; Postcondition: The subroutine has printed out a list of every LC3 instruction
;				 and corresponding opcode in the following format:
;					ADD = 0001
;					AND = 0101
;					BR = 0000
;					…
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3200
					
					ST R0, r0backup3200
					ST R2, r2backup3200
					ST R4, r4backup3200
					ST R5, r5backup3200
					ST R6, r6backup3200
					ST R7, r7backup3200
					
					;R4 = opcode array pointer
					;R5 = string array pointer
					
					LD R4, opcodes_po_ptr
					LD R5, instructions_po_ptr
					
					;first, we must output the string
					stroutloop3200
						LDR R0, R5, #0
						ADD R0, R0, #0 ;test R0
						BRn end3200 ;goto end if -1
						BRz endstroutloop3200 ;stop loop if null
						;else:
						OUT
						ADD R5, R5, #1
						BR stroutloop3200
						endstroutloop3200
						ADD R5, R5, #1 ;get ready for next loop
						
						LEA R0, equalsstring
						PUTS
						
						LDR R2, R4, #0 ;load R2
						LD R6, printopcodeptr3200
						JSRR R6 ;print
						ADD R4, R4, #1 ;add
					
					LD R0, newline3200
					OUT
					BR stroutloop3200
					
					end3200
					
					LD R0, r0backup3200
					LD R2, r2backup3200
					LD R4, r4backup3200
					LD R5, r5backup3200
					LD R6, r6backup3200
					LD R7, r7backup3200
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE_TABLE local data
printopcodeptr3200 .FILL x3400

opcodes_po_ptr		.fill x4000				; local pointer to remote table of opcodes
instructions_po_ptr	.fill x4100				; local pointer to remote table of instructions

newline3200 .FILL '\n'
equalsstring .STRINGZ " = "

r0backup3200 .BLKW #1
r2backup3200 .BLKW #1
r4backup3200 .BLKW #1
r5backup3200 .BLKW #1
r6backup3200 .BLKW #1
r7backup3200 .BLKW #1
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_PRINT_OPCODE
; Parameters: R2 containing a 4-bit op-code in the 4 LSBs of the register
; Postcondition: The subroutine has printed out just the 4 bits as 4 ascii 1s and 0s
;				 The output is NOT newline terminated.
; Return Value: None
;-----------------------------------------------------------------------------------------------
					.orig x3400
					
					ST R0, r0backup3400
					ST R3, r3backup3400
					ST R7, r7backup3400
				 
					;first, we right shift R2 12 times
					AND R3, R3, #0
					ADD R3, R3, #12 ;set R3 to loop counter
					
					preloop3400
						ADD R2, R2, R2 ;shift
						ADD R3, R3, #-1
						BRp preloop3400
						
					AND R3, R3, #0
					ADD R3, R3, #4 ;loop counter
						
					;main loop
					loop3400
						ADD R2, R2, #0 ;test R2
						BRn ifone3400
						BR  ifzero3400
						
						ifone3400
							LD R0, one3400
							OUT
							BR postprint3400
						
						ifzero3400
							LD R0, zero3400
							OUT
							BR postprint3400
							
						postprint3400
						ADD R2, R2, R2 ;shift
						ADD R3, R3, #-1
						BRp loop3400
					
					LD R0, r0backup3400
					LD R3, r3backup3400
					LD R7, r7backup3400 
					
					ret
;-----------------------------------------------------------------------------------------------
; SUB_PRINT_OPCODE local data
zero3400 .FILL #48
one3400  .FILL #49

r0backup3400 .BLKW #1
r3backup3400 .BLKW #1
r7backup3400 .BLKW #1
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_FIND_OPCODE
; Parameters: None
; Postcondition: The subroutine has invoked the SUB_GET_STRING subroutine and stored a string
; 				as local data; it has searched the AL instruction list for that string, and reported
;				either the instruction/opcode pair, OR "Invalid instruction"
; Return Value: None
;-----------------------------------------------------------------------------------------------
				.orig x3600
				 
				ST R0, r0backup3600
				ST R1, r1backup3600
				ST R2, r2backup3600
				ST R3, r3backup3600
				ST R4, r4backup3600
				ST R5, r5backup3600
				ST R6, r6backup3600
				ST R7, r7backup3600
				;end backups
				 
				begin3600	
				LEA R2, string3600
				LD R6, getstringptr3600 
				JSRR R6 ;get string
				
				;R0 = provided char
				;R1 = array char
				;R2 = comparision string pointer
				;R3 = equals flag
				;R4 = string number counter
				;R5 = char coutner pointer
				
				LEA R2, string3600
				LD R5, instructions_fo_ptr
				LD R4, opcodes_fo_ptr
				
				AND R3, R3, #0
				ADD R3, R3, #1 ;1 if equal, 0 if not
				
				arrayloop3600
					LDR R0, R2, #0
					LDR R1, R5, #0 ;get characters
					
					ADD R2, R2, #1
					ADD R5, R5, #1 ;increment for next pass
					
					NOT R0, R0
					ADD R0, R0, #1 ;make one neg
					
					ADD R0, R0, R1 ;test if equal
					BRnp notequal3600
					BR testnull3600
					
					notequal3600
						AND R3, R3, #0 ;set flag 
						
					testnull3600
						ADD R1, R1, #0 ;test char
						BRz testvalid3600
						BRn finishbad3600 ;finish if at end of array
						BR arrayloop3600 ;loop if not end
						
					testvalid3600
						ADD R3, R3, #-1
						BRz finishvalid3600 ;goto end if valid
						ADD R4, R4, #1
						AND R3, R3, #0
						ADD R3, R3, #1
						LEA R2, string3600
						BR arrayloop3600 ;reset R2 + R3 and branch if not
						
				finishvalid3600
					LEA R0, string3600
					PUTS
					LEA R0, equals3600
					PUTS
					LDR R2, R4, #0
					LD R6, printopcodeptr3600
					JSRR R6
					LD R0, newline3600
					OUT
					BR begin3600 ;print result and goto end
				
				finishbad3600
					LEA R0, invalidmessage
					PUTS
					BR begin3600
					
				end3600
				;start reloads
				LD R0, r0backup3600
				LD R1, r1backup3600
				LD R2, r2backup3600
				LD R3, r3backup3600
				LD R4, r4backup3600
				LD R5, r5backup3600
				LD R6, r6backup3600
				LD R7, r7backup3600
				 
				ret
;-----------------------------------------------------------------------------------------------
; SUB_FIND_OPCODE local data
opcodes_fo_ptr			.fill x4000
instructions_fo_ptr		.fill x4100

printopcodeptr3600 .FILL x3400
getstringptr3600 .FILL x3800

invalidmessage .STRINGZ "Invalid Instruction \n"
equals3600 .STRINGZ " = "
newline3600 .FILL '\n'

string3600 .BLKW #8

r0backup3600 .BLKW #1
r1backup3600 .BLKW #1
r2backup3600 .BLKW #1
r3backup3600 .BLKW #1
r4backup3600 .BLKW #1
r5backup3600 .BLKW #1
r6backup3600 .BLKW #1
r7backup3600 .BLKW #1
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; Subroutine: SUB_GET_STRING
; Parameters: R2 - the address to which the null-terminated string will be stored.
; Postcondition: The subroutine has prompted the user to enter a short string, terminated 
; 				by [ENTER]. That string has been stored as a null-terminated character array 
; 				at the address in R2
; Return Value: None (the address in R2 does not need to be preserved)
;-----------------------------------------------------------------------------------------------
					.orig x3800
				 
					ST R0, r0backup3800
					ST R2, r2backup3800
					ST R3, r3backup3800
					ST R7, r7backup3800
					
					LEA R0, prompt3800
					PUTS
				 
					inputloop3800
						GETC
						OUT
						ADD R3, R0, #-10 ;test if newline
						BRz end3800 ;goto end if newline
						STR R0, R2, #0 
						ADD R2, R2, #1
						BR inputloop3800
						
					end3800
					;ADD R2, R2, #1
					AND R0, R0, #0
					STR R0, R2, #0 ;null-terminate
				 
					LD R0, r0backup3800
					LD R2, r2backup3800
					LD R3, r3backup3800
					LD R7, r7backup3800
				 
					ret
;-----------------------------------------------------------------------------------------------
; SUB_GET_STRING local data

prompt3800 .STRINGZ "Enter an Instruction: \n"

r0backup3800 .BLKW #1
r2backup3800 .BLKW #1
r3backup3800 .BLKW #1
r7backup3800 .BLKW #1
;===============================================================================================


;-----------------------------------------------------------------------------------------------
; REMOTE DATA
					.ORIG x4000			; list opcodes as numbers from #0 through #15, e.g. .fill #12 or .fill xC
; opcodes			
					opadd .FILL #1
					opand .FILL #5
					opbr  .FILL #0
					opjmp .FILL #12
					opjsr .FILL #4
					opjsrr .FILL #4
					opld  .FILL #2
					opldi .FILL #10
					opldr .FILL #6
					oplea .FILL #14
					opnot .FILL #9
					opret .FILL #12
					oprti .FILL #8
					opst  .FILL #3
					opsti .FILL #11
					opstr .FILL #7
					optrp .FILL #15
					endop .FILL #-1

					.ORIG x4100			; list AL instructions as null-terminated character strings, e.g. .stringz "JMP"
								 		; - be sure to follow same order in opcode & instruction arrays!
					addname .STRINGZ "ADD"
					andname .STRINGZ "AND"
					brname  .STRINGZ "BR"
					jmpname .STRINGZ "JMP"
					jsrname .STRINGZ "JSR"
					jsrrname .STRINGZ "JSRR"
					ldname  .STRINGZ "LD"
					ldiname .STRINGZ "LDI"
					ldrname .STRINGZ "LDR"
					leaname .STRINGZ "LEA"
					notname .STRINGZ "NOT"
					retname .STRINGZ "RET"
					rtiname .STRINGZ "RTI"
					stname  .STRINGZ "ST"
					stiname .STRINGZ "STI"
					strname .STRINGZ "STR"
					trpnaem .STRINGZ "TRAP"
					endanem .FILL #-1
; instructions	

;===============================================================================================
