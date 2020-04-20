CC = icc12w
LIB = ilibw
CFLAGS =  -IC:\iccv712\include -e -D__ICC_VERSION=708 -D__BUILD=124  -l -g -Wa-g 
ASFLAGS = $(CFLAGS) 
LFLAGS =  -LC:\iccv712\lib -g -nb:124 -uMCSsetupASM.o -btext:0x4000.0xFFFF -bdata:0x1000.0x1FFF -dinit_sp:0x2000 -fmots19
FILES = ADU.o 

ADU:	$(FILES)
	$(CC) -o ADU $(LFLAGS) @ADU.lk  
ADU.o:	..\..\ADU\ADU.S
	$(CC) -c $(ASFLAGS) ..\..\ADU\ADU.S
