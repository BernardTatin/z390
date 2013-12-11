*********************************************************************
* Copyright 2005 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 11/30/05                                                 *
*********************************************************************
*
* RUN DEMOGUI3 WITH GUI OPTION TO DEMO GUI SCREEN TGET/TPUT EDIT MODE
*
* DEMOGUI3 SHOWS HOW TPUT AND TGET USE GUI SCREEN VIEW
*   1.  TPUT SCROLLS EACH MESSAGE AND WRAPS AT END OF SCREEN
*   2.  ONLY PRINTABLE CHARACTERS ARE DISPLAYED AND NO TN3270
*       CONTROLS ARE REQUIRED OR USED.
*********************************************************************
* 12/02/05 RPI47 ADD DEMO OF TPUT AND TGET DEFAULT EDIT MODE
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI3 SUBENTRY
DEMOGUI3    CSECT
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'DEMOGUI3'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING DEMOGUI3+8,13
*MEXIT #=     1 LV= 1 SUBENTRY
*MCALL #=     2 LV= 1          WTO   'DEMOGUI3 STARTING'
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'DEMOGUI3 STARTING'
WTO#0002_EOT EQU *
         SVC   35
*MEXIT #=     2 LV= 1 WTO
*MCALL #=     3 LV= 1          TPUT  MSG1,MSG1L
         LA    1,MSG1
         LA    0,MSG1L
         ICM   1,8,=B'00000000'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     3 LV= 1 TPUT
LOOP     EQU   *
*MCALL #=     4 LV= 1          TPUT  MSG2,MSG2L
         LA    1,MSG2
         LA    0,MSG2L
         ICM   1,8,=B'00000000'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     4 LV= 1 TPUT
*MCALL #=     5 LV= 1          TGET  REPLY,REPLYL
         LA    1,REPLY
         LA    0,REPLYL
         ICM   1,8,=B'10000000'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     5 LV= 1 TGET
*MCALL #=     6 LV= 1          TPUT  MSG3,MSG3L
         LA    1,MSG3
         LA    0,MSG3L
         ICM   1,8,=B'00000000'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     6 LV= 1 TPUT
         CLC   REPLY(3),=C'END'
         BNE   LOOP
*MCALL #=     7 LV= 1          WTO   'DEMOGUI3 ENDING'
         BRAS  1,*+(WTO#0007_EOT-*+1)/2*2
         DC    AL2(WTO#0007_EOT-*,0),C'DEMOGUI3 ENDING'
WTO#0007_EOT EQU *
         SVC   35
*MEXIT #=     7 LV= 1 WTO
*MCALL #=     8 LV= 1          SUBEXIT
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=     8 LV= 1 SUBEXIT
MSG1     DC    C'DEMOGUI3 TEST TN3270 EDIT MODE'
MSG1L    EQU   *-MSG1
MSG2     DC    C'ENTER TEXT TO DISPLAY'
MSG2L    EQU   *-MSG2
MSG3     EQU   *
REPLY    DC    CL40' '
REPLYL   EQU   *-REPLY
MSG3L    EQU   *-MSG3
         END
