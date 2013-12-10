* Calc extended precision PI using the series:
* (PI**2)/12=1-1/4+1/9-1/16+1/25 etc.
*MCALL #=     1 LV= 1 P8DSH1   ZMFACC CODE,START,NAME='Don Higgins'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P8DSH1   CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P8DSH1(15)
SV0001    DC    18F'0'
         DC    CL8'P8DSH1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P8DSHX
               1 by Don Higgins using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P8DSX
               H1 by Don Higgins using RUNSYS=390'
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
         MACRO
&N       LX    &F1,&S2      LOAD EXTENDED FP REG PAIR FROM LONG FP
&XREGS(1) SETA 1,1,0,0,4,5,0,0,8,9,0,0,12,13
         AIF   (&XREGS(&F1+1) NE 0).OK
         MNOTE 12,'LX INVALID EXTENDED REGISTER PAIR LOAD'
.OK      ANOP
         LD    &F1,&S2
         LD    &F1+2,&S2+8
         MEND
         MACRO
&N       STX   &F1,&S2      STORE EXTENDED FP REG PAIR TO LONG FP
&XREGS(1) SETA 1,1,0,0,4,5,0,0,8,9,0,0,12,13
         AIF   (&XREGS(&F1+1) NE 0).OK
         MNOTE 12,'STX INVALID EXTENDED REGISTER PAIR STORE'
.OK      ANOP
         STD   &F1,&S2
         STD   &F1+2,&S2+8
         MEND
*MCALL #=     5 LV= 1          LX    F0,=LH'1'     F0=SUM
         LD    F0,=LH'1'
         LD    F0+2,=LH'1'+8
*MEXIT #=     5 LV= 1 LX
*MCALL #=     6 LV= 1          LX    F1,=LH'1'     F1=N
         LD    F1,=LH'1'
         LD    F1+2,=LH'1'+8
*MEXIT #=     6 LV= 1 LX
*MCALL #=     7 LV= 1          LX    F4,=LH'1'     F4=1
         LD    F4,=LH'1'
         LD    F4+2,=LH'1'+8
*MEXIT #=     7 LV= 1 LX
*MCALL #=     8 LV= 1          LX    F5,=LH'1E-34' F5=ERROR LIMIT
         LD    F5,=LH'1E-34'
         LD    F5+2,=LH'1E-34'+8
*MEXIT #=     8 LV= 1 LX
         LA    R10,100       MAX INTERATIONS
LOOP     DS    0H
         AXR   F1,F4         N=N+1
         LXR   F8,F4
*MCALL #=     9 LV= 1          STX   F8,LH
         STD   F8,LH
         STD   F8+2,LH+8
*MEXIT #=     9 LV= 1 STX
*MCALL #=    10 LV= 1          CTD   CTD_LH,IN=LH,OUT=SNX
CTD_INT128 EQU 1 CONVERT 128 BIT INT TO 45 BYTE EBCDIC DECIMAL
CTD_EH   EQU   2 CONVERT HFP SHORT EH TO 45 BYTE EBCDIC N.N( 6)+ENNNN
CTD_EB   EQU   3 CONVERT BFP SHORT EB TO 45 BYTE EBCDIC N.N( 7)+ENNNN
CTD_DH   EQU   4 CONVERT HFP LONG  DH TO 45 BYTE EBCDIC N.N(14)+ENNNN
CTD_DB   EQU   5 CONVERT BFP LONG  DB TO 45 BYTE EBCDIC N.N(15)+ENNNN
CTD_LH   EQU   6 CONVERT HFP EXT.  LH TO 45 BYTE EBCDIC N.N(34)+ENNNN
CTD_LB   EQU   7 CONVERT BFP EXT.  LB TO 45 BYTE EBCDIC N.N(34)+ENNNN
CTD_DD   EQU   8 CONVERT DFP LONG  DD TO 45 BYTE EBCDIC N.N(16)+ENNNN
CTD_ED   EQU   9 CONVERT DFP SHORT ED TO 45 BYTE EBCDIC N.N( 7)+ENNNN
CTD_LD   EQU  10 CONVERT DFP EXT.  LD TO 45 BYTE EBCDIC N.N(34)+ENNNN
         LA    1,=A(CTD_LH,LH,SNX)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=    10 LV= 1 CTD
*MCALL #=    11 LV= 1          SNAP  PDATA=,STORAGE=(SNX,SNX+45),TEXT='X
               TRIAL'
         L     14,=A(SNX)
         L     15,=A(SNX+45)
         IILL  0,0                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'TRIAL'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    11 LV= 1 SNAP
         LXR   F9,F1
         MXR   F9,F9
         DXR   F8,F9         F8=1/(N*N)
         CXR   R8,F5
         BL    DONE
         CLI   SIGN,C'-'
         BE    SUB
ADD      DS    0H
         MVI   SIGN,C'-'
         AXR   F0,F8
         B     NEXT
SUB      DS    0H
         MVI   SIGN,C'+'
         SXR   F0,F8
NEXT     DS    0H
*MCALL #=    12 LV= 1          STX   F0,LH
         STD   F0,LH
         STD   F0+2,LH+8
*MEXIT #=    12 LV= 1 STX
*MCALL #=    13 LV= 1          CTD   CTD_LH,IN=LH,OUT=SNX
         LA    1,=A(CTD_LH,LH,SNX)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=    13 LV= 1 CTD
*MCALL #=    14 LV= 1          SNAP  PDATA=,STORAGE=(SNX,SNX+45),TEXT='X
               TRIAL'
         L     14,=A(SNX)
         L     15,=A(SNX+45)
         IILL  0,0                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'TRIAL'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    14 LV= 1 SNAP
         BCT   R10,LOOP
DONE     DS    0H
*MCALL #=    15 LV= 1          LX    F8,=LH'12'
         LD    F8,=LH'12'
         LD    F8+2,=LH'12'+8
*MEXIT #=    15 LV= 1 LX
         MXR   F0,F8
         LXR   F1,F0
         SQXR  F0,F1
*MCALL #=    16 LV= 1          STX   F0,LH
         STD   F0,LH
         STD   F0+2,LH+8
*MEXIT #=    16 LV= 1 STX
*MCALL #=    17 LV= 1          CTD   CTD_LH,IN=LH,OUT=SNX
         LA    1,=A(CTD_LH,LH,SNX)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=    17 LV= 1 CTD
*MCALL #=    18 LV= 1          ZMFACC CODE,END
*MCALL #=    19 LV= 2       ZMFACC DUMP,ID=2,ST=OUTPUTST,END=OUTPUTEN,NX
               AME='Output Area' RP2
         DS    0H
*MCALL #=    20 LV= 3          SNAP  ID=2,PDATA=,STORAGE=(OUTPUTST,OUTPX
               UTEN),TEXT='Output Area'
         L     14,=A(OUTPUTST)
         L     15,=A(OUTPUTEN)
         IILL  0,2                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'Output Area'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    20 LV= 3 SNAP
*MEXIT #=    19 LV= 2 ZMFACC
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
*MEXIT #=    18 LV= 1 ZMFACC
*MCALL #=    21 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=    21 LV= 1 ZMFACC
*MCALL #=    22 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    22 LV= 1 ZMFACC
*MCALL #=    23 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    23 LV= 1 ZMFACC
SNX      DC     CL45' '
*MCALL #=    24 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    24 LV= 1 ZMFACC
LH       DC     LH'0'
SIGN     DC     C'-'
         END 
