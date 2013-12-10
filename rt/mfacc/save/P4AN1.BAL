*MCALL #=     1 LV= 1 P4AN1    ZMFACC CODE,START,NAME='Alfred Nykolyn'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P4AN1    CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P4AN1(15)
SV0001    DC    18F'0'
         DC    CL8'P4AN1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P4AN1X
                by Alfred Nykolyn using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P4ANX
               1 by Alfred Nykolyn using RUNSYS=390'
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
*MCALL #=     5 LV= 1          CALL   SHELSORT,(TABLE,NTABLE)
*MCALL #=     6 LV= 2          ZCALL SHELSORT,(TABLE,NTABLE),,ID=,LINKIX
               NST=BALR,MF=I
         CNOP  0,4
         BRAS   1,*+4+2*4
         DC     A(TABLE,NTABLE)
         LRL    15,=V(SHELSORT)
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
TABLEI   DC    20A(TABLE_END-*)
TABLEI_END EQU  *
*MCALL #=    11 LV= 1          ZMFACC INPUT,END
INPUTEND  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
*MCALL #=    12 LV= 1          ZMFACC OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=    12 LV= 1 ZMFACC
TABLE    DC    20A(TABLE_END-*)
TABLE_END EQU  *
*MCALL #=    13 LV= 1          ZMFACC OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    13 LV= 1 ZMFACC
NTABLE   DC     A((TABLE_END-TABLE)/4)
SHELSORT CSECT 
*MCALL #=    14 LV= 1          SAVE (14,12)
         STM   14,12,12+4*(14-14)(13)
*MEXIT #=    14 LV= 1 SAVE
         BALR R12,0
         USING *,R12
         LM    R1,R2,0(R1)   R1,R2 = A(TABLE,NTABLE)
         L     R0,0(R2)      R0= NTABLE
         TITLE 'Shellsort from Sedgwick'
*
*  shellsort(itemType a[], int N)
*  {
*       int i, j, k, h; itemType v;
*       int incs[16] = { 1391376, 463792, 198768, 86961, 33936,
*                        13776, 4592, 1968, 861, 336,
*                        112, 48, 21, 7, 3, 1 };
*       for ( k = 0; k < 16; k++) {
*           for (h = incs[k], i = l+h; i <= N; i++) {
*               v = a[i]; j = i;
*               while (j > h && a[j-h] > v) {
*                   a[j] = a[j-h]; j -= h;
*               }
*               a[j] = v;
*           }
*       }
*  }
*
* See http://www.cs.princeton.edu/~rs/shell/paperF.pdf for details
*
*-------------------------------------------------
*
*   Input:
*     r1 = array address a[]
*     r0 = N array length
*
*   Output:
*     a[] sorted ascending
*
*-------------------------------------------------
*
         LA    r14,1
         LA    r11,incs           * r11 -> increment
         LA    r10,16             * r10 =  pass count
         SR    r0,r14             * elements are a[0], a[1], ... a[N-1]
nextINC  EQU   *
         L     r9,0(,r11)         * r9  =  h current increment
         LR    r8,r9              * r8  =  i
         CR    r8,r0              * larger than N?
         BH    bumpinc
nextI    EQU   *
         LR    r15,r8
         SLL   r15,2
         ALR   r15,r1             * r15 -> a[i]
         L     r14,0(,r15)        * r14 =  a[i] = v
         LR    r7,r8              * r7  =  j
         CR    r7,r9              * j > h ?
         BL    bumpI
nextJ    EQU   *
         LR    r2,r7              * r2  = j
         SR    r2,r9              * r2  = j - h
         SLL   r2,2
         ALR   r2,r1              * r2 -> a[j-h]
         L     r3,0(,r2)          * r3 =  a[j-h]
         CR    r3,r14             * a[j-h] > v ?
         BNH   bumpI
         LR    r4,r7              * r4  = j
         SLL   r4,2
         ALR   r4,r1              * r4 -> a[j]
         ST    r3,0(,r4)          * a[j]   = a[j-h]
         ST    r14,0(,r2)         * a[j-h] = v
bumpJ    EQU   *
         SR    r7,r9              * j = j-h
         CR    r7,r9              * j > h ?
         BNL   nextJ
bumpI    EQU   *
         LA    r8,1(,r8)          * next i
         CR    r8,r0              * larger than N?
         BNH   nextI
bumpinc  EQU   *
         LA    r11,4(,r11)        * r11 -> next increment
         BCT   r10,nextINC
*MCALL #=    15 LV= 1          RETURN (14,12),RC=0
*MCALL #=    16 LV= 2         ZRETURN (14,12),,MF=I,RC=0
*MCALL #=    17 LV= 3          RESTORE (14,12),RC=0
         LM    14,12,12+4*(14-14)(13)
*MEXIT #=    17 LV= 3 RESTORE
         LA    15,0
         BR    14
*MEXIT #=    16 LV= 2 ZRETURN
*MEXIT #=    15 LV= 1 RETURN
incs     DC    al4(1391376,463792,198768,86961,33936,13776,4592,1968)
         DC    al4(861,336,112,48,21,7,3,1)
         END 
