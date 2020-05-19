       //>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
       // File: C-UserProgBody.C      EMT/MCS        23.06.2009 Kzy  //
       //<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
       
       #include "HC12RegDefsMCS.h"
       #pragma interrupt_handler IRQ_Routine   // Interrupt Routine (vgl. HC12IntVecMCS.C)
       
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
                
                
                
4441            DDRS =  0b11110000;           //PORT S 4x OUTPUT
4446            PORTS = 0b00000000; //
                //TIMER SETIP
4449            TSCR1 = 0b10010000;
444E            TIOS= 0b00000001;
       
               //DISPLAY INIT
4453           LCD4x20C(0,0,0);
4463           LCD4x20C(1,4,"MCS-Praktikum");
4473           LCD4x20C(3,3,"Schalter-PBx = ?");
               //TERMINIERUNG
4483           DisplayPortNo[1] = 0;
4485           DisplayPortStatus[1] = 0;
               
4487           asm ("CLI");
       //=== Hauptroutine =============================================
       
44F5   while(1){ 
448D                                       button_state = PORTB<<4;//& 0b11110000; //ZUSTAND EINLESEN
4497                                           PORTS = button_state; //AUF LEDS SCHREIBEN
                                               
449A                                           DisplayPortNo[0] = 48 + menucounter; //0-9
44A2                                           DisplayPortStatus[0] = 48 + (PORTB &(0b00010000<<menucounter));
                                               
                                               //UPSATE DISPLAY
44BC                                           LCD4x20C(3,14,DisplayPortNo);
44CB                                           LCD4x20C(3,18,DisplayPortStatus);                                       
                                               
44DA                                           menucounter++;
44E1                                           if(menucounter > 3){
44E9                                           menucounter = 0;
                                               }
                                               
44EF                                           Wartexms(1000);
               } //Abschluss while(1)
       
       
       } //ende main()
       
       //=== end of main ====================================================================
       
       void Wartexms(unsigned short iwarte){
       unsigned short i;
       
44FF   for(i=1; i<= iwarte; i++){
4506   TC0 = TCNT + 8000;
4512   while((TFLG1 & 0b00000001) == 0){
4511   asm("nop");
       };
       }
       
       }
       
       
       //=== IRQ Interrupt Routine ==========================================================
       
       void IRQ_Routine(void)
4525   {
       //=== Variablendeklarationen ===
       //unsigned short IRQ_LocalVar1, IRQ_LocalVar2=8135; etc. etc.
       
       //=== IRQ-Routine =============================================
               //........
               //........
               //........
       }
       //=== Ende IRQ Interrupt Routine =====================================================


