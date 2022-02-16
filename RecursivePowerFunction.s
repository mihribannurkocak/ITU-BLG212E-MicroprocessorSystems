; BLG 212E HW 1 - Question 2
; Recursive Computation of the Power Function in O(a) Time
; 
;
; Student Name: Mihriban Nur Kocak
; Student Number: 150180090
; Description: I followed the steps of pseudocode. I used stack to pass parameters, to save return address and return value.
; I pushed return address and parameters x and a of every recursive call (x, a-1) to stack until a = 0 
; Then I started to pop parameters and return address of every recursive call, do the calculations, push the return value of every recursive call to stack
; When returned from the overall function call, the only value in stack is the result.
; Since we do recursion with a-1, the complexity is O(a)


y_size		EQU 0x4                                 ;Allocate 4 bytes of space for an 
	
			AREA	output, DATA, READWRITE			;Define area to write the output
			ALIGN 
y 			SPACE y_size 							;Define y as the output 
y_end 

			AREA recursivePower, CODE, READONLY		;Declare new area for code
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
			PUSH {LR} ;push the return address to stack
			PUSH{r5,r6} ;push the parameters x and a to the stack from r5 and r6 to use these values in the following recursive call
			CMP r6,#0 ;compare r6(a) and 0
			BEQ return1 ;if they are equal go to return1 part to return value 1 for a = 0
			;if they are not equal continue recursion
recursion	SUBS r6,#1 ;substract 1 from r6(a) to make its value a-1
			PUSH{r5,r6} ;push the parameters x and a-1 to the stack from r5 and r6 to use them as paramaters of following recursive call 
			BL	powerFunc ;go to function powerFunc, save return address in LR
return 		POP{r1} ;pop return value from inner recursive call from stack to r1
			POP{r5,r6} ;pop x and a values of corresponding recursive call to r5 and r6
			POP{r7} ;pop return address of corresponding recursive call to r7
			MULS r1, r5, r1 ;multiply r1(return value from inner recursive call) by r5(x) then move result to r1(x*powerFunc(x,a-1))
			PUSH{r1} ;push return value r1 to the stack
			BX r7 ;go to return address in r7
return1  	POP{r5,r6} ;pop x and a values of corresponding recursive call to r5 and r6(for a = 0) 
			POP{r7} ;pop return address of corresponding recursive call to r7
			MOVS r1,#1 ;set return value for a = 0 equals to 1, move decimal value 1 to r1
			PUSH{r1} ;push return value r1(1) to the stack
			BX r7 ;go to return address in r7
			
stop		B stop ;finish
			;Your code ends here

x			EQU 2 									;Define x
a			EQU 3 									;Define a
			ENDFUNC
			END