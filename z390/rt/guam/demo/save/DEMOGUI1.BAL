*********************************************************************
* Copyright 2005 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 11/28/05                                                 *
*********************************************************************
*
* RUN DEMOGUI1 WITH GUI OPTION TO DEMO WTO/WTOR/WAIT GUI MCS CONSOLE
*
* DEMOGUI1 CAN BE RUN IN 4 DIFFERENT MODES:
*    1. Windows command line interface
*       a.  Enter command: ez390 demo\demogui1
*       b.  Enter replies when prompted and terminal with END.
*       c.  When a WTOR reply is pending with GUI option off,
*           ez390 monitors the system standard input for keyboard input
*           and when ready, stores reply and posts ecb complete.
*
*    2. Windows z390 GUI system window interface
*       a.  Enter command: ez390 demo\demogui1
*       b.  Enter replies when prompted and terminal with END.
*       c.  When a WTOR reply is pending GUI option off,
*           ez390 monitors the system standard input for keyboard input
*           and when ready, stores reply and posts ecb complete.  Note
*           this case the standard input is supplied to ez390 process
*           started from the z390 GUI system window and the wto message
*           and reply messages are routed back to the z390 GUI system
*           window scrolling log display.
*
*    3. Windows command line interface
*       a.  Enter command: ez390 demo\demogui1 gui
*       b.  Enter replies when prompted and terminal with END.
*       c.  When a WTOR reply is pending with GUI option on,
*           ez390 monitors the GUI application window for command input
*           and when ready, stores reply and posts ecb complete.  WTO
*           and reply messages are routed to the GUI application window
*           for display on MCS console view panel and are also logged
*           on the z390 system log file.
*
*    4. Windows z390 GUI system window interface
*       a.  Enter command: ez390 demo\demogui1 gui
*       b.  Enter replies when prompted and terminal with END.
*       c.  When a WTOR reply is pending with GUI option on,
*           ez390 monitors the GUI application window for command input
*           and when ready, stores reply and posts ecb complete.  WTO
*           and reply messages are routed to the GUI application window
*           for display on MCS console view panel.  Note in this case
*           wto messages and reply messages are also routed to the
*           separate z390 GUI system window scrolling log display and
*           system log file.
*
*   See DEMOGUI2 for simllar demo but with counter being incremented
*   in loop until WTOR ECB is posted indicationg reply is read.  The
*   time and AP instructions since last reply is displayed.
*
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI1 SUBENTRY
DEMOGUI1    CSECT
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'DEMOGUI1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING DEMOGUI1+8,13
*MEXIT #=     1 LV= 1 SUBENTRY
*MCALL #=     2 LV= 1          WTO   'DEMOGUI1 DEMO WTO AND WTOR WAIT LX
               OOP'
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'DEMOGUI1 DEMO WTO AND WTOR WAIT X
               LOOP'
WTO#0002_EOT EQU *
         SVC   35
*MEXIT #=     2 LV= 1 WTO
LOOP     EQU   *
*MCALL #=     3 LV= 1          WTOR  'ENTER TEXT TO DISPLAY OR END',REPX
               LY,,WAITECB
         BAL   1,*+(WTOR#0003_EOT-*+1)/2*2
         DC    AL2(WTOR#0003_EOT-*,0),C'ENTER TEXT TO DISPLAY OR END'
WTOR#0003_EOT EQU *
         LA    0,REPLY
         LA    14,L'REPLY
         LA    15,WAITECB
         SVC   160 WTOR R1=MSG,R0=REPLY,R14=LEN,R15=ECB
*MEXIT #=     3 LV= 1 WTOR
*MCALL #=     4 LV= 1          WAIT  ECB=WAITECB
         SR    0,0
         LA    1,WAITECB
         SVC   1 (R0=0,R1=A(ECB) OR (R0=NUM,R1=ECBLIST)
*MEXIT #=     4 LV= 1 WAIT
         CLC   REPLY(3),=C'END'
         BE    EOF
*MCALL #=     5 LV= 1          WTO   MF=(E,WTOMSG1)
         LA    1,WTOMSG1
         SVC   35
*MEXIT #=     5 LV= 1 WTO
         B     LOOP
*MCALL #=     6 LV= 1 EOF      WTO   'DEMOGUI1 ENDING OK'
EOF       DS    0H
         BRAS  1,*+(WTO#0006_EOT-*+1)/2*2
         DC    AL2(WTO#0006_EOT-*,0),C'DEMOGUI1 ENDING OK'
WTO#0006_EOT EQU *
         SVC   35
*MEXIT #=     6 LV= 1 WTO
*MCALL #=     7 LV= 1          SUBEXIT
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=     7 LV= 1 SUBEXIT
WAITECB  DC    F'0'
WTOMSG1  DC    AL2(WTOEND1-*,0),C'TEXT ENTERED = '
REPLY    DC    CL40' '
WTOEND1  EQU   *
         END
