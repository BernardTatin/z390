*********************************************************************
* ZMFACC Problem #8 - calculate PI to as many decimal places as
* possible using extended precision floating point
*********************************************************************
* Lindy Mayfield solution based on this model program in REXX
* /* Rexx */
* size = 1165  /*    1165 gives 1000 digits    */
*  numeric digits size
*  n = 0
*  asubn = 3
*  sum = 3
*  last = no
*  do size
*    n = n + 1
*    n1 = n * 2
*    n1 = n1 * 2
*    n2 = n * n
*    n2 = n2 * 4
*    d1 = n2 - n1 + 1
*    d2 = (n2 * 2) + n1
*    d2 = d2 * 2
*    asubn = asubn * d1 / d2
*    sum = sum + asubn
*  end
*    say n 'iterations'
*    say 'pi =' sum * 1
*    say
*  exit 0
*********************************************************************
* 12/26/07 DSH1 Don Higgins changed to run on z390 with auto
*          termination when error from known PI is < 1E-33,
*          use LX and STX to simplify load and store extended fp
*          and display trial PI and error at each iteration.
*********************************************************************
*MCALL #=     1 LV= 1 P8LM1    ZMFACC CODE,START,NAME='Lindy Mayfield'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P8LM1    CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P8LM1(15)
SV0001    DC    18F'0'
         DC    CL8'P8LM1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P8LM1X
                by Lindy Mayfield using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P8LMX
               1 by Lindy Mayfield using RUNSYS=390'
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
MAIN     LA    R2,80              Number of iterations MAX      DSH1
         XR    R3,R3              N
         XR    R4,R4              N1
         XR    R6,R6              N2 high (not used)
         XR    R7,R7              N2 low
         XR    R8,R8              D1
         XR    R9,R9              D2
*MCALL #=     5 LV= 1          LX    F0,=L'3'           ASUBN initalizeX
               d to 3         DSH1
         LD    F0,=L'3'
         LD    F0+2,=L'3'+8
*MEXIT #=     5 LV= 1 LX
*MCALL #=     6 LV= 1          LX    F4,=L'3'           Result initalizX
               ed to 3        DSH1
         LD    F4,=L'3'
         LD    F4+2,=L'3'+8
*MEXIT #=     6 LV= 1 LX
*MCALL #=     7 LV= 1          LX    F8,=L'0'           Work           X
                              DSH1
         LD    F8,=L'0'
         LD    F8+2,=L'0'+8
*MEXIT #=     7 LV= 1 LX
LOOP     DS    0H
         LA    R3,1(,R3)          R3= n = n + 1
         LR    R4,R3              R4= n1 = n
         SLA   R4,2               R4= n1 = n1 * 4
         LR    R7,R3              R7= n2 = n * n
         MR    R6,R3
         SLA   R7,2               R7= n2 = 4 * n * n
         LR    R8,R7              R8= d1 = n2 - n1 + 1
         SR    R8,R4
* DSH1   LA    R8,1(,R8)                                        DSH1
         AHI   R8,1                                             DSH1
         LR    R9,R7              R9= d2 = (n2 * 2) + n1
         SLA   R9,1
         AR    R9,R4
         SLA   R9,1               R9= d2 = d2 + d2
         CXFR  F8,R8              asubn = asubn * d1 / d2       DSH1
         MXR   F0,F8              multiply
         CXFR  F8,R9              asubn = asubn * d1 / d2       DSH1
         DXR   F0,F8              divide
         AXR   F4,F0              sum = sum + asubn
*MCALL #=     8 LV= 1          STX   F4,LH
         STD   F4,LH
         STD   F4+2,LH+8
*MEXIT #=     8 LV= 1 STX
*MCALL #=     9 LV= 1          CTD    CTD_LH,IN=LH,OUT=SNX             X
                              DSH1
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
*MEXIT #=     9 LV= 1 CTD
*MCALL #=    10 LV= 1          SNAP  ID=(R2),PDATA=,STORAGE=(SNX,SNX+45X
               ),TEXT='NEXT TRIAL VALUE'
         L     14,=A(SNX)
         L     15,=A(SNX+45)
*MCALL #=    11 LV= 2          ZOPTLR 0,R2                      RPI 623
         LR    0,R2
*MEXIT #=    11 LV= 2 ZOPTLR
         IILH 0,32768               RPI158
         LA    1,=CL60'NEXT TRIAL VALUE'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    10 LV= 1 SNAP
*MCALL #=    12 LV= 1          STX   F4,LH
         STD   F4,LH
         STD   F4+2,LH+8
*MEXIT #=    12 LV= 1 STX
*MCALL #=    13 LV= 1          LX    F1,LHPI
         LD    F1,LHPI
         LD    F1+2,LHPI+8
*MEXIT #=    13 LV= 1 LX
         SXR   F1,F4
*MCALL #=    14 LV= 1          CTD   CTD_LH,IN=F1,OUT=PIDIF            X
                              DSH1
         LA    1,=A(CTD_LH,F1,PIDIF)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=    14 LV= 1 CTD
*MCALL #=    15 LV= 1          SNAP  ID=(R2),PDATA=,STORAGE=(PIDIF,PIDIX
               F+45),TEXT='PI DIFF'                                   DX
               SH1
         L     14,=A(PIDIF)
         L     15,=A(PIDIF+45)
*MCALL #=    16 LV= 2          ZOPTLR 0,R2                      RPI 623
         LR    0,R2
*MEXIT #=    16 LV= 2 ZOPTLR
         IILH 0,32768               RPI158
         LA    1,=CL60'PI DIFF'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    15 LV= 1 SNAP
*MCALL #=    17 LV= 1          LX    F5,=L'1E-33'                      X
                              DSH1
         LD    F5,=L'1E-33'
         LD    F5+2,=L'1E-33'+8
*MEXIT #=    17 LV= 1 LX
         CXR   F1,R5                                            DSH1
         BL    DONE                                             DSH1
         BCT   R2,LOOP                Loop for up to max limit  DSH1
DONE     DS    0H
*MCALL #=    18 LV= 1          CTD   CTD_LH,IN=LH,OUT=SNX
         LA    1,=A(CTD_LH,LH,SNX)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=    18 LV= 1 CTD
*MCALL #=    19 LV= 1          ZMFACC CODE,END ZMFACC INPUT,START      X
                              DSH1
*MCALL #=    20 LV= 2       ZMFACC DUMP,ID=2,ST=OUTPUTST,END=OUTPUTEN,NX
               AME='Output Area' RP2
         DS    0H
*MCALL #=    21 LV= 3          SNAP  ID=2,PDATA=,STORAGE=(OUTPUTST,OUTPX
               UTEN),TEXT='Output Area'
         L     14,=A(OUTPUTST)
         L     15,=A(OUTPUTEN)
         IILL  0,2                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'Output Area'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    21 LV= 3 SNAP
*MEXIT #=    20 LV= 2 ZMFACC
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
*MEXIT #=    19 LV= 1 ZMFACC
*MCALL #=    22 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=    22 LV= 1 ZMFACC
*MCALL #=    23 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    23 LV= 1 ZMFACC
SNX      DC    CL45' ' SCIENTIFIC NOTATION DISPLAY OF X VALUE   DSH1
*MCALL #=    24 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    24 LV= 1 ZMFACC
*MCALL #=    25 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    25 LV= 1 ZMFACC
LH       DC    LH'0' ZMFACC OUTPUT,END                          DSH1
* PI REF http://www.jimloy.com/geometry/pi.htm                  DSH1
LHPI     DC    LH'3.141592653589793238462643383279502'          DSH1
PIDIF    DC    CL45' '                                          DSH1
         END 
