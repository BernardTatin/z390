* Problem - Sort array of full word integers using fastest exec method
* Date    - 12/21/07
* Author  - Rafa Pereira
* Ref.    - z390 Mainframe Assembler Coding Contest on www.z390.org
*
* It is an implementation of the QuickSort Algorithm.
* This particular implementation is based on the code available at:
* http://www.mycsresource.net/articles/programming/sorting_algos/
* quicksort/
* An interesting and clear explanation of the algorithm is also
* available at the same URL.
*
* I have transformed it into an iterative implementation following the
* guidance at
* http://www.geocities.com/siliconvalley/garage/3323/aat/a_recu.html
*
* So, the code used as the starting point is:
*
* public void quickSortIterative(int start, int end)
* {
*   int i;
*   int k;
*   push (start, end);
*
*   while (pop(s,e) OK)  //i.e. while stack is not empty
*   {
*     if (e - s >= 1)
*     {
*       int pivot = array[s];
*       -> I will change this to pivot=array[(s+e)/2]
*
*       i = s;
*       k = e;
*
*       while (k > i)
*       {
*         while (array[i] <= pivot && i <= e && k > i) i++;
*         while (array[k] > pivot && k >= s && k >= i) k--;
*         if (k > i) swap(i, k);
*       }
*
*       swap(s, k);
*       push(s, k - 1);
*       push(k + 1, e);
*     }
*   }
*   return;
* }
*
* Changes from P4RAFA1:
*   Routines are now included in-stream, without BAL/BR instructions.
*   Register usage redesigned to reduce inter-register data movement.
*   Other minor changes.
**********************************************************************
* 12/23/07 DSH1 Don Higgins change F8 to F08, remove RUNSYS=MVS
**********************************************************************
* REGISTERS
* ---------
*
*    R0   WORK
*    R1   I, WORK
*    R2   K
*    R3   S, START
*    R4   E, END
*    R5   WORK
*    R6
*    R7   PIVOT
*    R8   BASE ADDRESS OF ARRAY TO SORT
*    R9   STACK POINTER
*    R10  STACK BASE ADDRESS
*    R11
*    R12
*    R13  BASE ADDRESSING REGISTER
*    R14
*    R15
**********************************************************************
*
*MCALL #=     1 LV= 1 P4RAFA2  ZMFACC  CODE,START,NAME='RAFA'
         MNOTE 4,'No RUNSYS= on first ZMFACC, 390 assumed.'
         MNOTE 'ZRUNSYS=390'                          DSH2
P4RAFA2  CSECT 
         STM   14,12,12(13)
         BAL   15,GO0001-P4RAFA2(15)
SV0001    DC    18F'0'
         DC    CL8'P4RAFA2'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
GO0001    DS    0H
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
      USING SV0001,13
*MCALL #=     2 LV= 2          WTO   'ZMFACC Solution for problem P4RAFX
               A2 by RAFA using RUNSYS=390'   DSH3
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'ZMFACC Solution for problem P4RAX
               FA2 by RAFA using RUNSYS=390'
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
**********************************************************************
* INIT ROUTINE - ROUTINE FOR INITIALIZATIONS
*
* R3: ZERO
* R4: OFFSET OF LAST ELEMENT IN THE ARRAY TO SORT
* R8: BASE ADDRESS OF THE ARRAY TO SORT
* R9: ZERO
* R10: BASE ADDRESS OF THE STACK
**********************************************************************
INIT     SR      R3,R3            R3 := 0
         L       R4,TABSIZM4      R4 := OFFSET LAST ELEMENT
         LA      R8,TABLE         R8 -> ARRAY TO SORT
         SR      R9,R9            R9 := 0
         LA      R10,STACK        R10 -> STACK
**********************************************************************
* INIT ROUTINE - END
**********************************************************************
*
**********************************************************************
* QUICK-SORT ROUTINE - ITERATIVE.
*                      SELECTS A PIVOT ELEMENT.
*                      PARTITIONS THE INPUT ARRAY INTO TWO ARRAYS,
*                      ONE WITH ELEMENTS LESS-THAN-OR-EQUAL-TO THE
*                      PIVOT AND ONE WITH ELEMENTS GREATER-THAN THE
*                      PIVOT.
*                      PROCESSES EACH OF THE TWO SUBARRAYS.
*                      THE PARTITIONING IS DONE IN-PLACE.
*
* ON ENTRY:
* R3: INDEX IN THE DATA ARRAY OF THE LEFTMOST ELEMENT
* R4: INDEX IN THE DATA ARRAY OF THE RIGHTMOST ELEMENT
* R8: BASE ADDRESS OF THE ARRAY TO SORT
*
* ON RETURN:
* R3: MODIFIED
* R4: MODIFIED
*
* public void quickSortIterative(int start, int end)
* {
*   int i;
*   int k;
*   push (start, end);
*
*   while (pop(s,e) OK)  //i.e. while stack is not empty
*   {
*     if (e - s >= 1)
*     {
*       int pivot = array[s];
*       -> I will change this to pivot=array[(s+e)/2]:
*
*             swap(s, (s+e)/2);
*             pivot = array[s];
*
*       i = s;
*       k = e;
*
*       while (k > i)
*       {
*         while (array[i] <= pivot && i <= e && k > i) i++;
*         while (array[k] > pivot && k >= s && k >= i) k--;
*         if (k > i) swap(i, k);
*       }
*
*       swap(s, k);
*       push(s, k - 1);
*       push(k + 1, e);
*     }
*   }
*   return;
* }
**********************************************************************
QSORT    B       QSORT03           BYPASS INITIAL PUSH+POP PAIR
*
* BEGINNING OF WHILE (POP(S,E) OK) LOOP
*
**********************************************************************
* POP (S,E)
*
* S IS LOADED INTO R3
* E IS LOADED INTO R4
**********************************************************************
POP      LTR     R9,R9            STACK IS ALREADY EMPTY?
         BZ      QSORTZ             YES: END WITH STACK-EMPTY
*
         S       R9,F08           UPDATE R9 (STACK POINTER)
         L       R3,0(R9,R10)     POP R3 FROM STACK
         L       R4,4(R9,R10)     POP R4 FROM STACK
**********************************************************************
* POP ROUTINE - END
**********************************************************************
*
* BEGINNING OF IF (E - S >= 1) FRAGMENT
*
QSORT03  LR      R5,R4            R5 := E
         SR      R5,R3            R5 := E - S
         C       R5,F04           R5 < 4? (4 BECAUSE FULLWORD SIZE)
         BL      POP                YES: BACK TO WHILE LOOP
*
         SRA     R5,1             R5 := (E-S)/2
         AR      R5,R3            R5 := (E-S)/2 + S = (E+S)/2
         N       R5,FFFFFFFC      ROUND TO MULTIPLE OF 4
         L       R7,0(R5,R8)      PIVOT (R7) := ARRAY[(S+E)/2]
*
         L       R1,0(R3,R8)      SWAP ...
         ST      R1,0(R5,R8)      ... (E+S)/2 ...
         ST      R7,0(R3,R8)      ... AND S
*
         LR      R1,R3            I := S
         LR      R2,R4            K := E
*
* BEGINNING OF WHILE (K > I) LOOP
*
QSORTWH2 CR      R1,R2            I < K?
         BNL     QSORT01            NO: END OF WHILE (K>I)
*
* BEGINNING OF WHILE (ARRAY[I] ...) LOOP
*
QSORTWH3 C       R7,0(R1,R8)      PIVOT < ARRAY[I]?
         BL      QSORTWH4           YES: END OF WHILE (ARRAY[I]..)
         CR      R1,R2            I < K?
         BNL     QSORTWH4           NO:  END OF WHILE (ARRAY[I]..)
         CR      R4,R1            E < I?
         BL      QSORTWH4           YES: END OF WHILE (ARRAY[I]..)
         LA      R1,4(R1)         I++  (4 BECAUSE FULLWORD SIZE)
         B       QSORTWH3         BACK TO WHILE (ARRAY[I]..) LOOP
*
* BEGINNING OF WHILE (ARRAY[K] ...) LOOP
*
QSORTWH4 C       R7,0(R2,R8)      PIVOT < ARRAY[K]?
         BNL     QSORT02            NO:  END OF WHILE (ARRAY[K]..)
         CR      R2,R1            K < I?
         BL      QSORT02            YES: END OF WHILE (ARRAY[K]..)
         CR      R2,R3            K < S?
         BL      QSORT02            YES: END OF WHILE (ARRAY[K]..)
         S       R2,F04           K--  (4 BECAUSE FULLWORD SIZE)
         B       QSORTWH4         BACK TO WHILE (ARRAY[K]..) LOOP
*
* END       OF WHILE (ARRAY[K] ...) LOOP
*
QSORT02  CR      R1,R2            I < K?
         BNL     QSORT01            NO:  END OF WHILE (K>I) LOOP
*
         L       R0,0(R1,R8)      SWAP    ...
         L       R5,0(R2,R8)      ...  I  ...
         ST      R0,0(R2,R8)      ... AND ...
         ST      R5,0(R1,R8)      ...  K
*
         B       QSORTWH2         BACK TO WHILE (K>I) LOOP
*
* END       OF WHILE (K > I) LOOP
*
QSORT01  L       R0,0(R3,R8)      SWAP    ...
         L       R5,0(R2,R8)      ...  S  ...
         ST      R0,0(R2,R8)      ... AND ...
         ST      R5,0(R3,R8)      ...  K
*
         S       R2,F04            R2:=K-1 (4 BECAUSE FULLWORD SIZE)
*
**********************************************************************
* PUSH (S,K-1)
* PUSH (K+1,E)
*
* NOTE: STACK-FULL CONDITION IS NOT CHECKED. STACK MUST BE PROPERLY
*       DIMENSIONED.
*
* S   IS IN R3
* K-1 IS IN R2
* E   IS IN R4
**********************************************************************
PUSH02   ST      R3,0(R9,R10)     PUSH R3 INTO STACK (S)
         ST      R2,4(R9,R10)     PUSH R2 INTO STACK (K-1)
         LA      R2,8(R2)         R2:=K+1 (8 BECAUSE FULLWORD SIZE)
         ST      R2,8(R9,R10)     PUSH R2 INTO STACK (K+1)
         ST      R4,12(R9,R10)    PUSH R4 INTO STACK (E)
         LA      R9,16(R9)         UDATE STACK POINTER
**********************************************************************
* PUSH ROUTINE - END
**********************************************************************
*
         B       POP               BACK TO WHILE (POP(S,E) OK) LOOP
*
QSORTZ   EQU     *
*
**********************************************************************
* QUICK-SORT ROUTINE - END
**********************************************************************
*
*MCALL #=     5 LV= 1          ZMFACC  CODE,END
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
**********************************************************************
* DATA
**********************************************************************
TABSIZM4 DC    A(TABLEEND-TABLE-4)    TABLE SIZE MINUS 4
F04      DC      F'4'    CONSTANT 4  (F4 IS USED BY MACRO ZMFACC)
F08      DC      F'8'    CONSTANT 8  (F8 IS USED BY MACRO ZMFACC)
FFFFFFFC DC      X'FFFFFFFC'  TWO LOW ORDER BITS = 00
STACK    DS      50F     STACK
*MCALL #=     8 LV= 1          ZMFACC  INPUT,START
INPUTSTR DS    0F
*MEXIT #=     8 LV= 1 ZMFACC
*MCALL #=     9 LV= 1          ZMFACC  OUTPUT,START
OUTPUTST DS    0F
*MEXIT #=     9 LV= 1 ZMFACC
TABLE    DC    20A(TABLEEND-*)
TABLEEND EQU *
*MCALL #=    10 LV= 1          ZMFACC  INPUT,END
INPUTEND  EQU  *
*MEXIT #=    10 LV= 1 ZMFACC
*MCALL #=    11 LV= 1          ZMFACC  OUTPUT,END
OUTPUTEN  EQU  *
*MEXIT #=    11 LV= 1 ZMFACC
*
         END 
