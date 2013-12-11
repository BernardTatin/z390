*********************************************************************
* #10 Convert 128 unsigned integer to display decimal
*********************************************************************
*
*   1.  Load 128 bit unsigned integer to convert in R0-R1.
*   2.  If high bit on, move 2**127 digits to PD counters.
*   3.  Turn off high bit so number is divible by 1E19 w/o overflow.
*   4.  Divide by unsigned 1E19 giving 64 bit remainder and quotent.
*   5.  Convert unsigned 64 bit remainder and quotent to PD.
*   6.  Add remainder to low 19 digit PD counter with possible carry.
*   7.  Add any carry and quotent to high 20 digit PD counter.
*   8.  Unpack low 19 digit counter with editing to insert commas.
*   9.  Unpack high 20 digit counter with editing to insert commas.
*
*********************************************************************
* 01/06/08 DSH1 add P10MB1 constant 16x'bb' to verify result
*********************************************************************
*MCALL #=     1 LV= 1 P10DSH1  ZMFACC CODE,START,NAME='Don Higgins'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P10DSH1  CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P10DSH1(15)
SV0001    DC    18F'0'
         DC    CL8'P10DSH1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P10DSX
               H1 by Don Higgins using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P10DX
               SH1 by Don Higgins using RUNSYS=390'
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
         USING  INTDECD,R4
         LA     R5,TOTINTS      R5=TOTAL INTEGERS
LOOP     DS     0H
         BAS    R10,CVTI128     CONVERT 128 BIT INTO TO DISPLAY
         AHI    R3,16           INC INPUT
         AHI    R4,LINTDECD     INC OUTPUT
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
         DC     C'TABLE OF EXPECTED DISPLAY UNSIGNED INTEGERS='
* Ref: http://www.newdream.net/~sage/old/numbers/pow2.htm
VERDEC   DS    0D  TABLE OF EXPECTED DECIMAL RESULTS
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
         DC     C'  CALCULATED DISPLAY UNSIGNED INTEGERS='
INTDEC   DS     0D    TABLE OF CALCULATED DISPLAY INTEGERS
         DC    ((INTEND-INT128)/16*LINTDECD)C' '
LINTDEC  EQU   *-INTDEC
*MCALL #=    13 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    13 LV= 1 ZMFACC
*
* CONVERT 128 BIT UNSIGEND INT AT R3 TO DISPLAY AT R4
*
CVTI128  DS     0H
         LMG    R0,R1,0(R3)     R0-R1=INPUT 128 BIT UNSIGNED INTEGER
         TMHH   R0,X'8000'      IF HIGH BIT ON
         BZ     CLEAR
         NIHH   R0,X'7FFF'          TURN HIGH BIT OFF
         ZAP    PLOW,PD127L         MOVE 2*127 LOW  19 DIGITS
         ZAP    PHIGH,PD127H        MOVE 2*127 HIGH 20 DIGITS
         B      DIVIDE
CLEAR    DS     0H
         ZAP    PLOW,=P'0'
         ZAP    PHIGH,=P'0'
DIVIDE   DS     0H
         DLG    R0,UG1E19       DIVIDE BY UNSIGNED 64 BIT 1E19
         BAS    R11,USCVDG      CONVERT UNSIGNED REMAINDER TO PD
         AP     PLOW,PWORK      ADD REMAINDER TO LOW 19 PD DIGITS
         TM     PLOW,X'01'      IF CARRY INTO 20TH DIGIT
         BZ     NOCARRY
         AP     PHIGH,=P'1'        ADD 1 TO HIGH 20 DIGITS
NOCARRY  DS     0H
         LGR    R0,R1
         BAS    R11,USCVDG      CONVERT UNSIGNED QUOTENT TO PD
         AP     PHIGH,PWORK     ADD QUOTENT TO HIGH 20 PD DIGITS
         BZ     NOLEAD          IF HIGH DIGITS NOT ZERO
         MVI    PLOW,X'01'        FORCE LEADING ZEROS FOR LOW DIGITS
NOLEAD   DS     0H                (NOTE 2 DIGIT OVERLAY OF HIGH/LOW)
         MVC    DLOW,MASKL21    MOVE EDIT MASK FOR LOW 19 DIGITS + 2
         ED     DLOW,PLOW       CONVERT LOW 19 DIGITS TO DISPLAY + 2
         MVC    DHIGH,MASKH21   MOVE EDIT MASK FOR HIGH 20 DIGITS + 1
         ED     DHIGH,PHIGH     CONVERT HIGH 20 DIGITS TO DISPLAY + 1
         BR     R10
*
* CONVERT UNSIGNED 64 BIT R0 TO PL16 PWORK AND EXIT R11
*
USCVDG   DS     0H
         TMHH   R0,X'8000' IF HIGH BIT ON
         BZ     USCVDGOK
         NIHH   R0,X'7FFF'    TURN OFF HIGH BIT
         CVDG   R0,PWORK      CONVERT AS POSITIVE 63 BITS
         AP     PWORK,PD2P63  ADD 2**63 FOR HIGH BIT
         BR     R11
USCVDGOK DS     0H
         CVDG   R0,PWORK      CONVERT POSITIVE 64 BITS
         BR     R11
PWORK    DC     PL16'0'         WORK AREA FOR CVDG
PHIGH    DC     PL11'0'         HIGH 20 DIGITS PLUS 1
PLOW     DC     PL11'0'         LOW  19 DIGITS PLUS 2 FOR CARRY
UG1E19   DC     X'8AC7230489E80000' UNSIGNED 1E19 (F'1E18' * 10)
PD127H   DC     PL16'17014118346046923173' HIGH 20 DIGITS OF 2*127
PD127L   DC     PL16'1687303715884105728'  LOW  19 DIGITS OF 2*127
PD2P63   DC     PL16'9223372036854775808'  2**63 FOR HIGH BIT OF R/Q
MASKH21  DC     C' ',X'20',C',',6AL1(X'20',X'20',X'20',C','),X'2020'
MASKL21  DC     C' ',6AL1(X'20',X'20',X'20',C','),X'202120'
INTDECD  DSECT 
DHIGH    DS     C' 0,ZZZ,ZZZ,ZZZ,ZZZ,ZZZ,ZZZ,ZZ' HIGH 20 DIGITS
         ORG    *-3   BACKUP TO OVERLAY FILLER AND CARRY DIGITS
DLOW     DS     C' CCZ,ZZZ,ZZZ,ZZZ,ZZZ,ZZZ,ZZZ'  LOW  19 DIGITS
LINTDECD EQU    *-INTDECD
         END 
