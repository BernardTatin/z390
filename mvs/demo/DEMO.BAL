*********************************************************************
* Copyright 2005 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 09/30/05                                                 *
*********************************************************************
         TITLE 'Z390 HELLO WORLD DEMO'
* YOU CAN ASSEMBLE, LINK, AND EXECUTE THIS DEMO
* USING Z390 GUI INTERFACE BY ENTERING DEMO IN COMMAND BOX
* OR BY EXECUTING DEMO FROM WINDOWS COMMAND LINE
* WITH CURRENT DIRECTORY SET TO Z390 INSTALL DIRECTORY WHICH
* IS "C:\PROGRAM FILES\AUTOMATED SOFTWARE TOOLS\Z390"
* THE Z390 TOOLKIT IS DISTRIBUTED IN SOURCE AND EXECUTABLE
* FORMAT UNDER OPEN SOURCE GPL LICENSE.  VISIT WWW.Z390.ORG
* FOR MORE INFORMATION.
*MCALL #=     1 LV= 1 DEMO     SUBENTRY 
DEMO     CSECT 
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'DEMO'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING DEMO+8,13
*MEXIT #=     1 LV= 1 SUBENTRY
*MCALL #=     2 LV= 1          WTO   'HELLO WORLD'
         CNOP  0,4
         BAL   1,IHB0002A                        BRANCH AROUND MESSAGE
         DC    AL2(15)           TEXT LENGTH
         DC    B'0000000000000000'     MCS FLAGS
         DC    C'HELLO WORLD'
IHB0002A DS    0H
         SVC   35
*MEXIT #=     2 LV= 1 WTO
*MCALL #=     3 LV= 1          SUBEXIT 
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=     3 LV= 1 SUBEXIT
         END 
