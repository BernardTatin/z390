*********************************************************************
* Z390 MAINFRAME ASSEMBLER CODING CONTEST PROBLEM #16.
*********************************************************************
*********************************************************************
*MCALL #=     1 LV= 1 P16WR1   ZMFACC CODE,START,NAME='WERNER RAMS',RUNX
               SYS=390
         MNOTE 'ZRUNSYS=390'                          DSH2
P16WR1   CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P16WR1(15)
SV0001    DC    18F'0'
         DC    CL8'P16WR1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P16WRX
               1 by WERNER RAMS using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P16WX
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
         LA     R4,TABELLE
         LA     R5,MAXPRIME
         SR     R2,R2
         LA     R6,2          FIRST PRIME
LOOP010  EQU    *
         CVD    R6,DW
         MVC    PRIMNR,=X'40202120'
         ED     PRIMNR,DW+6
*MCALL #=     5 LV= 1          WTO    MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=     5 LV= 1 WTO
         BAS    R12,SETBIT
         BAS    R12,SUCHBIT
         MVI    LAR6+3,2      INCREASE BY 2 FROM PRIME NR 3
         CR     R6,R5
         BL     LOOP010       NEXT PRIME NR IN R6
         B      END000
SETBIT   EQU    *   SET ALL BITS THAT ARE MULTIPE OF CURRENT PRIM
         LA     R1,0(R6,R6)   LET BIT OF CURRENT PRIME REMAIN ZERO
SET010   EQU    *
         CR     R1,R5
         BNL    SET100
         LR     R14,R1
         SRDL   R14,3      R14 = DISPLACEMENT IN TABELLE
         SRL    R15,29     R15 = DISPLACEMENT IN BITTAB
         AR     R14,R4
         IC     R2,BITTAB(R15)
         EX     R2,OIBIT   OI    0(R14),0
         AR     R1,R6
         B      SET010
SET100   EQU    *
         BR     R12
SUCHBIT  EQU    *    SEARCH NEXT BIT, THAT IS ZERO
LAR6     LA     R6,1(R6)
         CR     R6,R5
         BNL    SUCH100
         LR     R14,R6
         SRDL   R14,3      R14 = DISPLACEMENT IN TABELLE
         SRL    R15,29     R15 = DISPLACEMENT IN BITTAB
         AR     R14,R4
         IC     R2,BITTAB(R15)
         EX     R2,TMBIT   TM    0(R14),0
         BO     SUCHBIT    BIT ALREADY SET
SUCH100  EQU    *
         BR     R12
END000   EQU    *
*MCALL #=     6 LV= 1          ZMFACC CODE,END
*MCALL #=     7 LV= 2       ZMFACC DUMP,ID=2,ST=OUTPUTST,END=OUTPUTEN,NX
               AME='Output Area' RP2
         DS    0H
*MCALL #=     8 LV= 3          SNAP  ID=2,PDATA=,STORAGE=(OUTPUTST,OUTPX
               UTEN),TEXT='Output Area'
         L     14,=A(OUTPUTST)
         L     15,=A(OUTPUTEN)
         IILL  0,2                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'Output Area'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=     8 LV= 3 SNAP
*MEXIT #=     7 LV= 2 ZMFACC
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
*MEXIT #=     6 LV= 1 ZMFACC
*
OIBIT    OI     0(R14),0
TMBIT    TM     0(R14),0
*
*MCALL #=     9 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=     9 LV= 1 ZMFACC
*MCALL #=    10 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    10 LV= 1 ZMFACC
*MCALL #=    11 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    11 LV= 1 ZMFACC
MAXPRIME EQU    100
TABELLE  DC     (MAXPRIME/8+1)X'00'
*MCALL #=    12 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    12 LV= 1 ZMFACC
WTOMSG   DC     AL2(WTOEND-WTOMSG,0),C'PRIME ='
PRIMNR   DS     CL4
WTOEND   EQU    *
DW       DS     D
BITTAB   DC     X'8040201008040201'
         END 
