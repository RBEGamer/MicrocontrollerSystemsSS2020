

#include "HC12RegDefsMCSV2.h"

void Wartexms(unsigned short);
short menucounter  =0;   
void main(){
	 unsigned short button_state;
	 char DisplayPortNo[2];
	 char DisplayPortStatus[2];
	 
	 
	 
 	 DDRS =  0b11110000;           //PORT S 4x OUTPUT
	 PORTS = PORTB & 0b11110000; //ERSTES AUSLESEN ZUM TESTEN
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
 
while(1){
          
 	   	  			
		 			button_state = PORTB& 0b11110000; //ZUSTAND EINLESEN
					PORTS = button_state; //AUF LEDS SCHREIBEN
					
					DisplayPortNo[0] = 48 + menucounter; //0-9
					DisplayPortStatus[0] = 48 + (PORTB &(0b00010000<<menucounter));
					
					//UPSATE DISPLAY
					LCD4x20C(3,14,DisplayPortNo);
					LCD4x20C(3,18,DisplayPortStatus);					
					
					menucounter++;
					if(menucounter > 3){
					menucounter = 0;
					}
					
					Wartexms(1000);
				
	   	 			
		    
  }
  
}

   
void Wartexms(unsigned short iwarte){
unsigned short i;

for(i=1; i<= iwarte; i++){
TC0 = TCNT + 8000;
while((TFLG1 & 0b00000001) == 0){
asm("nop");
};
}

}
   
      



