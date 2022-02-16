; BLG 212E HW 2 - Question 1
; Student Name: Mihriban Nur Kocak
; Student Number: 150180090
ArraySize 	EQU 0x28 	; Array size = 40 (10 words, 4 bytes each)
SysTick_CTRL EQU 0xE000E010 ;Control and status register
SysTick_LOAD EQU 0xE000E014 ;Reload value register
SysTick_VAL EQU 0xE000E018 ;Current value register

			AREA output, DATA, READWRITE				; Data area
			ALIGN
Array_start SPACE ArraySize 							
Array_end				
			
			; You should first write arrays to the memory, then move onto the pooling part.

			AREA max_pool, CODE, READONLY
			ENTRY
			THUMB
			
__main		FUNCTION 
			EXPORT __main 
			
			LDR r0,=SysTick_CTRL ;get the address of control and status register
			LDR r1,=SysTick_LOAD ;get the address of reload value register
			LDR r2,=SysTick_VAL ;get the address of current value register
			LDR r6,=0x000000 ;0 value
			LDR r3, =0x7 ;0111 value
			LDR r4, =0xB71AFF ;for 1second = (1+11999999) x (1/12MHz) I setted reload value as 11999999
			STR r6, [r1] ;clear reload value register
			STR r4, [r1] ;load the decimal 11999999 value as reload value to reload value register for counting from that to 0
			STR r6, [r2] ;clear current value register
			STR r6, [r0] ;clear control and status register
			STR r3, [r0] ;load 0111 value to set CLCKSOURSE,TICKINT and ENABLE bits as 1
			;from now on, systick starts counting
			LDR r4,=Array_start ;get address of the array start
			LDR r5,=one_array ;get address of the first row
			LDR r6,=three_array ;get address of the third row
			MOVS r7,#0 ;r7 holds counter value
LOOP		CMP r7,#10; whether we have executed 10 polling operations
			BEQ disable;if yes disable
			B LOOP;if not continue to wait for interrupt
disable		LDR r0,=SysTick_CTRL;get the address of control and status register
			LDR r1, =0X6;to set ENABLE bit as 0
			STR r1,[r0] ;set ENABLE bit as 0 to disable systick
			;systick is disabled
			B disable;infinite loop for finish
			ENDFUNC
;INTERRUPT SUBROUTINE
SysTickISR	FUNCTION 
			EXPORT SysTickISR
			;some stack pushs are done automatically
			CMP r7,#5;if the upper part of the array is polled
			BGE part2 ;go next part
part1		LDR r0, [r5];get one element from array
			LDR r1, [r5,#40];get the element at same column at next row
			ADDS r5,#4 ;increment address to reach next element
			LDR r2, [r5];get second element from array
			LDR r3, [r5,#40];get the element at same column at next row
			ADDS r5,#4 ;increment address to reach next element
			B cmp1 ;go to comparison to find max
part2		CMP r7,#10 ;if the lower part of the array is polled
			BGE finish ;go to finish
			LDR r0, [r6] ;get one element from array
			LDR r1, [r6,#40];get the element at same column at next row
			ADDS r6,#4;increment address to reach next element
			LDR r2, [r6];get second element from array
			LDR r3, [r6,#40];get the element at same column at next row
			ADDS r6,#4;increment address to reach next element
cmp1		CMP r1,r0;initially value in r0 is set as max, if value in r1 > r0
			BGT update1 ;go to set r1 as max		
cmp2		CMP r2,r0 ;current value in r0 is max, if value in r2 > r0
			BGT update2 ;go to set r2 as max
cmp3		CMP r3,r0 ;current value in r0 is max, if value in r3 > r0
			BGT update3 ;go to set r3 as max
			B result ;we had max in r0, go to store it in array
update1		MOV r0,r1 ;set r1's value as max
			B cmp2
update2		MOV r0,r2 ;set r2's value as max
			B cmp3
update3		MOV r0,r3 ;set r3's value as max
result		ADDS r7,#1 ;increment r7 which shows number of polling done
			STR r0,[r4] ;store max value in array
			ADDS r4,#4 ;go to next element area for new element at storage array
finish		BX LR ;go to where the interrupt subroutine is called (it is popped from stack to LR)
		
			ALIGN
			ENDFUNC


one_array 	DCD 7, 28, 67, 40, 13, 19, 72, 56, 89, 92 ; first row
one_end 
two_array 	DCD 14, 55, 42, 36, 11, 57, 2, 18, 23, 17 ; second row
two_end 
three_array DCD 66, 22, 84, 15, 36, 5, 47, 12, 56, 74; third row
three_end 
four_array 	DCD 33, 21, 16, 8, 95, 43, 86, 28, 4, 62; fourth row
four_end 
			END