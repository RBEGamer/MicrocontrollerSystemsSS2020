//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
// File: C-UserProgBody.C      EMT/MCS	      23.06.2009 Kzy  //
//<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

#include "HC12RegDefsMCS.h"
#pragma interrupt_handler IRQ_Routine	// Interrupt Routine (vgl. HC12IntVecMCS.C)

//=== Globale Variablen ===

unsigned char increments[8] = {1,2,4,8,10,20,40};
unsigned char error;

unsigned char hours;
unsigned char minutes; 
unsigned char seconds;
 

//=== Funktionsdeklarationen ===
// Display:
int LCD4x20C (int LineSel, int CsrPos, char* ChrPntr); //LCD-Display

void display_hours(void) {
	 char display_str[4];
	 display_str[0] = 0x30 + (hours / 10);
	 display_str[1] = 0x30 + (hours % 10);
	 display_str[2] = ':';
	 display_str[3] = 0x00;
	 LCD4x20C(1, 2, display_str);
}

void display_minutes(void) {
	 char display_str[4];
	 display_str[0] = 0x30 + (minutes / 10);
	 display_str[1] = 0x30 + (minutes % 10);
	 display_str[2] = ':';
	 display_str[3] = 0x00;
	 LCD4x20C(1, 5, display_str);
}

void display_seconds(void) {
	 char display_str[3];
	 display_str[0] = 0x30 + (seconds / 10);
	 display_str[1] = 0x30 + (seconds % 10);
	 display_str[2] = 0x00;
	 LCD4x20C(1, 8, display_str);
}

//=== main ===========================================================================

void main(void) {

//=== Initialisierungen ===

// LCD-Display 
LCD4x20C(0,0,0); // Display löschen
display_hours();
display_minutes();
display_seconds();

// Ports
DDRA = 0b00001000; // PA3 Output

// Timer
TIOS  = 0b00000001; // Timer0 in Output Capture
TSCR2 = 0b00000101; // Prescaler = 32 => 4us
TSCR1 = 0b10010000; // Enable in Easy Quick Mode

// Reset IRQ
PORTA &= (PORTA & ~0b00001000);
PORTA |= 0b00001000;

asm("CLI"); // Clear Interrupt-Mask (falls IRQ Routine vorhanden)

while(1){
		 error = PORTA & 0b00000100;
		 if(error) {
		     LCD4x20C(1,2,"Error");
		 }
	}
}

void IRQ_Routine(void)
{	

	seconds = seconds + 1;
		
	// Check for new minute
	if(seconds == 60) {
	    display_hours();
		display_minutes();
		seconds = 0;
		minutes = 0;
		hours = 0;
	}

	
	// Delay
	TC0 = TCNT + 35000; // 35000 * 4us = 140ms
	while((TFLG1 & 0b00000001) == 0) {
	    // Busy wait
	}



	if(!(PORTA & 0x01)) {
		if((seconds >= 21) && (seconds <= 27)) {
			minutes += increments[seconds - 21];
		} else if((seconds >= 29) && (seconds <= 34)) {
		  	hours += increments[seconds - 29];
	    }
	}
	
	// Check for end of minute sync
	if (!(PORTA & 0b00000010)) {
	   seconds = 59;
	}

	display_seconds();
	
	// Reset IRQ
	PORTA &= (PORTA & ~0b00001000);
	PORTA |= 0b00001000;
}
