/*
 * This definitions of the PIC18F24K22 MCU.
 *
 * This file is part of the GNU PIC library for SDCC, originally
 * created by Molnar Karoly <molnarkaroly@users.sf.net> 2014.
 *
 * This file is generated automatically by the cinc2h.pl, 2014-03-09 13:32:34 UTC.
 *
 * SDCC is licensed under the GNU Public license (GPL) v2. Note that
 * this license covers the code to the compiler and other executables,
 * but explicitly does not cover any code or objects generated by sdcc.
 *
 * For pic device libraries and header files which are derived from
 * Microchip header (.inc) and linker script (.lkr) files Microchip
 * requires that "The header files should state that they are only to be
 * used with authentic Microchip devices" which makes them incompatible
 * with the GPL. Pic device libraries and header files are located at
 * non-free/lib and non-free/include directories respectively.
 * Sdcc should be run with the --use-non-free command line option in
 * order to include non-free header files and libraries.
 *
 * See http://sdcc.sourceforge.net/ for the latest information on sdcc.
 */

#include <pic18f24k22.h>

//==============================================================================

__at(0x0F38) __sfr ANSELA;
__at(0x0F38) volatile __ANSELAbits_t ANSELAbits;

__at(0x0F39) __sfr ANSELB;
__at(0x0F39) volatile __ANSELBbits_t ANSELBbits;

__at(0x0F3A) __sfr ANSELC;
__at(0x0F3A) volatile __ANSELCbits_t ANSELCbits;

__at(0x0F3D) __sfr PMD2;
__at(0x0F3D) volatile __PMD2bits_t PMD2bits;

__at(0x0F3E) __sfr PMD1;
__at(0x0F3E) volatile __PMD1bits_t PMD1bits;

__at(0x0F3F) __sfr PMD0;
__at(0x0F3F) volatile __PMD0bits_t PMD0bits;

__at(0x0F40) __sfr DACCON1;
__at(0x0F40) volatile __DACCON1bits_t DACCON1bits;

__at(0x0F40) __sfr VREFCON2;
__at(0x0F40) volatile __VREFCON2bits_t VREFCON2bits;

__at(0x0F41) __sfr DACCON0;
__at(0x0F41) volatile __DACCON0bits_t DACCON0bits;

__at(0x0F41) __sfr VREFCON1;
__at(0x0F41) volatile __VREFCON1bits_t VREFCON1bits;

__at(0x0F42) __sfr FVRCON;
__at(0x0F42) volatile __FVRCONbits_t FVRCONbits;

__at(0x0F42) __sfr VREFCON0;
__at(0x0F42) volatile __VREFCON0bits_t VREFCON0bits;

__at(0x0F43) __sfr CTMUICON;
__at(0x0F43) volatile __CTMUICONbits_t CTMUICONbits;

__at(0x0F43) __sfr CTMUICONH;
__at(0x0F43) volatile __CTMUICONHbits_t CTMUICONHbits;

__at(0x0F44) __sfr CTMUCON1;
__at(0x0F44) volatile __CTMUCON1bits_t CTMUCON1bits;

__at(0x0F44) __sfr CTMUCONL;
__at(0x0F44) volatile __CTMUCONLbits_t CTMUCONLbits;

__at(0x0F45) __sfr CTMUCON0;
__at(0x0F45) volatile __CTMUCON0bits_t CTMUCON0bits;

__at(0x0F45) __sfr CTMUCONH;
__at(0x0F45) volatile __CTMUCONHbits_t CTMUCONHbits;

__at(0x0F46) __sfr SRCON1;
__at(0x0F46) volatile __SRCON1bits_t SRCON1bits;

__at(0x0F47) __sfr SRCON0;
__at(0x0F47) volatile __SRCON0bits_t SRCON0bits;

__at(0x0F48) __sfr CCPTMRS1;
__at(0x0F48) volatile __CCPTMRS1bits_t CCPTMRS1bits;

__at(0x0F49) __sfr CCPTMRS0;
__at(0x0F49) volatile __CCPTMRS0bits_t CCPTMRS0bits;

__at(0x0F4A) __sfr T6CON;
__at(0x0F4A) volatile __T6CONbits_t T6CONbits;

__at(0x0F4B) __sfr PR6;

__at(0x0F4C) __sfr TMR6;

__at(0x0F4D) __sfr T5GCON;
__at(0x0F4D) volatile __T5GCONbits_t T5GCONbits;

__at(0x0F4E) __sfr T5CON;
__at(0x0F4E) volatile __T5CONbits_t T5CONbits;

__at(0x0F4F) __sfr TMR5;

__at(0x0F4F) __sfr TMR5L;

__at(0x0F50) __sfr TMR5H;

__at(0x0F51) __sfr T4CON;
__at(0x0F51) volatile __T4CONbits_t T4CONbits;

__at(0x0F52) __sfr PR4;

__at(0x0F53) __sfr TMR4;

__at(0x0F54) __sfr CCP5CON;
__at(0x0F54) volatile __CCP5CONbits_t CCP5CONbits;

__at(0x0F55) __sfr CCPR5;

__at(0x0F55) __sfr CCPR5L;

__at(0x0F56) __sfr CCPR5H;

__at(0x0F57) __sfr CCP4CON;
__at(0x0F57) volatile __CCP4CONbits_t CCP4CONbits;

__at(0x0F58) __sfr CCPR4;

__at(0x0F58) __sfr CCPR4L;

__at(0x0F59) __sfr CCPR4H;

__at(0x0F5A) __sfr PSTR3CON;
__at(0x0F5A) volatile __PSTR3CONbits_t PSTR3CONbits;

__at(0x0F5B) __sfr CCP3AS;
__at(0x0F5B) volatile __CCP3ASbits_t CCP3ASbits;

__at(0x0F5B) __sfr ECCP3AS;
__at(0x0F5B) volatile __ECCP3ASbits_t ECCP3ASbits;

__at(0x0F5C) __sfr PWM3CON;
__at(0x0F5C) volatile __PWM3CONbits_t PWM3CONbits;

__at(0x0F5D) __sfr CCP3CON;
__at(0x0F5D) volatile __CCP3CONbits_t CCP3CONbits;

__at(0x0F5E) __sfr CCPR3;

__at(0x0F5E) __sfr CCPR3L;

__at(0x0F5F) __sfr CCPR3H;

__at(0x0F60) __sfr SLRCON;
__at(0x0F60) volatile __SLRCONbits_t SLRCONbits;

__at(0x0F61) __sfr WPUB;
__at(0x0F61) volatile __WPUBbits_t WPUBbits;

__at(0x0F62) __sfr IOCB;
__at(0x0F62) volatile __IOCBbits_t IOCBbits;

__at(0x0F63) __sfr PSTR2CON;
__at(0x0F63) volatile __PSTR2CONbits_t PSTR2CONbits;

__at(0x0F64) __sfr CCP2AS;
__at(0x0F64) volatile __CCP2ASbits_t CCP2ASbits;

__at(0x0F64) __sfr ECCP2AS;
__at(0x0F64) volatile __ECCP2ASbits_t ECCP2ASbits;

__at(0x0F65) __sfr PWM2CON;
__at(0x0F65) volatile __PWM2CONbits_t PWM2CONbits;

__at(0x0F66) __sfr CCP2CON;
__at(0x0F66) volatile __CCP2CONbits_t CCP2CONbits;

__at(0x0F67) __sfr CCPR2;

__at(0x0F67) __sfr CCPR2L;

__at(0x0F68) __sfr CCPR2H;

__at(0x0F69) __sfr SSP2CON3;
__at(0x0F69) volatile __SSP2CON3bits_t SSP2CON3bits;

__at(0x0F6A) __sfr SSP2MSK;
__at(0x0F6A) volatile __SSP2MSKbits_t SSP2MSKbits;

__at(0x0F6B) __sfr SSP2CON2;
__at(0x0F6B) volatile __SSP2CON2bits_t SSP2CON2bits;

__at(0x0F6C) __sfr SSP2CON1;
__at(0x0F6C) volatile __SSP2CON1bits_t SSP2CON1bits;

__at(0x0F6D) __sfr SSP2STAT;
__at(0x0F6D) volatile __SSP2STATbits_t SSP2STATbits;

__at(0x0F6E) __sfr SSP2ADD;

__at(0x0F6F) __sfr SSP2BUF;

__at(0x0F70) __sfr BAUD2CON;
__at(0x0F70) volatile __BAUD2CONbits_t BAUD2CONbits;

__at(0x0F70) __sfr BAUDCON2;
__at(0x0F70) volatile __BAUDCON2bits_t BAUDCON2bits;

__at(0x0F71) __sfr RC2STA;
__at(0x0F71) volatile __RC2STAbits_t RC2STAbits;

__at(0x0F71) __sfr RCSTA2;
__at(0x0F71) volatile __RCSTA2bits_t RCSTA2bits;

__at(0x0F72) __sfr TX2STA;
__at(0x0F72) volatile __TX2STAbits_t TX2STAbits;

__at(0x0F72) __sfr TXSTA2;
__at(0x0F72) volatile __TXSTA2bits_t TXSTA2bits;

__at(0x0F73) __sfr TX2REG;

__at(0x0F73) __sfr TXREG2;

__at(0x0F74) __sfr RC2REG;

__at(0x0F74) __sfr RCREG2;

__at(0x0F75) __sfr SP2BRG;

__at(0x0F75) __sfr SPBRG2;

__at(0x0F76) __sfr SP2BRGH;

__at(0x0F76) __sfr SPBRGH2;

__at(0x0F77) __sfr CM12CON;
__at(0x0F77) volatile __CM12CONbits_t CM12CONbits;

__at(0x0F77) __sfr CM2CON1;
__at(0x0F77) volatile __CM2CON1bits_t CM2CON1bits;

__at(0x0F78) __sfr CM2CON;
__at(0x0F78) volatile __CM2CONbits_t CM2CONbits;

__at(0x0F78) __sfr CM2CON0;
__at(0x0F78) volatile __CM2CON0bits_t CM2CON0bits;

__at(0x0F79) __sfr CM1CON;
__at(0x0F79) volatile __CM1CONbits_t CM1CONbits;

__at(0x0F79) __sfr CM1CON0;
__at(0x0F79) volatile __CM1CON0bits_t CM1CON0bits;

__at(0x0F7A) __sfr PIE4;
__at(0x0F7A) volatile __PIE4bits_t PIE4bits;

__at(0x0F7B) __sfr PIR4;
__at(0x0F7B) volatile __PIR4bits_t PIR4bits;

__at(0x0F7C) __sfr IPR4;
__at(0x0F7C) volatile __IPR4bits_t IPR4bits;

__at(0x0F7D) __sfr PIE5;
__at(0x0F7D) volatile __PIE5bits_t PIE5bits;

__at(0x0F7E) __sfr PIR5;
__at(0x0F7E) volatile __PIR5bits_t PIR5bits;

__at(0x0F7F) __sfr IPR5;
__at(0x0F7F) volatile __IPR5bits_t IPR5bits;

__at(0x0F80) __sfr PORTA;
__at(0x0F80) volatile __PORTAbits_t PORTAbits;

__at(0x0F81) __sfr PORTB;
__at(0x0F81) volatile __PORTBbits_t PORTBbits;

__at(0x0F82) __sfr PORTC;
__at(0x0F82) volatile __PORTCbits_t PORTCbits;

__at(0x0F84) __sfr PORTE;
__at(0x0F84) volatile __PORTEbits_t PORTEbits;

__at(0x0F89) __sfr LATA;
__at(0x0F89) volatile __LATAbits_t LATAbits;

__at(0x0F8A) __sfr LATB;
__at(0x0F8A) volatile __LATBbits_t LATBbits;

__at(0x0F8B) __sfr LATC;
__at(0x0F8B) volatile __LATCbits_t LATCbits;

__at(0x0F92) __sfr DDRA;
__at(0x0F92) volatile __DDRAbits_t DDRAbits;

__at(0x0F92) __sfr TRISA;
__at(0x0F92) volatile __TRISAbits_t TRISAbits;

__at(0x0F93) __sfr DDRB;
__at(0x0F93) volatile __DDRBbits_t DDRBbits;

__at(0x0F93) __sfr TRISB;
__at(0x0F93) volatile __TRISBbits_t TRISBbits;

__at(0x0F94) __sfr DDRC;
__at(0x0F94) volatile __DDRCbits_t DDRCbits;

__at(0x0F94) __sfr TRISC;
__at(0x0F94) volatile __TRISCbits_t TRISCbits;

__at(0x0F96) __sfr TRISE;
__at(0x0F96) volatile __TRISEbits_t TRISEbits;

__at(0x0F9B) __sfr OSCTUNE;
__at(0x0F9B) volatile __OSCTUNEbits_t OSCTUNEbits;

__at(0x0F9C) __sfr HLVDCON;
__at(0x0F9C) volatile __HLVDCONbits_t HLVDCONbits;

__at(0x0F9C) __sfr LVDCON;
__at(0x0F9C) volatile __LVDCONbits_t LVDCONbits;

__at(0x0F9D) __sfr PIE1;
__at(0x0F9D) volatile __PIE1bits_t PIE1bits;

__at(0x0F9E) __sfr PIR1;
__at(0x0F9E) volatile __PIR1bits_t PIR1bits;

__at(0x0F9F) __sfr IPR1;
__at(0x0F9F) volatile __IPR1bits_t IPR1bits;

__at(0x0FA0) __sfr PIE2;
__at(0x0FA0) volatile __PIE2bits_t PIE2bits;

__at(0x0FA1) __sfr PIR2;
__at(0x0FA1) volatile __PIR2bits_t PIR2bits;

__at(0x0FA2) __sfr IPR2;
__at(0x0FA2) volatile __IPR2bits_t IPR2bits;

__at(0x0FA3) __sfr PIE3;
__at(0x0FA3) volatile __PIE3bits_t PIE3bits;

__at(0x0FA4) __sfr PIR3;
__at(0x0FA4) volatile __PIR3bits_t PIR3bits;

__at(0x0FA5) __sfr IPR3;
__at(0x0FA5) volatile __IPR3bits_t IPR3bits;

__at(0x0FA6) __sfr EECON1;
__at(0x0FA6) volatile __EECON1bits_t EECON1bits;

__at(0x0FA7) __sfr EECON2;

__at(0x0FA8) __sfr EEDATA;

__at(0x0FA9) __sfr EEADR;
__at(0x0FA9) volatile __EEADRbits_t EEADRbits;

__at(0x0FAB) __sfr RC1STA;
__at(0x0FAB) volatile __RC1STAbits_t RC1STAbits;

__at(0x0FAB) __sfr RCSTA;
__at(0x0FAB) volatile __RCSTAbits_t RCSTAbits;

__at(0x0FAB) __sfr RCSTA1;
__at(0x0FAB) volatile __RCSTA1bits_t RCSTA1bits;

__at(0x0FAC) __sfr TX1STA;
__at(0x0FAC) volatile __TX1STAbits_t TX1STAbits;

__at(0x0FAC) __sfr TXSTA;
__at(0x0FAC) volatile __TXSTAbits_t TXSTAbits;

__at(0x0FAC) __sfr TXSTA1;
__at(0x0FAC) volatile __TXSTA1bits_t TXSTA1bits;

__at(0x0FAD) __sfr TX1REG;

__at(0x0FAD) __sfr TXREG;

__at(0x0FAD) __sfr TXREG1;

__at(0x0FAE) __sfr RC1REG;

__at(0x0FAE) __sfr RCREG;

__at(0x0FAE) __sfr RCREG1;

__at(0x0FAF) __sfr SP1BRG;

__at(0x0FAF) __sfr SPBRG;

__at(0x0FAF) __sfr SPBRG1;

__at(0x0FB0) __sfr SP1BRGH;

__at(0x0FB0) __sfr SPBRGH;

__at(0x0FB0) __sfr SPBRGH1;

__at(0x0FB1) __sfr T3CON;
__at(0x0FB1) volatile __T3CONbits_t T3CONbits;

__at(0x0FB2) __sfr TMR3;

__at(0x0FB2) __sfr TMR3L;

__at(0x0FB3) __sfr TMR3H;

__at(0x0FB4) __sfr T3GCON;
__at(0x0FB4) volatile __T3GCONbits_t T3GCONbits;

__at(0x0FB6) __sfr ECCP1AS;
__at(0x0FB6) volatile __ECCP1ASbits_t ECCP1ASbits;

__at(0x0FB6) __sfr ECCPAS;
__at(0x0FB6) volatile __ECCPASbits_t ECCPASbits;

__at(0x0FB7) __sfr PWM1CON;
__at(0x0FB7) volatile __PWM1CONbits_t PWM1CONbits;

__at(0x0FB7) __sfr PWMCON;
__at(0x0FB7) volatile __PWMCONbits_t PWMCONbits;

__at(0x0FB8) __sfr BAUD1CON;
__at(0x0FB8) volatile __BAUD1CONbits_t BAUD1CONbits;

__at(0x0FB8) __sfr BAUDCON;
__at(0x0FB8) volatile __BAUDCONbits_t BAUDCONbits;

__at(0x0FB8) __sfr BAUDCON1;
__at(0x0FB8) volatile __BAUDCON1bits_t BAUDCON1bits;

__at(0x0FB8) __sfr BAUDCTL;
__at(0x0FB8) volatile __BAUDCTLbits_t BAUDCTLbits;

__at(0x0FB9) __sfr PSTR1CON;
__at(0x0FB9) volatile __PSTR1CONbits_t PSTR1CONbits;

__at(0x0FB9) __sfr PSTRCON;
__at(0x0FB9) volatile __PSTRCONbits_t PSTRCONbits;

__at(0x0FBA) __sfr T2CON;
__at(0x0FBA) volatile __T2CONbits_t T2CONbits;

__at(0x0FBB) __sfr PR2;

__at(0x0FBC) __sfr TMR2;

__at(0x0FBD) __sfr CCP1CON;
__at(0x0FBD) volatile __CCP1CONbits_t CCP1CONbits;

__at(0x0FBE) __sfr CCPR1;

__at(0x0FBE) __sfr CCPR1L;

__at(0x0FBF) __sfr CCPR1H;

__at(0x0FC0) __sfr ADCON2;
__at(0x0FC0) volatile __ADCON2bits_t ADCON2bits;

__at(0x0FC1) __sfr ADCON1;
__at(0x0FC1) volatile __ADCON1bits_t ADCON1bits;

__at(0x0FC2) __sfr ADCON0;
__at(0x0FC2) volatile __ADCON0bits_t ADCON0bits;

__at(0x0FC3) __sfr ADRES;

__at(0x0FC3) __sfr ADRESL;

__at(0x0FC4) __sfr ADRESH;

__at(0x0FC5) __sfr SSP1CON2;
__at(0x0FC5) volatile __SSP1CON2bits_t SSP1CON2bits;

__at(0x0FC5) __sfr SSPCON2;
__at(0x0FC5) volatile __SSPCON2bits_t SSPCON2bits;

__at(0x0FC6) __sfr SSP1CON1;
__at(0x0FC6) volatile __SSP1CON1bits_t SSP1CON1bits;

__at(0x0FC6) __sfr SSPCON1;
__at(0x0FC6) volatile __SSPCON1bits_t SSPCON1bits;

__at(0x0FC7) __sfr SSP1STAT;
__at(0x0FC7) volatile __SSP1STATbits_t SSP1STATbits;

__at(0x0FC7) __sfr SSPSTAT;
__at(0x0FC7) volatile __SSPSTATbits_t SSPSTATbits;

__at(0x0FC8) __sfr SSP1ADD;

__at(0x0FC8) __sfr SSPADD;

__at(0x0FC9) __sfr SSP1BUF;

__at(0x0FC9) __sfr SSPBUF;

__at(0x0FCA) __sfr SSP1MSK;
__at(0x0FCA) volatile __SSP1MSKbits_t SSP1MSKbits;

__at(0x0FCA) __sfr SSPMSK;
__at(0x0FCA) volatile __SSPMSKbits_t SSPMSKbits;

__at(0x0FCB) __sfr SSP1CON3;
__at(0x0FCB) volatile __SSP1CON3bits_t SSP1CON3bits;

__at(0x0FCB) __sfr SSPCON3;
__at(0x0FCB) volatile __SSPCON3bits_t SSPCON3bits;

__at(0x0FCC) __sfr T1GCON;
__at(0x0FCC) volatile __T1GCONbits_t T1GCONbits;

__at(0x0FCD) __sfr T1CON;
__at(0x0FCD) volatile __T1CONbits_t T1CONbits;

__at(0x0FCE) __sfr TMR1;

__at(0x0FCE) __sfr TMR1L;

__at(0x0FCF) __sfr TMR1H;

__at(0x0FD0) __sfr RCON;
__at(0x0FD0) volatile __RCONbits_t RCONbits;

__at(0x0FD1) __sfr WDTCON;
__at(0x0FD1) volatile __WDTCONbits_t WDTCONbits;

__at(0x0FD2) __sfr OSCCON2;
__at(0x0FD2) volatile __OSCCON2bits_t OSCCON2bits;

__at(0x0FD3) __sfr OSCCON;
__at(0x0FD3) volatile __OSCCONbits_t OSCCONbits;

__at(0x0FD5) __sfr T0CON;
__at(0x0FD5) volatile __T0CONbits_t T0CONbits;

__at(0x0FD6) __sfr TMR0;

__at(0x0FD6) __sfr TMR0L;

__at(0x0FD7) __sfr TMR0H;

__at(0x0FD8) __sfr STATUS;
__at(0x0FD8) volatile __STATUSbits_t STATUSbits;

__at(0x0FD9) __sfr FSR2L;

__at(0x0FDA) __sfr FSR2H;

__at(0x0FDB) __sfr PLUSW2;

__at(0x0FDC) __sfr PREINC2;

__at(0x0FDD) __sfr POSTDEC2;

__at(0x0FDE) __sfr POSTINC2;

__at(0x0FDF) __sfr INDF2;

__at(0x0FE0) __sfr BSR;

__at(0x0FE1) __sfr FSR1L;

__at(0x0FE2) __sfr FSR1H;

__at(0x0FE3) __sfr PLUSW1;

__at(0x0FE4) __sfr PREINC1;

__at(0x0FE5) __sfr POSTDEC1;

__at(0x0FE6) __sfr POSTINC1;

__at(0x0FE7) __sfr INDF1;

__at(0x0FE8) __sfr WREG;

__at(0x0FE9) __sfr FSR0L;

__at(0x0FEA) __sfr FSR0H;

__at(0x0FEB) __sfr PLUSW0;

__at(0x0FEC) __sfr PREINC0;

__at(0x0FED) __sfr POSTDEC0;

__at(0x0FEE) __sfr POSTINC0;

__at(0x0FEF) __sfr INDF0;

__at(0x0FF0) __sfr INTCON3;
__at(0x0FF0) volatile __INTCON3bits_t INTCON3bits;

__at(0x0FF1) __sfr INTCON2;
__at(0x0FF1) volatile __INTCON2bits_t INTCON2bits;

__at(0x0FF2) __sfr INTCON;
__at(0x0FF2) volatile __INTCONbits_t INTCONbits;

__at(0x0FF3) __sfr PROD;

__at(0x0FF3) __sfr PRODL;

__at(0x0FF4) __sfr PRODH;

__at(0x0FF5) __sfr TABLAT;

__at(0x0FF6) __sfr TBLPTR;

__at(0x0FF6) __sfr TBLPTRL;

__at(0x0FF7) __sfr TBLPTRH;

__at(0x0FF8) __sfr TBLPTRU;

__at(0x0FF9) __sfr PC;

__at(0x0FF9) __sfr PCL;

__at(0x0FFA) __sfr PCLATH;

__at(0x0FFB) __sfr PCLATU;

__at(0x0FFC) __sfr STKPTR;
__at(0x0FFC) volatile __STKPTRbits_t STKPTRbits;

__at(0x0FFD) __sfr TOS;

__at(0x0FFD) __sfr TOSL;

__at(0x0FFE) __sfr TOSH;

__at(0x0FFF) __sfr TOSU;
