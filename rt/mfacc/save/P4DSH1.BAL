         TITLE 'BSORT.MLC - BOUBLE SORT FOR INTEGER ARRAY'
* PROGRAM = BOSRT.MLC
* AUTHOR  - DON HIGGINS
* DATE    - 12/12/97
* REF     - WWW.Z390.ORG MAINFRAME ASSEMBLER CODING CONTEST
* REMARKS - THIS IS WORST CASE EXAMPLE TO BE IMPROVED UPON
*MCALL #=     1 LV= 1 P4DSH1   ZMFACC CODE,START,NAME='Don Higgins'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P4DSH1   CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P4DSH1(15)
SV0001    DC    18F'0'
         DC    CL8'P4DSH1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P4DSHX
               1 by Don Higgins using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P4DSX
               H1 by Don Higgins using RUNSYS=390'
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
         COPY  ASMMSP  COPY STRUCTURED PROGRAMMING MACROS
         COPY ZSTRMAC  Z390 STRUCTURED PROGRAMMING MACROS
*MCALL #=     5 LV= 1          CALL  BSORTINT,(TABLE,TABLE_END)
*MCALL #=     6 LV= 2          ZCALL BSORTINT,(TABLE,TABLE_END),,ID=,LIX
               NKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+2*4
         DC     A(TABLE,TABLE_END)
         LRL    15,=V(BSORTINT)
         BALR      14,15
*MEXIT #=     6 LV= 2 ZCALL
*MEXIT #=     5 LV= 1 CALL
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
*MCALL #=    11 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    11 LV= 1 ZMFACC
TABLE    DC    20A(TABLE_END-*)
TABLE_END EQU *
*MCALL #=    12 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    12 LV= 1 ZMFACC
*MCALL #=    13 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    13 LV= 1 ZMFACC
*
* SORT TABLE OF INTEGERS - ARGS = ADDR AND LENGTH OF TABLE IN BYTES
*
*MCALL #=    14 LV= 1 BSORTINT SUBENTRY 
BSORTINT CSECT 
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'BSORTINT'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING BSORTINT+8,13
*MEXIT #=    14 LV= 1 SUBENTRY
         LM    R3,R4,0(R1)  R3=ADDRESS OF TABLE
         LR    R5,R3        R5=NEXT COMPARE
         LR    R6,R4
         AHI   R6,-4        R6=LAST ENTRY TO BE COMPARED
*MCALL #=    15 LV= 1          DO    WHILE=(CR,R5,LT,R6)
*MCALL #=    16 LV= 2          ZSTREQU 
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
*MEXIT #=    16 LV= 2 ZSTREQU
#@DO_1_T                         DS 0H
*MCALL #=    17 LV= 2          IF CR,R5,LT,R6
*MCALL #=    18 LV= 3          ZSTREQU 
*MEXIT #=    18 LV= 3 ZSTREQU
         CR    R5,R6
         BC    15-LT,#@IF_1_2
*MEXIT #=    17 LV= 2 IF
               B   #@DO_1_1
*MCALL #=    19 LV= 2          ENDIF 
*MCALL #=    20 LV= 3          ZSTREQU 
*MEXIT #=    20 LV= 3 ZSTREQU
#@IF_1_2                                                 DS 0H
*MEXIT #=    19 LV= 2 ENDIF
         B     #@DO_1_E
#@DO_1_1                         DS 0H
*MEXIT #=    15 LV= 1 DO
               LM  R0,R1,0(R5)     FETCH TWO WORDS TO COMPARE
*MCALL #=    21 LV= 1                IF  (CR,R0,GT,R1)   COMPARE TWO WOX
               RDS
*MCALL #=    22 LV= 2          ZSTREQU 
*MEXIT #=    22 LV= 2 ZSTREQU
         CR    R0,R1
         BC    15-GT,#@IF_2_2
*MEXIT #=    21 LV= 1 IF
                   MVI SWAP,TRUE   AT LEAST ONE SWAP ON THIS PASS
                   LR  R2,R0
                   STM R1,R2,0(R5) STORE TWO WORDS REVERSED
*MCALL #=    23 LV= 1                ENDIF 
*MCALL #=    24 LV= 2          ZSTREQU 
*MEXIT #=    24 LV= 2 ZSTREQU
#@IF_2_2                                                 DS 0H
*MEXIT #=    23 LV= 1 ENDIF
               AHI R5,4            INCREMENT TO NEXT COMPARE
*MCALL #=    25 LV= 1                IF  (CR,R5,GE,R6)   ARE WE AT END X
               OF PASS
*MCALL #=    26 LV= 2          ZSTREQU 
*MEXIT #=    26 LV= 2 ZSTREQU
         CR    R5,R6
         BC    15-GE,#@IF_3_2
*MEXIT #=    25 LV= 1 IF
*MCALL #=    27 LV= 1                    IF (CLI,SWAP,EQ,TRUE) WAS THERX
               E A SWAP
*MCALL #=    28 LV= 2          ZSTREQU 
*MEXIT #=    28 LV= 2 ZSTREQU
         CLI   SWAP,TRUE
         BC    15-EQ,#@IF_4_2
*MEXIT #=    27 LV= 1 IF
                      MVI SWAP,FALSE RESET SWAP FLAG
                      LR  R5,R3      RESET NEXT COMP FOR NEXT PASS
                      AHI R6,-4      SKIP LAST COMPARE ALREADY  SORTED
*MCALL #=    29 LV= 1                   ENDIF 
*MCALL #=    30 LV= 2          ZSTREQU 
*MEXIT #=    30 LV= 2 ZSTREQU
#@IF_4_2                                                 DS 0H
*MEXIT #=    29 LV= 1 ENDIF
*MCALL #=    31 LV= 1                ENDIF 
*MCALL #=    32 LV= 2          ZSTREQU 
*MEXIT #=    32 LV= 2 ZSTREQU
#@IF_3_2                                                 DS 0H
*MEXIT #=    31 LV= 1 ENDIF
*MCALL #=    33 LV= 1          ENDDO 
*MCALL #=    34 LV= 2          DO    END
*MCALL #=    35 LV= 3          ZSTREQU 
*MEXIT #=    35 LV= 3 ZSTREQU
         B     #@DO_1_T
#@DO_1_E                         DS 0H
*MEXIT #=    34 LV= 2 DO
*MEXIT #=    33 LV= 1 ENDDO
*MCALL #=    36 LV= 1          SUBEXIT 
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=    36 LV= 1 SUBEXIT
SWAP     DC    AL1(FALSE)
TRUE     EQU   1
FALSE    EQU   0
         END 
