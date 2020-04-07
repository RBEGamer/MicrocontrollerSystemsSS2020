.AREA	Memory (abs)
STACK	=	$1000		; Nach RESET $1000, nach SetUp $2000=(End of RAM)+1
SetUp	=	$F800		; Suboutine System SetUp



PORTB	=	$0001
PORTS	=	$0248
DDRS	=	$024A




	.ORG	$1000		; Variablen ab 0x1000
	.ORG    $4000		; Program Code ab 0x4000
	
	
START:	LDS	#STACK		; Setzen Stackpointer
		JSR	SetUp			; System SetUp

		
INIT:	MOVB	#0b11110000,DDRS; 	  ; SETUP PORT DDRS
		  


MAIN: 	LDAA PORTB		 ; LESE PORT B EIN
		LSLA   		  	 ; SCHIEBE ERGEBNIS AUF 4 BIT NACH LINKS
		LSLA   		  	 ; SCHIEBE ERGEBNIS AUF 4 BIT NACH LINKS
		LSLA   		  	 ; SCHIEBE ERGEBNIS AUF 4 BIT NACH LINKS
		LSLA   		  	 ; SCHIEBE ERGEBNIS AUF 4 BIT NACH LINKS
		STA PORTS
	  	JMP MAIN  	  	 ; WIEDERHOLE
	
 
; **********************************************************************************

	.ORG	$FFFE
	.DW	START		; RESTART Vektor
