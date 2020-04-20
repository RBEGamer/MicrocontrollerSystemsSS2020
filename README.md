# MicrocontrollerSystemsSS2020

## USED SFOTWARE

* ICCv7 for CPU12
* NoICE for 68HC12
  
## USED HARDWARE

* CardS12 Module  with MC9S12D64
* AD5300 DAC `ADU`
* four LEDS AND BUTTONS `LEDTeil1`



## FOLDERS

* `/src` - asm src files and ICCv7 Project files



## PROJECTS

### LEDTeil1

GPIO mapping:

* PB0 -> PS4
* PB1 -> PS5
* PB2 -> PS6
* PB3 -> PS7


### LEDTeil2

LED Pattern with 4 phases:

* PHASE_1 PS4 PS6 ACTIVE
* PHASE_2 PS5 PS7 ACTIVE
* PHASE_3 PS4 PS7 ACTIVE
* PHASE_4 PS5 PS6 ACTIVE

### ADU

Using a approximation to set a dac voltaget to a user defined ref voltage. using a comperator an PB0 that indicates that the ref voltage is higher/lower the dac set voltage. by checking the PB0 and sending different voltages to the dac, the dac voltage can be approx to the ref voltage
