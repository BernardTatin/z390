         TITLE 'P12DSH1.MLC - Calc BFP 128 Bit Standard Deviation'
*********************************************************************
* Program ID.  P12DSH1.MLC
* Author.      Don Higgins.
* Date.        06/20/07.
*********************************************************************
* 01/14/08 DSH1 convert previous test program for solution to #12
*********************************************************************
*MCALL #=     1 LV= 1 P10DSH1  ZMFACC CODE,START,NAME='DON HIGGINS'
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
               H1 by DON HIGGINS using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P10DX
               SH1 by DON HIGGINS using RUNSYS=390'
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
         COPY  ASMMSP      STRUCTURED PROGRAMMING MACRO LIBRARY
         COPY ZSTRMAC  Z390 STRUCTURED PROGRAMMING MACROS
*MCALL #=     5 LV= 1          CALL  STDDEVLB,(LBX,N,LBSD)  CALCULATE SX
               TANDARD DEVIATION
*MCALL #=     6 LV= 2          ZCALL STDDEVLB,(LBX,N,LBSD),,ID=,LINKINSX
               T=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(LBX,N,LBSD)
         LRL    15,=V(STDDEVLB)
         BALR      14,15
*MEXIT #=     6 LV= 2 ZCALL
*MEXIT #=     5 LV= 1 CALL
*
* DISPLAY STD DEVIATION IN SCIENTIFIC NOTATION FOR DEBUGGIN
*
*MCALL #=     7 LV= 1          CTD   CTD_LB,IN=LBSD,OUT=DLBSD
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
         LA    1,=A(CTD_LB,LBSD,DLBSD)
         SVC   170 CTD R1=A(TYPE,IN,OUT)
*MEXIT #=     7 LV= 1 CTD
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
N        DC    F'4'        INTEGER NUMBER OF ARRAY ELEMENTS
         DS     0D
*MCALL #=    11 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=    11 LV= 1 ZMFACC
LBX      DC    LB'1,2,3,6' BINARY EXTENDED PRECISION (BFP) ARRAY
*MCALL #=    12 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    12 LV= 1 ZMFACC
*MCALL #=    13 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    13 LV= 1 ZMFACC
LBSD     DC    LB'0'       STANDARD DEVIATION BFP VALUE
DLBSD    DC    CL45' '     STANDARD DEVIATION IN SCIENTIFIC NOTATION
*MCALL #=    14 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    14 LV= 1 ZMFACC
         TITLE 'STDDEVLB - CALC BFP 128 BIT STANDARD DEVIATION'
STDDEVLB CSECT 
         USING *,15
*MCALL #=    15 LV= 1          SAVE  (14,12)
         STM   14,12,12+4*(14-14)(13)
*MEXIT #=    15 LV= 1 SAVE
         BALR  12,0
         USING *,12
*
* CALCULATE BFP 128 BIT STANDARD DEVIATION FOR ARRAY OF BFP ELEMENTS
*
* CALL PARAMETERS:
*
*  1 = INPUT  ADDRESS OF BFP ARRAY ELEMENTS (16 BYTE BFP LB FORMAT)
*  2 - INPUT  FULL WORD ARRAY ELEMENT COUNT (MUST BE >= 1)
*  3 - OUTPUT STANDARD DEVIATION IN 16 BYTE BFP LB FORMAT
*
* RETURN CODES:
*
*   0 - STANDARD DEVIATION STORED SUCCESSFULLY IN PARAMETER 3
*  16 - ELEMENT COUNT LESS THAN 1 (STD.DEV. UNDEFINED)
*
*
* CALCULATE BFP LBXM MEAN = (SUM X(I))/N AND SAVE IN F4+F6
*
         LM    R3,R5,0(R1) R3=A(ARRAY) R4=A(N) R5=A(LBSD)
         L     R4,0(R4)    R4=N ELEMENT COUNT
         LR    R6,R3       R6=AARRY ELEMENT ADDRESS
         LR    R7,R4       R7=ELEMENTS TO PROCESS IN LOOP
*MCALL #=    16 LV= 1          IF    (CHI,R7,LT,1)
*MCALL #=    17 LV= 2          ZSTREQU 
         PUSH  PRINT,NOPRINT
         PRINT OFF,NOPRINT
H        EQU   2
L        EQU   4
E        EQU   8
NH       EQU   13
NL       EQU   11
NE       EQU   7
O        EQU   1
P        EQU   2
M        EQU   4
Z        EQU   8
NP       EQU   13
NM       EQU   11
NZ       EQU   7
NO       EQU   14
EQ       EQU   8
GT       EQU   2
LT       EQU   4
GE       EQU   11
LE       EQU   13
         POP   PRINT,NOPRINT
*MEXIT #=    17 LV= 2 ZSTREQU
         CHI   R7,1
         BC    15-LT,#@IF_1_2
*MEXIT #=    16 LV= 1 IF
*MCALL #=    18 LV= 1                RETURN (14,12),RC=16  EXIT WITH RCX
               =16 IF COUNT < 1
*MCALL #=    19 LV= 2         ZRETURN (14,12),,MF=I,RC=16
*MCALL #=    20 LV= 3          RESTORE (14,12),RC=16
         LM    14,12,12+4*(14-14)(13)
*MEXIT #=    20 LV= 3 RESTORE
         LA    15,16
         BR    14
*MEXIT #=    19 LV= 2 ZRETURN
*MEXIT #=    18 LV= 1 RETURN
*MCALL #=    21 LV= 1          ENDIF 
*MCALL #=    22 LV= 2          ZSTREQU 
*MEXIT #=    22 LV= 2 ZSTREQU
#@IF_1_2                                                 DS 0H
*MEXIT #=    21 LV= 1 ENDIF
         STFPC  R8      SAVE FPC IN R8
         LR     R1,R8
FPC_MASK_UNF EQU X'01000000' BFP UNDERFLOW MASK BIT
         N      R1,=A(X'FFFFFFFF'-FPC_MASK_UNF)  TURN OFF UNDERFLOW
         LFPC   R1
         SXBR  F4,F4       F4+F6 = SUM X(I) TO CALC MEAN
*MCALL #=    23 LV= 1          DO    WHILE=(CHI,R7,GT,0)
*MCALL #=    24 LV= 2          ZSTREQU 
*MEXIT #=    24 LV= 2 ZSTREQU
#@DO_1_T                         DS 0H
*MCALL #=    25 LV= 2          IF CHI,R7,GT,0
*MCALL #=    26 LV= 3          ZSTREQU 
*MEXIT #=    26 LV= 3 ZSTREQU
         CHI   R7,0
         BC    15-GT,#@IF_2_2
*MEXIT #=    25 LV= 2 IF
               B   #@DO_1_1
*MCALL #=    27 LV= 2          ENDIF 
*MCALL #=    28 LV= 3          ZSTREQU 
*MEXIT #=    28 LV= 3 ZSTREQU
#@IF_2_2                                                 DS 0H
*MEXIT #=    27 LV= 2 ENDIF
         B     #@DO_1_E
#@DO_1_1                         DS 0H
*MEXIT #=    23 LV= 1 DO
               LD  F1,0(R6) F1+F3 = ELEMENT
               LD  F3,8(R6)
               AXBR F4,F1  ADD ELEMENT TO SUM
               AHI R6,16   NEXT ELEMENT
               AHI R7,-1   REDUCE ELEMENTS REMAINING
*MCALL #=    29 LV= 1          ENDDO 
*MCALL #=    30 LV= 2          DO    END
*MCALL #=    31 LV= 3          ZSTREQU 
*MEXIT #=    31 LV= 3 ZSTREQU
         B     #@DO_1_T
#@DO_1_E                         DS 0H
*MEXIT #=    30 LV= 2 DO
*MEXIT #=    29 LV= 1 ENDDO
         CXFBR F1,R4       F1+F3 = N
         DXBR  F4,F1       F4+F6 = F4+F6 / F1+F3 = BFP LB MEAN
*
* CALCULATE SUM OF VARIANCE SQUARED IN F0+F2
*
         LR    R6,R3       R6 = ADDRESS FIRST ARRAY ELEMENT
         LR    R7,R4       R7 = ELEMENTS TO PROCESS IN LOOP
         SXR   F0,F0       F0+F2 = (SUM X(I)-MEAN)**2
*MCALL #=    32 LV= 1          DO    WHILE=(CHI,R7,GT,0)
*MCALL #=    33 LV= 2          ZSTREQU 
*MEXIT #=    33 LV= 2 ZSTREQU
#@DO_2_T                         DS 0H
*MCALL #=    34 LV= 2          IF CHI,R7,GT,0
*MCALL #=    35 LV= 3          ZSTREQU 
*MEXIT #=    35 LV= 3 ZSTREQU
         CHI   R7,0
         BC    15-GT,#@IF_3_2
*MEXIT #=    34 LV= 2 IF
               B   #@DO_2_1
*MCALL #=    36 LV= 2          ENDIF 
*MCALL #=    37 LV= 3          ZSTREQU 
*MEXIT #=    37 LV= 3 ZSTREQU
#@IF_3_2                                                 DS 0H
*MEXIT #=    36 LV= 2 ENDIF
         B     #@DO_2_E
#@DO_2_1                         DS 0H
*MEXIT #=    32 LV= 1 DO
               LD  F1,0(R6) F1+F3 = BFP LB ELEMENT
               LD  F3,8(R6)
               SXBR F1,F4  SUBTRACT MEAN
               MXBR F1,F1  SQUARE   DIFF
               AXBR F0,F1  ADD      DIFF * DIFF
               AHI R6,16   NEXT ELEMENT
               AHI R7,-1   REDUCE ELEMENTS REMAINING
*MCALL #=    38 LV= 1          ENDDO 
*MCALL #=    39 LV= 2          DO    END
*MCALL #=    40 LV= 3          ZSTREQU 
*MEXIT #=    40 LV= 3 ZSTREQU
         B     #@DO_2_T
#@DO_2_E                         DS 0H
*MEXIT #=    39 LV= 2 DO
*MEXIT #=    38 LV= 1 ENDDO
         CXFBR F1,R4       F1+F3 = N
         DXBR  F0,F1       F0+F2 = F0+F2 / F1+F3 = (SUM DIFF*DIFF)/N
*
* CALCULATE STANDARD DEVIATION
*
         SQXBR F0,F0     CALC SQRT SUM OF VAR**2 IN F0+F2
         STD   F0,0(R5)  STORE F0+F2 LB STANDARD DEVIATION RESULT
         STD   F2,8(R5)
         LFPC  R8        RESTORE FPC REG
*MCALL #=    41 LV= 1          RETURN (14,12),RC=0
*MCALL #=    42 LV= 2         ZRETURN (14,12),,MF=I,RC=0
*MCALL #=    43 LV= 3          RESTORE (14,12),RC=0
         LM    14,12,12+4*(14-14)(13)
*MEXIT #=    43 LV= 3 RESTORE
         LA    15,0
         BR    14
*MEXIT #=    42 LV= 2 ZRETURN
*MEXIT #=    41 LV= 1 RETURN
LBXM     DS    LB        VARIANCE FOR DEBUG DISPLAY
LBXV2    DS    LB        (SUM DIFF*DIFF)/N FOR DEBUG DISPLAY
         END 
