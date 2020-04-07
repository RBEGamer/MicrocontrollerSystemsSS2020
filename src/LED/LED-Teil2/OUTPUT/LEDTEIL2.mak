CC = icc12w
LIB = ilibw
CFLAGS =  -IC:\iccv712\include -e -D__ICC_VERSION=708 -D__BUILD=118  -l -g -Wa-g 
ASFLAGS = $(CFLAGS) 
LFLAGS =  -LC:\iccv712\lib -g -nb:118 -uMCSsetupASM.o -btext:0x4000.0xFFFF -bdata:0x1000.0x1FFF -dinit_sp:0x2000 -fmots19
FILES = LEDTeil2.o 

LEDTEIL2:	$(FILES)
	$(CC) -o LEDTEIL2 $(LFLAGS) @LEDTEIL2.lk  
LEDTeil2.o:	..\LEDTeil2.S
	$(CC) -c $(ASFLAGS) ..\LEDTeil2.S
