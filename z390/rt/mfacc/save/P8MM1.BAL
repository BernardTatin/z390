*MCALL #=     1 LV= 1 P8MM1    ZMFACC CODE,START,NAME='MELVYN MALTZ',RUX
               NSYS=390
         MNOTE 'ZRUNSYS=390'                          DSH2
P8MM1    CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P8MM1(15)
SV0001    DC    18F'0'
         DC    CL8'P8MM1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P8MM1X
                by MELVYN MALTZ using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P8MMX
               1 by MELVYN MALTZ using RUNSYS=390'
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
* I THINK THIS IS CALLED THE INVERSE TANGENT METHOD
* ATTRIBUTED TO GREGORY/MACHIN 17TH CENTURY
*
* OPTIMIZED FOR SPEED AND GIVES PI TO 31 DEC POS
* CHECKED WITH WEB SITE, LAST DIGITS ARE ...33832795 0288
*********************************************************************
* 12/22/07 DSH1 Don Higgins - added diff from ref. calc of PI
*********************************************************************
         LA    R2,45              CYCLE CONTROL
*
         LA    R3,1               N
         LXD   F1,=DH'5'          F1/F3=5
         LXD   F4,=DH'1'          F4/F6=1  MULTIPLIER
         LZXR  R8                 ZERO THE 5'S TERMS
         LZXR  R9                 ZERO THE 239'S TERMS
         LXD   F12,=DH'2'         F12/F13  INCREMENT
LOOP5    DS    0H
         LR    R4,R3              SAVE FOR LOOPING
         LXD   F0,=DH'1'          F0/F1=1  POWER
         LXD   F5,=DH'1'          F5/F7=1  FORM RECIPROCAL
POWER5   DS    0H
         MXR   F0,F1              5^N
         BCT   R4,POWER5          LOOP
         MXR   F0,F4              N*5^N
         DXR   F5,F0              1/(N*5^N)
         CLI   SIGN,X'00'         +VE ?
         BNE   NEG5               EXIT IF NOT
         AXR   F8,F5              ADD TERM
         XI    SIGN,X'FF'         FLIP SIGN
         B     CYCLE5             EXIT
*
NEG5     DS    0H
         SXR   F8,F5              SUBTRACT TERM
         XI    SIGN,X'FF'         FLIP SIGN
CYCLE5   DS    0H
         CR    R3,R2              CYCLE DONE ?
         BE    DO239              EXIT IF IT IS
         AHI   R3,2               N+2
         AXR   F4,F12             MULTIPLIER+2
         B     LOOP5              LOOP THRU TERMS5
*
DO239    EQU   *
* OPTIMAL SOLUTION FOR TERMS239 REACHED AFTER 7 CYCLES
         LA    R2,13              RESTRICT TO 7 CYCLES
         MVI   SIGN,X'00'         RESET SIGN
         LA    R3,1               N
         LXD   F1,=DH'239'        F1/F3=239
         LXD   F4,=DH'1'          F4/F6=1  MULTIPLIER
LOOP239  DS    0H
         LR    R4,R3              SAVE FOR LOOPING
         LXD   F0,=DH'1'          F0/F1=1  POWER
         LXD   F5,=DH'1'          F5/F7=1  FORM RECIPROCAL
POWER239 DS    0H
         MXR   F0,F1              239^N
         BCT   R4,POWER239        LOOP
         MXR   F0,F4              N*239^N
         DXR   F5,F0              1/(N*239^N)
         CLI   SIGN,X'00'         +VE ?
         BNE   NEG239             EXIT IF NOT
         AXR   F9,F5              ADD TERM
         XI    SIGN,X'FF'         FLIP SIGN
         B     CYCLE239           EXIT
*
NEG239   DS    0H
         SXR   F9,F5              SUBTRACT TERM
         XI    SIGN,X'FF'         FLIP SIGN
CYCLE239 DS    0H
         CR    R3,R2              CYCLE DONE ?
         BE    DUNBOTH            EXIT IF IT IS
         AHI   R3,2               N+2
         AXR   F4,F12             MULTIPLIER+2
         B     LOOP239            LOOP THRU TERMS239
*
DUNBOTH  DS    0H
         LXD   F0,=DH'4'          F0/F1=4
         MXR   R8,R0              TERMS5*4
         SXR   R8,R9              TERMS5*4-TERMS239
         MXR   R8,R0              4*(TERMS5*4-TERMS239)
*MCALL #=     5 LV= 1          CTD   CTD_LH,IN=R8,OUT=PI
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
         LA    1,=A(CTD_LH,R8,PI)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=     5 LV= 1 CTD
         LD    F0,LHPI                                         DSH1
         LD    F0+2,LHPI+8                                     DSH1
         SXR   F0,F8                                           DSH1
*MCALL #=     6 LV= 1          CTD   CTD_LH,IN=F0,OUT=PIDIF            X
                             DSH1
         LA    1,=A(CTD_LH,F0,PIDIF)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=     6 LV= 1 CTD
*MCALL #=     7 LV= 1          SNAP  ID=3,PDATA=,STORAGE=(PIDIF,PIDIF+4X
               5),TEXT='DIF' DSH1
         L     14,=A(PIDIF)
         L     15,=A(PIDIF+45)
         IILL  0,3                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'DIF'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=     7 LV= 1 SNAP
*
*MCALL #=     8 LV= 1          ZMFACC CODE,END
*MCALL #=     9 LV= 2       ZMFACC DUMP,ID=2,ST=OUTPUTST,END=OUTPUTEN,NX
               AME='Output Area' RP2
         DS    0H
*MCALL #=    10 LV= 3          SNAP  ID=2,PDATA=,STORAGE=(OUTPUTST,OUTPX
               UTEN),TEXT='Output Area'
         L     14,=A(OUTPUTST)
         L     15,=A(OUTPUTEN)
         IILL  0,2                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'Output Area'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    10 LV= 3 SNAP
*MEXIT #=     9 LV= 2 ZMFACC
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
*MEXIT #=     8 LV= 1 ZMFACC
*
*MCALL #=    11 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=    11 LV= 1 ZMFACC
*MCALL #=    12 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    12 LV= 1 ZMFACC
*
SIGN     DC    X'00'
*MCALL #=    13 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    13 LV= 1 ZMFACC
PI       DS    CL45
*MCALL #=    14 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    14 LV= 1 ZMFACC
* PI REF http://www.jimloy.com/geometry/pi.htm                 DSH1
LHPI     DC    LH'3.141592653589793238462643383279502'         DSH1
PIDIF    DC    CL45' '                                         DSH1
         END 
