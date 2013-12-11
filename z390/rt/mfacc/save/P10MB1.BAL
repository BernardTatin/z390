*              CONVERT 128 UNSIGNED INTEGER TO DISPLAY DECIMAL
*MCALL #=     1 LV= 1 P10MB1   ZMFACC   CODE,START,NAME='MATS BROBERG AX
               T SEB SWEDEN'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P10MB1   CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P10MB1(15)
SV0001    DC    18F'0'
         DC    CL8'P10MB1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P10MBX
               1 by MATS BROBERG AT SEB SWEDEN using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P10MX
               B1 by MATS BROBERG AT SEB SWEDEN using RUNSYS=390'
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
*
         LMG   6,7,INPUT        THE NUMBER IS R6*2**64 + R7
* 2**64 = 10**19 + 8446 744 073 709 551 616 = POT10 + B
* R6*2**64 + R7 =
* R6*(POT10 + B) + R7  =
* R6*POT10  + R6*B + R7
*
* ONLY R6*B + R7 CONTRIBUTE TO THE RIGHTMOST 19 DECIMAL DIGITS
* IT MAY VERY WELL CONTRIBUTE TO THE LEFTMOST 20 DIGITS ALSO.
* WE WILL FIRST COMPUTE R6*B + R7
*
         LGR   9,6              COMPUTE R6 ...
         MLG   8,B              ... TIMES B INTO R8-R9
         ALGR  9,7              ADD R7
         ALCG  8,NULL           ADD ANY CARRY INTO R8
* R6*B + R7 NOW EQUALS R8*2**64 + R9
* DIVIDING BY POT10 WILL GIVE THE REMAINDER IN R8 AND THAT IS THE
* RIGHTMOST 19 DIGITS. R9 CONTAINS WHAT CONTRIBUTES TO THE LEFTMOST
* 20 DIGITS.
         DLG   8,POT10
* AND NOW THE SAME NUMBER (R6*B + R7) IS R9*POT10 + R8
* THE NUMBER WE STARTED WITH IS           R6*POT10 + R9*POT10 + R8 =
* THE NUMBER WE STARTED WITH IS           (R6 + R9)*POT10 + R8
* IN THE PACKED FORMAT THEY WILL GO INTO   L2   L1          H
* SO FAR THE ARITHMETIC HAS BEEN UNSIGNED, BUT CVDG IS SENSITIVE TO
* THE SIGN. SO WE MUST COMPENSATE FOR THAT.
* FIRST THE RIGHTMOST 19 DIGITS IN R8
         CVDG  8,H
         LTGR  8,8
         BNM   NOTMIN0
          AP   H,TVATO64
* THEN ONE PART OF THE VALUE IN THE FIRST 20 POSITIONS
NOTMIN0  CVDG  9,L1
         LTGR  9,9
         BNM   NOTMIN1
          AP   L1,TVATO64
* AND THE NEXT PART
NOTMIN1  CVDG  6,L2
         LTGR  6,6
         BNM   NOTMIN2
          AP   L2,TVATO64
* FINALLY ADD THE TWO LEFT PARTS.
NOTMIN2  AP    L2,L1
         SRP   L2,1,0
         MVC   HD(10),L2+5
         MVC   RES,MASK
         ED    RES,HD
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
INPUT    DC    0FD,XL16'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB'
*MCALL #=     9 LV= 1       ZMFACC   INPUT,END
INPUTEND  EQU  *
*MEXIT #=     9 LV= 1 ZMFACC
*MCALL #=    10 LV= 1       ZMFACC   OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    10 LV= 1 ZMFACC
RES      DS    CL(MASKL)
*MCALL #=    11 LV= 1       ZMFACC   OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
MASK     DC    X'40',12X'20202040',X'202120'
MASKL    EQU   *-MASK
         DS    0FD
NULL     DC    16X'0'
POT10    DC    X'8AC7230489E80000'      10000000000000000000 (10**19)
B        DC    X'7538DCFB76180000'       8446744073709551616
TVATO64  DC    PL16'18446744073709551616' X'10000000000000000'
HD       DS    XL20
H        EQU   HD+4,16,C'P'
L1       DS    PL16
L2       DS    PL16
      END 
