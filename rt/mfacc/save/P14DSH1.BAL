         TITLE 'P14DSH1.MLC - Calc Ackerman function a(4,1)=65533'
* SEE REFERENCE: http://en.wikipedia.org/wiki/Ackermann_function
*MCALL #=     1 LV= 1 P143DSH1  ZMFACC CODE,START,NAME='DON HIGGINS'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P143DSH1 CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P143DSH1(15)
SV0001    DC    18F'0'
         DC    CL8'P143DSH1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P143DX
               SH1 by DON HIGGINS using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P143X
               DSH1 by DON HIGGINS using RUNSYS=390'
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
         ACK  &M,&N
         GBLA &A
         AIF   (&M EQ 0).MEQ0
.MGT0    ANOP
         AIF   (&N EQ 0).NEQ0
.NGT0    ANOP
         AIF   (&M EQ 1).MEQ1
         AIF   (&M EQ 2).MEQ2
&NV      SETA  &N-1
         ACK   &M,&NV
&MV      SETA  &M-1
         ACK   &MV,&A
         MEXIT
.MEQ1    ANOP
&A       SETA  &N+2
         MEXIT
.MEQ2    ANOP
&A       SETA  2*&N+3
         MEXIT
.NEQ0    ANOP
&MV      SETA  &M-1
         ACK   &MV,1
         MEXIT
.MEQ0    ANOP
&A       SETA  &N+1
         MEXIT
         MEND
*MCALL #=     5 LV= 1          ACK   4,1
*MCALL #=     6 LV= 2          ACK   4,0
*MCALL #=     7 LV= 3          ACK   3,1
*MCALL #=     8 LV= 4          ACK   3,0
*MCALL #=     9 LV= 5          ACK   2,1
*MEXIT #=     9 LV= 5 ACK
*MEXIT #=     8 LV= 4 ACK
*MCALL #=    10 LV= 4          ACK   2,5
*MEXIT #=    10 LV= 4 ACK
*MEXIT #=     7 LV= 3 ACK
*MEXIT #=     6 LV= 2 ACK
*MCALL #=    11 LV= 2          ACK   3,13
*MCALL #=    12 LV= 3          ACK   3,12
*MCALL #=    13 LV= 4          ACK   3,11
*MCALL #=    14 LV= 5          ACK   3,10
*MCALL #=    15 LV= 6          ACK   3,9
*MCALL #=    16 LV= 7          ACK   3,8
*MCALL #=    17 LV= 8          ACK   3,7
*MCALL #=    18 LV= 9          ACK   3,6
*MCALL #=    19 LV=10          ACK   3,5
*MCALL #=    20 LV=11          ACK   3,4
*MCALL #=    21 LV=12          ACK   3,3
*MCALL #=    22 LV=13          ACK   3,2
*MCALL #=    23 LV=14          ACK   3,1
*MCALL #=    24 LV=15          ACK   3,0
*MCALL #=    25 LV=16          ACK   2,1
*MEXIT #=    25 LV=16 ACK
*MEXIT #=    24 LV=15 ACK
*MCALL #=    26 LV=15          ACK   2,5
*MEXIT #=    26 LV=15 ACK
*MEXIT #=    23 LV=14 ACK
*MCALL #=    27 LV=14          ACK   2,13
*MEXIT #=    27 LV=14 ACK
*MEXIT #=    22 LV=13 ACK
*MCALL #=    28 LV=13          ACK   2,29
*MEXIT #=    28 LV=13 ACK
*MEXIT #=    21 LV=12 ACK
*MCALL #=    29 LV=12          ACK   2,61
*MEXIT #=    29 LV=12 ACK
*MEXIT #=    20 LV=11 ACK
*MCALL #=    30 LV=11          ACK   2,125
*MEXIT #=    30 LV=11 ACK
*MEXIT #=    19 LV=10 ACK
*MCALL #=    31 LV=10          ACK   2,253
*MEXIT #=    31 LV=10 ACK
*MEXIT #=    18 LV= 9 ACK
*MCALL #=    32 LV= 9          ACK   2,509
*MEXIT #=    32 LV= 9 ACK
*MEXIT #=    17 LV= 8 ACK
*MCALL #=    33 LV= 8          ACK   2,1021
*MEXIT #=    33 LV= 8 ACK
*MEXIT #=    16 LV= 7 ACK
*MCALL #=    34 LV= 7          ACK   2,2045
*MEXIT #=    34 LV= 7 ACK
*MEXIT #=    15 LV= 6 ACK
*MCALL #=    35 LV= 6          ACK   2,4093
*MEXIT #=    35 LV= 6 ACK
*MEXIT #=    14 LV= 5 ACK
*MCALL #=    36 LV= 5          ACK   2,8189
*MEXIT #=    36 LV= 5 ACK
*MEXIT #=    13 LV= 4 ACK
*MCALL #=    37 LV= 4          ACK   2,16381
*MEXIT #=    37 LV= 4 ACK
*MEXIT #=    12 LV= 3 ACK
*MCALL #=    38 LV= 3          ACK   2,32765
*MEXIT #=    38 LV= 3 ACK
*MEXIT #=    11 LV= 2 ACK
*MEXIT #=     5 LV= 1 ACK
*MCALL #=    39 LV= 1          ZMFACC CODE,END
*MCALL #=    40 LV= 2       ZMFACC DUMP,ID=2,ST=OUTPUTST,END=OUTPUTEN,NX
               AME='Output Area' RP2
         DS    0H
*MCALL #=    41 LV= 3          SNAP  ID=2,PDATA=,STORAGE=(OUTPUTST,OUTPX
               UTEN),TEXT='Output Area'
         L     14,=A(OUTPUTST)
         L     15,=A(OUTPUTEN)
         IILL  0,2                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'Output Area'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    41 LV= 3 SNAP
*MEXIT #=    40 LV= 2 ZMFACC
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
*MEXIT #=    39 LV= 1 ZMFACC
*MCALL #=    42 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=    42 LV= 1 ZMFACC
*MCALL #=    43 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    43 LV= 1 ZMFACC
*MCALL #=    44 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    44 LV= 1 ZMFACC
         DC     C'ACKERMAN A(4,1)=65533'
*MCALL #=    45 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    45 LV= 1 ZMFACC
         END 
