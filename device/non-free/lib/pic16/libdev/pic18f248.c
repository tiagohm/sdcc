/*
 * This definitions of the PIC18F248 MCU.
 *
 * This file is part of the GNU PIC library for SDCC, originally
 * created by Molnar Karoly <molnarkaroly@users.sf.net> 2016.
 *
 * This file is generated automatically by the cinc2h.pl, 2016-01-09 15:09:29 UTC.
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

#include <pic18f248.h>

//==============================================================================

__at(0x0F00) __sfr RXF0SIDH;
__at(0x0F00) volatile __RXF0SIDHbits_t RXF0SIDHbits;

__at(0x0F01) __sfr RXF0SIDL;
__at(0x0F01) volatile __RXF0SIDLbits_t RXF0SIDLbits;

__at(0x0F02) __sfr RXF0EIDH;
__at(0x0F02) volatile __RXF0EIDHbits_t RXF0EIDHbits;

__at(0x0F03) __sfr RXF0EIDL;
__at(0x0F03) volatile __RXF0EIDLbits_t RXF0EIDLbits;

__at(0x0F04) __sfr RXF1SIDH;
__at(0x0F04) volatile __RXF1SIDHbits_t RXF1SIDHbits;

__at(0x0F05) __sfr RXF1SIDL;
__at(0x0F05) volatile __RXF1SIDLbits_t RXF1SIDLbits;

__at(0x0F06) __sfr RXF1EIDH;
__at(0x0F06) volatile __RXF1EIDHbits_t RXF1EIDHbits;

__at(0x0F07) __sfr RXF1EIDL;
__at(0x0F07) volatile __RXF1EIDLbits_t RXF1EIDLbits;

__at(0x0F08) __sfr RXF2SIDH;
__at(0x0F08) volatile __RXF2SIDHbits_t RXF2SIDHbits;

__at(0x0F09) __sfr RXF2SIDL;
__at(0x0F09) volatile __RXF2SIDLbits_t RXF2SIDLbits;

__at(0x0F0A) __sfr RXF2EIDH;
__at(0x0F0A) volatile __RXF2EIDHbits_t RXF2EIDHbits;

__at(0x0F0B) __sfr RXF2EIDL;
__at(0x0F0B) volatile __RXF2EIDLbits_t RXF2EIDLbits;

__at(0x0F0C) __sfr RXF3SIDH;
__at(0x0F0C) volatile __RXF3SIDHbits_t RXF3SIDHbits;

__at(0x0F0D) __sfr RXF3SIDL;
__at(0x0F0D) volatile __RXF3SIDLbits_t RXF3SIDLbits;

__at(0x0F0E) __sfr RXF3EIDH;
__at(0x0F0E) volatile __RXF3EIDHbits_t RXF3EIDHbits;

__at(0x0F0F) __sfr RXF3EIDL;
__at(0x0F0F) volatile __RXF3EIDLbits_t RXF3EIDLbits;

__at(0x0F10) __sfr RXF4SIDH;
__at(0x0F10) volatile __RXF4SIDHbits_t RXF4SIDHbits;

__at(0x0F11) __sfr RXF4SIDL;
__at(0x0F11) volatile __RXF4SIDLbits_t RXF4SIDLbits;

__at(0x0F12) __sfr RXF4EIDH;
__at(0x0F12) volatile __RXF4EIDHbits_t RXF4EIDHbits;

__at(0x0F13) __sfr RXF4EIDL;
__at(0x0F13) volatile __RXF4EIDLbits_t RXF4EIDLbits;

__at(0x0F14) __sfr RXF5SIDH;
__at(0x0F14) volatile __RXF5SIDHbits_t RXF5SIDHbits;

__at(0x0F15) __sfr RXF5SIDL;
__at(0x0F15) volatile __RXF5SIDLbits_t RXF5SIDLbits;

__at(0x0F16) __sfr RXF5EIDH;
__at(0x0F16) volatile __RXF5EIDHbits_t RXF5EIDHbits;

__at(0x0F17) __sfr RXF5EIDL;
__at(0x0F17) volatile __RXF5EIDLbits_t RXF5EIDLbits;

__at(0x0F18) __sfr RXM0SIDH;
__at(0x0F18) volatile __RXM0SIDHbits_t RXM0SIDHbits;

__at(0x0F19) __sfr RXM0SIDL;
__at(0x0F19) volatile __RXM0SIDLbits_t RXM0SIDLbits;

__at(0x0F1A) __sfr RXM0EIDH;
__at(0x0F1A) volatile __RXM0EIDHbits_t RXM0EIDHbits;

__at(0x0F1B) __sfr RXM0EIDL;
__at(0x0F1B) volatile __RXM0EIDLbits_t RXM0EIDLbits;

__at(0x0F1C) __sfr RXM1SIDH;
__at(0x0F1C) volatile __RXM1SIDHbits_t RXM1SIDHbits;

__at(0x0F1D) __sfr RXM1SIDL;
__at(0x0F1D) volatile __RXM1SIDLbits_t RXM1SIDLbits;

__at(0x0F1E) __sfr RXM1EIDH;
__at(0x0F1E) volatile __RXM1EIDHbits_t RXM1EIDHbits;

__at(0x0F1F) __sfr RXM1EIDL;
__at(0x0F1F) volatile __RXM1EIDLbits_t RXM1EIDLbits;

__at(0x0F20) __sfr TXB2CON;
__at(0x0F20) volatile __TXB2CONbits_t TXB2CONbits;

__at(0x0F21) __sfr TXB2SIDH;
__at(0x0F21) volatile __TXB2SIDHbits_t TXB2SIDHbits;

__at(0x0F22) __sfr TXB2SIDL;
__at(0x0F22) volatile __TXB2SIDLbits_t TXB2SIDLbits;

__at(0x0F23) __sfr TXB2EIDH;
__at(0x0F23) volatile __TXB2EIDHbits_t TXB2EIDHbits;

__at(0x0F24) __sfr TXB2EIDL;
__at(0x0F24) volatile __TXB2EIDLbits_t TXB2EIDLbits;

__at(0x0F25) __sfr TXB2DLC;
__at(0x0F25) volatile __TXB2DLCbits_t TXB2DLCbits;

__at(0x0F26) __sfr TXB2D0;
__at(0x0F26) volatile __TXB2D0bits_t TXB2D0bits;

__at(0x0F27) __sfr TXB2D1;
__at(0x0F27) volatile __TXB2D1bits_t TXB2D1bits;

__at(0x0F28) __sfr TXB2D2;
__at(0x0F28) volatile __TXB2D2bits_t TXB2D2bits;

__at(0x0F29) __sfr TXB2D3;
__at(0x0F29) volatile __TXB2D3bits_t TXB2D3bits;

__at(0x0F2A) __sfr TXB2D4;
__at(0x0F2A) volatile __TXB2D4bits_t TXB2D4bits;

__at(0x0F2B) __sfr TXB2D5;
__at(0x0F2B) volatile __TXB2D5bits_t TXB2D5bits;

__at(0x0F2C) __sfr TXB2D6;
__at(0x0F2C) volatile __TXB2D6bits_t TXB2D6bits;

__at(0x0F2D) __sfr TXB2D7;
__at(0x0F2D) volatile __TXB2D7bits_t TXB2D7bits;

__at(0x0F2E) __sfr CANSTATRO4;
__at(0x0F2E) volatile __CANSTATRO4bits_t CANSTATRO4bits;

__at(0x0F30) __sfr TXB1CON;
__at(0x0F30) volatile __TXB1CONbits_t TXB1CONbits;

__at(0x0F31) __sfr TXB1SIDH;
__at(0x0F31) volatile __TXB1SIDHbits_t TXB1SIDHbits;

__at(0x0F32) __sfr TXB1SIDL;
__at(0x0F32) volatile __TXB1SIDLbits_t TXB1SIDLbits;

__at(0x0F33) __sfr TXB1EIDH;
__at(0x0F33) volatile __TXB1EIDHbits_t TXB1EIDHbits;

__at(0x0F34) __sfr TXB1EIDL;
__at(0x0F34) volatile __TXB1EIDLbits_t TXB1EIDLbits;

__at(0x0F35) __sfr TXB1DLC;
__at(0x0F35) volatile __TXB1DLCbits_t TXB1DLCbits;

__at(0x0F36) __sfr TXB1D0;
__at(0x0F36) volatile __TXB1D0bits_t TXB1D0bits;

__at(0x0F37) __sfr TXB1D1;
__at(0x0F37) volatile __TXB1D1bits_t TXB1D1bits;

__at(0x0F38) __sfr TXB1D2;
__at(0x0F38) volatile __TXB1D2bits_t TXB1D2bits;

__at(0x0F39) __sfr TXB1D3;
__at(0x0F39) volatile __TXB1D3bits_t TXB1D3bits;

__at(0x0F3A) __sfr TXB1D4;
__at(0x0F3A) volatile __TXB1D4bits_t TXB1D4bits;

__at(0x0F3B) __sfr TXB1D5;
__at(0x0F3B) volatile __TXB1D5bits_t TXB1D5bits;

__at(0x0F3C) __sfr TXB1D6;
__at(0x0F3C) volatile __TXB1D6bits_t TXB1D6bits;

__at(0x0F3D) __sfr TXB1D7;
__at(0x0F3D) volatile __TXB1D7bits_t TXB1D7bits;

__at(0x0F3E) __sfr CANSTATRO3;
__at(0x0F3E) volatile __CANSTATRO3bits_t CANSTATRO3bits;

__at(0x0F40) __sfr TXB0CON;
__at(0x0F40) volatile __TXB0CONbits_t TXB0CONbits;

__at(0x0F41) __sfr TXB0SIDH;
__at(0x0F41) volatile __TXB0SIDHbits_t TXB0SIDHbits;

__at(0x0F42) __sfr TXB0SIDL;
__at(0x0F42) volatile __TXB0SIDLbits_t TXB0SIDLbits;

__at(0x0F43) __sfr TXB0EIDH;
__at(0x0F43) volatile __TXB0EIDHbits_t TXB0EIDHbits;

__at(0x0F44) __sfr TXB0EIDL;
__at(0x0F44) volatile __TXB0EIDLbits_t TXB0EIDLbits;

__at(0x0F45) __sfr TXB0DLC;
__at(0x0F45) volatile __TXB0DLCbits_t TXB0DLCbits;

__at(0x0F46) __sfr TXB0D0;
__at(0x0F46) volatile __TXB0D0bits_t TXB0D0bits;

__at(0x0F47) __sfr TXB0D1;
__at(0x0F47) volatile __TXB0D1bits_t TXB0D1bits;

__at(0x0F48) __sfr TXB0D2;
__at(0x0F48) volatile __TXB0D2bits_t TXB0D2bits;

__at(0x0F49) __sfr TXB0D3;
__at(0x0F49) volatile __TXB0D3bits_t TXB0D3bits;

__at(0x0F4A) __sfr TXB0D4;
__at(0x0F4A) volatile __TXB0D4bits_t TXB0D4bits;

__at(0x0F4B) __sfr TXB0D5;
__at(0x0F4B) volatile __TXB0D5bits_t TXB0D5bits;

__at(0x0F4C) __sfr TXB0D6;
__at(0x0F4C) volatile __TXB0D6bits_t TXB0D6bits;

__at(0x0F4D) __sfr TXB0D7;
__at(0x0F4D) volatile __TXB0D7bits_t TXB0D7bits;

__at(0x0F4E) __sfr CANSTATRO2;
__at(0x0F4E) volatile __CANSTATRO2bits_t CANSTATRO2bits;

__at(0x0F50) __sfr RXB1CON;
__at(0x0F50) volatile __RXB1CONbits_t RXB1CONbits;

__at(0x0F51) __sfr RXB1SIDH;
__at(0x0F51) volatile __RXB1SIDHbits_t RXB1SIDHbits;

__at(0x0F52) __sfr RXB1SIDL;
__at(0x0F52) volatile __RXB1SIDLbits_t RXB1SIDLbits;

__at(0x0F53) __sfr RXB1EIDH;
__at(0x0F53) volatile __RXB1EIDHbits_t RXB1EIDHbits;

__at(0x0F54) __sfr RXB1EIDL;
__at(0x0F54) volatile __RXB1EIDLbits_t RXB1EIDLbits;

__at(0x0F55) __sfr RXB1DLC;
__at(0x0F55) volatile __RXB1DLCbits_t RXB1DLCbits;

__at(0x0F56) __sfr RXB1D0;
__at(0x0F56) volatile __RXB1D0bits_t RXB1D0bits;

__at(0x0F57) __sfr RXB1D1;
__at(0x0F57) volatile __RXB1D1bits_t RXB1D1bits;

__at(0x0F58) __sfr RXB1D2;
__at(0x0F58) volatile __RXB1D2bits_t RXB1D2bits;

__at(0x0F59) __sfr RXB1D3;
__at(0x0F59) volatile __RXB1D3bits_t RXB1D3bits;

__at(0x0F5A) __sfr RXB1D4;
__at(0x0F5A) volatile __RXB1D4bits_t RXB1D4bits;

__at(0x0F5B) __sfr RXB1D5;
__at(0x0F5B) volatile __RXB1D5bits_t RXB1D5bits;

__at(0x0F5C) __sfr RXB1D6;
__at(0x0F5C) volatile __RXB1D6bits_t RXB1D6bits;

__at(0x0F5D) __sfr RXB1D7;
__at(0x0F5D) volatile __RXB1D7bits_t RXB1D7bits;

__at(0x0F5E) __sfr CANSTATRO1;
__at(0x0F5E) volatile __CANSTATRO1bits_t CANSTATRO1bits;

__at(0x0F60) __sfr RXB0CON;
__at(0x0F60) volatile __RXB0CONbits_t RXB0CONbits;

__at(0x0F61) __sfr RXB0SIDH;
__at(0x0F61) volatile __RXB0SIDHbits_t RXB0SIDHbits;

__at(0x0F62) __sfr RXB0SIDL;
__at(0x0F62) volatile __RXB0SIDLbits_t RXB0SIDLbits;

__at(0x0F63) __sfr RXB0EIDH;
__at(0x0F63) volatile __RXB0EIDHbits_t RXB0EIDHbits;

__at(0x0F64) __sfr RXB0EIDL;
__at(0x0F64) volatile __RXB0EIDLbits_t RXB0EIDLbits;

__at(0x0F65) __sfr RXB0DLC;
__at(0x0F65) volatile __RXB0DLCbits_t RXB0DLCbits;

__at(0x0F66) __sfr RXB0D0;
__at(0x0F66) volatile __RXB0D0bits_t RXB0D0bits;

__at(0x0F67) __sfr RXB0D1;
__at(0x0F67) volatile __RXB0D1bits_t RXB0D1bits;

__at(0x0F68) __sfr RXB0D2;
__at(0x0F68) volatile __RXB0D2bits_t RXB0D2bits;

__at(0x0F69) __sfr RXB0D3;
__at(0x0F69) volatile __RXB0D3bits_t RXB0D3bits;

__at(0x0F6A) __sfr RXB0D4;
__at(0x0F6A) volatile __RXB0D4bits_t RXB0D4bits;

__at(0x0F6B) __sfr RXB0D5;
__at(0x0F6B) volatile __RXB0D5bits_t RXB0D5bits;

__at(0x0F6C) __sfr RXB0D6;
__at(0x0F6C) volatile __RXB0D6bits_t RXB0D6bits;

__at(0x0F6D) __sfr RXB0D7;
__at(0x0F6D) volatile __RXB0D7bits_t RXB0D7bits;

__at(0x0F6E) __sfr CANSTAT;
__at(0x0F6E) volatile __CANSTATbits_t CANSTATbits;

__at(0x0F6F) __sfr CANCON;
__at(0x0F6F) volatile __CANCONbits_t CANCONbits;

__at(0x0F70) __sfr BRGCON1;
__at(0x0F70) volatile __BRGCON1bits_t BRGCON1bits;

__at(0x0F71) __sfr BRGCON2;
__at(0x0F71) volatile __BRGCON2bits_t BRGCON2bits;

__at(0x0F72) __sfr BRGCON3;
__at(0x0F72) volatile __BRGCON3bits_t BRGCON3bits;

__at(0x0F73) __sfr CIOCON;
__at(0x0F73) volatile __CIOCONbits_t CIOCONbits;

__at(0x0F74) __sfr COMSTAT;
__at(0x0F74) volatile __COMSTATbits_t COMSTATbits;

__at(0x0F75) __sfr RXERRCNT;
__at(0x0F75) volatile __RXERRCNTbits_t RXERRCNTbits;

__at(0x0F76) __sfr TXERRCNT;
__at(0x0F76) volatile __TXERRCNTbits_t TXERRCNTbits;

__at(0x0F80) __sfr PORTA;
__at(0x0F80) volatile __PORTAbits_t PORTAbits;

__at(0x0F81) __sfr PORTB;
__at(0x0F81) volatile __PORTBbits_t PORTBbits;

__at(0x0F82) __sfr PORTC;
__at(0x0F82) volatile __PORTCbits_t PORTCbits;

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

__at(0x0FAB) __sfr RCSTA;
__at(0x0FAB) volatile __RCSTAbits_t RCSTAbits;

__at(0x0FAC) __sfr TXSTA;
__at(0x0FAC) volatile __TXSTAbits_t TXSTAbits;

__at(0x0FAD) __sfr TXREG;

__at(0x0FAE) __sfr RCREG;

__at(0x0FAF) __sfr SPBRG;

__at(0x0FB1) __sfr T3CON;
__at(0x0FB1) volatile __T3CONbits_t T3CONbits;

__at(0x0FB2) __sfr TMR3;

__at(0x0FB2) __sfr TMR3L;

__at(0x0FB3) __sfr TMR3H;

__at(0x0FBD) __sfr CCP1CON;
__at(0x0FBD) volatile __CCP1CONbits_t CCP1CONbits;

__at(0x0FBE) __sfr CCPR1;

__at(0x0FBE) __sfr CCPR1L;

__at(0x0FBF) __sfr CCPR1H;

__at(0x0FC1) __sfr ADCON1;
__at(0x0FC1) volatile __ADCON1bits_t ADCON1bits;

__at(0x0FC2) __sfr ADCON0;
__at(0x0FC2) volatile __ADCON0bits_t ADCON0bits;

__at(0x0FC3) __sfr ADRES;

__at(0x0FC3) __sfr ADRESL;

__at(0x0FC4) __sfr ADRESH;

__at(0x0FC5) __sfr SSPCON2;
__at(0x0FC5) volatile __SSPCON2bits_t SSPCON2bits;

__at(0x0FC6) __sfr SSPCON1;
__at(0x0FC6) volatile __SSPCON1bits_t SSPCON1bits;

__at(0x0FC7) __sfr SSPSTAT;
__at(0x0FC7) volatile __SSPSTATbits_t SSPSTATbits;

__at(0x0FC8) __sfr SSPADD;

__at(0x0FC9) __sfr SSPBUF;

__at(0x0FCA) __sfr T2CON;
__at(0x0FCA) volatile __T2CONbits_t T2CONbits;

__at(0x0FCB) __sfr PR2;

__at(0x0FCC) __sfr TMR2;

__at(0x0FCD) __sfr T1CON;
__at(0x0FCD) volatile __T1CONbits_t T1CONbits;

__at(0x0FCE) __sfr TMR1;

__at(0x0FCE) __sfr TMR1L;

__at(0x0FCF) __sfr TMR1H;

__at(0x0FD0) __sfr RCON;
__at(0x0FD0) volatile __RCONbits_t RCONbits;

__at(0x0FD1) __sfr WDTCON;
__at(0x0FD1) volatile __WDTCONbits_t WDTCONbits;

__at(0x0FD2) __sfr LVDCON;
__at(0x0FD2) volatile __LVDCONbits_t LVDCONbits;

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

__at(0x0FF2) __sfr INTCON1;
__at(0x0FF2) volatile __INTCON1bits_t INTCON1bits;

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
