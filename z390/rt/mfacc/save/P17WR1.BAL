*********************************************************************
* Z390 MAINFRAME ASSEMBLER CODING CONTEST PROBLEM #17.
*********************************************************************
*********************************************************************
*MCALL #=     1 LV= 1 P17WR1   ZMFACC CODE,START,NAME='WERNER RAMS',RUNX
               SYS=390
         MNOTE 'ZRUNSYS=390'                          DSH2
P17WR1   CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P17WR1(15)
SV0001    DC    18F'0'
         DC    CL8'P17WR1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P17WRX
               1 by WERNER RAMS using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P17WX
               R1 by WERNER RAMS using RUNSYS=390'
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
         LA     R10,EIN1
         LA     R11,COMP1
         LA     R12,LENG1
         BAS    R14,COMPR000
         LA     R10,EIN2
         LA     R11,COMP2
         LA     R12,LENG2
         BAS    R14,COMPR000
         LA     R10,EIN3
         LA     R11,COMP3
         LA     R12,LENG3
         BAS    R14,COMPR000
         LA     R10,COMP1
         LA     R11,DCOMP1
         BAS    R14,DCOMP000
         LA     R10,COMP2
         LA     R11,DCOMP2
         BAS    R14,DCOMP000
         LA     R10,COMP3
         LA     R11,DCOMP3
         BAS    R14,DCOMP000
         B      END000
*     COMPRESS STRING ADR IN R10 TO ADR IN R11
COMPR000 EQU    *
         ST     R14,SAR14
         LR     R14,R10         EIN
         LA     R15,80          LENGTH OF INPUT
         LR     R9,R11          ANFADDR COMPX
COMPR010 EQU    *
         LR     R2,R14          CURRENT ADDRESS IN INPUT
         LTR    R15,R15         R15=LENGTH OF REST
         BZ     COMPR100
         LR     R1,R15          REST-LENGTH
         CLI    0(R14),X'40'
         BNE    COMPR020        FIRST BYTE IS NOT BLANK
         SR     R0,R0
         SR     R1,R1
         ICM    R1,8,=X'40'     PADDING CHAR = BLANK
         CLCL   R14,R0          SEARCH FOR NEXT NONBLANK
         LR     R1,R14          = ADDRESS OF FIRST NONBLANK CHAR
         SR     R1,R2           COUNT OF BLANK BYTES
         STC    R1,0(R11)       LENGHT OF BLANKS
         OI     0(R11),X'80'    MARK AS COUNT OF BLANKS
         AHI    R11,1           NEXT ADDRESS IN OUTPUT
         B      COMPR010
COMPR020 EQU    *
         LA     R0,X'40'         SEARCH FOR NEXT BLANK
COMPR030 EQU    *
         LR     R1,R10
         AR     R1,R15           ENDADDRESS OF SEARCH
         SRST   R1,R14           LOOK FOR NEXT BLANK
         BC     1,COMPR030       REPEAT SEARCH
COMPR040 EQU    *
         LR     R14,R1           ADDRESS OF NEXT BLANK
         SR     R1,R2            LENGTH OF NON-BLANK
         SR     R15,R1           LENGTH OF REST
         STC    R1,0(R11)
         AHI    R1,-1
         EX     R1,MVCDATEN      MVC    1(0,R11),0(R2)
         LA     R11,2(R1,R11)    NEXT ADDRESS IN OUTPUT
         B      COMPR010
COMPR100 EQU    *
         MVI    0(R11),X'00'     MARK END OF COMPRESSED STRING
         LA     R11,1(R11)
         SR     R11,R9           LENG AUS
         STH    R11,0(R12)
COMPR900 EQU    *
         L      R14,SAR14
         BR     R14
*     DECOMPRESS STRING ADR IN R10 TO ADR IN R11
DCOMP000 EQU    *
         ST     R14,SAR14
         SR     R1,R1
DCOMP010 EQU    *
         CLI    0(R10),0
         BE     DCOMP100
         TM     0(R10),X'80'
         BO     DCOMP020
         IC     R1,0(R10)      LENGTH OF TEXT
         AHI    R1,-1
         EX     R1,MVCTEXT     MVC   0(0,R11),1(R10)
         LA     R10,2(R1,R10)  NEXT ADDRESS IN COMPRESSED INPUT
         LA     R11,1(R1,R11)  NEXT ADDRESS IN DECOMPRESSED FIELD
         B      DCOMP010
DCOMP020 EQU    *              DECOMPRESS COMPRESSED BLANKS
         IC     R1,0(R10)
         AHI    R1,-129        -X'80' AND -1 FOR EX
         EX     R1,MVCBLANK    MVC   0(0,R11),BLANK
         AHI    R10,1          NEXT ADDRESS IN COMPRESSED INPUT
         LA     R11,1(R1,R11)  NEXT ADDRESS IN DECOMPRESSED FIELD
         B      DCOMP010
DCOMP100 EQU    *
         L      R14,SAR14
         BR     R14
MVCDATEN MVC    1(0,R11),0(R2)
MVCTEXT  MVC    0(0,R11),1(R10)
MVCBLANK MVC    0(0,R11),BLANK
END000   EQU    *
*MCALL #=     5 LV= 1          ZMFACC CODE,END
*MCALL #=     6 LV= 2       ZMFACC DUMP,ID=2,ST=OUTPUTST,END=OUTPUTEN,NX
               AME='Output Area' RP2
         DS    0H
*MCALL #=     7 LV= 3          SNAP  ID=2,PDATA=,STORAGE=(OUTPUTST,OUTPX
               UTEN),TEXT='Output Area'
         L     14,=A(OUTPUTST)
         L     15,=A(OUTPUTEN)
         IILL  0,2                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'Output Area'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=     7 LV= 3 SNAP
*MEXIT #=     6 LV= 2 ZMFACC
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
*MEXIT #=     5 LV= 1 ZMFACC
SAR14    DS     F
BLANK    DC     CL80' '
*MCALL #=     8 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=     8 LV= 1 ZMFACC
EIN1     DC     CL80'LABEL     OPCODE PARMS'
EIN2     DC     CL80'          AP    FELD1,FELD2'
EIN3     DC     CL80'ANF010    CLC   FELD1,FELD2   COMPARE F1 WITH F2'
*MCALL #=     9 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=     9 LV= 1 ZMFACC
*MCALL #=    10 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    10 LV= 1 ZMFACC
DCOMP1   DS     CL80
DCOMP2   DS     CL80
DCOMP3   DS     CL80
LENG1    DS     H
COMP1    DC     78X'FF'
LENG2    DS     H
COMP2    DC     78X'FF'
LENG3    DS     H
COMP3    DC     78X'FF'
*MCALL #=    11 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
         LTORG 
*  THIS MAKES THE LAST 3 BYTES OF THE REAL ADDRESS
*  EQUAL TO THE RELATIVE ADDRESS IN THE .PRN-FILE
         ORG    P17WR1+X'1000'
*
         END 
