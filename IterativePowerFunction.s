; BLG 212E HW 1 - Question 1
; Iterative Computation of the Power Function
; 
;
; Student Name: Mihriban Nur Kocak
; Student Number: 150180090
; Description: I followed the steps of pseudocode. I used stack to pass parameters, to save return address and return value. 
; startCode is the main part which is initializing parameters and making the function call then store the return value in memory
; powerFunc and loop together is the power function which is calculating the x^a, returning the result, going back to where function is called
; powerFunc is getting parameters and doing initializations
; loop1 is the while loop in the power function which iterates a times to calculate x^a

y_size		EQU 0x4									;Allocate 4 bytes of space for an integer output 
	
			AREA	output, DATA, READWRITE			;Define area to write the output
			ALIGN 								
y 			SPACE y_size 							;Define y as the output
y_end 

			AREA iterativePower,CODE, READONLY		;Declare new area for code
			ENTRY
			THUMB
			ALIGN

__main		FUNCTION								;Define main function
			EXPORT __main
				
			;Your code starts here
startCode 	MOVS r5, #x ;move value of x to r5
			MOVS r6, #a	;move value of a to r6
			PUSH{r5,r6} ;push the values x and a in the r5 and r6 to stack to use them as paramaters of following function call
			BL powerFunc ;go to function powerFunc, save return address in LR
			POP{r1} ;pop return value from stack to r1
			LDR r3,=y   ;load r3 with address of y in memory
			STR r1,[r3] ;store value in r1(y) in the memory at the address in r3
			B stop ;go to stop to finish

powerFunc	POP{r5,r6} ;pop the parameters x and a from the stack to r5 and r6
			PUSH{LR} ;push the return address to stack
			MOVS r4, #1 ;move decimal 1 which is the initial value of y to r4 
			MOVS r2, #1 ;move decimal 1 which is the initial value of counter to r2(i)
loop		MULS r4, r5, r4 ;multiply r4(y) by r5(x) then move result to r4
			ADDS r2, #1 ;increment r2(i) by 1
			CMP	r2,r6 ;compare r2(i) and r6(a) to check if y is multiplied by x a times or not
			BLE	loop ;if r2(i) is less than or equal to a go back to loop
					  ;if r2(i) is greater than a continue from here
			POP{r7} ;pop the return address from stack to r7
			PUSH{r4} ;push the return value(y) in r4 to stack
			BX r7 ;go to the return address in r7
	
stop		B stop ;finish
			;Your code ends here

x			EQU 2 									;Define x
a			EQU 3 									;Define a
			ENDFUNC
			END