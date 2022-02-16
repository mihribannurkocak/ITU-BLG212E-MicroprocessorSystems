; BLG 212E HW 2 - Question 2
; Student Name: Mihriban Nur Kocak
; Student Number: 150180090
GPIOA_PDOR	EQU 0x400FF000 ;address of output data register
GPIOA_PCOR	EQU 0x400FF008 ;address of output clear register
GPIOA_PDIR	EQU 0x400FF010 ;address of input data register
GPIOA_PDDR	EQU 0x400FF014 ;address of data direction register

			AREA led_function, CODE, READONLY		;Declare new area for code
			ENTRY
			THUMB
			ALIGN

__main		FUNCTION								;Define main function
			EXPORT __main	

			;Your code starts here
setup 		LDR r0,=0x00000001 ;mask to set 0th bit as output
			LDR r1,=GPIOA_PDDR ;get addres of data direction register
			LDR r2,[r1] ;get value in data register 
			ORRS r2,r2,r0 ;by or operation, obtain value to set 0th bit as 1(output)
			LDR r0,=0x00000002 ;mask to set 1st bit as input
			BICS r2,r2,r0 ;by bit clear operation, obtain value to set 1st bit as 0(input)
			STR r2,[r1] ;load obtained value to data direction register
			LDR r7,=0 ;counter to arrange period
		
open_led	LDR r3,=GPIOA_PDOR ;get address of output data register
			LDR r1,[r3] ;get the current value in output data register
			LDR r0,=0x000000001 ;mask to set 0th bit of output is high to which corresponds openning 0th led
			ORRS r1,r0;apply the mask to set 0th bit as high
			STR r1,[r3];load obtained value to output data register to turn on the led
			BL period ;remain open during time period/2			

close_led	LDR r1,[r3] ;get the current value in output data register
			BICS r1,r0 ;apply the mask to set 0th bit as high
			STR r1,[r3] ;load obtained value to output data register to turn of the led
			BL period ;remain close during time period/2
			B press ;as if pin is pressed

press		LDR r3,=GPIOA_PDIR ;get address of input data register
			LDR r1,[r3] ;get the current value in input data register
			LDR r0,=0x00000002;mask to set 1st bit of input is high to simulate pressing button scenerio
			ORRS r1,r0;apply mask by or operation
			STR r1,[r3];load obtained value to input data register 
			;now the button is pressed so we need to change the period
check		LDR r1,[r3] ;get the current value in input data register
			CMP r1,r0;check if button is pressed
			BEQ change ;change period
			B release ;move without changing period
change		ADDS r7,#1 ;change to next period duration
			;as if pin is released
release		LDR r1,[r3] ;get the current value in input data register
			LDR r0,=0x00000002;mask to set 1st bit of input is low to simulate releasing button scenerio
			BICS r1,r0;apply mask by bics operation
			STR r1,[r3];load obtained value to input data register 
			B open_led ;go to repeat with next period option

period		LDR r5,=0x0 ;time counter
			LDR r6,=1199999 ;(1+1199999) / 2.4Mh z = 0.5s
			CMP r7,#3 ;if 3 period options are occured
			BEQ reset ;reset to start period options from beginning
increase	LSLS r6,r6,r7 ;make period 2times of the previous period
			B counter ;go to count

reset 		LDR r7,=0 ;reset period order
			B increase ;continue with counting

;wait along given time by looping, time is decided according to clock frequency
counter		CMP r6,r5
			BEQ	return
			ADDS r5,r5,#1
			B counter
return		BX LR				
			;Your code ends here
			ENDFUNC
			END