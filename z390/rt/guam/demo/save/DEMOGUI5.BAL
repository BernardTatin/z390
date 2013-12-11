*********************************************************************
* Copyright 2005 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
* Date   - 11/30/05                                                 *
*********************************************************************
* RUN DEMOGUI5 WITH GUI OPTION TO DEMO GUI GPRAHIC VIEW
*********************************************************************
* 12/02/05 RPI47  ADD DEMO OF GUI GRAPHIC DISPLAY COMMANDS
* 02/21/06 RPI206 CHANGE NAME FROM GUI TO GUAM
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI5 SUBENTRY
DEMOGUI5    CSECT
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'DEMOGUI5'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING DEMOGUI5+8,13
*MEXIT #=     1 LV= 1 SUBENTRY
*MCALL #=     2 LV= 1          WTO   'DEMOGUI5 GRAPHICS DEMO - MSG FOR X
               MCS LOG'
         BRAS  1,*+(WTO#0002_EOT-*+1)/2*2
         DC    AL2(WTO#0002_EOT-*,0),C'DEMOGUI5 GRAPHICS DEMO - MSG FORX
                MCS LOG'
WTO#0002_EOT EQU *
         SVC   35
*MEXIT #=     2 LV= 1 WTO
*MCALL #=     3 LV= 1          TPUT  MSG1,L'MSG1
         LA    1,MSG1
         LA    0,L'MSG1
         ICM   1,8,=B'00000000'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     3 LV= 1 TPUT
*MCALL #=     4 LV= 1          GUAM  WINDOW,TITLE,'DEMOGUI5 GUI GRAPHICX
                DISPLAY DEMO'
        LA     0,GUI_WINDOW_TITLE
        LA     15,=C'"DEMOGUI5 GUI GRAPHIC DISPLAY DEMO"'     R15=A(TITX
               LE) DQ DELIMITED
        LA     1,=A(*-*)
        ST     15,0(1)            R1=A(A(TITLE))
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=     4 LV= 1 GUAM
*MCALL #=     5 LV= 1          GUAM  WINDOW,VIEW,GRAPH,800,600,BLUE    X
               BACKGROUND
        LA     0,GUI_WINDOW_VIEW
        LA     1,=A(GUI_WINDOW_VIEW_GRAPH,800,600,BLUE) R1=VIEW (0-NONEX
               ,1=MCS,2=SCREEN,3=GRAPH)
        LA     15,=A(800)
        ST     15,4(1)
        LA     15,=A(600)
        ST     15,8(1)
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=     5 LV= 1 GUAM
*MCALL #=     6 LV= 1          GUAM  GRAPH,TEXT,100,100,'HELLO FROM GUIX
                GRAPHIC DISPLAY',,RED
        LA     0,GUI_GRAPH_TEXT
        LA     1,=A(100,100,*-*,*-*,RED)       R1=A(X,Y,'text',text_lenX
               gth,COLOR)   RPI217
        LA     15,=C'HELLO FROM GUI GRAPHIC DISPLAY'
        ST     15,8(1)
        LA     15,30 RPI217
        ST     15,12(1)
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=     6 LV= 1 GUAM
*MCALL #=     7 LV= 1          GUAM  GRAPH,LINE,200,200,200,400,WHITE  X
               DRAW A BOX
        LA     0,GUI_GRAPH_LINE
        LA     1,=A(200,200,200,400,WHITE) R1=A(X1,Y1,X2,Y2,COLOR)
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=     7 LV= 1 GUAM
*MCALL #=     8 LV= 1          GUAM  GRAPH,LINE,200,400,400,400,WHITE
        LA     0,GUI_GRAPH_LINE
        LA     1,=A(200,400,400,400,WHITE) R1=A(X1,Y1,X2,Y2,COLOR)
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=     8 LV= 1 GUAM
*MCALL #=     9 LV= 1          GUAM  GRAPH,LINE,400,400,200,400,WHITE
        LA     0,GUI_GRAPH_LINE
        LA     1,=A(400,400,200,400,WHITE) R1=A(X1,Y1,X2,Y2,COLOR)
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=     9 LV= 1 GUAM
*MCALL #=    10 LV= 1          GUAM  GRAPH,LINE,200,400,200,200,WHITE
        LA     0,GUI_GRAPH_LINE
        LA     1,=A(200,400,200,200,WHITE) R1=A(X1,Y1,X2,Y2,COLOR)
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=    10 LV= 1 GUAM
*MCALL #=    11 LV= 1          GUAM  GRAPH,FILL,205,205,395,395,RED    X
               DRAW RED BOX INSIDE
        LA     0,GUI_GRAPH_FILL
        LA     1,=A(205,205,395,395,RED) R1=A(X1,Y1,X2,Y2,COLOR)
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=    11 LV= 1 GUAM
*MCALL #=    12 LV= 1          GUAM  KEYBOARD,READ,MODE,CHAR,WAIT  HIT X
               ANY KEY TO EXIT
        LA     0,GUI_KEYBOARD_READ
        LA     1,=A(MODE,CHAR,GUI_WAIT) R1=A(mode,char,WAIT/NOWAIT)
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=    12 LV= 1 GUAM
*MCALL #=    13 LV= 1          SUBEXIT
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=    13 LV= 1 SUBEXIT
*MCALL #=    14 LV= 1          GUAM  SYMBOLS
GUI_WINDOW_TITLE       EQU X'0101' GUI WINDOW,TITLE,'text'
GUI_WINDOW_LOC         EQU X'0102' GUI WINDOW,LOC,x,y
GUI_WINDOW_SIZE        EQU X'0103' GUI WINDOW,width,height
GUI_WINDOW_FONT        EQU X'0104' GUI WINDOW,size (8-30)
GUI_WINDOW_VIEW        EQU X'0105' GUI WINDOW,VIEW,type (0-3)
GUI_WINDOW_VIEW_NONE   EQU 0       GUI WINDOW,VIEW,NONE window closed
GUI_WINDOW_VIEW_MCS    EQU 1       GUI WINDOW,VIEW,MCS console log
GUI_WINDOW_VIEW_SCREEN EQU 2       GUI WINDOW,VIEW,SCREEN,row,col,color
GUI_WINDOW_VIEW_GRAPH  EQU 3       GUI WINDOW,VIEW,GRAPH,x,y,color
GUI_WINDOW_GETVIEW     EQU X'0106' GUI WINDOW,GETVIEW return view 0-3
GUI_SCREEN_READ        EQU X'0201' GUI SCREEN,READ,b,lb,WAIT/NOWAIT
GUI_WAIT               EQU 1       GUI WAIT FOR KEYBOARD INPUT
GUI_NOWAIT             EQU 0       GUI NOWAIT RETURN R15=4 IF NO INPUT
GUI_SCREEN_WRITE       EQU X'0202' GUI SCREEN,WRITE,row,col,b,lb,color
GUI_SCREEN_FIELD       EQU X'0203' GUI SCREEN,FIELD,row,col,length
GUI_SCREEN_CURSOR      EQU X'0204' GUI SCREEN,CURSOR,row,col,type
GUI_SCREEN_COLOR       EQU X'0205' GUI SCREEN,COLOR,bg_color,text_color
GUI_GRAPH_POINT        EQU X'0301' GUI GRAPH,POINT,x,y,color
GUI_GRAPH_LINE         EQU X'0302' GUI GRAPH,LINE,x1,y1,x2,y2,color
GUI_GRAPH_FILL         EQU X'0303' GUI GRAPH,FILL,x1,y1,x2,y2,color
GUI_GRAPH_TEXT         EQU X'0304' GUI GRAPH,TEXT,x,y,'text',color
GUI_KEYBOARD_READ      EQU X'0401' GUI KEYBOARD,mode,char,WAIT/NOWAIT
GUI_MOUSE_READ         EQU X'0501' GUI MOUSE,x,y,left,right
GUI_BUTTON_DOWN        EQU 1 MOUSE BUTTON PRESSED DOWN
GUI_BUTTON_UP          EQU 0 MOUSE BUTTON UP
GUI_SOUND_PLAY         EQU X'0601' GUI SOUND,PLAY,wav_file
*MEXIT #=    14 LV= 1 GUAM
MODE     DC    F'0'
CHAR     DC    X'00'
*MCALL #=    15 LV= 1 RED      GUAM  COLOR,RED
RED       DS    0H
         DC    AL1(0,255,0,0) RGB RED COLOR
*MEXIT #=    15 LV= 1 GUAM
*MCALL #=    16 LV= 1 WHITE    GUAM  COLOR,WHITE
WHITE       DS    0H
         DC    AL1(0,255,255,255) RGB WHITE COLOR
*MEXIT #=    16 LV= 1 GUAM
*MCALL #=    17 LV= 1 BLUE     GUAM  COLOR,BLUE
BLUE       DS    0H
         DC    AL1(0,0,0,255) RGB BLUE COLOR
*MEXIT #=    17 LV= 1 GUAM
MSG1     DC    C'DEMOGUI5 GRAPHICS DEMO - MSG FOR TN3270 SCREEN'
         END
