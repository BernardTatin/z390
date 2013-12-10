*MCALL #=     1 LV= 1 P3MM1    ZMFACC CODE,START,NAME='Melvyn Maltz'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P3MM1    CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P3MM1(15)
SV0001    DC    18F'0'
         DC    CL8'P3MM1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P3MM1X
                by Melvyn Maltz using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P3MMX
               1 by Melvyn Maltz using RUNSYS=390'
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
         LA    R1,TRANHEX         R1=TRANSLATE TABLE ADDRESS
         LA    R6,MYSHOW          DESTINATION ADDRESS
         LA    R7,6               SOURCE LENGTH
         LA    R8,MYHEX           SOURCE ADDRESS
RETRY    EQU   *
         TROT  R6,R8,1            TRANSLATE TO PRINTABLE HEX
         BC    1,RETRY            RETRY REQ'D FOR MF PER MICHAEL POIL
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
*MCALL #=     8 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=     8 LV= 1 ZMFACC
MYHEX    DC    X'FFA193BC120A'    HEX DATA
*MCALL #=     9 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=     9 LV= 1 ZMFACC
*MCALL #=    10 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    10 LV= 1 ZMFACC
MYSHOW   DS    CL12               RESULT
*MCALL #=    11 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
TRANHEX  DC    C'000102030405060708090A0B0C0D0E0F'  00-0F
         DC    C'101112131415161718191A1B1C1D1E1F'  10-1F
         DC    C'202122232425262728292A2B2C2D2E2F'  20-2F
         DC    C'303132333435363738393A3B3C3D3E3F'  30-3F
         DC    C'404142434445464748494A4B4C4D4E4F'  40-4F
         DC    C'505152535455565758595A5B5C5D5E5F'  50-5F
         DC    C'606162636465666768696A6B6C6D6E6F'  60-6F
         DC    C'707172737475767778797A7B7C7D7E7F'  70-7F
         DC    C'808182838485868788898A8B8C8D8E8F'  80-8F
         DC    C'909192939495969798999A9B9C9D9E9F'  90-9F
         DC    C'A0A1A2A3A4A5A6A7A8A9AAABACADAEAF'  A0-AF
         DC    C'B0B1B2B3B4B5B6B7B8B9BABBBCBDBEBF'  B0-BF
         DC    C'C0C1C2C3C4C5C6C7C8C9CACBCCCDCECF'  C0-CF
         DC    C'D0D1D2D3D4D5D6D7D8D9DADBDCDDDEDF'  D0-DF
         DC    C'E0E1E2E3E4E5E6E7E8E9EAEBECEDEEEF'  E0-EF
         DC    C'F0F1F2F3F4F5F6F7F8F9FAFBFCFDFEFF'  F0-FF
         LTORG 
         END 
