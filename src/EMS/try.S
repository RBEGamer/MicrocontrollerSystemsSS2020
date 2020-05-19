

#include "HC12RegDefsMCS.h"
#pragma interrupt_handler IRQ_Routine	// Interrupt Routine (vgl. HC12IntVecMCS.C)

//=== Globale Variablen ===
//
void Wartexms(unsigned short);
short menucounter  =0;
//=== Funktionsdeklarationen ===
// Display:
int LCD4x20C (int LineSel, int CsrPos, char* ChrPntr); //LCD-Display


//=== main ===========================================================================

void main(void) {
unsigned short button_state;
	 char DisplayPortNo[2];
	 char DisplayPortStatus[2];
	 
	 
	 
 	 DDRS =  0b11110000;           //PORT S 4x OUTPUT
	 PORTS = 0b00000000; //
	 //TIMER SETIP
	 TSCR1 = 0b10010000;
	 TIOS= 0b00000001;

	//DISPLAY INIT
	LCD4x20C(0,0,0);
	LCD4x20C(1,4,"MCS-Praktikum");
	LCD4x20C(3,3,"Schalter-PBx = ?");
	//TERMINIERUNG
	DisplayPortNo[1] = 0;
	DisplayPortStatus[1] = 0;
	
	asm ("CLI");
//=== Hauptroutine =============================================

while(1){ 
		  		    
					PORTS = PORTB<<4; //AUF LEDS SCHREIBEN
					
					DisplayPortNo[0] = 48 + menucounter; //0-9
					
					if(PORTB &(0b00000001<<menucounter)){
					DisplayPortStatus[0] = 49;
					}else{
					DisplayPortStatus[0] = 48;
					}
					
					
					//UPSATE DISPLAY
					LCD4x20C(3,14,DisplayPortNo);
					LCD4x20C(3,18,DisplayPortStatus);					
					
					menucounter++;
					if(menucounter > 3){
					menucounter = 0;
					}
					
					Wartexms(1000);
	} //Abschluss while(1)


} //ende main()

//=== end of main ====================================================================

void Wartexms(unsigned short iwarte){
unsigned short i;

for(i=1; i<= iwarte; i++){
TC0 = TCNT + 8000;
while((TFLG1 & 0b00000001) == 0){
asm("nop");
};
}

}


//=== IRQ Interrupt Routine ==========================================================

void IRQ_Routine(void)
{
//=== Variablendeklarationen ===
//unsigned short IRQ_LocalVar1, IRQ_LocalVar2=8135; etc. etc.

//=== IRQ-Routine =============================================
	//........
	//........
	//........
}
//=== Ende IRQ Interrupt Routine =====================================================
