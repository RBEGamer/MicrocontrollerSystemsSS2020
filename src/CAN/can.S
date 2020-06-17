#include "HC12RegDefsMCS.h"
#pragma interrupt_handler MSCAN_Receive

unsigned char data_available;
unsigned short data_identifier;
unsigned char  data_length;
unsigned char data[8];

int LCD4x20C (int LineSel, int CsrPos, char* ChrPntr); //LCD-Display
void init_can(void);
void init_lcd(void);
void data_out(void);

void main(void) {
    LCD4x20C(0,0,0); // Display löschen
    init_can();
    init_lcd();
    asm ("CLI"); // Clear Interrupt-Mask (falls IRQ Routine vorhanden)

    while(1){
        if(data_available) {
            data_out();
            data_available = 0;
        }
	}
}

void data_out(void) {
    char len_decimal[2];
    char id_decimal[5];
    len_decimal[0] = '0' + data_length;
    len_decimal[1] = 0;
    id_decimal[0] = '0' + ((data_identifier / 1000) % 10);
    id_decimal[1] = '0' + ((data_identifier / 100) % 10);
    id_decimal[2] = '0' + ((data_identifier / 10) % 10);
    id_decimal[3] = '0' + ((data_identifier / 1) % 10);
    id_decimal[4] = 0;
    LCD4x20C(1, 13, id_decimal);
    LCD4x20C(2, 13, data);
    LCD4x20C(3, 13, len_decimal);
}

void init_lcd(void) {
    LCD4x20C(1,1,"IDENTIFIER ");
    LCD4x20C(2,1,"DATA ");
    LCD4x20C(3,1,"DATALENGTH ");
}

void init_can(void) {
     // Tnbt = 1bit / 500kbps = 2us;
     // Tq = 1/16 Tnbt = 125ns;
     // Tosc = 1 / 16Mhz = 62.5ns 
     // Prescaler = Tq / Tosc = 2
     // Tbus = 5ns/m * 60m = 300ns
     // Tprop = 2(Tbus + Tx0 + Tr0) = 2(300 + 170) = 940ns
     // Prop = Tprop / Tq = 7
     // Quantisation = SYNC(1) + PROP(7) + PHASE1(4) + PHASE2(4)
     // Sync jump width = 1
     // SEG1 = PROP + PHASE 1 = 11
     // SEG2 = PHASE2 = 4
        
     
     CANCTL0 = 0b00000001; // Start initialization
     CANCTL1 = 0b10000000; // Enable CAN
     
     CANBTR0 = 0b00000001; // [..][......] SJW-1 and Prescaler-1
     CANBTR1 = 0b00111010; // [.][...][....] Test once, SEG2 - 1, SEG1 - 1
     CANIDAC = 0b00010000; // 4x16b Acceptance filters
     
     /*
     CANIDAR0 = 0b00001100; // Filter 1 = 100
     CANIDAR1 = 0b10000000;
     CANIDMR0 = 0b00000000; // Test all high bits
     CANIDMR1 = 0b00000111; // 3 low bits, RTR, IDE, Mask out last 3 bits 
     */
     
     CANIDAR2 = 0b00011001; // Filter 2 = 200
     CANIDAR3 = 0b00000000;
     CANIDMR0 = 0b00000000; // Test all high bits
     CANIDMR1 = 0b00000111; // 3 low bits, RTR, IDE, Mask out last 3 bits 
     
     CANCTL0 = 0b00000000; // End initialization
     CANRIER = 0b00000001; // Enable IR by RXFIE
}

void MSCAN_Receive(void)
{
    volatile unsigned char* data_start = &CANRXDSR0;
    unsigned char rtr = CANRXIDR1 & 0b00010000; // Remote transmission request
    unsigned short idx = 0;

    data_length = CANRXDLR;
    data_identifier = (CANRXIDR0 << 3) + (CANRXIDR1 >> 5); // ID bits from IDR0-1
    
    while(idx < data_length) {
        data[idx] = data_start[idx];
        idx++;
    }
    
    while(idx < 7) {
        data[idx] = ' ';
        idx++;
    }
    data[idx] = 0;
    
    CANRFLG = 0b00000001; // RXF = 1 -> Ack IR
    data_available = 1; // Set flag for main loop
    
}
