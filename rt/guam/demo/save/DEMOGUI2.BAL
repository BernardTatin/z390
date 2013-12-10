*********************************************************************
* Copyright 2005 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 11/28/05                                                 *
*********************************************************************
*
* RUN DEMOGUI2 WITH GUI OPTION TO DEMO WTO/WTOR GUI MCS CONSOLE
* WITH LOOP COUNTER RUNNING BETWEEN REPLYS TO SHOW MULTI-PROCESSING
*
* DEMOGUI2 CAN BE RUN IN 4 DIFFERENT MODES:
*    1. Windows command line interface
*       a.  Enter command: ez390 demo\demogui2
*       b.  Enter replies when prompted and terminal with END.
*       c.  When a WTOR reply is pending with GUI option off,
*           ez390 monitors the system standard input for keyboard input
*           and when ready, stores reply and posts ecb complete.
*
*    2. Windows z390 GUI system window interface
*       a.  Enter command: ez390 demo\demogui2
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
*       a.  Enter command: ez390 demo\demogui2 gui
*       b.  Enter replies when prompted and terminal with END.
*       c.  When a WTOR reply is pending with GUI option on,
*           ez390 monitors the GUI application window for command input
*           and when ready, stores reply and posts ecb complete.  WTO
*           and reply messages are routed to the GUI application window
*           for display on MCS console view panel and are also logged
*           on the z390 system log file.
*
*    4. Windows z390 GUI system window interface
*       a.  Enter command: ez390 demo\demogui2 gui
*       b.  Enter replies when prompted and terminal with END.
*       c.  When a WTOR reply is pending with GUI option on,
*           ez390 monitors the GUI application window for command input
*           and when ready, stores reply and posts ecb complete.  WTO
*           and reply messages are routed to the GUI application window
*           for display on MCS console view panel.  Note in this case
*           wto messages and reply messages are also routed to the
*           separate Z390 GUI system window scrolling log display and
*           system log file.
*
*   See DEMOGUI1 for simllar demo using WAIT for each reply.
*
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI2 SUBENTRY
DEMOGUI2    CSECT
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'DEMOGUI2'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING DEMOGUI2+8,13
*MEXIT #=     1 LV= 1 SUBENTRY
*MCALL #=     2 LV= 1          WTO   'DEMOGUI2 DEMO WTO AND WTOR MULTI-X
               PROCESSING'
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'DEMOGUI2 DEMO WTO AND WTOR MULTIX
               -PROCESSING'
WTO#0002_EOT EQU *
         SVC   35
*MEXIT #=     2 LV= 1 WTO
         SGR   R3,R3           R3 = TOTAL INSTRUCTION COUNT
LOOP1    EQU   *
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
*MCALL #=     4 LV= 1          TIME  NS,TOD_NS_START
         LA    0,8 NANOSECONDS - DOUBLE WORD BIT 63 NANO-SEC COUNTER
         LA    1,TOD_NS_START
         SVC   11 TIME AND DATE
*MEXIT #=     4 LV= 1 TIME
         STG   R3,INS_START
         LG    R4,=FL8'3'      INS INC = AGR,TM,BO LOOP2
LOOP2    EQU   *
         AGR   R3,R4           COUNT INSTRUCTIONS EXECUTED
         TM    WAITECB,X'80'   ARE WE STILL WAITING FOR REPLY
         BO    LOOP2           YES, KEEP COUNTING
*MCALL #=     5 LV= 1          TIME  NS,TOD_NS_END
         LA    0,8 NANOSECONDS - DOUBLE WORD BIT 63 NANO-SEC COUNTER
         LA    1,TOD_NS_END
         SVC   11 TIME AND DATE
*MEXIT #=     5 LV= 1 TIME
         STG   R3,INS_END
*MCALL #=     6 LV= 1          WTO   MF=(E,WTOMSG1)       DISPLAY REPLYX
                =
         LA    1,WTOMSG1
         SVC   35
*MEXIT #=     6 LV= 1 WTO
*MCALL #=     7 LV= 1          TIME  DEC,TIMEDATE,LINKAGE=SYSTEM,DATETYX
               PE=MMDDYYYY
         LA    0,10   DEC   0(4,R1) = HHMMSSTH
         LA    1,TIMEDATE
         IILH  0,2      8(4,R1) = HEX MMDDYYYY
         SVC   11 TIME AND DATE
*MEXIT #=     7 LV= 1 TIME
         UNPK  DWORK(9),TIMEDATE+8(5)
         MVC   DDATE(2),DWORK
         MVC   DDATE+3(2),DWORK+2
         MVC   DDATE+6(2),DWORK+6
*MCALL #=     8 LV= 1          WTO   MF=(E,WTOMSG2)       DISPLAY DATE X
               = MM/DD/YY
         LA    1,WTOMSG2
         SVC   35
*MEXIT #=     8 LV= 1 WTO
         MVC   DTIME,MTIME
         ED    DTIME,TIMEDATE
*MCALL #=     9 LV= 1          WTO   MF=(E,WTOMSG3)       DISPLAY TIME X
               = HH:MM:SS:TH
         LA    1,WTOMSG3
         SVC   35
*MEXIT #=     9 LV= 1 WTO
         CVDG  R3,PWORK16
         MVC   DCOUNT,MCOUNT
         ED    DCOUNT,PWORK16+10
*MCALL #=    10 LV= 1          WTO   MF=(E,WTOMSG4)       DISPLAY TOTALX
                INS COUNT
         LA    1,WTOMSG4
         SVC   35
*MEXIT #=    10 LV= 1 WTO
         LG    R4,INS_END
         SG    R4,INS_START         R4 = INT COUNT
         CVDG  R4,PWORK16
         MVC   DICOUNT,MCOUNT
         ED    DICOUNT,PWORK16+10
*MCALL #=    11 LV= 1          WTO   MF=(E,WTOMSG5)       DISPLAY INTERX
               VAL INS COUNT
         LA    1,WTOMSG5
         SVC   35
*MEXIT #=    11 LV= 1 WTO
         LG    R5,TOD_NS_END
         SG    R5,TOD_NS_START      R5 = INT NS
         LGR   R1,R5
         DSGF  R0,=F'1000000'
         CVDG  R1,PWORK16           R1 = INT MILLISECONDS
         MVC   DITIME,MCOUNT
         ED    DITIME,PWORK16+10
*MCALL #=    12 LV= 1          WTO   MF=(E,WTOMSG6)       DISPLAY INTERX
               VAL NS
         LA    1,WTOMSG6
         SVC   35
*MEXIT #=    12 LV= 1 WTO
         LGR   R1,R4
         MSGF  R1,=F'1000000000'    R1=INT COUNT * 10E9
         DSGR  R0,R5
         CVDG  R1,PWORK16
         MVC   DRATE,MCOUNT
         ED    DRATE,PWORK16+10
*MCALL #=    13 LV= 1          WTO   MF=(E,WTOMSG7)
         LA    1,WTOMSG7
         SVC   35
*MEXIT #=    13 LV= 1 WTO
         CLC   REPLY(3),=C'END'
         BNE   LOOP1
*MCALL #=    14 LV= 1 EOF      WTO   'DEMOGUI2 ENDING OK'
EOF       DS    0H
         BRAS  1,*+(WTO#0014_EOT-*+1)/2*2
         DC    AL2(WTO#0014_EOT-*,0),C'DEMOGUI2 ENDING OK'
WTO#0014_EOT EQU *
         SVC   35
*MEXIT #=    14 LV= 1 WTO
*MCALL #=    15 LV= 1          SUBEXIT
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=    15 LV= 1 SUBEXIT
WAITECB  DC    F'0'
PWORK16  DC    XL16'0'
TOD_NS_START DC FL8'0'
TOD_NS_END   DC FL8'0'
INS_START    DC FL8'0'
INS_END      DC FL8'0'
MTIME    DC    C' ',X'2120',C':',X'2020',C':',X'2020',C':',X'2020'
MCOUNT   DC    C' ',11X'20'
TIMEDATE DC    XL16'00'
DWORK    DC    XL9'00'
WTOMSG1  DC    AL2(WTOEND1-*,0),C'WTOR REPLY            = '
REPLY    DC    CL40' '
WTOEND1  EQU   *
WTOMSG2  DC    AL2(WTOEND2-*,0),C'CURRENT DATE          = '
DDATE    DC    C'MM/DD/YY'
WTOEND2  EQU   *
WTOMSG3  DC    AL2(WTOEND3-*,0),C'CURRENT TIME          ='
DTIME    DC    C' HH:MM:SS:TH'
WTOEND3  EQU   *
WTOMSG4  DC    AL2(WTOEND4-*,0),C'TOTAL INSTRUCTIONS    ='
DCOUNT   DC    CL12' '
WTOEND4  EQU   *
WTOMSG5  DC    AL2(WTOEND5-*,0),C'INTERVAL INSTRUCTIONS ='
DICOUNT  DC    CL12' '
WTOEND5  EQU   *
WTOMSG6  DC    AL2(WTOEND6-*,0),C'INTERVAL TIME (MS)    ='
DITIME   DC    CL12' '
WTOEND6  EQU   *
WTOMSG7  DC    AL2(WTOEND7-*,0),C'INTERVAL INS/SEC      ='
DRATE    DC    CL12' '
WTOEND7  EQU   *
*MCALL #=    16 LV= 1          EQUREGS
R0 EQU 0
R1 EQU 1
R2 EQU 2
R3 EQU 3
R4 EQU 4
R5 EQU 5
R6 EQU 6
R7 EQU 7
R8 EQU 8
R9 EQU 9
R10 EQU 10
R11 EQU 11
R12 EQU 12
R13 EQU 13
R14 EQU 14
R15 EQU 15
*MEXIT #=    16 LV= 1 EQUREGS
         END
