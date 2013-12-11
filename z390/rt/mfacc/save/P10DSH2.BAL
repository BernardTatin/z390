*              CONVERT 128 UNSIGNED INTEGER TO DISPLAY DECIMAL
* 01/07/08 DSH1 USE MB1 ROUTINE TO CONVERT 128 BIT #'S IN DSH1
*MCALL #=     1 LV= 1 P10DSH2  ZMFACC   CODE,START,NAME='MATS BROBERG AX
               T SEB SWEDEN'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P10DSH2  CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P10DSH2(15)
SV0001    DC    18F'0'
         DC    CL8'P10DSH2'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P10DSX
               H2 by MATS BROBERG AT SEB SWEDEN using RUNSYS=390'   DSHX
               3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P10DX
               SH2 by MATS BROBERG AT SEB SWEDEN using RUNSYS=390'
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
         LA     R3,INT128       R3=TABLE OF 128 BIT UNSIGNED INTEGERS
         LA     R4,INTDEC       R4=TABLE OF OUTPUT DISPLAY INTEGERS
         LA     R5,TOTINTS      R5=TOTAL INTEGERS
LOOP     DS     0H
         BAS    R10,CVTI128     CONVERT 128 BIT INTO TO DISPLAY
         AHI    R3,16           INC INPUT
         AHI    R4,L'RES        INC OUTPUT
         BCT    R5,LOOP
         LM     R0,R3,=A(INTDEC,LINTDEC,VERDEC,LINTDEC)
         CLCL   R0,R2
         BZ     VEROK
*MCALL #=     5 LV= 1          WTO    'VERIFY ERROR - CALCULATED VERSUSX
                EXPECTED DIFFERENCE'
         BRAS  1,*+(WTO#0005_EOT-*+1)/2*2
         DC    AL2(WTO#0005_EOT-*,0),C'VERIFY ERROR - CALCULATED VERSUSX
                EXPECTED DIFFERENCE'
WTO#0005_EOT     EQU *
         SVC   35
*MEXIT #=     5 LV= 1 WTO
         B      EXIT
VEROK    DS     0H
*MCALL #=     6 LV= 1          WTO    'VERIFY OK - CALCULATED EQUALS EXX
               PECTED DISPLAY VALUES'
         BRAS  1,*+(WTO#0006_EOT-*+1)/2*2
         DC    AL2(WTO#0006_EOT-*,0),C'VERIFY OK - CALCULATED EQUALS EXX
               PECTED DISPLAY VALUES'
WTO#0006_EOT     EQU *
         SVC   35
*MEXIT #=     6 LV= 1 WTO
EXIT     DS     0H
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
INT128   DS     0D            TABLE OF 128 BIT UNSIGNED INTS TO CVT
         DC     FL8'0,0'                            0
         DC     FL8'0,1'                            1
         DC     FL8'0,1E18'                         10**18
         DC     FL8'0',X'7F',7X'FF'                 2**63-1
         DC     FL8'0',X'8AC7230489E80000' 10**19 = 1E18 * 10 VIA MLG
         DC     FL8'0',8X'FF'                       2**64-1
         DC     FL8'1',8X'FF'                       2**65-1
         DC     X'00000000000000056BC75E2D63100000' 10**20
         DC     X'3F',15X'FF'                       2**126-1
         DC     X'7F',15X'FF'                       2**127-1
         DC     16x'BB'                             P10MB1 CONSTANT
         DC     X'FF',15X'FF'                       2**128-1
INTEND   EQU    *
TOTINTS  EQU    (INTEND-INT128)/16
*MCALL #=    11 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
*MCALL #=    12 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    12 LV= 1 ZMFACC
         DC     C'TABLE OF EXPECTED DISPLAY INTEGERS='
* Ref: http://www.newdream.net/~sage/old/numbers/pow2.htm
VERDEC   DS     0D      TABLE OF EXPECTED DECIMAL RESULTS
 DC C'                                                     0'  0
 DC C'                                                     1'  1
 DC C'                             1,000,000,000,000,000,000'  1E18
 DC C'                             9,223,372,036,854,775,807'  2**63-1
 DC C'                            10,000,000,000,000,000,000'  1E19
 DC C'                            18,446,744,073,709,551,615'  2**64-1
 DC C'                            36,893,488,147,419,103,231'  2**65-1
 DC C'                           100,000,000,000,000,000,000'  1E20
 DC C'    85,070,591,730,234,615,865,843,651,857,942,052,863'  2**126-1
 DC C'   170,141,183,460,469,231,731,687,303,715,884,105,727'  2**127-1
 DC C'   249,540,402,408,688,206,539,808,045,449,963,355,067'  P10MB1 #
 DC C'   340,282,366,920,938,463,463,374,607,431,768,211,455'  2**128-1
         DC     C'TABLE OF CALCULATED DISPLAY INTEGERS='
INTDEC   DS    0D       TABLE OF DISPLAY INTEGERS
         DC    ((INTEND-INT128)/16)CL(L'RES)' '
LINTDEC  EQU   *-INTDEC
*MCALL #=    13 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    13 LV= 1 ZMFACC
*
* CONVERT 128 BIT UNSIGEND INT AT R3 TO DISPLAY AT R4
*
CVTI128  DS     0H
         LMG   6,7,0(R3)  R6-R7 = 128 BIT INSIGNED INT
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
         MVC   0(L'RES,R4),RES
         BR    R10
RES      DS    CL(MASKL)
MASK     DC    3X'40',12X'2020206B',X'202120'
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
