         TITLE 'P16DSH1.MLC - Calc primes using store/fetch bit array'
*********************************************************************
* Program ID.  P16DSH1.MLC
* Author.      Don Higgins.
* Date.        02/22/08.
*********************************************************************
         MACRO
&N       SETBIT &BIT=,&ARRAY=,&BITMASK=
&N       LR     14,&BIT(1)           R14=BIT # STARTING WITH 0
         LR     15,14                R15=BIT # STARTING WITH 0
         NILL   14,X'FFF8'           TURN OFF LOW 3 BITS OF R14
         SR     15,14                R15=RELATIVE BIT IN BYTE 0-7
         IC     15,0(&BITMASK(1),15) R15=BIT MASK X'80'-X'01'
         SRL    14,3                 R14=BYTE OFFSET IN ARRAY
         LA     14,0(14,&ARRAY(1))   R14=ADDR OF BYTE IN ARRAY
         EX     15,*+4+4             EX OI WITH BIT MASK
         B      *+4+4                SKIP OI
         OI     0(14),*-*
         MEND
         MACRO
&N       TESTBIT &BIT=(2),&ARRAY=(3),&BITMASK=(4)
&N       LR     14,&BIT(1)           R14=BIT # STARTING WITH 0
         LR     15,14                R15=BIT # STARTING WITH 0
         NILL   14,X'FFF8'           TURN OFF LOW 3 BITS OF R14
         SR     15,14                R15=RELATIVE BIT IN BYTE 0-7
         IC     15,0(&BITMASK(1),15) R15=BIT MASK X'80'-X'01'
         SRL    14,3                 R14=BYTE OFFSET IN ARRAY
         LA     14,0(14,&ARRAY(1))   R14=ADDR OF BYTE IN ARRAY
         EX     15,*+4+4             EX TM WITH BIT MASK
         B      *+4+4                SKIP TM
         TM     0(14),*-*
         MEND
*MCALL #=     1 LV= 1 P16DSH1  ZMFACC CODE,START,NAME='DON HIGGINS'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P16DSH1  CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P16DSH1(15)
SV0001    DC    18F'0'
         DC    CL8'P16DSH1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P16DSX
               H1 by DON HIGGINS using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P16DX
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
         COPY   ASMMSP
         COPY ZSTRMAC  Z390 STRUCTURED PROGRAMMING MACROS
         LA     R3,TABLE
         LA     R4,=X'8040201008040201'
         LA     R5,3                  R5=NEXT N TO TEST
*MCALL #=     5 LV= 1          DO     WHILE=(CHI,R5,LT,100) TEST ODD N X
               FOR N=3 TO 99
*MCALL #=     6 LV= 2          ZSTREQU 
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
*MEXIT #=     6 LV= 2 ZSTREQU
#@DO_1_T                         DS 0H
*MCALL #=     7 LV= 2          IF CHI,R5,LT,100
*MCALL #=     8 LV= 3          ZSTREQU 
*MEXIT #=     8 LV= 3 ZSTREQU
         CHI   R5,100
         BC    15-LT,#@IF_1_2
*MEXIT #=     7 LV= 2 IF
               B   #@DO_1_1
*MCALL #=     9 LV= 2          ENDIF 
*MCALL #=    10 LV= 3          ZSTREQU 
*MEXIT #=    10 LV= 3 ZSTREQU
#@IF_1_2                                                 DS 0H
*MEXIT #=     9 LV= 2 ENDIF
         B     #@DO_1_E
#@DO_1_1                         DS 0H
*MEXIT #=     5 LV= 1 DO
                MVI  PRIME,TRUE
                LA   R2,3
                LR   R1,R2
                MR   R0,R2
*MCALL #=    11 LV= 1                 DO   WHILE=(CR,R1,LE,R5) TEST ODDX
                UP TO SQRT N
*MCALL #=    12 LV= 2          ZSTREQU 
*MEXIT #=    12 LV= 2 ZSTREQU
#@DO_2_T                         DS 0H
*MCALL #=    13 LV= 2          IF CR,R1,LE,R5
*MCALL #=    14 LV= 3          ZSTREQU 
*MEXIT #=    14 LV= 3 ZSTREQU
         CR    R1,R5
         BC    15-LE,#@IF_2_2
*MEXIT #=    13 LV= 2 IF
               B   #@DO_2_1
*MCALL #=    15 LV= 2          ENDIF 
*MCALL #=    16 LV= 3          ZSTREQU 
*MEXIT #=    16 LV= 3 ZSTREQU
#@IF_2_2                                                 DS 0H
*MEXIT #=    15 LV= 2 ENDIF
         B     #@DO_2_E
#@DO_2_1                         DS 0H
*MEXIT #=    11 LV= 1 DO
                     SR   R0,R0
                     LR   R1,R5
                     DR   R0,R2
*MCALL #=    17 LV= 1                      IF   (CHI,R0,EQ,0)
*MCALL #=    18 LV= 2          ZSTREQU 
*MEXIT #=    18 LV= 2 ZSTREQU
         CHI   R0,0
         BC    15-EQ,#@IF_3_2
*MEXIT #=    17 LV= 1 IF
                          MVI  PRIME,FALSE
                          LA   R1,1(R5)
*MCALL #=    19 LV= 1                      ELSE 
*MCALL #=    20 LV= 2          ZSTREQU 
*MEXIT #=    20 LV= 2 ZSTREQU
        B      #@IF_3_E
#@IF_3_2                                                 DS 0H
*MEXIT #=    19 LV= 1 ELSE
                          AHI  R2,2
                          LR   R1,R2
                          MR   R0,R2
*MCALL #=    21 LV= 1                      ENDIF 
*MCALL #=    22 LV= 2          ZSTREQU 
*MEXIT #=    22 LV= 2 ZSTREQU
#@IF_3_E                         DS 0H
*MEXIT #=    21 LV= 1 ENDIF
*MCALL #=    23 LV= 1                 ENDDO 
*MCALL #=    24 LV= 2          DO    END
*MCALL #=    25 LV= 3          ZSTREQU 
*MEXIT #=    25 LV= 3 ZSTREQU
         B     #@DO_2_T
#@DO_2_E                         DS 0H
*MEXIT #=    24 LV= 2 DO
*MEXIT #=    23 LV= 1 ENDDO
*MCALL #=    26 LV= 1                 IF   (CLI,PRIME,EQ,TRUE)
*MCALL #=    27 LV= 2          ZSTREQU 
*MEXIT #=    27 LV= 2 ZSTREQU
         CLI   PRIME,TRUE
         BC    15-EQ,#@IF_4_2
*MEXIT #=    26 LV= 1 IF
*MCALL #=    28 LV= 1                      SETBIT BIT=(R5),ARRAY=(R3),BX
               ITMASK=(R4)
         LR     14,R5           R14=BIT # STARTING WITH 0
         LR     15,14                R15=BIT # STARTING WITH 0
         NILL   14,X'FFF8'           TURN OFF LOW 3 BITS OF R14
         SR     15,14                R15=RELATIVE BIT IN BYTE 0-7
         IC     15,0(R4,15) R15=BIT MASK X'80'-X'01'
         SRL    14,3                 R14=BYTE OFFSET IN ARRAY
         LA     14,0(14,R3)   R14=ADDR OF BYTE IN ARRAY
         EX     15,*+4+4             EX OI WITH BIT MASK
         B      *+4+4                SKIP OI
         OI     0(14),*-*
*MEXIT #=    28 LV= 1 SETBIT
*MCALL #=    29 LV= 1                 ENDIF 
*MCALL #=    30 LV= 2          ZSTREQU 
*MEXIT #=    30 LV= 2 ZSTREQU
#@IF_4_2                                                 DS 0H
*MEXIT #=    29 LV= 1 ENDIF
                AHI  R5,2   R5 = NEXT TRIAL PRIME
*MCALL #=    31 LV= 1          ENDDO 
*MCALL #=    32 LV= 2          DO    END
*MCALL #=    33 LV= 3          ZSTREQU 
*MEXIT #=    33 LV= 3 ZSTREQU
         B     #@DO_1_T
#@DO_1_E                         DS 0H
*MEXIT #=    32 LV= 2 DO
*MEXIT #=    31 LV= 1 ENDDO
         LA    R5,3
*MCALL #=    34 LV= 1          DO    WHILE=(CHI,R5,LT,100)
*MCALL #=    35 LV= 2          ZSTREQU 
*MEXIT #=    35 LV= 2 ZSTREQU
#@DO_3_T                         DS 0H
*MCALL #=    36 LV= 2          IF CHI,R5,LT,100
*MCALL #=    37 LV= 3          ZSTREQU 
*MEXIT #=    37 LV= 3 ZSTREQU
         CHI   R5,100
         BC    15-LT,#@IF_5_2
*MEXIT #=    36 LV= 2 IF
               B   #@DO_3_1
*MCALL #=    38 LV= 2          ENDIF 
*MCALL #=    39 LV= 3          ZSTREQU 
*MEXIT #=    39 LV= 3 ZSTREQU
#@IF_5_2                                                 DS 0H
*MEXIT #=    38 LV= 2 ENDIF
         B     #@DO_3_E
#@DO_3_1                         DS 0H
*MEXIT #=    34 LV= 1 DO
*MCALL #=    40 LV= 1                TESTBIT BIT=(R5),ARRAY=(R3),BITMASX
               K=(R4)
         LR     14,R5           R14=BIT # STARTING WITH 0
         LR     15,14                R15=BIT # STARTING WITH 0
         NILL   14,X'FFF8'           TURN OFF LOW 3 BITS OF R14
         SR     15,14                R15=RELATIVE BIT IN BYTE 0-7
         IC     15,0(R4,15) R15=BIT MASK X'80'-X'01'
         SRL    14,3                 R14=BYTE OFFSET IN ARRAY
         LA     14,0(14,R3)   R14=ADDR OF BYTE IN ARRAY
         EX     15,*+4+4             EX TM WITH BIT MASK
         B      *+4+4                SKIP TM
         TM     0(14),*-*
*MEXIT #=    40 LV= 1 TESTBIT
*MCALL #=    41 LV= 1                IF  (LR,R0,NZ,R0) TEST CC NZ
*MCALL #=    42 LV= 2          ZSTREQU 
*MEXIT #=    42 LV= 2 ZSTREQU
         LR    R0,R0
         BC    15-NZ,#@IF_6_2
*MEXIT #=    41 LV= 1 IF
                   CVD R5,PWORK
                   MVC DPRIME,=X'40202020'
                   ED  DPRIME,PWORK+6
*MCALL #=    43 LV= 1                    WTO MF=(E,WTOMSG)
         LA    1,WTOMSG
         SVC   35
*MEXIT #=    43 LV= 1 WTO
*MCALL #=    44 LV= 1                ENDIF 
*MCALL #=    45 LV= 2          ZSTREQU 
*MEXIT #=    45 LV= 2 ZSTREQU
#@IF_6_2                                                 DS 0H
*MEXIT #=    44 LV= 1 ENDIF
               AHI R5,2
*MCALL #=    46 LV= 1          ENDDO 
*MCALL #=    47 LV= 2          DO    END
*MCALL #=    48 LV= 3          ZSTREQU 
*MEXIT #=    48 LV= 3 ZSTREQU
         B     #@DO_3_T
#@DO_3_E                         DS 0H
*MEXIT #=    47 LV= 2 DO
*MEXIT #=    46 LV= 1 ENDDO
*MCALL #=    49 LV= 1          ZMFACC CODE,END
*MCALL #=    50 LV= 2       ZMFACC DUMP,ID=2,ST=OUTPUTST,END=OUTPUTEN,NX
               AME='Output Area' RP2
         DS    0H
*MCALL #=    51 LV= 3          SNAP  ID=2,PDATA=,STORAGE=(OUTPUTST,OUTPX
               UTEN),TEXT='Output Area'
         L     14,=A(OUTPUTST)
         L     15,=A(OUTPUTEN)
         IILL  0,2                  RPI158
         IILH 0,32768               RPI158
         LA    1,=CL60'Output Area'
         SVC   51  SNAP DUMP R0=FLAGS,ID,R1=A(TEXT),R14-15=A(LOW,HIGH)
*MEXIT #=    51 LV= 3 SNAP
*MEXIT #=    50 LV= 2 ZMFACC
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
*MEXIT #=    49 LV= 1 ZMFACC
*MCALL #=    52 LV= 1          ZMFACC INPUT,START
INPUTSTR DS    0F
*MEXIT #=    52 LV= 1 ZMFACC
*MCALL #=    53 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    53 LV= 1 ZMFACC
*MCALL #=    54 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    54 LV= 1 ZMFACC
*MCALL #=    55 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    55 LV= 1 ZMFACC
PRIME    DC    AL1(FALSE)
FALSE    EQU   0
TRUE     EQU   1
TABLE    DC    XL(100/8+1)'00'
PWORK    DC    PL16'0'
WTOMSG   DC    AL2(WTOEND-WTOMSG,0),C'PRIME ='
DPRIME   DC    C' ZZZ'
WTOEND   EQU   *
         END 
