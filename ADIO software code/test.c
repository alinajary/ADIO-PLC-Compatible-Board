// I/O Registers definitions
#include <io.h>
#include <delay.h>

// Standard Input/Output functions
#include <stdio.h>
unsigned int DAQ_data = 0;
float f_DAQ_data = 0;
unsigned char start_byte=0xAA;
unsigned char stop_byte=0xBB;
 int flag;
char requ_buffer[14];     
#define packet_size_request     12  
unsigned int data_recieved; 
unsigned int packet_start; 
unsigned int DAC_data;

// Declare your global variables here
void dacb_write(unsigned char ch, unsigned int data);
// System Clocks initialization
void system_clocks_init(void)
{
unsigned char n,s;

// Optimize for speed
#pragma optsize- 
// Save interrupts enabled/disabled state
s=SREG;
// Disable interrupts
#asm("cli")

// Internal 32 MHz RC oscillator initialization
// Enable the internal 32 MHz RC oscillator
OSC.CTRL|=OSC_RC32MEN_bm;

// System Clock prescaler A division factor: 1
// System Clock prescalers B & C division factors: B:1, C:1
// ClkPer4: 32000.000 kHz
// ClkPer2: 32000.000 kHz
// ClkPer:  32000.000 kHz
// ClkCPU:  32000.000 kHz
n=(CLK.PSCTRL & (~(CLK_PSADIV_gm | CLK_PSBCDIV1_bm | CLK_PSBCDIV0_bm))) |
	CLK_PSADIV_1_gc | CLK_PSBCDIV_1_1_gc;
CCP=CCP_IOREG_gc;
CLK.PSCTRL=n;

// Disable the auto-calibration of the internal 32 MHz RC oscillator
DFLLRC32M.CTRL&= ~DFLL_ENABLE_bm;

// Wait for the internal 32 MHz RC oscillator to stabilize
while ((OSC.STATUS & OSC_RC32MRDY_bm)==0);

// Select the system clock source: 32 MHz Internal RC Osc.
n=(CLK.CTRL & (~CLK_SCLKSEL_gm)) | CLK_SCLKSEL_RC32M_gc;
CCP=CCP_IOREG_gc;
CLK.CTRL=n;

// Disable the unused oscillators: 2 MHz, internal 32 kHz, external clock/crystal oscillator, PLL
OSC.CTRL&= ~(OSC_RC2MEN_bm | OSC_RC32KEN_bm | OSC_XOSCEN_bm | OSC_PLLEN_bm);

// ClkPer output disabled
PORTCFG.CLKEVOUT&= ~(PORTCFG_CLKOUTSEL_gm | PORTCFG_CLKOUT_gm);
// Restore interrupts enabled/disabled state
SREG=s;
// Restore optimization for size if needed
#pragma optsize_default
}

// Event System initialization
void event_system_init(void)
{
// Event System Channel 0 source: None
EVSYS.CH0MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 1 source: None
EVSYS.CH1MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 2 source: None
EVSYS.CH2MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 3 source: None
EVSYS.CH3MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 4 source: None
EVSYS.CH4MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 5 source: None
EVSYS.CH5MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 6 source: None
EVSYS.CH6MUX=EVSYS_CHMUX_OFF_gc;
// Event System Channel 7 source: None
EVSYS.CH7MUX=EVSYS_CHMUX_OFF_gc;

// Event System Channel 0 Digital Filter Coefficient: 1 Sample
// Quadrature Decoder: Off
EVSYS.CH0CTRL=(EVSYS.CH0CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
	EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 1 Digital Filter Coefficient: 1 Sample
EVSYS.CH1CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 2 Digital Filter Coefficient: 1 Sample
// Quadrature Decoder: Off
EVSYS.CH2CTRL=(EVSYS.CH2CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
	EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 3 Digital Filter Coefficient: 1 Sample
EVSYS.CH3CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 4 Digital Filter Coefficient: 1 Sample
// Quadrature Decoder: Off
EVSYS.CH4CTRL=(EVSYS.CH4CTRL & (~(EVSYS_QDIRM_gm | EVSYS_QDIEN_bm | EVSYS_QDEN_bm | EVSYS_DIGFILT_gm))) |
	EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 5 Digital Filter Coefficient: 1 Sample
EVSYS.CH5CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 6 Digital Filter Coefficient: 1 Sample
EVSYS.CH6CTRL=EVSYS_DIGFILT_1SAMPLE_gc;
// Event System Channel 7 Digital Filter Coefficient: 1 Sample
EVSYS.CH7CTRL=EVSYS_DIGFILT_1SAMPLE_gc;

// Event System Channel output: Disabled
PORTCFG.CLKEVOUT&= ~PORTCFG_EVOUT_gm;
PORTCFG.EVOUTSEL&= ~PORTCFG_EVOUTSEL_gm;
}

// Ports initialization
void ports_init(void)
{
// PORTA initialization
// OUT register
PORTA.OUT=0x00;
// Pin0: Input
// Pin1: Input
// Pin2: Input
// Pin3: Input
// Pin4: Input
// Pin5: Input
// Pin6: Input
// Pin7: Input
PORTA.DIR=0x00;
// Pin0 Output/Pull configuration: Totempole/No
// Pin0 Input/Sense configuration: Sense both edges
// Pin0 Inverted: Off
// Pin0 Slew Rate Limitation: Off
PORTA.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin1 Output/Pull configuration: Totempole/No
// Pin1 Input/Sense configuration: Sense both edges
// Pin1 Inverted: Off
// Pin1 Slew Rate Limitation: Off
PORTA.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin2 Output/Pull configuration: Totempole/No
// Pin2 Input/Sense configuration: Sense both edges
// Pin2 Inverted: Off
// Pin2 Slew Rate Limitation: Off
PORTA.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin3 Output/Pull configuration: Totempole/No
// Pin3 Input/Sense configuration: Sense both edges
// Pin3 Inverted: Off
// Pin3 Slew Rate Limitation: Off
PORTA.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin4 Output/Pull configuration: Totempole/No
// Pin4 Input/Sense configuration: Sense both edges
// Pin4 Inverted: Off
// Pin4 Slew Rate Limitation: Off
PORTA.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin5 Output/Pull configuration: Totempole/No
// Pin5 Input/Sense configuration: Sense both edges
// Pin5 Inverted: Off
// Pin5 Slew Rate Limitation: Off
PORTA.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin6 Output/Pull configuration: Totempole/No
// Pin6 Input/Sense configuration: Sense both edges
// Pin6 Inverted: Off
// Pin6 Slew Rate Limitation: Off
PORTA.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin7 Output/Pull configuration: Totempole/No
// Pin7 Input/Sense configuration: Sense both edges
// Pin7 Inverted: Off
// Pin7 Slew Rate Limitation: Off
PORTA.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTA.INTCTRL=(PORTA.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
    PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Pin0 Pin Change interrupt 0: Off
// Pin1 Pin Change interrupt 0: Off
// Pin2 Pin Change interrupt 0: Off
// Pin3 Pin Change interrupt 0: Off
// Pin4 Pin Change interrupt 0: Off
// Pin5 Pin Change interrupt 0: Off
// Pin6 Pin Change interrupt 0: Off
// Pin7 Pin Change interrupt 0: Off
PORTA.INT0MASK=0x00;
// Pin0 Pin Change interrupt 1: Off
// Pin1 Pin Change interrupt 1: Off
// Pin2 Pin Change interrupt 1: Off
// Pin3 Pin Change interrupt 1: Off
// Pin4 Pin Change interrupt 1: Off
// Pin5 Pin Change interrupt 1: Off
// Pin6 Pin Change interrupt 1: Off
// Pin7 Pin Change interrupt 1: Off
PORTA.INT1MASK=0x00;

// PORTB initialization
// OUT register
PORTB.OUT=0x00;
// Pin0: Input
// Pin1: Input
// Pin2: Input
// Pin3: Input
// Pin4: Input
// Pin5: Input
// Pin6: Input
// Pin7: Input
PORTB.DIR=0x00;
// Pin0 Output/Pull configuration: Totempole/No
// Pin0 Input/Sense configuration: Sense both edges
// Pin0 Inverted: Off
// Pin0 Slew Rate Limitation: Off
PORTB.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin1 Output/Pull configuration: Totempole/No
// Pin1 Input/Sense configuration: Sense both edges
// Pin1 Inverted: Off
// Pin1 Slew Rate Limitation: Off
PORTB.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin2 Output/Pull configuration: Totempole/No
// Pin2 Input/Sense configuration: Sense both edges
// Pin2 Inverted: Off
// Pin2 Slew Rate Limitation: Off
PORTB.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin3 Output/Pull configuration: Totempole/No
// Pin3 Input/Sense configuration: Sense both edges
// Pin3 Inverted: Off
// Pin3 Slew Rate Limitation: Off
PORTB.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin4 Output/Pull configuration: Totempole/No
// Pin4 Input/Sense configuration: Sense both edges
// Pin4 Inverted: Off
// Pin4 Slew Rate Limitation: Off
PORTB.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin5 Output/Pull configuration: Totempole/No
// Pin5 Input/Sense configuration: Sense both edges
// Pin5 Inverted: Off
// Pin5 Slew Rate Limitation: Off
PORTB.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin6 Output/Pull configuration: Totempole/No
// Pin6 Input/Sense configuration: Sense both edges
// Pin6 Inverted: Off
// Pin6 Slew Rate Limitation: Off
PORTB.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin7 Output/Pull configuration: Totempole/No
// Pin7 Input/Sense configuration: Sense both edges
// Pin7 Inverted: Off
// Pin7 Slew Rate Limitation: Off
PORTB.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTB.INTCTRL=(PORTB.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
    PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Pin0 Pin Change interrupt 0: Off
// Pin1 Pin Change interrupt 0: Off
// Pin2 Pin Change interrupt 0: Off
// Pin3 Pin Change interrupt 0: Off
// Pin4 Pin Change interrupt 0: Off
// Pin5 Pin Change interrupt 0: Off
// Pin6 Pin Change interrupt 0: Off
// Pin7 Pin Change interrupt 0: Off
PORTB.INT0MASK=0x00;
// Pin0 Pin Change interrupt 1: Off
// Pin1 Pin Change interrupt 1: Off
// Pin2 Pin Change interrupt 1: Off
// Pin3 Pin Change interrupt 1: Off
// Pin4 Pin Change interrupt 1: Off
// Pin5 Pin Change interrupt 1: Off
// Pin6 Pin Change interrupt 1: Off
// Pin7 Pin Change interrupt 1: Off
PORTB.INT1MASK=0x00;

// PORTC initialization
// OUT register
PORTC.OUT=0x04;
// Pin0: Output
// Pin1: Output
// Pin2: Output
// Pin3: Input
// Pin4: Input
// Pin5: Input
// Pin6: Input
// Pin7: Input
PORTC.DIR=0x07;
// Pin0 Output/Pull configuration: Totempole/No
// Pin0 Input/Sense configuration: Sense both edges
// Pin0 Inverted: Off
// Pin0 Slew Rate Limitation: Off
PORTC.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin1 Output/Pull configuration: Totempole/No
// Pin1 Input/Sense configuration: Sense both edges
// Pin1 Inverted: Off
// Pin1 Slew Rate Limitation: Off
PORTC.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin2 Output/Pull configuration: Totempole/No
// Pin2 Input/Sense configuration: Sense both edges
// Pin2 Inverted: Off
// Pin2 Slew Rate Limitation: Off
PORTC.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin3 Output/Pull configuration: Totempole/No
// Pin3 Input/Sense configuration: Sense both edges
// Pin3 Inverted: Off
// Pin3 Slew Rate Limitation: Off
PORTC.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin4 Output/Pull configuration: Totempole/No
// Pin4 Input/Sense configuration: Sense both edges
// Pin4 Inverted: Off
// Pin4 Slew Rate Limitation: Off
PORTC.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin5 Output/Pull configuration: Totempole/No
// Pin5 Input/Sense configuration: Sense both edges
// Pin5 Inverted: Off
// Pin5 Slew Rate Limitation: Off
PORTC.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin6 Output/Pull configuration: Totempole/No
// Pin6 Input/Sense configuration: Sense both edges
// Pin6 Inverted: Off
// Pin6 Slew Rate Limitation: Off
PORTC.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin7 Output/Pull configuration: Totempole/No
// Pin7 Input/Sense configuration: Sense both edges
// Pin7 Inverted: Off
// Pin7 Slew Rate Limitation: Off
PORTC.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// PORTC Peripheral Output Remapping
// OC0A Output: Pin 0
// OC0B Output: Pin 1
// OC0C Output: Pin 2
// OC0D Output: Pin 3
// USART0 XCK: Pin 1
// USART0 RXD: Pin 2
// USART0 TXD: Pin 3
// SPI MOSI: Pin 5
// SPI SCK: Pin 7
PORTC.REMAP=(0<<PORT_SPI_bp) | (0<<PORT_USART0_bp) | (0<<PORT_TC0D_bp) | (0<<PORT_TC0C_bp) | (0<<PORT_TC0B_bp) | (0<<PORT_TC0A_bp);
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTC.INTCTRL=(PORTC.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
    PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Pin0 Pin Change interrupt 0: Off
// Pin1 Pin Change interrupt 0: Off
// Pin2 Pin Change interrupt 0: Off
// Pin3 Pin Change interrupt 0: Off
// Pin4 Pin Change interrupt 0: Off
// Pin5 Pin Change interrupt 0: Off
// Pin6 Pin Change interrupt 0: Off
// Pin7 Pin Change interrupt 0: Off
PORTC.INT0MASK=0x00;
// Pin0 Pin Change interrupt 1: Off
// Pin1 Pin Change interrupt 1: Off
// Pin2 Pin Change interrupt 1: Off
// Pin3 Pin Change interrupt 1: Off
// Pin4 Pin Change interrupt 1: Off
// Pin5 Pin Change interrupt 1: Off
// Pin6 Pin Change interrupt 1: Off
// Pin7 Pin Change interrupt 1: Off
PORTC.INT1MASK=0x00;

// PORTD initialization
// OUT register
PORTD.OUT=0x00;
// Pin0: Input
// Pin1: Input
// Pin2: Input
// Pin3: Input
// Pin4: Output
// Pin5: Output
// Pin6: Output
// Pin7: Output
PORTD.DIR=0xF0;
// Pin0 Output/Pull configuration: Totempole/No
// Pin0 Input/Sense configuration: Sense both edges
// Pin0 Inverted: Off
// Pin0 Slew Rate Limitation: Off
PORTD.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin1 Output/Pull configuration: Totempole/No
// Pin1 Input/Sense configuration: Sense both edges
// Pin1 Inverted: Off
// Pin1 Slew Rate Limitation: Off
PORTD.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin2 Output/Pull configuration: Totempole/No
// Pin2 Input/Sense configuration: Sense both edges
// Pin2 Inverted: Off
// Pin2 Slew Rate Limitation: Off
PORTD.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin3 Output/Pull configuration: Totempole/No
// Pin3 Input/Sense configuration: Sense both edges
// Pin3 Inverted: Off
// Pin3 Slew Rate Limitation: Off
PORTD.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin4 Output/Pull configuration: Totempole/No
// Pin4 Input/Sense configuration: Sense both edges
// Pin4 Inverted: Off
// Pin4 Slew Rate Limitation: Off
PORTD.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin5 Output/Pull configuration: Totempole/No
// Pin5 Input/Sense configuration: Sense both edges
// Pin5 Inverted: Off
// Pin5 Slew Rate Limitation: Off
PORTD.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin6 Output/Pull configuration: Totempole/No
// Pin6 Input/Sense configuration: Sense both edges
// Pin6 Inverted: Off
// Pin6 Slew Rate Limitation: Off
PORTD.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin7 Output/Pull configuration: Totempole/No
// Pin7 Input/Sense configuration: Sense both edges
// Pin7 Inverted: Off
// Pin7 Slew Rate Limitation: Off
PORTD.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTD.INTCTRL=(PORTD.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
    PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Pin0 Pin Change interrupt 0: Off
// Pin1 Pin Change interrupt 0: Off
// Pin2 Pin Change interrupt 0: Off
// Pin3 Pin Change interrupt 0: Off
// Pin4 Pin Change interrupt 0: Off
// Pin5 Pin Change interrupt 0: Off
// Pin6 Pin Change interrupt 0: Off
// Pin7 Pin Change interrupt 0: Off
PORTD.INT0MASK=0x00;
// Pin0 Pin Change interrupt 1: Off
// Pin1 Pin Change interrupt 1: Off
// Pin2 Pin Change interrupt 1: Off
// Pin3 Pin Change interrupt 1: Off
// Pin4 Pin Change interrupt 1: Off
// Pin5 Pin Change interrupt 1: Off
// Pin6 Pin Change interrupt 1: Off
// Pin7 Pin Change interrupt 1: Off
PORTD.INT1MASK=0x00;

// PORTE initialization
// OUT register
PORTE.OUT=0x00;
// Pin0: Output
// Pin1: Output
// Pin2: Output
// Pin3: Output
// Pin4: Output
// Pin5: Output
// Pin6: Output
// Pin7: Output
PORTE.DIR=0xFF;
// Pin0 Output/Pull configuration: Totempole/No
// Pin0 Input/Sense configuration: Sense both edges
// Pin0 Inverted: Off
// Pin0 Slew Rate Limitation: Off
PORTE.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin1 Output/Pull configuration: Totempole/No
// Pin1 Input/Sense configuration: Sense both edges
// Pin1 Inverted: Off
// Pin1 Slew Rate Limitation: Off
PORTE.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin2 Output/Pull configuration: Totempole/No
// Pin2 Input/Sense configuration: Sense both edges
// Pin2 Inverted: Off
// Pin2 Slew Rate Limitation: Off
PORTE.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin3 Output/Pull configuration: Totempole/No
// Pin3 Input/Sense configuration: Sense both edges
// Pin3 Inverted: Off
// Pin3 Slew Rate Limitation: Off
PORTE.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin4 Output/Pull configuration: Totempole/No
// Pin4 Input/Sense configuration: Sense both edges
// Pin4 Inverted: Off
// Pin4 Slew Rate Limitation: Off
PORTE.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin5 Output/Pull configuration: Totempole/No
// Pin5 Input/Sense configuration: Sense both edges
// Pin5 Inverted: Off
// Pin5 Slew Rate Limitation: Off
PORTE.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin6 Output/Pull configuration: Totempole/No
// Pin6 Input/Sense configuration: Sense both edges
// Pin6 Inverted: Off
// Pin6 Slew Rate Limitation: Off
PORTE.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin7 Output/Pull configuration: Totempole/No
// Pin7 Input/Sense configuration: Sense both edges
// Pin7 Inverted: Off
// Pin7 Slew Rate Limitation: Off
PORTE.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTE.INTCTRL=(PORTE.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
    PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Pin0 Pin Change interrupt 0: Off
// Pin1 Pin Change interrupt 0: Off
// Pin2 Pin Change interrupt 0: Off
// Pin3 Pin Change interrupt 0: Off
// Pin4 Pin Change interrupt 0: Off
// Pin5 Pin Change interrupt 0: Off
// Pin6 Pin Change interrupt 0: Off
// Pin7 Pin Change interrupt 0: Off
PORTE.INT0MASK=0x00;
// Pin0 Pin Change interrupt 1: Off
// Pin1 Pin Change interrupt 1: Off
// Pin2 Pin Change interrupt 1: Off
// Pin3 Pin Change interrupt 1: Off
// Pin4 Pin Change interrupt 1: Off
// Pin5 Pin Change interrupt 1: Off
// Pin6 Pin Change interrupt 1: Off
// Pin7 Pin Change interrupt 1: Off
PORTE.INT1MASK=0x00;

// PORTF initialization
// OUT register
PORTF.OUT=0x00;
// Pin0: Input
// Pin1: Input
// Pin2: Input
// Pin3: Output
// Pin4: Input
// Pin5: Input
// Pin6: Input
// Pin7: Input
PORTF.DIR=0x08;
// Pin0 Output/Pull configuration: Totempole/No
// Pin0 Input/Sense configuration: Sense both edges
// Pin0 Inverted: Off
// Pin0 Slew Rate Limitation: Off
PORTF.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin1 Output/Pull configuration: Totempole/No
// Pin1 Input/Sense configuration: Sense both edges
// Pin1 Inverted: Off
// Pin1 Slew Rate Limitation: Off
PORTF.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin2 Output/Pull configuration: Totempole/No
// Pin2 Input/Sense configuration: Sense both edges
// Pin2 Inverted: Off
// Pin2 Slew Rate Limitation: Off
PORTF.PIN2CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin3 Output/Pull configuration: Totempole/No
// Pin3 Input/Sense configuration: Sense both edges
// Pin3 Inverted: Off
// Pin3 Slew Rate Limitation: Off
PORTF.PIN3CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin4 Output/Pull configuration: Totempole/No
// Pin4 Input/Sense configuration: Sense both edges
// Pin4 Inverted: Off
// Pin4 Slew Rate Limitation: Off
PORTF.PIN4CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin5 Output/Pull configuration: Totempole/No
// Pin5 Input/Sense configuration: Sense both edges
// Pin5 Inverted: Off
// Pin5 Slew Rate Limitation: Off
PORTF.PIN5CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin6 Output/Pull configuration: Totempole/No
// Pin6 Input/Sense configuration: Sense both edges
// Pin6 Inverted: Off
// Pin6 Slew Rate Limitation: Off
PORTF.PIN6CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin7 Output/Pull configuration: Totempole/No
// Pin7 Input/Sense configuration: Sense both edges
// Pin7 Inverted: Off
// Pin7 Slew Rate Limitation: Off
PORTF.PIN7CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTF.INTCTRL=(PORTF.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Pin0 Pin Change interrupt 0: Off
// Pin1 Pin Change interrupt 0: Off
// Pin2 Pin Change interrupt 0: Off
// Pin3 Pin Change interrupt 0: Off
// Pin4 Pin Change interrupt 0: Off
// Pin5 Pin Change interrupt 0: Off
// Pin6 Pin Change interrupt 0: Off
// Pin7 Pin Change interrupt 0: Off
PORTF.INT0MASK=0x00;
// Pin0 Pin Change interrupt 1: Off
// Pin1 Pin Change interrupt 1: Off
// Pin2 Pin Change interrupt 1: Off
// Pin3 Pin Change interrupt 1: Off
// Pin4 Pin Change interrupt 1: Off
// Pin5 Pin Change interrupt 1: Off
// Pin6 Pin Change interrupt 1: Off
// Pin7 Pin Change interrupt 1: Off
PORTF.INT1MASK=0x00;

// PORTR initialization
// OUT register
PORTR.OUT=0x00;
// Pin0: Input
// Pin1: Input
PORTR.DIR=0x00;
// Pin0 Output/Pull configuration: Totempole/No
// Pin0 Input/Sense configuration: Sense both edges
// Pin0 Inverted: Off
// Pin0 Slew Rate Limitation: Off
PORTR.PIN0CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Pin1 Output/Pull configuration: Totempole/No
// Pin1 Input/Sense configuration: Sense both edges
// Pin1 Inverted: Off
// Pin1 Slew Rate Limitation: Off
PORTR.PIN1CTRL=PORT_OPC_TOTEM_gc | PORT_ISC_BOTHEDGES_gc;
// Interrupt 0 level: Disabled
// Interrupt 1 level: Disabled
PORTR.INTCTRL=(PORTR.INTCTRL & (~(PORT_INT1LVL_gm | PORT_INT0LVL_gm))) |
	PORT_INT1LVL_OFF_gc | PORT_INT0LVL_OFF_gc;
// Pin0 Pin Change interrupt 0: Off
// Pin1 Pin Change interrupt 0: Off
PORTR.INT0MASK=0x00;
// Pin0 Pin Change interrupt 1: Off
// Pin1 Pin Change interrupt 1: Off
PORTR.INT1MASK=0x00;
}

// Virtual Ports initialization
void vports_init(void)
{
// PORTA mapped to VPORT0
// PORTB mapped to VPORT1
PORTCFG.VPCTRLA=PORTCFG_VP13MAP_PORTB_gc | PORTCFG_VP02MAP_PORTA_gc;
// PORTC mapped to VPORT2
// PORTD mapped to VPORT3
PORTCFG.VPCTRLB=PORTCFG_VP13MAP_PORTD_gc | PORTCFG_VP02MAP_PORTC_gc;
}

// USARTF0 initialization
void usartf0_init(void)
{
// Note: The correct PORTF direction for the RxD, TxD and XCK signals
// is configured in the ports_init function.

// Transmitter is enabled
// Set TxD=1
PORTF.OUTSET=0x08;

// Communication mode: Asynchronous USART
// Data bits: 8
// Stop bits: 1
// Parity: Disabled
USARTF0.CTRLC=USART_CMODE_ASYNCHRONOUS_gc | USART_PMODE_DISABLED_gc | USART_CHSIZE_8BIT_gc;

// Receive complete interrupt: High Level
// Transmit complete interrupt: Medium Level
// Data register empty interrupt: Disabled
USARTF0.CTRLA=(USARTF0.CTRLA & (~(USART_RXCINTLVL_gm | USART_TXCINTLVL_gm | USART_DREINTLVL_gm))) |
	USART_RXCINTLVL_HI_gc | USART_TXCINTLVL_MED_gc | USART_DREINTLVL_OFF_gc;

// Required Baud rate: 115200
// Real Baud Rate: 115211.5 (x1 Mode), Error: 0.0 %
USARTF0.BAUDCTRLA=0x2E;
USARTF0.BAUDCTRLB=((0x09 << USART_BSCALE_gp) & USART_BSCALE_gm) | 0x08;

// Receiver: On
// Transmitter: On
// Double transmission speed mode: Off
// Multi-processor communication mode: Off
USARTF0.CTRLB=(USARTF0.CTRLB & (~(USART_RXEN_bm | USART_TXEN_bm | USART_CLK2X_bm | USART_MPCM_bm | USART_TXB8_bm))) |
	USART_RXEN_bm | USART_TXEN_bm;
}

// USARTF0 Receiver buffer
#define RX_BUFFER_SIZE_USARTF0 64
char rx_buffer_usartf0[RX_BUFFER_SIZE_USARTF0];

#if RX_BUFFER_SIZE_USARTF0 <= 256
unsigned char rx_wr_index_usartf0=0,rx_rd_index_usartf0=0;
#else
unsigned int rx_wr_index_usartf0=0,rx_rd_index_usartf0=0;
#endif

#if RX_BUFFER_SIZE_USARTF0 < 256
unsigned char rx_counter_usartf0=0;
#else
unsigned int rx_counter_usartf0=0;
#endif

// This flag is set on USARTF0 Receiver buffer overflow
bit rx_buffer_overflow_usartf0=0;

// USARTF0 Receiver interrupt service routine
interrupt [USARTF0_RXC_vect] void usartf0_rx_isr(void)
{
unsigned char status;
char data;
int data0,data1,data2;

status=USARTF0.STATUS;
data=USARTF0.DATA;
       /*
if ((status & (USART_FERR_bm | USART_PERR_bm | USART_BUFOVF_bm)) == 0)
   {
   rx_buffer_usartf0[rx_wr_index_usartf0++]=data;
   if(rx_wr_index_usartf0 == 5)  
   {
   if(rx_buffer_usartf0[rx_wr_index_usartf0-5]=='A')
   {
   data0 = rx_buffer_usartf0[rx_wr_index_usartf0-4]-0x30; 
   data1 = rx_buffer_usartf0[rx_wr_index_usartf0-3]-0x30; 
   data2 = rx_buffer_usartf0[rx_wr_index_usartf0-2]-0x30; 

   DAQ_data =  (data0*100) + ((data1)*10) + (data2);
   f_DAQ_data=(float)(DAQ_data*40.95); 
   DAQ_data = (unsigned int) (f_DAQ_data);
   putchar (DAQ_data>>8);
   putchar (DAQ_data);   
//   DAQ_data = 4095;
   rx_wr_index_usartf0=0; 
   dacb_write(0,DAQ_data);
   }
   }
 //  putchar(rx_buffer_usartf0[(rx_wr_index_usartf0-1)]);
#if RX_BUFFER_SIZE_USARTF0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter_usartf0 == 0) rx_buffer_overflow_usartf0=1;
#else
   if (rx_wr_index_usartf0 == RX_BUFFER_SIZE_USARTF0) rx_wr_index_usartf0=0;
   if (++rx_counter_usartf0 == RX_BUFFER_SIZE_USARTF0)
      {
      rx_counter_usartf0=0;
      rx_buffer_overflow_usartf0=1;
      }
#endif
   }*/
     if((data==start_byte)&&(packet_start==0))
            {
            //packet start________________________________
            packet_start=1;                     //packet start
            data_recieved = 0;                  //Byte Number Set
            requ_buffer[data_recieved]=data;  //Save data
            data_recieved++;                    //Byte Number Set For next Byte
            //____________________________________________
            }
        else if(packet_start==1)
            {
            //packet end__________________________________
            if ( (data_recieved==(packet_size_request-1))&&(data==stop_byte))
                {
                    packet_start=0;
                    requ_buffer[data_recieved]=data;  //Save data
                    data_recieved++;
                    flag=1; 
  
                }
            //____________________________________________

            //packet not end dnf__________________________
            else if ( (data_recieved==(packet_size_request-1))&&(data!=stop_byte))
                {
                    packet_start=0;
                    data_recieved = 0;
                }
            //____________________________________________

            //packet is ok yet__________________________
            else
                {
                requ_buffer[data_recieved]=data;  //Save data
                data_recieved++;
                }
            //________________________________putchar____________
            }


}

// Receive a character from USARTF0
// USARTF0 is used as the default input device by the 'getchar' function
#define _ALTERNATE_GETCHAR_

#pragma used+
char getchar(void)
{
char data;

while (rx_counter_usartf0==0);
data=rx_buffer_usartf0[rx_rd_index_usartf0++];
#if RX_BUFFER_SIZE_USARTF0 != 256
if (rx_rd_index_usartf0 == RX_BUFFER_SIZE_USARTF0) rx_rd_index_usartf0=0;
#endif
#asm("cli")
--rx_counter_usartf0;
#asm("sei")
return data;
}
#pragma used-

// USARTF0 Transmitter buffer
#define TX_BUFFER_SIZE_USARTF0 64
char tx_buffer_usartf0[TX_BUFFER_SIZE_USARTF0];

#if TX_BUFFER_SIZE_USARTF0 <= 256
unsigned char tx_wr_index_usartf0=0,tx_rd_index_usartf0=0;
#else
unsigned int tx_wr_index_usartf0=0,tx_rd_index_usartf0=0;
#endif

#if TX_BUFFER_SIZE_USARTF0 < 256
unsigned char tx_counter_usartf0=0;
#else
unsigned int tx_counter_usartf0=0;
#endif

// USARTF0 Transmitter interrupt service routine
interrupt [USARTF0_TXC_vect] void usartf0_tx_isr(void)
{
if (tx_counter_usartf0)
   {
   --tx_counter_usartf0;
   USARTF0.DATA=tx_buffer_usartf0[tx_rd_index_usartf0++];
#if TX_BUFFER_SIZE_USARTF0 != 256
   if (tx_rd_index_usartf0 == TX_BUFFER_SIZE_USARTF0) tx_rd_index_usartf0=0;
#endif
   }
}

// Write a character to the USARTF0 Transmitter buffer
// USARTF0 is used as the default output device by the 'putchar' function
#define _ALTERNATE_PUTCHAR_

#pragma used+
void putchar(char c)
{
while (tx_counter_usartf0 == TX_BUFFER_SIZE_USARTF0);
#asm("cli")
if (tx_counter_usartf0 || ((USARTF0.STATUS & USART_DREIF_bm)==0))
   {
   tx_buffer_usartf0[tx_wr_index_usartf0++]=c;
#if TX_BUFFER_SIZE_USARTF0 != 256
   if (tx_wr_index_usartf0 == TX_BUFFER_SIZE_USARTF0) tx_wr_index_usartf0=0;
#endif
   ++tx_counter_usartf0;
   }
else
   USARTF0.DATA=c;
#asm("sei")
}
#pragma used-



// DACB initialization
void dacb_init(void)
{
// Operating mode: Single Channel (Ch0)
// Channel 0 triggered by the event system: Off
DACB.CTRLB=(DACB.CTRLB & (~(DAC_CHSEL_gm | DAC_CH0TRIG_bm | DAC_CH1TRIG_bm))) |
	DAC_CHSEL_SINGLE_gc;

// Reference: AREF on PORTB
// Left adjust value: Off
DACB.CTRLC=(DACB.CTRLC & (~(DAC_REFSEL_gm | DAC_LEFTADJ_bm))) |
	DAC_REFSEL_AREFB_gc;

// DACB is enabled
// Low power mode: Off
// Channel 0 output: On
// Channel 1 output: Off
// Internal output connected to the ADCB and Analog Comparator MUX-es: Off
DACB.CTRLA=(DACB.CTRLA & (~(DAC_IDOEN_bm | DAC_CH0EN_bm | DAC_CH1EN_bm | DAC_LPMODE_bm))) |
	DAC_CH0EN_bm | DAC_ENABLE_bm;
}

// Function used to write data to a DACB channel ch
void dacb_write(unsigned char ch, unsigned int data)
{
register unsigned char m=ch ? DAC_CH1DRE_bm : DAC_CH0DRE_bm;
// Wait for the channel data register to be ready for new data
while ((DACB.STATUS & m)==0);
// Write new data to the channel data register
if (m==DAC_CH1DRE_bm) DACB.CH1DATA=data;
else DACB.CH0DATA=data;
}
// Disable a Timer/Counter type TC0
void tc0_disable(TC0_t *ptc)
{
// Timer/Counter off
ptc->CTRLA=TC_CLKSEL_OFF_gc;
// Issue a reset command
ptc->CTRLFSET=TC_CMD_RESET_gc;
}

// Timer/Counter TCC0 initialization
void tcc0_init(void)
{
unsigned char s;
unsigned char n;

// Note: The correct PORTC direction for the Compare Channels
// outputs is configured in the ports_init function.

// Save interrupts enabled/disabled state
s=SREG;
// Disable interrupts
#asm("cli")

// Disable and reset the timer/counter just to be sure
tc0_disable(&TCC0);
// Clock source: ClkPer/1
TCC0.CTRLA=TC_CLKSEL_DIV1_gc;
// Mode: Single Slope PWM Gen., Overflow Int./Event on BOTTOM
// Compare/Capture on channel A: On
// Compare/Capture on channel B: On
// Compare/Capture on channel C: On
// Compare/Capture on channel D: Off
TCC0.CTRLB=(0<<TC0_CCDEN_bp) | (1<<TC0_CCCEN_bp) | (1<<TC0_CCBEN_bp) | (1<<TC0_CCAEN_bp) |
	TC_WGMODE_SS_gc;
// Capture event source: None
// Capture event action: None
TCC0.CTRLD=TC_EVACT_OFF_gc | TC_EVSEL_OFF_gc;

// Set Timer/Counter in Normal mode
TCC0.CTRLE=TC_BYTEM_NORMAL_gc;

// Overflow interrupt: Disabled
// Error interrupt: Disabled
TCC0.INTCTRLA=TC_ERRINTLVL_OFF_gc | TC_OVFINTLVL_OFF_gc;

// Compare/Capture channel A interrupt: Disabled
// Compare/Capture channel B interrupt: Disabled
// Compare/Capture channel C interrupt: Disabled
// Compare/Capture channel D interrupt: Disabled
TCC0.INTCTRLB=TC_CCDINTLVL_OFF_gc | TC_CCCINTLVL_OFF_gc | TC_CCBINTLVL_OFF_gc | TC_CCAINTLVL_OFF_gc;

// High resolution extension: Off
HIRESC.CTRLA&= ~HIRES_HREN0_bm;

// Advanced Waveform Extension initialization
// Optimize for speed
#pragma optsize- 
// Disable locking the AWEX configuration registers just to be sure
n=MCU.AWEXLOCK & (~MCU_AWEXCLOCK_bm);
CCP=CCP_IOREG_gc;
MCU.AWEXLOCK=n;
// Restore optimization for size if needed
#pragma optsize_default

// Pattern generation: Off
// Common waveform channel mode: Off
// Dead time insertion for compare channel A: Off
// Dead time insertion for compare channel B: Off
// Dead time insertion for compare channel C: Off
// Dead time insertion for compare channel D: Off
AWEXC.CTRL=(0<<AWEX_PGM_bp) | (0<<AWEX_CWCM_bp) | (0<<AWEX_DTICCDEN_bp) | (0<<AWEX_DTICCCEN_bp) | 
	(0<<AWEX_DTICCBEN_bp) | (0<<AWEX_DTICCAEN_bp);
// Low side dead time duration [ClkPer cycles]
AWEXC.DTLS=0;
// High side dead time duration [ClkPer cycles]
AWEXC.DTHS=0;
// PORTC output register override
AWEXC.OUTOVEN=0b00000000;

// Fault protection initialization
// Fault detection on OCD Break detection: On
// Fault detection restart mode: Latched Mode
// Fault detection action: None (Fault protection disabled)
AWEXC.FDCTRL=(AWEXC.FDCTRL & (~(AWEX_FDDBD_bm | AWEX_FDMODE_bm | AWEX_FDACT_gm))) |
	(0<<AWEX_FDDBD_bp) | (0<<AWEX_FDMODE_bp) | AWEX_FDACT_NONE_gc;
// Fault detect events: 
// Event channel 0: Off
// Event channel 1: Off
// Event channel 2: Off
// Event channel 3: Off
// Event channel 4: Off
// Event channel 5: Off
// Event channel 6: Off
// Event channel 7: Off
AWEXC.FDEMASK=0b00000000;
// Make sure the fault detect flag is cleared
AWEXC.STATUS|=AWEXC.STATUS & AWEX_FDF_bm;

// Clear the interrupt flags
TCC0.INTFLAGS=TCC0.INTFLAGS;
// Set Counter register
TCC0.CNT=0x0000;
// Set Period register
TCC0.PER=0x013F;
// Set channel A Compare/Capture register
TCC0.CCA=0x0000;
// Set channel B Compare/Capture register
TCC0.CCB=0x0000;
// Set channel C Compare/Capture register
TCC0.CCC=0x0000;
// Set channel D Compare/Capture register
TCC0.CCD=0x0000;

// Restore interrupts enabled/disabled state
SREG=s;
}



// Function used to read the calibration byte from the
// signature row, specified by 'index'
#pragma optsize-
unsigned char read_calibration_byte(unsigned char index)
{
unsigned char r;
NVM.CMD=NVM_CMD_READ_CALIB_ROW_gc;
r=*((flash unsigned char*) index);
// Clean up NVM command register
NVM.CMD=NVM_CMD_NO_OPERATION_gc;
return r;
}
#pragma optsize_default
// ADCA initialization
void adca_init(void)
{
// ADCA is enabled
// Resolution: 12 Bits
// Load the calibration value for 12 Bit resolution
// from the signature row
ADCA.CALL=read_calibration_byte(PROD_SIGNATURES_START+ADCACAL0_offset);
ADCA.CALH=read_calibration_byte(PROD_SIGNATURES_START+ADCACAL1_offset);

// Free Running mode: Off
// Gain stage impedance mode: High-impedance sources
// Current consumption: No limit
// Conversion mode: Unsigned
ADCA.CTRLB=(0<<ADC_IMPMODE_bp) | ADC_CURRLIMIT_NO_gc | (0<<ADC_CONMODE_bp) | ADC_RESOLUTION_12BIT_gc;

// Clock frequency: 2000.000 kHz
ADCA.PRESCALER=ADC_PRESCALER_DIV16_gc;

// Reference: AREF pin on PORTA
// Temperature reference: Off
ADCA.REFCTRL=ADC_REFSEL_AREFA_gc | (0<<ADC_TEMPREF_bp) | (0<<ADC_BANDGAP_bp);

// Initialize the ADC Compare register
ADCA.CMPL=0x00;
ADCA.CMPH=0x00;

// ADC channel 0 gain: 1
// ADC channel 0 input mode: Single-ended positive input signal
ADCA.CH0.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;

// ADC channel 0 positive input: ADC1 pin
// ADC channel 0 negative input: GND
ADCA.CH0.MUXCTRL=ADC_CH_MUXPOS_PIN1_gc;

// ADC channel 1 gain: 1
// ADC channel 1 input mode: Single-ended positive input signal
ADCA.CH1.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;

// ADC channel 1 positive input: ADC2 pin
// ADC channel 1 negative input: GND
ADCA.CH1.MUXCTRL=ADC_CH_MUXPOS_PIN2_gc;

// ADC channel 2 gain: 1
// ADC channel 2 input mode: Single-ended positive input signal
ADCA.CH2.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;

// ADC channel 2 positive input: ADC3 pin
// ADC channel 2 negative input: GND
ADCA.CH2.MUXCTRL=ADC_CH_MUXPOS_PIN3_gc;

// ADC channel 3 gain: 1
// ADC channel 3 input mode: Single-ended positive input signal
ADCA.CH3.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;

// ADC channel 3 positive input: ADC4 pin
// ADC channel 3 negative input: GND
ADCA.CH3.MUXCTRL=ADC_CH_MUXPOS_PIN4_gc;

// AD conversion is started by software
ADCA.EVCTRL=ADC_EVACT_NONE_gc;

// Channel 0 interrupt: Disabled
ADCA.CH0.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
// Channel 1 interrupt: Disabled
ADCA.CH1.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
// Channel 2 interrupt: Disabled
ADCA.CH2.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
// Channel 3 interrupt: Disabled
ADCA.CH3.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;

// Enable the ADC
ADCA.CTRLA|=ADC_ENABLE_bm;
// Insert a delay to allow the ADC common mode voltage to stabilize
delay_us(2);
}

// ADCA channel data read function using polled mode
unsigned int adca_read(unsigned char channel)
{
ADC_CH_t *pch=&ADCA.CH0+channel;
unsigned int data;

// Start the AD conversion
pch->CTRL|= 1<<ADC_CH_START_bp;
// Wait for the AD conversion to complete
while ((pch->INTFLAGS & ADC_CH_CHIF_bm)==0);
// Clear the interrupt flag
pch->INTFLAGS=ADC_CH_CHIF_bm;
// Read the AD conversion result
((unsigned char *) &data)[0]=pch->RESL;
((unsigned char *) &data)[1]=pch->RESH;
return data;
}

// ADCA sweeped channel(s) data read function
// for software triggered mode
void adca_sweep_read(unsigned char nch, unsigned int *pdata)
{
ADC_CH_t *pch=&ADCA.CH0;
unsigned char i,j,m;

// Sweep starts with channel 0
j=ADC_CH0START_bm;
// Prepare the AD conversion start mask for the sweeped channel(s)
m=0;
i=0;
do
  {
  m|=j;
  j<<=1;
  }
while (++i<nch);
// Ensure the interrupt flags are cleared
ADCA.INTFLAGS=ADCA.INTFLAGS;
// Start the AD conversion for the sweeped channel(s)
ADCA.CTRLA=(ADCA.CTRLA & (ADC_DMASEL_gm | ADC_FLUSH_bm | ADC_ENABLE_bm)) | m;
// Read and store the AD conversion results for all the sweeped channels
for (i=0; i<nch; i++)
    {
    // Wait for the AD conversion to complete
    while ((pch->INTFLAGS & ADC_CH_CHIF_bm)==0);
    // Clear the interrupt flag
    pch->INTFLAGS=ADC_CH_CHIF_bm;
    // Read the AD conversion result
    ((unsigned char *) pdata)[0]=pch->RESL;
    ((unsigned char *) pdata)[1]=pch->RESH;
    pdata++;
    pch++;
    }
}

// ADCB initialization
void adcb_init(void)
{
// ADCB is enabled
// Resolution: 12 Bits
// Load the calibration value for 12 Bit resolution
// from the signature row
ADCB.CALL=read_calibration_byte(PROD_SIGNATURES_START+ADCBCAL0_offset);
ADCB.CALH=read_calibration_byte(PROD_SIGNATURES_START+ADCBCAL1_offset);

// Free Running mode: Off
// Gain stage impedance mode: High-impedance sources
// Current consumption: No limit
// Conversion mode: Unsigned
ADCB.CTRLB=(0<<ADC_IMPMODE_bp) | ADC_CURRLIMIT_NO_gc | (0<<ADC_CONMODE_bp) | ADC_RESOLUTION_12BIT_gc;

// Clock frequency: 2000.000 kHz
ADCB.PRESCALER=ADC_PRESCALER_DIV16_gc;

// Reference: AREF pin on PORTA
// Temperature reference: On
ADCB.REFCTRL=ADC_REFSEL_AREFA_gc | (1<<ADC_TEMPREF_bp) | (0<<ADC_BANDGAP_bp);

// Initialize the ADC Compare register
ADCB.CMPL=0x00;
ADCB.CMPH=0x00;

// ADC channel 0 gain: 1
// ADC channel 0 input mode: Single-ended positive input signal
ADCB.CH0.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;

// ADC channel 0 positive input: ADC1 pin
// ADC channel 0 negative input: GND
ADCB.CH0.MUXCTRL=ADC_CH_MUXPOS_PIN1_gc;

// ADC channel 1 gain: 1
// ADC channel 1 input mode: Single-ended positive input signal
ADCB.CH1.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_SINGLEENDED_gc;

// ADC channel 1 positive input: ADC3 pin
// ADC channel 1 negative input: GND
ADCB.CH1.MUXCTRL=ADC_CH_MUXPOS_PIN3_gc;

// ADC channel 2 gain: 1
// ADC channel 2 input mode: Internal positive input signal
ADCB.CH2.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_INTERNAL_gc;

// ADC channel 2 positive input: Temp. Reference
// ADC channel 2 negative input: GND
ADCB.CH2.MUXCTRL=ADC_CH_MUXINT_TEMP_gc;

// ADC channel 3 gain: 1
// ADC channel 3 input mode: Internal positive input signal
ADCB.CH3.CTRL=(0<<ADC_CH_START_bp) | ADC_CH_GAIN_1X_gc | ADC_CH_INPUTMODE_INTERNAL_gc;

// ADC channel 3 positive input: Temp. Reference
// ADC channel 3 negative input: GND
ADCB.CH3.MUXCTRL=ADC_CH_MUXINT_TEMP_gc;

// AD conversion is started by software
ADCB.EVCTRL=ADC_EVACT_NONE_gc;

// Channel 0 interrupt: Disabled
ADCB.CH0.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
// Channel 1 interrupt: Disabled
ADCB.CH1.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
// Channel 2 interrupt: Disabled
ADCB.CH2.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;
// Channel 3 interrupt: Disabled
ADCB.CH3.INTCTRL=ADC_CH_INTMODE_COMPLETE_gc | ADC_CH_INTLVL_OFF_gc;

// Enable the ADC
ADCB.CTRLA|=ADC_ENABLE_bm;
// Insert a delay to allow the ADC common mode voltage to stabilize
delay_us(2);
}

// ADCB channel data read function using polled mode
unsigned int adcb_read(unsigned char channel)
{
ADC_CH_t *pch=&ADCB.CH0+channel;
unsigned int data;

// Start the AD conversion
pch->CTRL|= 1<<ADC_CH_START_bp;
// Wait for the AD conversion to complete
while ((pch->INTFLAGS & ADC_CH_CHIF_bm)==0);
// Clear the interrupt flag
pch->INTFLAGS=ADC_CH_CHIF_bm;
// Read the AD conversion result
((unsigned char *) &data)[0]=pch->RESL;
((unsigned char *) &data)[1]=pch->RESH;
return data;
}

// ADCB sweeped channel(s) data read function
// for software triggered mode
void adcb_sweep_read(unsigned char nch, unsigned int *pdata)
{
ADC_CH_t *pch=&ADCB.CH0;
unsigned char i,j,m;

// Sweep starts with channel 0
j=ADC_CH0START_bm;
// Prepare the AD conversion start mask for the sweeped channel(s)
m=0;
i=0;
do
  {
  m|=j;
  j<<=1;
  }
while (++i<nch);
// Ensure the interrupt flags are cleared
ADCB.INTFLAGS=ADCB.INTFLAGS;
// Start the AD conversion for the sweeped channel(s)
ADCB.CTRLA=(ADCB.CTRLA & (ADC_DMASEL_gm | ADC_FLUSH_bm | ADC_ENABLE_bm)) | m;
// Read and store the AD conversion results for all the sweeped channels
for (i=0; i<nch; i++)
    {
    // Wait for the AD conversion to complete
    while ((pch->INTFLAGS & ADC_CH_CHIF_bm)==0);
    // Clear the interrupt flag
    pch->INTFLAGS=ADC_CH_CHIF_bm;
    // Read the AD conversion result
    ((unsigned char *) pdata)[0]=pch->RESL;
    ((unsigned char *) pdata)[1]=pch->RESH;
    pdata++;
    pch++;
    }
}

void main(void)
{
// Declare your local variables here
unsigned char n;
int i;
unsigned int ADCA_data,ai;
unsigned char send_data[14];
unsigned char data_DIG;

// Interrupt system initialization
// Optimize for speed
#pragma optsize- 
// Make sure the interrupts are disabled
#asm("cli")
// Low level interrupt: Off
// Round-robin scheduling for low level interrupt: Off
// Medium level interrupt: On
// High level interrupt: On
// The interrupt vectors will be placed at the start of the Application FLASH section
n=(PMIC.CTRL & (~(PMIC_RREN_bm | PMIC_IVSEL_bm | PMIC_HILVLEN_bm | PMIC_MEDLVLEN_bm | PMIC_LOLVLEN_bm))) |
    PMIC_MEDLVLEN_bm | PMIC_HILVLEN_bm;
CCP=CCP_IOREG_gc;
PMIC.CTRL=n;
// Set the default priority for round-robin scheduling
PMIC.INTPRI=0x00;
// Restore optimization for size if needed
#pragma optsize_default

// System clocks initialization
system_clocks_init();

// Event system initialization
event_system_init();

// Ports initialization
ports_init();

// Virtual Ports initialization
vports_init();

// USARTF0 initialization
usartf0_init();

dacb_init();

tcc0_init();

adca_init();
adcb_init();

// Globally enable interrupts
#asm("sei")

while (1)
      {    
           if(flag)
           {
           flag=0; 
           DAC_data = (requ_buffer[1]*256)+requ_buffer[2];//dac init  
           
           for(i=0;i<=11;i++)
           putchar(requ_buffer[i]);  

           dacb_write(0,DAC_data); 
           
           TCC0.CCA = ((requ_buffer[3]*256)+requ_buffer[4])/12.84;//PWM A init  
           TCC0.CCB = ((requ_buffer[5]*256)+requ_buffer[6])/12.84;//PWM B init 
           TCC0.CCC = ((requ_buffer[7]*256)+requ_buffer[8])/12.84;//PWM C init 
           PORTE.OUT = ((requ_buffer[9]<<4)&0xF0)|((requ_buffer[10]>>4&0X0F)); 
           if(requ_buffer[10]&0X01)
           PORTD.OUTSET = 0X10;
           else
           PORTD.OUTCLR = 0X10;
           if(requ_buffer[10]&0X02)
           PORTD.OUTSET = 0X20;
           else
           PORTD.OUTCLR = 0X20;
           if(requ_buffer[10]&0X04)
           PORTD.OUTSET = 0X40;
           else
           PORTD.OUTCLR = 0X40;
           if(requ_buffer[10]&0X08)
           PORTD.OUTSET = 0X80;
           else
           PORTD.OUTCLR = 0X80; 


           for(i=0x01;i<=0x08;i=i*2) 
            {
           if(requ_buffer[10]&i)
           PORTD.OUTSET = i*16;
           else
           PORTD.OUTCLR = i*16;
            }        
               
           PORTD.OUT |= ((requ_buffer[10]<<4)&0xF0);
//            PORTD.OUT = (0xFF);
                       
           
           
           putchar(0xCC);
           ADCA_data = adca_read(0);
           send_data[0] = ADCA_data>>8 ;
           send_data[1] = ADCA_data ;  
             
           ADCA_data = adca_read(1);
           send_data[2] = ADCA_data>>8 ;
           send_data[3] = ADCA_data ; 
           
           ADCA_data = adca_read(2);
           send_data[4] = ADCA_data>>8 ;
           send_data[5] = ADCA_data ; 
           
           ADCA_data = adca_read(3);
           send_data[6] = ADCA_data>>8 ;
           send_data[7] = ADCA_data ;
           
           ADCA_data = adcb_read(0);
           send_data[8] = ADCA_data>>8 ;
           send_data[9] = ADCA_data ;
           
           ADCA_data = adcb_read(1);
           send_data[10] = ADCA_data>>8 ;
           send_data[11] = ADCA_data ; 
           //output ports 
           send_data[12] = ((PORTB.IN&0XF0)>>4); 
           send_data[13] = (PORTC.IN&0XF0);
           send_data[13] |= (PORTD.IN&0X0F);
           
           for(ai=0;ai<=13;ai++)
           {
            putchar(send_data[ai]);
           }
           
           putchar(0xDD);
              }
      }
}