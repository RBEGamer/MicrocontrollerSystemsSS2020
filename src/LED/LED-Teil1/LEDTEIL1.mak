CC = icc12w
LIB = ilibw
CFLAGS =  -IC:\Programme -I(x86)\ICC12\include\ -e -D__ICC_VERSION=708 -D__BUILD=110  -l -g -Wa-g 
ASFLAGS = $(CFLAGS) 
LFLAGS =  -LC:\Programme -L(x86)\ICC12\lib\ -g -nb:110 -uMCSsetupASM.o -btext:0x4000.0xFFFF -bdata:0x1000.0x1FFF -dinit_sp:0x2000 -fmots19
FILES = LEDTeil1.o 

LEDTEIL1:	$(FILES)
	$(CC) -o LEDTEIL1 $(LFLAGS) @LEDTEIL1.lk  
LEDTeil1.o:	..\..\LED-Teil1\LEDTeil1.S
	$(CC) -c $(ASFLAGS) ..\..\LED-Teil1\LEDTeil1.S
