         TITLE 'P15DSH1.MLC - Calc PD divide with rounding'
*********************************************************************
* Program ID.  P15DSH1.MLC
* Author.      Don Higgins.
* Date.        02/22/08.
*********************************************************************
         MACRO
&N       DPR    &DIVIDEND,&DIVISOR,&QUOTIENT
&N       ZAP    PWORK,&DIVIDEND        MOVE DIVIDENT TO 16 BYTE WORK
         DP     PWORK,&DIVISOR         DIVIDE GIVING QUOTIENT+RMAINDER
         ZAP    &QUOTIENT,PWORK(L'PWORK-L'&DIVISOR)  MOVE QUOTIENT
&RMO     SETA   L'PWORK-L'&DIVISOR-1   DEFINE OFFSET TO REMAINDER+1
&RML     SETA   L'&DIVISOR+1           DEFINE LENGTH OF REMAINDER+1
         MVI    PWORK+&RMO,0           CLEAR HIGH BYTE OF REMAINER
         AP     PWORK+&RMO.(&RML),PWORK+&RMO.(&RML) DOUBLE REMAINDER
         CP     PWORK+&RMO.(&RML),&DIVISOR  IF REMAINDER*2 < DIVISOR
         BM     *+4+6                          THEN SKIP ADD
         AP     QUOTIENT1,=P'1'             ELSE ADD 1 TO QUOTIENT
         MEND
*MCALL #=     1 LV= 1 P15DSH1  ZMFACC CODE,START,NAME='DON HIGGINS'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P15DSH1  CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P15DSH1(15)
SV0001    DC    18F'0'
         DC    CL8'P15DSH1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P15DSX
               H1 by DON HIGGINS using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P15DX
               SH1 by DON HIGGINS using RUNSYS=390'
WTO#0002_EOT     EQU *
         SVC   35
*MEXIT #=     2 LV= 2 WTO
*MCALL #=     3 LV= 2          ZMFACC DUMP,ID=1,ST=INPUTSTR,END=INPUTENX
               D,NAME='Input Area'
         DS    0H
*MCALL #=     4 LV= 3          SNAP  ID=1,PDATA=,STORAGE=(INPUTSTR,INPUX
               TEND),TEXT='Input Area'
         L     14,=A(INPUTSTR)
         L     15,=A(INPUTEND)
         IILL  0,1                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'Input Area'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=     4 LV= 3 SNAP
*MEXIT #=     3 LV= 2 ZMFACC
*MEXIT #=     1 LV= 1 ZMFACC
*MCALL #=     5 LV= 1          DPR    DIVIDEND1,DIVISOR1,QUOTIENT1   EXX
               AMPLE  WITH ADD 1
         ZAP    PWORK,DIVIDEND1        MOVE DIVIDENT TO 16 BYTE WORK
         DP     PWORK,DIVISOR1         DIVIDE GIVING QUOTIENT+RMAINDER
         ZAP    QUOTIENT1,PWORK(L'PWORK-L'DIVISOR1)  MOVE QUOTIENT
         MVI    PWORK+7,0           CLEAR HIGH BYTE OF REMAINER
         AP     PWORK+7(9),PWORK+7(9) DOUBLE REMAINDER
         CP     PWORK+7(9),DIVISOR1  IF REMAINDER*2 < DIVISOR
         BM     *+4+6                          THEN SKIP ADD
         AP     QUOTIENT1,=P'1'             ELSE ADD 1 TO QUOTIENT
*MEXIT #=     5 LV= 1 DPR
*MCALL #=     6 LV= 1          DPR    DIVIDEND2,DIVISOR2,QUOTIENT2   EXX
               AMPLE  WITH NO ADD
         ZAP    PWORK,DIVIDEND2        MOVE DIVIDENT TO 16 BYTE WORK
         DP     PWORK,DIVISOR2         DIVIDE GIVING QUOTIENT+RMAINDER
         ZAP    QUOTIENT2,PWORK(L'PWORK-L'DIVISOR2)  MOVE QUOTIENT
         MVI    PWORK+7,0           CLEAR HIGH BYTE OF REMAINER
         AP     PWORK+7(9),PWORK+7(9) DOUBLE REMAINDER
         CP     PWORK+7(9),DIVISOR2  IF REMAINDER*2 < DIVISOR
         BM     *+4+6                          THEN SKIP ADD
         AP     QUOTIENT1,=P'1'             ELSE ADD 1 TO QUOTIENT
*MEXIT #=     6 LV= 1 DPR
*MCALL #=     7 LV= 1          ZMFACC CODE,END
*MCALL #=     8 LV= 2       ZMFACC DUMP,ID=2,ST=OUTPUTST,END=OUTPUTEN,NX
               AME='Output Area' RP2
         DS    0H
*MCALL #=     9 LV= 3          SNAP  ID=2,PDATA=,STORAGE=(OUTPUTST,OUTPX
               UTEN),TEXT='Output Area'
         L     14,=A(OUTPUTST)
         L     15,=A(OUTPUTEN)
         IILL  0,2                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'Output Area'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=     9 LV= 3 SNAP
*MEXIT #=     8 LV= 2 ZMFACC
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         SR    15,15
         BR    14
*        YREGS
***      REGISTER EQUATES
*
         SPACE 2
* GENERAL  REGISTERS
         SPACE 
R0        EQU  0
R1        EQU  1
R2        EQU  2
R3        EQU  3
R4        EQU  4
R5        EQU  5
R6        EQU  6
R7        EQU  7
R8        EQU  8
R9        EQU  9
R10       EQU  10
R11       EQU  11
R12       EQU  12
R13       EQU  13
R14       EQU  14
R15       EQU  15
         SPACE 
* FLOATING POINT REGISTERS
         SPACE 
F0        EQU  0  L0
F1        EQU  1  L1
F2        EQU  2  L0+
F3        EQU  3  L1+
F4        EQU  4  L4
F5        EQU  5  L5
F6        EQU  6  L4+
F7        EQU  7  L5+
F8        EQU  8  L8
F9        EQU  9  L9
F10       EQU  10 L8+
F11       EQU  11 L9+
F12       EQU  12 L12
F13       EQU  13 L13
F14       EQU  14 L12+
F15       EQU  15 L13+
         SPACE 
* EXTENDED CONTROL REGISTERS
         SPACE 
C0        EQU  0
C1        EQU  1
C2        EQU  2
C3        EQU  3
C4        EQU  4
C5        EQU  5
C6        EQU  6
C7        EQU  7
C8        EQU  8
C9        EQU  9
C10       EQU  10
C11       EQU  11
C12       EQU  12
C13       EQU  13
C14       EQU  14
C15       EQU  15
*MEXIT #=     7 LV= 1 ZMFACC
*MCALL #=    10 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=    10 LV= 1 ZMFACC
*MCALL #=    11 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
*MCALL #=    12 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    12 LV= 1 ZMFACC
         DC    CL8'DIVD1'
DIVIDEND1 DC    P'12345678.1234567'
         DC    CL8'DIVR1'
DIVISOR1  DC    P'00000000.0001000'
         DC    CL8'QUOT1'
QUOTIENT1 DC    PL8'0'
         DC    CL8'DIVD2'
DIVIDEND2 DC    P'12345678.1234567'
         DC    CL8'DIVR2'
DIVISOR2  DC    P'00000000.0010000'
         DC    CL8'QUOT2'
QUOTIENT2 DC    PL8'0'
*MCALL #=    13 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    13 LV= 1 ZMFACC
PWORK    DC    PL16'0'
         END 
