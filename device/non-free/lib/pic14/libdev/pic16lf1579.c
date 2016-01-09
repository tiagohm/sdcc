/*
 * This definitions of the PIC16LF1579 MCU.
 *
 * This file is part of the GNU PIC library for SDCC, originally
 * created by Molnar Karoly <molnarkaroly@users.sf.net> 2016.
 *
 * This file is generated automatically by the cinc2h.pl, 2016-01-09 15:09:16 UTC.
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

#include <pic16lf1579.h>

//==============================================================================

__at(0x0000) __sfr INDF0;

__at(0x0001) __sfr INDF1;

__at(0x0002) __sfr PCL;

__at(0x0003) __sfr STATUS;
__at(0x0003) volatile __STATUSbits_t STATUSbits;

__at(0x0004) __sfr FSR0;

__at(0x0004) __sfr FSR0L;

__at(0x0005) __sfr FSR0H;

__at(0x0006) __sfr FSR1;

__at(0x0006) __sfr FSR1L;

__at(0x0007) __sfr FSR1H;

__at(0x0008) __sfr BSR;
__at(0x0008) volatile __BSRbits_t BSRbits;

__at(0x0009) __sfr WREG;

__at(0x000A) __sfr PCLATH;

__at(0x000B) __sfr INTCON;
__at(0x000B) volatile __INTCONbits_t INTCONbits;

__at(0x000C) __sfr PORTA;
__at(0x000C) volatile __PORTAbits_t PORTAbits;

__at(0x000D) __sfr PORTB;
__at(0x000D) volatile __PORTBbits_t PORTBbits;

__at(0x000E) __sfr PORTC;
__at(0x000E) volatile __PORTCbits_t PORTCbits;

__at(0x0011) __sfr PIR1;
__at(0x0011) volatile __PIR1bits_t PIR1bits;

__at(0x0012) __sfr PIR2;
__at(0x0012) volatile __PIR2bits_t PIR2bits;

__at(0x0013) __sfr PIR3;
__at(0x0013) volatile __PIR3bits_t PIR3bits;

__at(0x0015) __sfr TMR0;

__at(0x0016) __sfr TMR1;

__at(0x0016) __sfr TMR1L;

__at(0x0017) __sfr TMR1H;

__at(0x0018) __sfr T1CON;
__at(0x0018) volatile __T1CONbits_t T1CONbits;

__at(0x0019) __sfr T1GCON;
__at(0x0019) volatile __T1GCONbits_t T1GCONbits;

__at(0x001A) __sfr TMR2;

__at(0x001B) __sfr PR2;

__at(0x001C) __sfr T2CON;
__at(0x001C) volatile __T2CONbits_t T2CONbits;

__at(0x008C) __sfr TRISA;
__at(0x008C) volatile __TRISAbits_t TRISAbits;

__at(0x008D) __sfr TRISB;
__at(0x008D) volatile __TRISBbits_t TRISBbits;

__at(0x008E) __sfr TRISC;
__at(0x008E) volatile __TRISCbits_t TRISCbits;

__at(0x0091) __sfr PIE1;
__at(0x0091) volatile __PIE1bits_t PIE1bits;

__at(0x0092) __sfr PIE2;
__at(0x0092) volatile __PIE2bits_t PIE2bits;

__at(0x0093) __sfr PIE3;
__at(0x0093) volatile __PIE3bits_t PIE3bits;

__at(0x0095) __sfr OPTION_REG;
__at(0x0095) volatile __OPTION_REGbits_t OPTION_REGbits;

__at(0x0096) __sfr PCON;
__at(0x0096) volatile __PCONbits_t PCONbits;

__at(0x0097) __sfr WDTCON;
__at(0x0097) volatile __WDTCONbits_t WDTCONbits;

__at(0x0098) __sfr OSCTUNE;
__at(0x0098) volatile __OSCTUNEbits_t OSCTUNEbits;

__at(0x0099) __sfr OSCCON;
__at(0x0099) volatile __OSCCONbits_t OSCCONbits;

__at(0x009A) __sfr OSCSTAT;
__at(0x009A) volatile __OSCSTATbits_t OSCSTATbits;

__at(0x009B) __sfr ADRES;

__at(0x009B) __sfr ADRESL;

__at(0x009C) __sfr ADRESH;

__at(0x009D) __sfr ADCON0;
__at(0x009D) volatile __ADCON0bits_t ADCON0bits;

__at(0x009E) __sfr ADCON1;
__at(0x009E) volatile __ADCON1bits_t ADCON1bits;

__at(0x009F) __sfr ADCON2;
__at(0x009F) volatile __ADCON2bits_t ADCON2bits;

__at(0x010C) __sfr LATA;
__at(0x010C) volatile __LATAbits_t LATAbits;

__at(0x010D) __sfr LATB;
__at(0x010D) volatile __LATBbits_t LATBbits;

__at(0x010E) __sfr LATC;
__at(0x010E) volatile __LATCbits_t LATCbits;

__at(0x0111) __sfr CM1CON0;
__at(0x0111) volatile __CM1CON0bits_t CM1CON0bits;

__at(0x0112) __sfr CM1CON1;
__at(0x0112) volatile __CM1CON1bits_t CM1CON1bits;

__at(0x0113) __sfr CM2CON0;
__at(0x0113) volatile __CM2CON0bits_t CM2CON0bits;

__at(0x0114) __sfr CM2CON1;
__at(0x0114) volatile __CM2CON1bits_t CM2CON1bits;

__at(0x0115) __sfr CMOUT;
__at(0x0115) volatile __CMOUTbits_t CMOUTbits;

__at(0x0116) __sfr BORCON;
__at(0x0116) volatile __BORCONbits_t BORCONbits;

__at(0x0117) __sfr FVRCON;
__at(0x0117) volatile __FVRCONbits_t FVRCONbits;

__at(0x0118) __sfr DACCON0;
__at(0x0118) volatile __DACCON0bits_t DACCON0bits;

__at(0x0119) __sfr DACCON1;
__at(0x0119) volatile __DACCON1bits_t DACCON1bits;

__at(0x018C) __sfr ANSELA;
__at(0x018C) volatile __ANSELAbits_t ANSELAbits;

__at(0x018D) __sfr ANSELB;
__at(0x018D) volatile __ANSELBbits_t ANSELBbits;

__at(0x018E) __sfr ANSELC;
__at(0x018E) volatile __ANSELCbits_t ANSELCbits;

__at(0x0191) __sfr PMADR;

__at(0x0191) __sfr PMADRL;

__at(0x0192) __sfr PMADRH;

__at(0x0193) __sfr PMDAT;

__at(0x0193) __sfr PMDATL;

__at(0x0194) __sfr PMDATH;

__at(0x0195) __sfr PMCON1;
__at(0x0195) volatile __PMCON1bits_t PMCON1bits;

__at(0x0196) __sfr PMCON2;

__at(0x0199) __sfr RCREG;

__at(0x019A) __sfr TXREG;

__at(0x019B) __sfr SPBRG;

__at(0x019B) __sfr SPBRGL;

__at(0x019C) __sfr SPBRGH;

__at(0x019D) __sfr RCSTA;
__at(0x019D) volatile __RCSTAbits_t RCSTAbits;

__at(0x019E) __sfr TXSTA;
__at(0x019E) volatile __TXSTAbits_t TXSTAbits;

__at(0x019F) __sfr BAUDCON;
__at(0x019F) volatile __BAUDCONbits_t BAUDCONbits;

__at(0x020C) __sfr WPUA;
__at(0x020C) volatile __WPUAbits_t WPUAbits;

__at(0x020D) __sfr WPUB;
__at(0x020D) volatile __WPUBbits_t WPUBbits;

__at(0x020E) __sfr WPUC;
__at(0x020E) volatile __WPUCbits_t WPUCbits;

__at(0x028C) __sfr ODCONA;
__at(0x028C) volatile __ODCONAbits_t ODCONAbits;

__at(0x028D) __sfr ODCONB;
__at(0x028D) volatile __ODCONBbits_t ODCONBbits;

__at(0x028E) __sfr ODCONC;
__at(0x028E) volatile __ODCONCbits_t ODCONCbits;

__at(0x030C) __sfr SLRCONA;
__at(0x030C) volatile __SLRCONAbits_t SLRCONAbits;

__at(0x030D) __sfr SLRCONB;
__at(0x030D) volatile __SLRCONBbits_t SLRCONBbits;

__at(0x030E) __sfr SLRCONC;
__at(0x030E) volatile __SLRCONCbits_t SLRCONCbits;

__at(0x038C) __sfr INLVLA;
__at(0x038C) volatile __INLVLAbits_t INLVLAbits;

__at(0x038D) __sfr INLVLB;
__at(0x038D) volatile __INLVLBbits_t INLVLBbits;

__at(0x038E) __sfr INLVLC;
__at(0x038E) volatile __INLVLCbits_t INLVLCbits;

__at(0x0391) __sfr IOCAP;
__at(0x0391) volatile __IOCAPbits_t IOCAPbits;

__at(0x0392) __sfr IOCAN;
__at(0x0392) volatile __IOCANbits_t IOCANbits;

__at(0x0393) __sfr IOCAF;
__at(0x0393) volatile __IOCAFbits_t IOCAFbits;

__at(0x0394) __sfr IOCBP;
__at(0x0394) volatile __IOCBPbits_t IOCBPbits;

__at(0x0395) __sfr IOCBN;
__at(0x0395) volatile __IOCBNbits_t IOCBNbits;

__at(0x0396) __sfr IOCBF;
__at(0x0396) volatile __IOCBFbits_t IOCBFbits;

__at(0x0397) __sfr IOCCP;
__at(0x0397) volatile __IOCCPbits_t IOCCPbits;

__at(0x0398) __sfr IOCCN;
__at(0x0398) volatile __IOCCNbits_t IOCCNbits;

__at(0x0399) __sfr IOCCF;
__at(0x0399) volatile __IOCCFbits_t IOCCFbits;

__at(0x0691) __sfr CWG1DBR;
__at(0x0691) volatile __CWG1DBRbits_t CWG1DBRbits;

__at(0x0692) __sfr CWG1DBF;
__at(0x0692) volatile __CWG1DBFbits_t CWG1DBFbits;

__at(0x0693) __sfr CWG1CON0;
__at(0x0693) volatile __CWG1CON0bits_t CWG1CON0bits;

__at(0x0694) __sfr CWG1CON1;
__at(0x0694) volatile __CWG1CON1bits_t CWG1CON1bits;

__at(0x0695) __sfr CWG1CON2;
__at(0x0695) volatile __CWG1CON2bits_t CWG1CON2bits;

__at(0x0D8E) __sfr PWMEN;
__at(0x0D8E) volatile __PWMENbits_t PWMENbits;

__at(0x0D8F) __sfr PWMLD;
__at(0x0D8F) volatile __PWMLDbits_t PWMLDbits;

__at(0x0D90) __sfr PWMOUT;
__at(0x0D90) volatile __PWMOUTbits_t PWMOUTbits;

__at(0x0D91) __sfr PWM1PH;

__at(0x0D91) __sfr PWM1PHL;
__at(0x0D91) volatile __PWM1PHLbits_t PWM1PHLbits;

__at(0x0D92) __sfr PWM1PHH;
__at(0x0D92) volatile __PWM1PHHbits_t PWM1PHHbits;

__at(0x0D93) __sfr PWM1DC;

__at(0x0D93) __sfr PWM1DCL;
__at(0x0D93) volatile __PWM1DCLbits_t PWM1DCLbits;

__at(0x0D94) __sfr PWM1DCH;
__at(0x0D94) volatile __PWM1DCHbits_t PWM1DCHbits;

__at(0x0D95) __sfr PWM1PR;

__at(0x0D95) __sfr PWM1PRL;
__at(0x0D95) volatile __PWM1PRLbits_t PWM1PRLbits;

__at(0x0D96) __sfr PWM1PRH;
__at(0x0D96) volatile __PWM1PRHbits_t PWM1PRHbits;

__at(0x0D97) __sfr PWM1OF;

__at(0x0D97) __sfr PWM1OFL;
__at(0x0D97) volatile __PWM1OFLbits_t PWM1OFLbits;

__at(0x0D98) __sfr PWM1OFH;
__at(0x0D98) volatile __PWM1OFHbits_t PWM1OFHbits;

__at(0x0D99) __sfr PWM1TMR;

__at(0x0D99) __sfr PWM1TMRL;
__at(0x0D99) volatile __PWM1TMRLbits_t PWM1TMRLbits;

__at(0x0D9A) __sfr PWM1TMRH;
__at(0x0D9A) volatile __PWM1TMRHbits_t PWM1TMRHbits;

__at(0x0D9B) __sfr PWM1CON;
__at(0x0D9B) volatile __PWM1CONbits_t PWM1CONbits;

__at(0x0D9C) __sfr PWM1INTCON;
__at(0x0D9C) volatile __PWM1INTCONbits_t PWM1INTCONbits;

__at(0x0D9C) __sfr PWM1INTE;
__at(0x0D9C) volatile __PWM1INTEbits_t PWM1INTEbits;

__at(0x0D9D) __sfr PWM1INTF;
__at(0x0D9D) volatile __PWM1INTFbits_t PWM1INTFbits;

__at(0x0D9D) __sfr PWM1INTFLG;
__at(0x0D9D) volatile __PWM1INTFLGbits_t PWM1INTFLGbits;

__at(0x0D9E) __sfr PWM1CLKCON;
__at(0x0D9E) volatile __PWM1CLKCONbits_t PWM1CLKCONbits;

__at(0x0D9F) __sfr PWM1LDCON;
__at(0x0D9F) volatile __PWM1LDCONbits_t PWM1LDCONbits;

__at(0x0DA0) __sfr PWM1OFCON;
__at(0x0DA0) volatile __PWM1OFCONbits_t PWM1OFCONbits;

__at(0x0DA1) __sfr PWM2PH;

__at(0x0DA1) __sfr PWM2PHL;
__at(0x0DA1) volatile __PWM2PHLbits_t PWM2PHLbits;

__at(0x0DA2) __sfr PWM2PHH;
__at(0x0DA2) volatile __PWM2PHHbits_t PWM2PHHbits;

__at(0x0DA3) __sfr PWM2DC;

__at(0x0DA3) __sfr PWM2DCL;
__at(0x0DA3) volatile __PWM2DCLbits_t PWM2DCLbits;

__at(0x0DA4) __sfr PWM2DCH;
__at(0x0DA4) volatile __PWM2DCHbits_t PWM2DCHbits;

__at(0x0DA5) __sfr PWM2PR;

__at(0x0DA5) __sfr PWM2PRL;
__at(0x0DA5) volatile __PWM2PRLbits_t PWM2PRLbits;

__at(0x0DA6) __sfr PWM2PRH;
__at(0x0DA6) volatile __PWM2PRHbits_t PWM2PRHbits;

__at(0x0DA7) __sfr PWM2OF;

__at(0x0DA7) __sfr PWM2OFL;
__at(0x0DA7) volatile __PWM2OFLbits_t PWM2OFLbits;

__at(0x0DA8) __sfr PWM2OFH;
__at(0x0DA8) volatile __PWM2OFHbits_t PWM2OFHbits;

__at(0x0DA9) __sfr PWM2TMR;

__at(0x0DA9) __sfr PWM2TMRL;
__at(0x0DA9) volatile __PWM2TMRLbits_t PWM2TMRLbits;

__at(0x0DAA) __sfr PWM2TMRH;
__at(0x0DAA) volatile __PWM2TMRHbits_t PWM2TMRHbits;

__at(0x0DAB) __sfr PWM2CON;
__at(0x0DAB) volatile __PWM2CONbits_t PWM2CONbits;

__at(0x0DAC) __sfr PWM2INTCON;
__at(0x0DAC) volatile __PWM2INTCONbits_t PWM2INTCONbits;

__at(0x0DAC) __sfr PWM2INTE;
__at(0x0DAC) volatile __PWM2INTEbits_t PWM2INTEbits;

__at(0x0DAD) __sfr PWM2INTF;
__at(0x0DAD) volatile __PWM2INTFbits_t PWM2INTFbits;

__at(0x0DAD) __sfr PWM2INTFLG;
__at(0x0DAD) volatile __PWM2INTFLGbits_t PWM2INTFLGbits;

__at(0x0DAE) __sfr PWM2CLKCON;
__at(0x0DAE) volatile __PWM2CLKCONbits_t PWM2CLKCONbits;

__at(0x0DAF) __sfr PWM2LDCON;
__at(0x0DAF) volatile __PWM2LDCONbits_t PWM2LDCONbits;

__at(0x0DB0) __sfr PWM2OFCON;
__at(0x0DB0) volatile __PWM2OFCONbits_t PWM2OFCONbits;

__at(0x0DB1) __sfr PWM3PH;

__at(0x0DB1) __sfr PWM3PHL;
__at(0x0DB1) volatile __PWM3PHLbits_t PWM3PHLbits;

__at(0x0DB2) __sfr PWM3PHH;
__at(0x0DB2) volatile __PWM3PHHbits_t PWM3PHHbits;

__at(0x0DB3) __sfr PWM3DC;

__at(0x0DB3) __sfr PWM3DCL;
__at(0x0DB3) volatile __PWM3DCLbits_t PWM3DCLbits;

__at(0x0DB4) __sfr PWM3DCH;
__at(0x0DB4) volatile __PWM3DCHbits_t PWM3DCHbits;

__at(0x0DB5) __sfr PWM3PR;

__at(0x0DB5) __sfr PWM3PRL;
__at(0x0DB5) volatile __PWM3PRLbits_t PWM3PRLbits;

__at(0x0DB6) __sfr PWM3PRH;
__at(0x0DB6) volatile __PWM3PRHbits_t PWM3PRHbits;

__at(0x0DB7) __sfr PWM3OF;

__at(0x0DB7) __sfr PWM3OFL;
__at(0x0DB7) volatile __PWM3OFLbits_t PWM3OFLbits;

__at(0x0DB8) __sfr PWM3OFH;
__at(0x0DB8) volatile __PWM3OFHbits_t PWM3OFHbits;

__at(0x0DB9) __sfr PWM3TMR;

__at(0x0DB9) __sfr PWM3TMRL;
__at(0x0DB9) volatile __PWM3TMRLbits_t PWM3TMRLbits;

__at(0x0DBA) __sfr PWM3TMRH;
__at(0x0DBA) volatile __PWM3TMRHbits_t PWM3TMRHbits;

__at(0x0DBB) __sfr PWM3CON;
__at(0x0DBB) volatile __PWM3CONbits_t PWM3CONbits;

__at(0x0DBC) __sfr PWM3INTCON;
__at(0x0DBC) volatile __PWM3INTCONbits_t PWM3INTCONbits;

__at(0x0DBC) __sfr PWM3INTE;
__at(0x0DBC) volatile __PWM3INTEbits_t PWM3INTEbits;

__at(0x0DBD) __sfr PWM3INTF;
__at(0x0DBD) volatile __PWM3INTFbits_t PWM3INTFbits;

__at(0x0DBD) __sfr PWM3INTFLG;
__at(0x0DBD) volatile __PWM3INTFLGbits_t PWM3INTFLGbits;

__at(0x0DBE) __sfr PWM3CLKCON;
__at(0x0DBE) volatile __PWM3CLKCONbits_t PWM3CLKCONbits;

__at(0x0DBF) __sfr PWM3LDCON;
__at(0x0DBF) volatile __PWM3LDCONbits_t PWM3LDCONbits;

__at(0x0DC0) __sfr PWM3OFCON;
__at(0x0DC0) volatile __PWM3OFCONbits_t PWM3OFCONbits;

__at(0x0DC1) __sfr PWM4PH;

__at(0x0DC1) __sfr PWM4PHL;
__at(0x0DC1) volatile __PWM4PHLbits_t PWM4PHLbits;

__at(0x0DC2) __sfr PWM4PHH;
__at(0x0DC2) volatile __PWM4PHHbits_t PWM4PHHbits;

__at(0x0DC3) __sfr PWM4DC;

__at(0x0DC3) __sfr PWM4DCL;
__at(0x0DC3) volatile __PWM4DCLbits_t PWM4DCLbits;

__at(0x0DC4) __sfr PWM4DCH;
__at(0x0DC4) volatile __PWM4DCHbits_t PWM4DCHbits;

__at(0x0DC5) __sfr PWM4PR;

__at(0x0DC5) __sfr PWM4PRL;
__at(0x0DC5) volatile __PWM4PRLbits_t PWM4PRLbits;

__at(0x0DC6) __sfr PWM4PRH;
__at(0x0DC6) volatile __PWM4PRHbits_t PWM4PRHbits;

__at(0x0DC7) __sfr PWM4OF;

__at(0x0DC7) __sfr PWM4OFL;
__at(0x0DC7) volatile __PWM4OFLbits_t PWM4OFLbits;

__at(0x0DC8) __sfr PWM4OFH;
__at(0x0DC8) volatile __PWM4OFHbits_t PWM4OFHbits;

__at(0x0DC9) __sfr PWM4TMR;

__at(0x0DC9) __sfr PWM4TMRL;
__at(0x0DC9) volatile __PWM4TMRLbits_t PWM4TMRLbits;

__at(0x0DCA) __sfr PWM4TMRH;
__at(0x0DCA) volatile __PWM4TMRHbits_t PWM4TMRHbits;

__at(0x0DCB) __sfr PWM4CON;
__at(0x0DCB) volatile __PWM4CONbits_t PWM4CONbits;

__at(0x0DCC) __sfr PWM4INTCON;
__at(0x0DCC) volatile __PWM4INTCONbits_t PWM4INTCONbits;

__at(0x0DCC) __sfr PWM4INTE;
__at(0x0DCC) volatile __PWM4INTEbits_t PWM4INTEbits;

__at(0x0DCD) __sfr PWM4INTF;
__at(0x0DCD) volatile __PWM4INTFbits_t PWM4INTFbits;

__at(0x0DCD) __sfr PWM4INTFLG;
__at(0x0DCD) volatile __PWM4INTFLGbits_t PWM4INTFLGbits;

__at(0x0DCE) __sfr PWM4CLKCON;
__at(0x0DCE) volatile __PWM4CLKCONbits_t PWM4CLKCONbits;

__at(0x0DCF) __sfr PWM4LDCON;
__at(0x0DCF) volatile __PWM4LDCONbits_t PWM4LDCONbits;

__at(0x0DD0) __sfr PWM4OFCON;
__at(0x0DD0) volatile __PWM4OFCONbits_t PWM4OFCONbits;

__at(0x0E0F) __sfr PPSLOCK;
__at(0x0E0F) volatile __PPSLOCKbits_t PPSLOCKbits;

__at(0x0E10) __sfr INTPPS;
__at(0x0E10) volatile __INTPPSbits_t INTPPSbits;

__at(0x0E11) __sfr T0CKIPPS;
__at(0x0E11) volatile __T0CKIPPSbits_t T0CKIPPSbits;

__at(0x0E12) __sfr T1CKIPPS;
__at(0x0E12) volatile __T1CKIPPSbits_t T1CKIPPSbits;

__at(0x0E13) __sfr T1GPPS;
__at(0x0E13) volatile __T1GPPSbits_t T1GPPSbits;

__at(0x0E14) __sfr CWG1INPPS;
__at(0x0E14) volatile __CWG1INPPSbits_t CWG1INPPSbits;

__at(0x0E15) __sfr RXPPS;
__at(0x0E15) volatile __RXPPSbits_t RXPPSbits;

__at(0x0E16) __sfr CKPPS;
__at(0x0E16) volatile __CKPPSbits_t CKPPSbits;

__at(0x0E17) __sfr ADCACTPPS;
__at(0x0E17) volatile __ADCACTPPSbits_t ADCACTPPSbits;

__at(0x0E90) __sfr RA0PPS;
__at(0x0E90) volatile __RA0PPSbits_t RA0PPSbits;

__at(0x0E91) __sfr RA1PPS;
__at(0x0E91) volatile __RA1PPSbits_t RA1PPSbits;

__at(0x0E92) __sfr RA2PPS;
__at(0x0E92) volatile __RA2PPSbits_t RA2PPSbits;

__at(0x0E94) __sfr RA4PPS;
__at(0x0E94) volatile __RA4PPSbits_t RA4PPSbits;

__at(0x0E95) __sfr RA5PPS;
__at(0x0E95) volatile __RA5PPSbits_t RA5PPSbits;

__at(0x0E9C) __sfr RB4PPS;
__at(0x0E9C) volatile __RB4PPSbits_t RB4PPSbits;

__at(0x0E9D) __sfr RB5PPS;
__at(0x0E9D) volatile __RB5PPSbits_t RB5PPSbits;

__at(0x0E9E) __sfr RB6PPS;
__at(0x0E9E) volatile __RB6PPSbits_t RB6PPSbits;

__at(0x0E9F) __sfr RB7PPS;
__at(0x0E9F) volatile __RB7PPSbits_t RB7PPSbits;

__at(0x0EA0) __sfr RC0PPS;
__at(0x0EA0) volatile __RC0PPSbits_t RC0PPSbits;

__at(0x0EA1) __sfr RC1PPS;
__at(0x0EA1) volatile __RC1PPSbits_t RC1PPSbits;

__at(0x0EA2) __sfr RC2PPS;
__at(0x0EA2) volatile __RC2PPSbits_t RC2PPSbits;

__at(0x0EA3) __sfr RC3PPS;
__at(0x0EA3) volatile __RC3PPSbits_t RC3PPSbits;

__at(0x0EA4) __sfr RC4PPS;
__at(0x0EA4) volatile __RC4PPSbits_t RC4PPSbits;

__at(0x0EA5) __sfr RC5PPS;
__at(0x0EA5) volatile __RC5PPSbits_t RC5PPSbits;

__at(0x0EA6) __sfr RC6PPS;
__at(0x0EA6) volatile __RC6PPSbits_t RC6PPSbits;

__at(0x0EA7) __sfr RC7PPS;
__at(0x0EA7) volatile __RC7PPSbits_t RC7PPSbits;

__at(0x0FE4) __sfr STATUS_SHAD;
__at(0x0FE4) volatile __STATUS_SHADbits_t STATUS_SHADbits;

__at(0x0FE5) __sfr WREG_SHAD;

__at(0x0FE6) __sfr BSR_SHAD;

__at(0x0FE7) __sfr PCLATH_SHAD;

__at(0x0FE8) __sfr FSR0L_SHAD;

__at(0x0FE8) __sfr FSR0_SHAD;

__at(0x0FE9) __sfr FSR0H_SHAD;

__at(0x0FEA) __sfr FSR1L_SHAD;

__at(0x0FEA) __sfr FSR1_SHAD;

__at(0x0FEB) __sfr FSR1H_SHAD;

__at(0x0FED) __sfr STKPTR;

__at(0x0FEE) __sfr TOS;

__at(0x0FEE) __sfr TOSL;

__at(0x0FEF) __sfr TOSH;
