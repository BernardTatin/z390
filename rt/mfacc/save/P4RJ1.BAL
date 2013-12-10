* PROBLEM - SORT ARRAY OF FULL WORD INTEGERS USING FASTEST EXEC METHOD
* DATE    - 12/27/07
* AUTHOR  - MATS BROBERG AND ROLAND JOHANSSON, SEB SWEDEN
*
* IT IS AN IMPLEMENTATION OF THE QUICKERSORT ALGORITHM.
*MCALL #=     1 LV= 1 P4RJ1  ZMFACC   CODE,START,NAME='MATS B/ROLAND J X
               SEB'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P4RJ1    CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P4RJ1(15)
SV0001    DC    18F'0'
         DC    CL8'P4RJ1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P4RJ1X
                by MATS B/ROLAND J SEB using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P4RJX
               1 by MATS B/ROLAND J SEB using RUNSYS=390'
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
*                                   START QUICKER SORT
         MVC   AREAOUT,AREAIN
         USING DUMMY0010,WORKAR
         STMY  14,12,S0010          SAVE REGISTERS
         STY   13,R130010           R13 IN OWN AREA
         LAY   0,AREAOUT
         STY   0,UT0010
         LHI   0,20
         STY   0,LT0010
         LAY   15,DUMMY0010         ADDRESS WORKING AREA
         PUSH  USING
         DROP  R13
         USING DUMMY0010,R15
         LHI   10,4                 RECORD LENGTH
         LHI   8,-4                  - RECORD LENGTH
         LY    13,LT0010             NO OF RECORDS
         MHI   13,4                  TOTAL LENGTH
         LY    12,UT0010             I: START OF AREA
         AR    13,12                      FIRST BYTE AFTER AREA
         AHI   13,-4                   J: LAST RECORD
         LHI   5,0                     M: EMPTY STACK
         LAY   2,TMP0010               T: WORK AREA
N0010    EQU   *
         LR    7,13
         SR    7,12           (J-I)*L
         AHI   7,-4           (J-I-1)*L
         BRNP  L3E0010        BRANCH IF 1 OR 2 RECORDS
         AHI   7,4            (J-I)*L      P:=I+(J-I)/2;
         LHI   6,0
         LHI   1,2*4           2*L
         DR    6,1             ((J-I))/2 I R7
         MHI   7,4             *L  IS L*((J-I)/2)
         AR    7,12            +I*L IS L*(I+(J-I)/2)
         MVC   0(4,2),0(7)             T := A(P)
         MVC   0(4,7),0(12)            A(P) := A(I);
         LR    11,13                   Q = J
         LA    9,4(12)                 K = I+1
LP10010  EQU   *
         CLC   0(4,2),0(9)
         BRNL  ND10010         K PLACED CORRECT. TAKE NEXT K
LP20010  EQU   *
         CLC   0(4,2),0(11)
         BRNH  ND20010         Q PLACED CORRECT. NEXT Q
         XC    0(4,11),0(9)              SWITCH K ...
         XC    0(4,9),0(11)                    AND ...
         XC    0(4,11),0(9)                    Q
         AHI   11,-4
         BRU   ND10010
ND20010  EQU   *
        BRXH   11,8,LP20010      LOOP CNTRL FOR Q
         LR    11,9
         AHI   11,-4                I+1 -> Q PCACED CORRECT
         BRU   M0010                      GO TO M;
ND10010  EQU   *
         BRXLE  9,10,LP10010      LOOP CNTRL FOR K
M0010    EQU   *
         MVC   0(4,12),0(11)          M: A(I) := A(Q);
         MVC   0(4,11),TMP0010                  A(Q) := T;
         LR    6,11                 Q
         AHI   11,-4                Q-1
         SLA   6,1                  2*Q
         SR    6,12                 2*Q-I
         SR    6,13                 2*Q-I-J
         BRNP  LWR0010
         STY   12,LT0010(5)      LOWER LIMIT I
         STY   11,UT0010(5)      UPPER LIMIT Q-1
         AHI   11,2*4
         LR    12,11                Q+1
         BRU   UM0010
LWR0010  EQU   *
         STY   13,UT0010(5)      UPPER LIMIT J
         LR    13,11                Q-1
         AHI   11,2*4               Q+1
         STY   11,LT0010(5)      LOWER LIMIT Q+1
UM0010   EQU   *
         AHI   5,4                  MARK ONE MORE IN STACK
         BRU   N0010                MAIN LOOP
L3E0010  EQU   *
         CR    12,13
         BRNL  P0010
         CLC   0(4,12),0(13)
         BRNH  P0010         PLACED CORRECT
         XC    0(4,12),0(13)
         XC    0(4,13),0(12)
         XC    0(4,12),0(13)
P0010    EQU   *
         AHI   5,-4
         BRM   QT0010                     END OF INTERVAL
         LY    12,LT0010(5)               I := LT(M);
         LY    13,UT0010(5)               J := UT(M);
         BRU   N0010                      MAIN LOOP
QT0010   EQU   *
         LY    13,R130010               END QUICKERSORT
         POP   USING
         LMY   14,12,S0010
*MCALL #=     5 LV= 1       ZMFACC   CODE,END
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
*MCALL #=     8 LV= 1       ZMFACC   INPUT,START
INPUTSTR DS    0F
*MEXIT #=     8 LV= 1 ZMFACC
AREAIN   DC    20A(AREAEND-*)
AREAEND  EQU *
*MCALL #=     9 LV= 1       ZMFACC   INPUT,END
INPUTEND  EQU  *
*MEXIT #=     9 LV= 1 ZMFACC
*MCALL #=    10 LV= 1       ZMFACC   OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    10 LV= 1 ZMFACC
AREAOUT  DS    XL80
*MCALL #=    11 LV= 1       ZMFACC   OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
WORKAR   DS    XL512
DUMMY0010 DSECT 
S0010    DS    15F
UT0010   DS    20F                AUXILLARY STORAGE FOR UT ARRAY
LT0010   DS    20F                AUXILLARY STORAGE FOR LT ARRAY
R130010  DS    F                       SAVE AREA FOR REGISTER 13
TMP0010  DS    CL4                            TEMP STORAGE FOR COMPARE
      END 
