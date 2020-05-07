;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name: Merrick Slane
; Email: mslan002@ucr.edu
; 
; Assignment name: Assignment 4
; Lab section: 025
; TA: Ethan Valdez
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=================================================================================
;THE BINARY REPRESENTATION OF THE USER-ENTERED DECIMAL NUMBER MUST BE STORED IN R1
;=================================================================================

;-------------
;Instructions
;-------------
; output intro prompt
						
; Set up flags, counters, accumulators as needed

; Get first character, test for '\n', '+', '-', digit/non-digit: 	
					
					; is very first character = '\n'? if so, just quit (no message)!

					; is it = '+'? if so, ignore it, go get digits

					; is it = '-'? if so, set neg flag, go get digits
					
					; is it < '0'? if so, it is not a digit	- o/p error message, start over

					; is it > '9'? if so, it is not a digit	- o/p error message, start over
				
					; if none of the above, first character is first numeric digit - convert it to number & store in target register!
					
; Now get remaining digits (max 5) from user, testing each to see if it is a digit, and build up number in accumulator

					; remember to end with a newline!

					;ADD R4, R4, #1 ;set flag if neg
					.ORIG x3000		
					
					begin
					LD R0, introPromptPtr ;output prompt
					PUTS
					
					AND R1, R1, #0 ;zero out value holder
					
					AND R2, R2, #0 ;zero out loop counter
					
					AND R4, R4, #0 ;zero out sign flag
					
					inputloop
					GETC ;get char 
					OUT ;echo
					ADD R6, R0, #0 ;backup R0
					
					;begin char value check
					LD R5, negoffset
					ADD R0, R0, R5 ;test if negative
					BRz ifneg
					ADD R0, R6, #0
					
					LD R5, newlineoffset
					ADD R0, R0, R5 ;test if newline
					BRz ifnewline
					ADD R0, R6, #0
					
					LD R5, psignoffset
					ADD R0, R0, R5 ;test if plus sign
					BRz ifplus
					ADD R0, R6, #0
					
					LD R5, numzerooffset
					ADD R0, R0, R5 ;else: test if  >= 0
					BRzp ifgz
					BRn error
					ADD R0, R6, #0
					
					
					BR endinputloop ;temp
					
					;if conditions
					
					ifneg
						ADD R2, R2, #0 ;check loop counter
						BRp error ;goto error if not first in loop
						ADD R4, R4, #1 ;set flag if neg
						BR endcheck
					
					ifnewline
						ADD R2, R2, #0 ;check loop counter
						BRz finish ;go to the end if first char
						BR testneg ;end if not
						
					ifplus
						ADD R4, R4, #2 ;set flag to two if positive
						ADD R2, R2, #0 ;check loop counter
						BRz endcheck ;go to end if zero
						BR error ;error if not
						
					ifgz
						ADD R0, R0, #-9
						BRp error ;goto error if positive
						;handle digit
						AND R6, R6, #0 ;use R6 as loop counter
						ADD R6, R6, #9
						
						ADD R3, R1, #0 ;save loop value
						mulloop
							ADD R1, R1, R3 ;multiply by 10
							ADD R6, R6, #-1
							BRp mulloop
						
						ADD R0, R0, #9
						ADD R1, R1, R0 ;add next digit
						
						;end handle digit
						;handle loop end
						ADD R6, R2, #-4 ;if greater than or eq to 5
						BRn endcheck ;branch to end if below threshold
						ADD R4, R4, #0 ;test R4
						BRz finishwnewline ;goto end if no flag
						ADD R6, R2, #-4 ;test again
						BRz endcheck ;go again if loop not finished
						LD R0, newline ;do newline
						OUT
						testneg
						ADD R4, R4, #-1 ;test R4 again
						BRnp finish ;end if not neg
						;ifneg invert
						NOT R1, R1
						ADD R1, R1, #1
						BR finish ;send it
						
						
						;end handle loop end
						
						BR endcheck
						
						
					error
						LD R0, newline
						OUT
						LD R0, errorMessagePtr ;error mesasge if not
						PUTS
						BR begin ;restart	
					
					endcheck
					;end char value check
					
					endinputloop
					ADD R2, R2, #1
					BR inputloop
					
					finishwnewline
					LD R0, newline ;do newline
					OUT
					
					finish
					HALT

;---------------	
; Program Data
;---------------

introPromptPtr		.FILL xA800
errorMessagePtr		.FILL xA900
negoffset           .FILL #-45
newlineoffset       .FILL #-10
psignoffset         .FILL #-43
numzerooffset       .FILL #-48
numnineoffset       .FILL #-57
newline 			.FILL '\n'

;------------
; Remote data
;------------
					.ORIG xA800			; intro prompt
					.STRINGZ	"Input a positive or negative decimal number (max 5 digits), followed by ENTER\n"
					
					
					.ORIG xA900			; error message
					.STRINGZ	"ERROR! invalid input\n"

;---------------
; END of PROGRAM
;---------------
					.END

;-------------------
; PURPOSE of PROGRAM
;-------------------
; Convert a sequence of up to 5 user-entered ascii numeric digits into a 16-bit two's complement binary representation of the number.
; if the input sequence is less than 5 digits, it will be user-terminated with a newline (ENTER).
; Otherwise, the program will emit its own newline after 5 input digits.
; The program must end with a *single* newline, entered either by the user (< 5 digits), or by the program (5 digits)
; Input validation is performed on the individual characters as they are input, but not on the magnitude of the number.
