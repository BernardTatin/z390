*********************************************************************
* MAINFRAME ASSEMBLER PROBLEM 7 - CALC AND DISPLAY 311/99
* USING SINGLE PRECISION FLOATING POINT WITHOUT USING CTD OR
* OTHER LIBRARY SERVICES.
*********************************************************************
* 12/20/07 EH1  SOLUTION SUBMITTED BY JOHN ERHMAN USING AW INSTR.
* 12/21/07 DSH1 ADDED Z390 DISPLAY OF EH AND DH INTERMEDIATE RESULTS
*               USING CTD AND WTO FOR VERIFICATION
* 12/21/07 DSH2 ADDED Z390 ALTERNATE CODE PATH FOR AW SINCE
*               Z390 MAINTANINS ALL FP VALUES IN CACHE
*               USING NORMALIZED SINGLE, DOUBLE, OR BIGDECIMAL JAVA
*               FORMAT WHICH PREVENTS AW UNNORMALIZED INSTR. FROM
*               WORKING AS INTENDED. SEE NEW Z390 PTF 767 TO DISABLE
*               ALL THE UNNORMALIZED FP INSTRUCTIONS RATHER THAN
*               RETURNING NORMALIZED RESULT WHICH MAY NOT BE DESIRED.
*********************************************************************
*MCALL #=     1 LV= 1 P7EH1    ZMFACC CODE,START,NAME='John Erhman'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P7EH1    CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P7EH1(15)
SV0001    DC    18F'0'
         DC    CL8'P7EH1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P7EH1X
                by John Erhman using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P7EHX
               1 by John Erhman using RUNSYS=390'
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
         LE    F0,=E'311'
         DE    F0,=E'99'
         STE   F0,EH                                    DSH1
*MCALL #=     5 LV= 1          CTD   CTD_EH,IN=EH,OUT=DNUM             X
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
         LA    1,=A(CTD_EH,EH,DNUM)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=     5 LV= 1 CTD
         MVC   DMSG,=CL10'EH=311./99.'                  DSH1
*MCALL #=     6 LV= 1          WTO   MF=(E,MSG)                        X
                      DSH1
         LA    1,MSG
         SVC   35
*MEXIT #=     6 LV= 1 WTO
         MVI   ESign,C'+'
         MVI   EDecimal,C'.'
         MD    F0,=D'.1'
         MD    F0,=D'1.E6'
         AD    F0,=D'.5'
         STD   F0,DH                                    DSH1
*MCALL #=     7 LV= 1          CTD   CTD_DH,IN=DH,OUT=DNUM             X
                      DSH1
         LA    1,=A(CTD_DH,DH,DNUM)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=     7 LV= 1 CTD
         MVC   DMSG,=CL10'DH=EH*1E7+.5'                 DSH1
*MCALL #=     8 LV= 1          WTO   MF=(E,MSG)                        X
                      DSH1
         LA    1,MSG
         SVC   35
*MEXIT #=     8 LV= 1 WTO
         STD   F0,DWord                                 DSH2
         SR    R2,R2                                    DSH2
         IC    R2,Dword         exp from DH value       DSH2
         MVI   DWord,x'00'      clear exponent          DSH2
         LG    R0,DWord         R0=64 bit normalized DH DSH2
         LA    R1,X'4E'         exp when decimal at end DSH2
         SR    R1,R2            nibbles to shift        DSH2
         SLL   R1,2             bits to shift           DSH2
         SRLG  R0,R0,0(R1)      shift 64 bits to align  DSH2
         CVD   R0,DWord
         OI    DWord+7,X'0F'
         UNPK  EDigits,DWord
         MVI   ExoneE,C'E'
         MVI   ExpSign,C'+'
         LHI   R1,1
         CVD   R1,DWord
         OI    DWord+7,X'0F'
         UNPK  Exponent,DWord
*MCALL #=     9 LV= 1          ZMFACC CODE,END
*MCALL #=    10 LV= 2       ZMFACC DUMP,ID=2,ST=OUTPUTST,END=OUTPUTEN,NX
               AME='Output Area' RP2
         DS    0H
*MCALL #=    11 LV= 3          SNAP  ID=2,PDATA=,STORAGE=(OUTPUTST,OUTPX
               UTEN),TEXT='Output Area'
         L     14,=A(OUTPUTST)
         L     15,=A(OUTPUTEN)
         IILL  0,2                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'Output Area'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    11 LV= 3 SNAP
*MEXIT #=    10 LV= 2 ZMFACC
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
*MEXIT #=     9 LV= 1 ZMFACC
EH       DC    E'0'
DH       DC    D'0'
MSG      DC    AL2(MSGEND-MSG,0)
DMSG     DC    CL10' ',C'='
DNUM     DC    CL45' '
MSGEND   EQU   *
DWord    DC    D'0'
UnNormer DC    X'4E00000000000000'
*MCALL #=    12 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=    12 LV= 1 ZMFACC
*MCALL #=    13 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    13 LV= 1 ZMFACC
ESign    DS    C
EDecimal DS    C
EDigits  DS    CL6
ExoneE   DS    C
ExpSign  DS    C
Exponent DS    CL2
*MCALL #=    14 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    14 LV= 1 ZMFACC
*MCALL #=    15 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    15 LV= 1 ZMFACC
         END 
