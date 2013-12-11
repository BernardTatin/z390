*********************************************************************
*  ACKERMAN PROGRAM                                                 *
*                                                                   *
*  Input is M and N (PL16)                                          *
*  Output is RESULT (PL16)                                          *
*                                                                   *
*********************************************************************
*
*MCALL #=     1 LV= 1 P14MW1   ZMFACC CODE,START,RUNSYS=390,NAME='MartiX
               n Ward'
         MNOTE 'ZRUNSYS=390'                          DSH2
P14MW1   CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P14MW1(15)
SV0001    DC    18F'0'
         DC    CL8'P14MW1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P14MWX
               1 by Martin Ward using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P14MX
               W1 by Martin Ward using RUNSYS=390'
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
* START OF ACKERMAN COMPUTATION: RESULT = A(M,N)
*
ACKERMAN EQU   *
         ZAP   RESULT,N
         CP    M,=P'1'
  BH    M2
* M=0 or 1, RESULT=N+M+1
         AP    RESULT,M
         BO    TOOBIG
         AP    RESULT,=P'1'
         BO    TOOBIG
         B     ACK999
*
M2       EQU   *
         CP    M,=P'2'
         BH    M3
* M=2, RESULT=2N+3
         MP    RESULT,=P'2'
         AP    RESULT,=P'3'
         BO    TOOBIG
         B     ACK999
*
M3       EQU   *
         CP    M,=P'3'
         BH    M4
* M=3, RESULT=2**(N+3)-3
         CP    N,=P'99'  A(3,99) is the limit for 31 digits
         BH    TOOBIG
         ZAP   WORK,N
  AP    WORK,=P'3'
  ZAP   RESULT,=P'1'
M3LOOP  CP    WORK,=P'0'
  BE    M3EXIT
         MP    RESULT,=P'2'
         SP    WORK,=P'1'
         B     M3LOOP
M3EXIT   SP    RESULT,=P'3'
         B     ACK999
*
M4       EQU   *
         CP    M,=P'4'
         BH    M5
* M=4, CHECK N
         CP    N,=P'0'
         BH    M51
         ZAP   RESULT,A40
         B     ACK999
M51      CP    N,=P'1'
         BH    TOOBIG
         ZAP   RESULT,A41
         B     ACK999
*
M5       EQU   *
         CP    M,=P'5'
         BH    TOOBIG
* M=5, CHECK N
         CP    N,=P'0'
         BH    TOOBIG
         ZAP   RESULT,A50
         B     ACK999
TOOBIG   ZAP   RESULT,=P'-1'
*
ACK999   EQU   *
*
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
*
*MCALL #=     8 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=     8 LV= 1 ZMFACC
M        DC    PL16'4'
N        DC    PL16'1'
*MCALL #=     9 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=     9 LV= 1 ZMFACC
*MCALL #=    10 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    10 LV= 1 ZMFACC
RESULT   DC    PL16'0'
*MCALL #=    11 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
WORK     DC    PL16'0'                 USED TO COMPUTE 2**(N+3)
A40      DC    P'13'                   A(4,0)
A41      DC    P'65533'                A(4,1)
* NOTE: A(4,2) = 2**65536-3 IS TOO BIG FOR PL16
A50      DC    P'65533'                A(5,0)
* ALL LARGER VALUES OF M ARE TOO BIG FOR PL16
*
         LTORG 
*
         END 
