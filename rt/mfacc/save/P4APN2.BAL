* PROBLEM - SORT ARRAY OF FULL WORD INTEGERS USING FASTEST EXEC METHOD
* DATE    - 05/01/2008
* AUTHOR  - Alfred Nykolyn - Second attempt using CountSort
* REF     - WWW.Z390.ORG MAINFRAME ASSEMBLER CODING CONTEST
* REMARKS - Counting Sort
*
*MCALL #=     1 LV= 1 P4APN2   ZMFACC   CODE,START,NAME='Alfred NykolynX
                - Try 2'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P4APN2   CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P4APN2(15)
SV0001    DC    18F'0'
         DC    CL8'P4APN2'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P4APNX
               2 by Alfred Nykolyn - Try 2 using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P4APX
               N2 by Alfred Nykolyn - Try 2 using RUNSYS=390'
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
*MCALL #=     5 LV= 1          CALL CNTSORT,(AREAIN,AREAOUT,AREA#)
*MCALL #=     6 LV= 2          ZCALL CNTSORT,(AREAIN,AREAOUT,AREA#),,IDX
               =,LINKINST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+3*4
         DC     A(AREAIN,AREAOUT,AREA#)
         LRL    15,=V(CNTSORT)
         BALR      14,15
*MEXIT #=     6 LV= 2 ZCALL
*MEXIT #=     5 LV= 1 CALL
*MCALL #=     7 LV= 1          ZMFACC   CODE,END
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
*MCALL #=    10 LV= 1          ZMFACC   INPUT,START
INPUTSTR DS    0F
*MEXIT #=    10 LV= 1 ZMFACC
AREAIN   DC    20A(AREAEND-*)
AREAEND  EQU *
*MCALL #=    11 LV= 1          ZMFACC   INPUT,END
INPUTEND  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
AREA#    DC     A((AREAEND-AREAIN)/4)
*MCALL #=    12 LV= 1       ZMFACC   OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    12 LV= 1 ZMFACC
AREAOUT  DS    XL80
*MCALL #=    13 LV= 1       ZMFACC   OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    13 LV= 1 ZMFACC
*
*-------------------------------------------------
*
*   Input:
*     R1 -> 3 words
*           +0 -> source array A[] elements between 0 and 512
*           +4 -> target array B[]
*           +8 =  N array length
*   Output:
*     B[] sorted ascending
*
*-------------------------------------------------
*
CNTSORT  CSECT 
*MCALL #=    14 LV= 1          SAVE  (14,12)
         STM   14,12,12+4*(14-14)(13)
*MEXIT #=    14 LV= 1 SAVE
         BASR  r12,0
         USING *,r12
         LM    r7,r9,0(r1)        * r7 -> source, r8 -> target, r9 -> N
         L     r9,0(,r9)          * r9 = N
         STM   r7,r9,A            * save parms
*
* build counts array
* counts[source[i]] =  counts[source[i]] + 1
*
         USING sourceD,r2
         USING targetD,r3
         L     r2,A               * r2 -> source
         XR    r4,r4              * r4 =  largest element
         L     r11,N              * r11 = N
nextcount      EQU *
         L     r9,source          * r9 = source[i]
         CR    r9,r4
         BNH   *+4+2
         LR    r4,r9              * new max
         SLL   r9,2
         L     r8,counts(r9)
         LA    r8,1(,r8)
         ST    r8,counts(r9)
         LA    r2,4(,r2)
         BCT   r11,nextcount
*
* build offsets array
* counts[i] = counts[i] + counts[i-1]
*
         ST    r4,max
         XR    r5,r5
         XR    r6,r6              * last offsets entry
         XR    r7,r7              * last counts entry
         LA    r11,1(,r4)         * counts is 0 offset!
nextoffset     EQU *
         AR    r6,r7
         L     r7,counts(r5)
         ST    r6,counts(r5)
         LA    r5,4(,r5)          * next element
         BCT   r11,nextoffset
*
* build target array - from start to end
*   dest[offsets[source[i]]] = source[i]
*   offsets[source[i]] = offsets[source[i]] + 1
*
         L     r11,N              * r11 = N
         L     r2,A               * r2 -> source
         L     r3,B               * r3 -> target
nextdest EQU   *
         L     r9,source          * r9 = source[i]
         LR    r8,r9              * r8 = source[i]
         SLL   r9,2
         L     r7,counts(r9)      * r7 = target offset
         LR    r6,r7
         SLL   r7,2
         ST    r8,target(r7)
         LA    r6,1(,r6)          * increment offset for next save
         ST    r6,counts(r9)
         LA    r2,4(,r2)          * next element
         BCT   r11,nextdest
done     EQU   *
*MCALL #=    15 LV= 1          RETURN (14,12),rc=0
*MCALL #=    16 LV= 2         ZRETURN (14,12),,MF=I,RC=0
*MCALL #=    17 LV= 3          RESTORE (14,12),RC=0
         LM    14,12,12+4*(14-14)(13)
*MEXIT #=    17 LV= 3 RESTORE
         LA    15,0
         BR    14
*MEXIT #=    16 LV= 2 ZRETURN
*MEXIT #=    15 LV= 1 RETURN
         DS    0d
A        DS    a                  * source addr
B        DS    a                  * target addr
N        DS    a                  * # elements
max      DS    a                  * max element
counts   DC    513f'0'
$countLN EQU   *-counts
*
*  Source Descriptor
*
sourceD  DSECT 
source   DS    f
*
*  Target Descriptor
*
targetD  DSECT 
target   DS    f
      END 
