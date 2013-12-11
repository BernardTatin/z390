*MCALL #=     1 LV= 1 P6MM1    ZMFACC CODE,START,NAME='Melvyn Maltz'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P6MM1    CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P6MM1(15)
SV0001    DC    18F'0'
         DC    CL8'P6MM1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P6MM1X
                by Melvyn Maltz using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P6MMX
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
*
* METHOD 1 57.2 mS
* USES SLDL
*
         SR R2,R2 CLEAR R2
         SR R3,R3 CLEAR R3
         LA R4,BITS1 OUTPUT AREA
         LA R5,8 COUNT
         ICM R3,8,BYTE INSERT BYTE AT TOP
BITLOOP1 EQU *
         SLDL R2,1 SHIFT NEXT BIT INTO R2
         LTR R2,R2 IS IT 1 ?
         BZ INCR EXIT IF NOT
         MVI 0(R4),C'1' MARK IT
         SR R2,R2 CLEAR R2
INCR EQU *
         AHI R4,1 BUMP OUTPUT POINTER
         BCT R5,BITLOOP1 LOOP
*
* METHOD 2 2.4mS
* USES 2K TABLE
         SR R2,R2 CLEAR R2
         IC R2,BYTE INSERT BYTE TO CONVERT
         SLL R2,3 * 8
         LA R3,BITABLE1(R2) INDEX
         MVC BITS2(8),0(R3) MOVE TO OUTPUT
*
* METHOD 3 5mS
* USES 64-BYTE TABLE
         SR R2,R2 CLEAR R2
         SR R3,R3 CLEAR R3
         ICM R3,8,BYTE INSERT BYTE AT TOP
         SLDL R2,4 SHIFT 1ST NIBBLE
         SLL R2,2 * 4
         LA R2,BITABLE2(R2) INDEX
         MVC BITS3(4),0(R2) MOVE TO OUTPUT
         SR R2,R2 CLEAR R2
         SLDL R2,4 SHIFT 2ND NIBBLE
         SLL R2,2 * 4
         LA R2,BITABLE2(R2) INDEX
         MVC BITS3+4(4),0(R2) MOVE TO OUTPUT
*
* METHOD 4 49mS WITHOUT FLAG CONVERSION...44.3mS
* USES ROTATE, WITH ADDED FLAG CONVERSION
         SR R2,R2 CLEAR R2
         SR R3,R3 CLEAR R3
         LA R4,WORK OUTPUT AREA
         LA R5,8 COUNT
         ICM R3,8,BYTE INSERT BYTE AT TOP
         LR R2,R3 COPY TO R2
BITLOOP4 EQU *
         LTR R2,R2 TEST IT
         BNM INCR4 EXIT IF -VE
         MVI 0(R4),X'FF' MARK IT
INCR4 EQU *
         AHI R4,1 BUMP OUTPUT POINTER
         RLL R2,R3,1 ROTATE LEFT INTO R2
         LR R3,R2 COPY BACK
         BCT R5,BITLOOP4 LOOP
* CONVERT TO INDICATOR FLAGS
         XC BITS4(8),WORK INVERT IT
         OC WORK,ZEROS MARK THE ZEROS
         OC BITS4(8),ONES MARK THE ONES
         NC BITS4(8),WORK COMBINE
*
*MCALL #=     5 LV= 1 P6MM1    ZMFACC CODE,END
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
*MCALL #=     8 LV= 1 P6MM1    ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=     8 LV= 1 ZMFACC
BYTE DC X'AB' A NICE BYTE
*MCALL #=     9 LV= 1 P6MM1    ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=     9 LV= 1 ZMFACC
*
*MCALL #=    10 LV= 1 P6MM1    ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    10 LV= 1 ZMFACC
BITS1 DC 8C'0'
BITS2 DC 8C'0'
BITS3 DC 8C'0'
BITS4 DC 8X'FF'
*MCALL #=    11 LV= 1 P6MM1    ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
*
BITABLE1 EQU * 2K TABLE
         DC C'00000000'
         DC (X'AB'-X'01')CL8' ' I'M NOT DOING IT
         DC C'10101011'
         DC (X'FF'-X'AC')CL8' ' I'M NOT DOING IT
         DC C'11111111'
*
BITABLE2 EQU * 64-BYTE TABLE
         DC C'0000'
         DC C'0001'
         DC C'0010'
         DC C'0011'
         DC C'0100'
         DC C'0101'
         DC C'0110'
         DC C'0111'
         DC C'1000'
         DC C'1001'
         DC C'1010'
         DC C'1011'
         DC C'1100'
         DC C'1101'
         DC C'1110'
         DC C'1111'
*
ZEROS DC 8C'.'
ONES DC C'12345678'
WORK DS XL8
         END 
