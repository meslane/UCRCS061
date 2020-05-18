;=========================================================================
; Name & Email must be EXACTLY as in Gradescope roster!
; Name:  Merrick Slane
; Email: mslan002@ucr.edu
; 
; Assignment name: Assignment 5
; Lab section: 025
; TA: Ethan Valdez
; 
; I hereby certify that I have not received assistance on this assignment,
; or used code, from ANY outside source other than the instruction team
; (apart from what was provided in the starter file).
;
;=========================================================================
;0 = busy 1 = free
;
;COMPLETION STATUS:
;menu sub    : TODO
;all busy sub: DONE
;all free sub: DONE
;num busy sub: DONE
;num free sub: DONE
;status sub  : DONE
;1st free sub: DONE
;get num sub : DONE
;print sub   : DONE

.ORIG x3000			; Program begins here
;-------------
;Instructions
;-------------
;-------------------------------
;INSERT CODE STARTING FROM HERE
;--------------------------------
beginmain
LD R6, sub_menu_ptr
JSRR R6 ;load R1 with selection

ADD R3, R1, #-1
BRz ifallbusysub

ADD R3, R1, #-2
BRz ifallfreesub

ADD R3, R1, #-3
BRz ifnumbusysub

ADD R3, R1, #-4
BRz ifnumfreesub

ADD R3, R1, #-5
BRz ifstatussub

ADD R3, R1, #-6
BRz iffirstsub

BR endmain ;quit if 7

;all busy check
ifallbusysub 
LD R6, sub_all_busy_ptr
JSRR R6
ADD R2, R2, #0 ;test R2
BRz ifbusyzero
;if not
	LEA R0, allbusy
	PUTS
	BR beginmain

ifbusyzero
	LEA R0, allnotbusy
	PUTS
	BR beginmain
;end all busy


;begin all free
ifallfreesub
LD R6, sub_all_free_ptr
JSRR R6
ADD R2, R2, #0 ;test R2
BRz iffreezero
	LEA R0, allfree
	PUTS
	BR beginmain

iffreezero
	LEA R0, allnotfree
	PUTS
	BR beginmain
;end all free


;begin num busy
ifnumbusysub
LD R6, sub_num_busy_ptr
JSRR R6

LEA R0, busymachine1
PUTS

LD R6, sub_print_num
JSRR R6

LEA R0, busymachine2
PUTS

BR beginmain
;end num busy


;begin num free
ifnumfreesub
LD R6, sub_num_free_ptr
JSRR R6

LEA R0, freemachine1
PUTS

LD R6, sub_print_num
JSRR R6

LEA R0, freemachine2
PUTS

BR beginmain
;end num free


;begin status sub
ifstatussub
LD R6, sub_get_num_ptr
JSRR R6

LD R6, sub_status_ptr
JSRR R6

LEA R0, status1
PUTS

LD R6, sub_print_num
JSRR R6

ADD R2, R2, #0 ;test R2
BRz iffreestatus
	LEA R0, status3
	PUTS
	BR beginmain

iffreestatus
	LEA R0, status2
	PUTS
	BR beginmain

BR beginmain
;end status sub


;begin first sub
iffirstsub
LD R6, sub_first_ptr
JSRR R6

AND R3, R3, #0 ;zero out
ADD R3, R3, #-15
ADD R3, R3, #-1  ;set to -16

ADD R3, R1, R3 ;test
BRz nonefree

LEA R0, firstfree1
PUTS

ADD R2, R1, #0

LD R6, sub_print_num
JSRR R6

LD R0, newlinemain
OUT

BR beginmain

nonefree
LEA R0, firstfree2
PUTS

BR beginmain
;end first sub


endmain

LEA R0, goodbye
PUTS

HALT
;---------------	
;Data
;---------------
;Subroutine pointers
sub_menu_ptr     .FILL x3100
sub_all_busy_ptr .FILL x3200
sub_all_free_ptr .FILL x3300
sub_num_busy_ptr .FILL x3400
sub_num_free_ptr .FILL x3500
sub_status_ptr   .FILL x3600
sub_first_ptr    .FILL x3700
sub_get_num_ptr  .FILL x3800
sub_print_num    .FILL x3900

;Other data 
newlinemain 		.fill '\n'

; Strings for reports from menu subroutines:
goodbye         .stringz "Goodbye!\n"
allbusy         .stringz "All machines are busy\n"
allnotbusy      .stringz "Not all machines are busy\n"
allfree         .stringz "All machines are free\n"
allnotfree		.stringz "Not all machines are free\n"
busymachine1    .stringz "There are "
busymachine2    .stringz " busy machines\n"
freemachine1    .stringz "There are "
freemachine2    .stringz " free machines\n"
status1         .stringz "Machine "
status2		    .stringz " is busy\n"
status3		    .stringz " is free\n"
firstfree1      .stringz "The first available machine is number "
firstfree2      .stringz "No machines are free\n"


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MENU
; Inputs: None
; Postcondition: The subroutine has printed out a menu with numerical options, invited the
;                user to select an option, and returned the selected option.
; Return Value (R1): The option selected:  #1, #2, #3, #4, #5, #6 or #7 (as a number, not a character)
;                    no other return value is possible
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MENU
;--------------------------------
.orig x31B0
;back ups 
ST R0, r0_backup_3100
ST R2, r2_backup_3100
ST R7, r7_backup_3100

begin3100
LD R0, Menu_string_addr
PUTS ;output menu 

GETC
OUT

LD R1, zerooffset3100
ADD R2, R0, R1 ;backup value

LD R1, zerooffset3100
ADD R0, R0, R1
BRn error3100 ;check if under
NOT R1, R1
ADD R1, R1, #1 ;invert 
ADD R0, R0, R1 ;re add
LD R1, nineoffset3100
ADD R0, R0, R1
BRp error3100 ;check if over
LD R0, newline3100 ;newline
OUT
ADD R1, R2, #1 ;load to R1
BR end3100

error3100
LD R0, newline3100
OUT ;newline
LEA r0, Error_msg_1
PUTS
BR begin3100

end3100

;restores
LD R0, r0_backup_3100
LD R2, r2_backup_3100
LD R7, r7_backup_3100

ret
;--------------------------------
;Data for subroutine MENU
;--------------------------------
r0_backup_3100 .BLKW #1
r2_backup_3100 .BLKW #1
r7_backup_3100 .BLKW #1

zerooffset3100 .FILL #-49
nineoffset3100 .FILL #-55

newline3100 .FILL '\n'

Error_msg_1	      .STRINGZ "INVALID INPUT\n"
Menu_string_addr  .FILL x6400

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_BUSY (#1)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are busy
; Return value (R2): 1 if all machines are busy, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_BUSY
;--------------------------------
.orig x3200 ;DONE

ST R7, r7_backup_3200

;R2 = vector temp storage and return

LD R2, BUSYNESS_ADDR_ALL_MACHINES_BUSY
LDR R2, R2, #0 ;get data 

ADD R2, R2, #0 ;test if zero
BRnp notz3200

ADD R2, R2, #1
BR end3200

notz3200
AND R2, R2, #0

end3200

LD R7, r7_backup_3200

ret
;--------------------------------
;Data for subroutine ALL_MACHINES_BUSY
;--------------------------------
r7_backup_3200 .BLKW #1

BUSYNESS_ADDR_ALL_MACHINES_BUSY .Fill xB200

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: ALL_MACHINES_FREE (#2)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating whether all machines are free
; Return value (R2): 1 if all machines are free, 0 otherwise
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine ALL_MACHINES_FREE
;--------------------------------
.orig x3300 ;DONE

ST R7, r7_backup_3300

;R2 = vector temp storage and return

LD R2, BUSYNESS_ADDR_ALL_MACHINES_FREE
LDR R2, R2, #0 ;get data 

ADD R2, R2, #1 ;test
BRnp notz3300

AND R2, R2, #0
ADD R2, R2, #1
BR end3300

notz3300
AND R2, R2, #0

end3300

LD R7, r7_backup_3300

ret
;--------------------------------
;Data for subroutine ALL_MACHINES_FREE
;--------------------------------
r7_backup_3300 .BLKW #1

BUSYNESS_ADDR_ALL_MACHINES_FREE .Fill xB200


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_BUSY_MACHINES (#3)
; Inputs: None
; Postcondition: The subroutine has returned the number of busy machines.
; Return Value (R1): The number of machines that are busy (0)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_BUSY_MACHINES
;--------------------------------
.orig x3400 ;DONE
;back ups 
ST R0, r0_backup_3400
ST R6, r6_backup_3400
ST R7, r7_backup_3400

LD R0, BUSYNESS_ADDR_NUM_BUSY_MACHINES
LDR R0, R0, #0 ;load vector

LD R6, bitcountsubptr3400
JSRR R6 ;goto bit count subroutine

AND R0, R0, #0
ADD R0, R0, #15
ADD R0, R0, #1  ;load R0 with 16

NOT R1, R1
ADD R1, R1, #1 ;negate R1

ADD R1, R1, R0 ;subtract to get num busy

;restores
LD R0, r0_backup_3400
LD R6, r6_backup_3400
LD R7, r7_backup_3400

ret ;return
;--------------------------------
;Data for subroutine NUM_BUSY_MACHINES
;--------------------------------
bitcountsubptr3400 .FILL x4000

r0_backup_3400 .BLKW #1
r6_backup_3400 .BLKW #1
r7_backup_3400 .BLKW #1

BUSYNESS_ADDR_NUM_BUSY_MACHINES .Fill xB200


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: NUM_FREE_MACHINES (#4)
; Inputs: None
; Postcondition: The subroutine has returned the number of free machines
; Return Value (R1): The number of machines that are free (1)
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine NUM_FREE_MACHINES
;--------------------------------
.orig x3500
;back up 
ST R0, r0_backup_3500
ST R6, r6_backup_3500
ST R7, r7_backup_3500

LD R0, BUSYNESS_ADDR_NUM_FREE_MACHINES
LDR R0, R0, #0 ;load vector

LD R6, bitcountsubptr3500
JSRR R6 ;goto bit count subroutine

;restores
LD R0, r0_backup_3500
LD R6, r6_backup_3500
LD R7, r7_backup_3500

ret
;--------------------------------
;Data for subroutine NUM_FREE_MACHINES 
;--------------------------------
bitcountsubptr3500 .FILL x4000

r0_backup_3500 .BLKW #1
r6_backup_3500 .BLKW #1
r7_backup_3500 .BLKW #1

BUSYNESS_ADDR_NUM_FREE_MACHINES .Fill xB200


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: MACHINE_STATUS (#5)
; Input (R1): Which machine to check, guaranteed in range {0,15}
; Postcondition: The subroutine has returned a value indicating whether
;                the selected machine (R1) is busy or not.
; Return Value (R2): 0 if machine (R1) is busy, 1 if it is free
;              (R1) unchanged
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine MACHINE_STATUS
;--------------------------------
.orig x3600
;back ups 
ST R1, r1_backup_3600
ST R3, r3_backup_3600
ST R4, r4_backup_3600
ST R7, r7_backup_3600

;R1 = bit position
;R2 = return
;R3 = busyness data
;R4 = mask data

LD R3, BUSYNESS_ADDR_MACHINE_STATUS
LDR R3, R3, #0 ;get data 

AND R4, R4, #0
ADD R4, R4, #1 ;set R4 to 1

ADD R1, R1, #0 
BRz endmaskloop3600 ;skip loop if zero

maskloop3600
	ADD R4, R4, R4 ;shift 1
	ADD R1, R1, #-1 
	BRp maskloop3600
	endmaskloop3600

AND R2, R3, R4 ;mask and test if zero
BRz isbusy3600
BR  notbusy3600

isbusy3600
	AND R2, R2, #0
	BR end3600
	
notbusy3600
	AND R2, R2, #0
	ADD R2, R2, #1
	BR end3600

	
end3600

;restores
LD R1, r1_backup_3600
LD R3, r3_backup_3600
LD R4, r4_backup_3600
LD R7, r7_backup_3600

ret
;--------------------------------
;Data for subroutine MACHINE_STATUS
;--------------------------------
r1_backup_3600 .BLKW #1 
r3_backup_3600 .BLKW #1 
r4_backup_3600 .BLKW #1 
r7_backup_3600 .BLKW #1

BUSYNESS_ADDR_MACHINE_STATUS .Fill xB200

;-----------------------------------------------------------------------------------------------------------------
; Subroutine: FIRST_FREE (#6)
; Inputs: None
; Postcondition: The subroutine has returned a value indicating the lowest numbered free machine
; Return Value (R1): the number of the free machine
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine FIRST_FREE
;--------------------------------
.orig x3700
;back ups 
ST R2, r2_backup_3700
ST R3, r3_backup_3700
ST R4, r4_backup_3700
ST R7, r7_backup_3700

;R1 = loop counter
;R2 = busyness data
;R3 = temp mask result
;R4 = mask value

LD R2, BUSYNESS_ADDR_FIRST_FREE
LDR R2, R2, #0 ;get data 

AND R4, R4, #0
ADD R4, R4, #1 ;set R4 to 1

AND R1, R1, #0 ;zero out loop counter

testloop3700
	AND R3, R2, R4 ;test
	BRnp end3700 ;goto end if found value
	ADD R1, R1, #1
	ADD R4, R4, R4
	BRz end3700 ;goto end if shift overflows
	BR testloop3700 ;inc vals and loop again if not
	
end3700

;restores
LD R2, r2_backup_3700
LD R3, r3_backup_3700
LD R4, r4_backup_3700
LD R7, r7_backup_3700

ret
;--------------------------------
;Data for subroutine FIRST_FREE
;--------------------------------
r2_backup_3700 .BLKW #1 
r3_backup_3700 .BLKW #1 
r4_backup_3700 .BLKW #1 
r7_backup_3700 .BLKW #1

BUSYNESS_ADDR_FIRST_FREE .Fill xB200


;-----------------------------------------------------------------------------------------------------------------
; Subroutine: GET_MACHINE_NUM
; Inputs: None
; Postcondition: The number entered by the user at the keyboard has been converted into binary,
;                and stored in R1. The number has been validated to be in the range {0,15}
; Return Value (R1): The binary equivalent of the numeric keyboard entry
; NOTE: You can use your code from assignment 4 for this subroutine, changing the prompt, 
;       and with the addition of validation to restrict acceptable values to the range {0,15}
;-----------------------------------------------------------------------------------------------------------------
;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
.orig x3800

;backups
ST R0, r0_backup_3800
ST R2, r2_backup_3800
ST R3, r3_backup_3800
ST R4, r4_backup_3800
ST R5, r5_backup_3800
ST R6, r6_backup_3800
ST R7, r7_backup_3800

begin
LEA R0, prompt 
PUTS ;print prompt string
					
					AND R1, R1, #0 ;zero out value holder
					
					AND R2, R2, #0 ;zero out loop counter
					
					AND R4, R4, #0 ;zero out sign flag
					
					inputloop
					GETC ;get char 
					OUT ;echo
					ADD R6, R0, #0 ;backup R0
					
					;begin char value check
					;LD R5, negoffset
					;ADD R0, R0, R5 ;test if negative
					;BRz ifneg
					;ADD R0, R6, #0
					
					LD R5, newlineoffset
					ADD R0, R0, R5 ;test if newline
					BRz ifnewline
					ADD R0, R6, #0
					
					LD R5, psignoffset
					ADD R0, R0, R5 ;test if plus sign
					BRz ifplus
					ADD R0, R6, #0
					
					LD R5, spaceoffset ;test if space
					ADD R0, R0, R5 
					BRz error
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
						BRp finish ;go to the end if not zero
						BR error
						
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
						LEA R0, Error_msg_2 ;error mesasge if not
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
					ADD R2, R1, #-16
					BRzp error ;goto error if bad value
					 
;restores
LD R0, r0_backup_3800
LD R2, r2_backup_3800
LD R3, r3_backup_3800
LD R4, r4_backup_3800
LD R5, r5_backup_3800
LD R6, r6_backup_3800
LD R7, r7_backup_3800
								
ret

;--------------------------------
;Data for subroutine Get input
;--------------------------------

r0_backup_3800 .BLKW #1
r2_backup_3800 .BLKW #1
r3_backup_3800 .BLKW #1
r4_backup_3800 .BLKW #1
r5_backup_3800 .BLKW #1
r6_backup_3800 .BLKW #1
r7_backup_3800 .BLKW #1

introPromptPtr		.FILL xA800
errorMessagePtr		.FILL xA900
negoffset           .FILL #-45
newlineoffset       .FILL #-10
psignoffset         .FILL #-43
numzerooffset       .FILL #-48
numnineoffset       .FILL #-57
spaceoffset         .FILL #-32
newline 			.FILL '\n'

prompt .STRINGZ "Enter which machine you want the status of (0 - 15), followed by ENTER: "
Error_msg_2 .STRINGZ "ERROR INVALID INPUT\n"
	
;-----------------------------------------------------------------------------------------------------------------
; Subroutine: PRINT_NUM
; Inputs: R1, which is guaranteed to be in range {0,16}
; Postcondition: The subroutine has output the number in R1 as a decimal ascii string, 
;                WITHOUT leading 0's, a leading sign, or a trailing newline.
; Return Value: None; the value in R1 is unchanged
;-----------------------------------------------------------------------------------------------------------------


;-------------------------------
;INSERT CODE For Subroutine 
;--------------------------------
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



;COUNT BITS Subroutine
.orig x4000
countbits
	ST R0, r0backup4000
	ST R2, r2backup4000
	ST R7, r7backup4000
	
	;r1 = bitcount
	;r2 = loop counter

	AND R2, R2, #0 ;zero
	ADD R2, R2, #15
	ADD R2, R2, #1 ;add 16
	
	AND R1, R1, #0 ;zero out bitcount
	
	loop4000 ;start loop
		ADD R0, R0, #0 ;test
		BRzp shift4000;skip add if MSB not 1 
		ADD R1, R1, #1
		shift4000
		ADD R0, R0, R0 ;shift 1
		ADD R2, R2, #-1 ;sub 1
		BRp loop4000 ;loop if not at end
	
	LD R0, r0backup4000
	LD R2, r2backup4000
	LD R7, r7backup4000
		 
	ret

;end
r0backup4000 .BLKW #1
r2backup4000 .BLKW #1
r7backup4000 .BLKW #1


;REMOTE DATA
.ORIG x6400
MENUSTRING .STRINGZ "**********************\n* The Busyness Server *\n**********************\n1. Check to see whether all machines are busy\n2. Check to see whether all machines are free\n3. Report the number of busy machines\n4. Report the number of free machines\n5. Report the status of machine n\n6. Report the number of the first available machine\n7. Quit\n"

.ORIG xB200			; Remote data
BUSYNESS .FILL x0000		; <----!!!BUSYNESS VECTOR!!! Change this value to test your program.

;---------------	
;END of PROGRAM
;---------------	
.END
