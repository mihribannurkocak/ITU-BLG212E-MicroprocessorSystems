; BLG 212E HW 1 - Question 3
; Recursive Divide and Conquer Computation of the Power Function in O(a) Time
; 
;
; Student Name: Mihriban Nur Kocak
; Student Number: 150180090
; Description: I followed the steps of pseudocode. I used stack to pass parameters, to save return address and return value.
; In contrast to other parts, the recursive calls are not done one after the other and the returns from recursive calls are not done one after the other, they are done in nested way 
; The recursive calls are done in the way of binary tree
; Except a = 0, every (x,a) pair calls two times (x,a/2)
; For example (x,1) first calls (x,0), store its return value at the stack return back and then calls (x,0) again and save its return value at the stack
; Using these two return values (x,1) calculates its return value , pushes it to stack, and it goes like that
; I pushed return address and parameters x and a of every recursive call (x, a/2) to stack until a = 0 
; When returned from the overall function call, the only value in stack is the result.


y_size		EQU 0x4                                 ;Allocate 4 bytes of space for an 
	
			AREA	output, DATA, READWRITE			;Define area to write the output
			ALIGN 
y 			SPACE y_size 							;Define y as the output 
y_end 

			AREA recursivePowerDNQ, CODE, READONLY	;Declare New Area
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
recursion	LSRS r6,#1 ;by logical shift right divide r6(a) by 2 to obtain a/2
			PUSH{r5,r6} ;push the parameters x and a/2 to the stack from r5 and r6 to use them as paramaters of following recursive call 
			BL	powerFunc ;go to function powerFunc, save return address in LR: first recursive call for powerFunc(x,a/2)
			POP{r2} ;pop the curent return value from stack to r2
			POP{r5,r6} ;pop the parameters x and a from the stack to r5 and r6
			PUSH{r5,r6} ;push the parameters x and a to the stack from r5 and r6
			LSRS r6,#1 ;by logical shift right divide r6(a) by 2 to obtain a/2
			PUSH{r2} ;push the current return value to the stack
			PUSH{r5,r6} ;push the parameters x and a/2 to the stack from r5 and r6 to use them as paramaters of following recursive call
			BL powerFunc ;go to function powerFunc, save return address in LR: second recursive call for powerFunc(x,a/2)
return 		POP{r1} ;pop return value from second powerFunc(x,a/2) to r1
			POP{r2} ;pop return value from first powerFunc(x,a/2) to r2
			POP{r5,r6} ;pop the parameters x and a from the stack to r5 and r6
			POP{r7} ;pop return address of corresponding recursive call to r7
			LSRS r6,#1 ;to check is (a % 2) equals to 0, divide r6(a) by 2 and then check the carry flag 
			BCC condition1 ;if carry is clear which means carry flag = 0 then go to condition1
			BCS condition2 ;if carry is set which mean carry flag = 1 then go to condition2
condition1	MULS r1, r2, r1 ;multiply r1(powerFunc(x,a/2)) by r2(powerFunc(x,a/2)) then move result to r1(powerFunc(x,a/2) * powerFunc(x,a/2))
			PUSH{r1} ;push return value r1 to the stack
			BX r7 ;go to return address in r7
condition2	MULS r1, r2, r1 ;multiply r1(powerFunc(x,a/2)) by r2(powerFunc(x,a/2)) then move result to r1(powerFunc(x,a/2) * powerFunc(x,a/2))
			MULS r1, r5, r1 ;multiply r1(powerFunc(x,a/2) * powerFunc(x,a/2)) by r5(x) then move result to r1(powerFunc(x,a/2) * powerFunc(x,a/2) * x)
			PUSH{r1} ;push return value r1 to the stack
			BX r7 ;go to return address in r7
return1  	POP{r5,r6} ;pop x and a values of corresponding recursive call to r5 and r6(for a = 0) 
			POP{r7} ;pop return address of corresponding recursive call to r7
			MOVS r1,#1 ;set return value for a = 0 equals to 1, move decimal value 1 to r1
			PUSH{r1} ;push return value r1(1) to the stack
			BX r7 ;go to return address in r7
			
stop		B stop				
			;Your code ends here

x			EQU 2 									;Define x
a			EQU 3 									;Define a
			ENDFUNC
			END