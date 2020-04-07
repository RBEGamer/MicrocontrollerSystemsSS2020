CC = icc12w
LIB = ilibw
CFLAGS =  -IC:\iccv712\include -e -D__ICC_VERSION=708 -D__BUILD=111  -l -g -Wa-g 
ASFLAGS = $(CFLAGS) 
LFLAGS =  -LC:\iccv712\lib -g -nb:111 -uMCSsetupASM.o -btext:0x4000.0xFFFF -bdata:0x1000.0x1FFF -dinit_sp:0x2000 -fmots19
FILES = LEDTeil1.o 

LEDTEIL1:	$(FILES)
	$(CC) -o LEDTEIL1 $(LFLAGS) @LEDTEIL1.lk  
LEDTeil1.o:	..\LEDTeil1.S
	$(CC) -c $(ASFLAGS) ..\LEDTeil1.S
