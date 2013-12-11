*********************************************************************
* Copyright 2006 Automated Software Tools Corporation               *
* This source code is part of z390 assembler/emulator package       *
* The z390 package is distributed under GNU general public license  *
* Author - Don Higgins                                              *
*********************************************************************
* DEMO DISPLAY OF APL GRAPHICS UNICODE CHARACTERS USING GE GRAPHIC
* ESCAPE X'08' FOLLOWED BY BYTE INDEX TO APL CODE TABLE.
*********************************************************************
* 05/17/06 DSH RPI 227 ADD GUAM TN3270 GE GRAPHIC ESCAPE ORDER SUPP.
* 05/24/06 DSH RPI 227 ADD GUAM SCREEN,COLOR,BG,TEXT
*********************************************************************
*MCALL #=     1 LV= 1 DEMOAPL1 SUBENTRY
DEMOAPL1    CSECT
         STM   14,12,12(13)
         BAL   15,104(15)
         DC    18F'0'
         DC    CL8'DEMOAPL1'
         DC    CL8'01/02/05'
         DC    CL8'22.33'
         ST    15,8(13)
         ST    13,4(15)
         LR    13,15
         USING DEMOAPL1+8,13
*MEXIT #=     1 LV= 1 SUBENTRY
*MCALL #=     2 LV= 1          GUAM  WINDOW,TITLE,'DEMOAPL1 SHOWING APLX
                CHARACTERS'
        LA     0,GUI_WINDOW_TITLE
        LA     15,=C'"DEMOAPL1 SHOWING APL CHARACTERS"'     R15=A(TITLEX
               ) DQ DELIMITED
        LA     1,=A(*-*)
        ST     15,0(1)            R1=A(A(TITLE))
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=     2 LV= 1 GUAM
*MCALL #=     3 LV= 1          GUAM  SCREEN,COLOR,GREEN,BLACK
        LA     0,GUI_SCREEN_COLOR
        LA     1,=A(GREEN,BLACK)
         SVC   84 GUAM R0LL=MAJOR/MINOR
*MEXIT #=     3 LV= 1 GUAM
*MCALL #=     4 LV= 1          TPUT  STREAM,LSTREAM,FULLSCR
         LA    1,STREAM
         LA    0,LSTREAM
         ICM   1,8,=B'00000011'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     4 LV= 1 TPUT
*MCALL #=     5 LV= 1          TGET  INBUF,LINBUF,ASIS
         LA    1,INBUF
         LA    0,LINBUF
         ICM   1,8,=B'10000001'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     5 LV= 1 TGET
*MCALL #=     6 LV= 1          SUBEXIT
         LA    15,0
         L     13,4(,13)
         L     14,12(,13)
         LM    2,12,28(13)
         BR    14
*MEXIT #=     6 LV= 1 SUBEXIT
*MCALL #=     7 LV= 1          TN3270 SYMBOLS DEFINE TN3290 CONTROL ANDX
                ATTRIBUTE CODES
*
* TN3270 CALL OPTIONS FROM TOP 16 BITS OF FIRST WORD OF PARMLIST
*
TGET_EDIT_WAIT   EQU X'80' READ,EDIT,WAIT FOR TN3270 DEVICE
TGET_EDIT_NOWAIT EQU X'90' READ,EDIT,WAIT FOR TN3270 DEVICE
TGET_ASIS_WAIT   EQU X'81' READ,ASIS,WAIT FOR TN3270 DEVICE
TGET_ASIS_NOWAIT EQU X'91' READ,ASIS,NOWAIT FOR TN3270 DEVICE
TPUT_EDIT        EQU X'00' WRITE,FULLSCN  FOR 3270 DEVICE
TPUT_ASIS        EQU X'01' WRITE,FULLSCN  FOR 3270 DEVICE
TPUT_FULLSCR     EQU X'03' WRITE,FULLSCN  FOR 3270 DEVICE
*
* TN3270 DATA STREAM PREFIX CONTROL CODES
*
ESC      EQU   X'27'       ESCAPE (OPTIONAL FOLLOWED BY WRT,WCC)
WRT      EQU   X'F1'       WRITE
WRT_EW   EQU   X'F5'       ERASE WRITE
WRT_EWA  EQU   X'7E'       ERASE WRITE ALTERNATE
WRT_EAU  EQU   X'6F'       ERASE ALL UNPROTECTED FIELDS RPI 628
WCC_BKD  EQU   X'C7'       WCC BEEP, RESET KBD, RESET MDT
WCC_KD   EQU   X'C3'       WCC RESET KBD, RESET MDT
*
* TN3270 DATA STREAM ORDERS
*
PT       EQU   X'05'       PROGRAM TAB (ADVANCE TO NEXT UNPROT FIELD)
GE       EQU   X'08'       GRAPHIC ESCAPE (REPLACE CHAR FROM APL TAB)
SBA      EQU   X'11'       SET BUFFER ADDRESS (2 ADDR BYTES)
SF       EQU   X'1D'       START FIELD        (1 - ATTRIBUTE BYTE)
EUA      EQU   X'12'       ERASE UNPROTECTED FIELDS TO (2 ADDR BYTES)
IC       EQU   X'13'       INSERT CURSOR AT CURRENT SBA
SFE      EQU   X'29'       START EXTENDED FIELD (COUNT,(ATT_TYPE,ATT))
RA       EQU   X'3C'       REPEAT TO ADDR (2 ADDR BYTES, REPEAT CHAR)
*
* TN3270 KEYBOARD INPUT AID CONTROL CODES
*
NOAID    EQU   X'60'       NO AID AVAILABLE
ENTER    EQU   X'7D'       ENTER KEY
PF1      EQU   X'F1'       PROGRAM FUNCTION KEY 1
PF2      EQU   X'F2'       PROGRAM FUNCTION KEY 2
PF3      EQU   X'F3'       PROGRAM FUNCTION KEY 3
PF4      EQU   X'F4'       PROGRAM FUNCTION KEY 4
PF5      EQU   X'F5'       PROGRAM FUNCTION KEY 5
PF6      EQU   X'F6'       PROGRAM FUNCTION KEY 6
PF7      EQU   X'F7'       PROGRAM FUNCTION KEY 7
PF8      EQU   X'F8'       PROGRAM FUNCTION KEY 8
PF9      EQU   X'F9'       PROGRAM FUNCTION KEY 9
PF10     EQU   X'7A'       PROGRAM FUNCTION KEY 10
PF11     EQU   X'7B'       PROGRAM FUNCTION KEY 11
PF12     EQU   X'7C'       PROGRAM FUNCTION KEY 12
PF13     EQU   X'C1'       PROGRAM FUNCTION KEY 13 (CTRL-ALT F1-F12)
PF14     EQU   X'C2'       PROGRAM FUNCTION KEY 14 (CTRL-ALT F1-F12)
PF15     EQU   X'C3'       PROGRAM FUNCTION KEY 15 (CTRL-ALT F1-F12)
PF16     EQU   X'C4'       PROGRAM FUNCTION KEY 16 (CTRL-ALT F1-F12)
PF17     EQU   X'C5'       PROGRAM FUNCTION KEY 17 (CTRL-ALT F1-F12)
PF18     EQU   X'C6'       PROGRAM FUNCTION KEY 18 (CTRL-ALT F1-F12)
PF19     EQU   X'C7'       PROGRAM FUNCTION KEY 19 (CTRL-ALT F1-F12)
PF20     EQU   X'C8'       PROGRAM FUNCTION KEY 20 (CTRL-ALT F1-F12)
PF21     EQU   X'C9'       PROGRAM FUNCTION KEY 21 (CTRL-ALT F1-F12)
PF22     EQU   X'4A'       PROGRAM FUNCTION KEY 22 (CTRL-ALT F1-F12)
PF23     EQU   X'4B'       PROGRAM FUNCTION KEY 23 (CTRL-ALT F1-F12)
PF24     EQU   X'4C'       PROGRAM FUNCTION KEY 24 (CTRL-ALT F1-F12)
PA1      EQU   X'6C'       PROGRAM ATTENTION 1     (CTRL-F1)
PA2      EQU   X'6E'       PROGRAM ATTENTION 2     (CTRL-F2)
PA3      EQU   X'6B'       PROGRAM ATTENTION 3     (CTRL-F3)
CLEAR    EQU   X'6D'       CLEAR SCREEN            (CTRL-C)
*
* LOCAL 3270 KEYBOARD COMMANDS - RPI 628 (SEE GZ390.JAVA)
* (THESE KEYSTROKES ONLY CHANGE TN3270 BUFFER SO NO CODE ASSIGNED)
*
* EEOF - ERASE TO END OF FIELD   (CTRL-F6)
* EINP - ERASE INPUT             (CTRL-F7)
*
* TN3270 ATTRIBUTE BYTES
*
*  BIT 0-1 CHECKSUM
*  BIT 2   PROTECTED FIELD
*  BIT 3   NUMBERIC  FIELD
*  BIT 4-5 FIELD DISPLAY
*           00=NORMAL INTENSITY
*           01=NORMAL INTENSITY PLUS LIGHT PEN
*           10=HIGH   INTENSITY NO LIGHT PEN
*           11=NON DISPLAY USED FOR HIDDEN FIELDS
*
*                EBCDIC CHAR 6bit RPI 572 See 3270 Pgmr Ref Appendix C
ATT_PAH     EQU X'F8'  '8'  38   PROTECTED HIGH INTENSITY TEXT
ATT_PND     EQU X'6C'  '%"  3C   PROTECTED NON-DISPLAY
ATT_PA      EQU X'F0'  '0'  30   PROTECTED NORMAL TEXT
ATT_UA      EQU X'40'  ' '  00   UNPROTECTED ALPHA INPUT FIELD
ATT_UN      EQU X'50'  '&'  10   UNPROTECTED NUMERIC INPUT FIELD
ATT_UND     EQU X'4C'  '<'  0C   UNPROTECTED NON-DISPLAY
ATT_PAH_MDT EQU X'F9'  '9'  39   PROTECTED HIGH INTENSITY TEXT, MDT
ATT_PA_MDT  EQU X'F1'  '1'  31   PROTECTED NORMAL TEXT, MDT
ATT_UA_MDT  EQU X'C1'  'A'  01   UNPROTECTED ALPHA INPUT FIELD, MDT
ATT_UN_MDT  EQU X'D1'  'J'  11   UNPROTECTED NUMERIC INPUT FIELD, MDT
*
* SFE ENTENDED ATTRIBUTE TYPE PREFIXES
*
SFE_BFA  EQU   X'C0'       BASIC FIELD ATTRIBUTE
SFE_HL   EQU   X'41'       EXTENDED HIGHLIGHTING
SFE_COLOR EQU  X'42'       COLOR
SFE_DEFAULT   EQU X'00'
SFE_BLUE      EQU X'F1'
SFE_RED       EQU X'F2'
SFE_PINK      EQU X'F3'
SFE_GREEN     EQU X'F4'
SFE_TURQUOISE EQU X'F5'
SFE_YELLOW    EQU X'F6'
SFE_WHITE     EQU X'F7'
*MEXIT #=     7 LV= 1 TN3270
*MCALL #=     8 LV= 1 STREAM   TN3270 ESC,WRT_EW,WCC_KD
STREAM       EQU   *
         DC    AL1(ESC,WRT_EW,WCC_KD)
*MEXIT #=     8 LV= 1 TN3270
*MCALL #=     9 LV= 1          TN3270 (SBA,3,10)
         DC    AL1(SBA,194,233)
*MEXIT #=     9 LV= 1 TN3270
*MCALL #=    10 LV= 1          TN3270 (SFE,2,SFE_BFA,ATT_PA,SFE_COLOR,SX
               FE_BLUE)
         DC    AL1(SFE,2,SFE_BFA,ATT_PA,SFE_COLOR,SFE_BLUE)
*MEXIT #=    10 LV= 1 TN3270
*MCALL #=    11 LV= 1          TN3270 C'DEMOAPL1 SHOW TN3270 APL CODES'
         DC    C'DEMOAPL1 SHOW TN3270 APL CODES'
*MEXIT #=    11 LV= 1 TN3270
*MCALL #=    12 LV= 1          TN3270 (SBA,6,10),(SF,ATT_PA),CL10' ROW X
               1',C'='
         DC    AL1(SBA,198,217)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 1'
         DC    C'='
*MEXIT #=    12 LV= 1 TN3270
*MCALL #=    13 LV= 1          TN3270 (GE,0)
         DC    AL1(GE,0)
*MEXIT #=    13 LV= 1 TN3270
*MCALL #=    14 LV= 1          TN3270 (GE,1)
         DC    AL1(GE,1)
*MEXIT #=    14 LV= 1 TN3270
*MCALL #=    15 LV= 1          TN3270 (GE,2)
         DC    AL1(GE,2)
*MEXIT #=    15 LV= 1 TN3270
*MCALL #=    16 LV= 1          TN3270 (GE,3)
         DC    AL1(GE,3)
*MEXIT #=    16 LV= 1 TN3270
*MCALL #=    17 LV= 1          TN3270 (GE,4)
         DC    AL1(GE,4)
*MEXIT #=    17 LV= 1 TN3270
*MCALL #=    18 LV= 1          TN3270 (GE,5)
         DC    AL1(GE,5)
*MEXIT #=    18 LV= 1 TN3270
*MCALL #=    19 LV= 1          TN3270 (GE,6)
         DC    AL1(GE,6)
*MEXIT #=    19 LV= 1 TN3270
*MCALL #=    20 LV= 1          TN3270 (GE,7)
         DC    AL1(GE,7)
*MEXIT #=    20 LV= 1 TN3270
*MCALL #=    21 LV= 1          TN3270 (GE,8)
         DC    AL1(GE,8)
*MEXIT #=    21 LV= 1 TN3270
*MCALL #=    22 LV= 1          TN3270 (GE,9)
         DC    AL1(GE,9)
*MEXIT #=    22 LV= 1 TN3270
*MCALL #=    23 LV= 1          TN3270 (GE,10)
         DC    AL1(GE,10)
*MEXIT #=    23 LV= 1 TN3270
*MCALL #=    24 LV= 1          TN3270 (GE,11)
         DC    AL1(GE,11)
*MEXIT #=    24 LV= 1 TN3270
*MCALL #=    25 LV= 1          TN3270 (GE,12)
         DC    AL1(GE,12)
*MEXIT #=    25 LV= 1 TN3270
*MCALL #=    26 LV= 1          TN3270 (GE,13)
         DC    AL1(GE,13)
*MEXIT #=    26 LV= 1 TN3270
*MCALL #=    27 LV= 1          TN3270 (GE,14)
         DC    AL1(GE,14)
*MEXIT #=    27 LV= 1 TN3270
*MCALL #=    28 LV= 1          TN3270 (GE,15)
         DC    AL1(GE,15)
*MEXIT #=    28 LV= 1 TN3270
*MCALL #=    29 LV= 1          TN3270 (SBA,7,10),(SF,ATT_PA),CL10' ROW X
               2',C'='
         DC    AL1(SBA,199,233)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 2'
         DC    C'='
*MEXIT #=    29 LV= 1 TN3270
*MCALL #=    30 LV= 1          TN3270 (GE,16)
         DC    AL1(GE,16)
*MEXIT #=    30 LV= 1 TN3270
*MCALL #=    31 LV= 1          TN3270 (GE,17)
         DC    AL1(GE,17)
*MEXIT #=    31 LV= 1 TN3270
*MCALL #=    32 LV= 1          TN3270 (GE,18)
         DC    AL1(GE,18)
*MEXIT #=    32 LV= 1 TN3270
*MCALL #=    33 LV= 1          TN3270 (GE,19)
         DC    AL1(GE,19)
*MEXIT #=    33 LV= 1 TN3270
*MCALL #=    34 LV= 1          TN3270 (GE,20)
         DC    AL1(GE,20)
*MEXIT #=    34 LV= 1 TN3270
*MCALL #=    35 LV= 1          TN3270 (GE,21)
         DC    AL1(GE,21)
*MEXIT #=    35 LV= 1 TN3270
*MCALL #=    36 LV= 1          TN3270 (GE,22)
         DC    AL1(GE,22)
*MEXIT #=    36 LV= 1 TN3270
*MCALL #=    37 LV= 1          TN3270 (GE,23)
         DC    AL1(GE,23)
*MEXIT #=    37 LV= 1 TN3270
*MCALL #=    38 LV= 1          TN3270 (GE,24)
         DC    AL1(GE,24)
*MEXIT #=    38 LV= 1 TN3270
*MCALL #=    39 LV= 1          TN3270 (GE,25)
         DC    AL1(GE,25)
*MEXIT #=    39 LV= 1 TN3270
*MCALL #=    40 LV= 1          TN3270 (GE,26)
         DC    AL1(GE,26)
*MEXIT #=    40 LV= 1 TN3270
*MCALL #=    41 LV= 1          TN3270 (GE,27)
         DC    AL1(GE,27)
*MEXIT #=    41 LV= 1 TN3270
*MCALL #=    42 LV= 1          TN3270 (GE,28)
         DC    AL1(GE,28)
*MEXIT #=    42 LV= 1 TN3270
*MCALL #=    43 LV= 1          TN3270 (GE,29)
         DC    AL1(GE,29)
*MEXIT #=    43 LV= 1 TN3270
*MCALL #=    44 LV= 1          TN3270 (GE,30)
         DC    AL1(GE,30)
*MEXIT #=    44 LV= 1 TN3270
*MCALL #=    45 LV= 1          TN3270 (GE,31)
         DC    AL1(GE,31)
*MEXIT #=    45 LV= 1 TN3270
*MCALL #=    46 LV= 1          TN3270 (SBA,8,10),(SF,ATT_PA),CL10' ROW X
               3',C'='
         DC    AL1(SBA,200,249)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 3'
         DC    C'='
*MEXIT #=    46 LV= 1 TN3270
*MCALL #=    47 LV= 1          TN3270 (GE,32)
         DC    AL1(GE,32)
*MEXIT #=    47 LV= 1 TN3270
*MCALL #=    48 LV= 1          TN3270 (GE,33)
         DC    AL1(GE,33)
*MEXIT #=    48 LV= 1 TN3270
*MCALL #=    49 LV= 1          TN3270 (GE,34)
         DC    AL1(GE,34)
*MEXIT #=    49 LV= 1 TN3270
*MCALL #=    50 LV= 1          TN3270 (GE,35)
         DC    AL1(GE,35)
*MEXIT #=    50 LV= 1 TN3270
*MCALL #=    51 LV= 1          TN3270 (GE,36)
         DC    AL1(GE,36)
*MEXIT #=    51 LV= 1 TN3270
*MCALL #=    52 LV= 1          TN3270 (GE,37)
         DC    AL1(GE,37)
*MEXIT #=    52 LV= 1 TN3270
*MCALL #=    53 LV= 1          TN3270 (GE,38)
         DC    AL1(GE,38)
*MEXIT #=    53 LV= 1 TN3270
*MCALL #=    54 LV= 1          TN3270 (GE,39)
         DC    AL1(GE,39)
*MEXIT #=    54 LV= 1 TN3270
*MCALL #=    55 LV= 1          TN3270 (GE,40)
         DC    AL1(GE,40)
*MEXIT #=    55 LV= 1 TN3270
*MCALL #=    56 LV= 1          TN3270 (GE,41)
         DC    AL1(GE,41)
*MEXIT #=    56 LV= 1 TN3270
*MCALL #=    57 LV= 1          TN3270 (GE,42)
         DC    AL1(GE,42)
*MEXIT #=    57 LV= 1 TN3270
*MCALL #=    58 LV= 1          TN3270 (GE,43)
         DC    AL1(GE,43)
*MEXIT #=    58 LV= 1 TN3270
*MCALL #=    59 LV= 1          TN3270 (GE,44)
         DC    AL1(GE,44)
*MEXIT #=    59 LV= 1 TN3270
*MCALL #=    60 LV= 1          TN3270 (GE,45)
         DC    AL1(GE,45)
*MEXIT #=    60 LV= 1 TN3270
*MCALL #=    61 LV= 1          TN3270 (GE,46)
         DC    AL1(GE,46)
*MEXIT #=    61 LV= 1 TN3270
*MCALL #=    62 LV= 1          TN3270 (GE,47)
         DC    AL1(GE,47)
*MEXIT #=    62 LV= 1 TN3270
*MCALL #=    63 LV= 1          TN3270 (SBA,9,10),(SF,ATT_PA),CL10' ROW X
               4',C'='
         DC    AL1(SBA,74,201)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 4'
         DC    C'='
*MEXIT #=    63 LV= 1 TN3270
*MCALL #=    64 LV= 1          TN3270 (GE,48)
         DC    AL1(GE,48)
*MEXIT #=    64 LV= 1 TN3270
*MCALL #=    65 LV= 1          TN3270 (GE,49)
         DC    AL1(GE,49)
*MEXIT #=    65 LV= 1 TN3270
*MCALL #=    66 LV= 1          TN3270 (GE,50)
         DC    AL1(GE,50)
*MEXIT #=    66 LV= 1 TN3270
*MCALL #=    67 LV= 1          TN3270 (GE,51)
         DC    AL1(GE,51)
*MEXIT #=    67 LV= 1 TN3270
*MCALL #=    68 LV= 1          TN3270 (GE,52)
         DC    AL1(GE,52)
*MEXIT #=    68 LV= 1 TN3270
*MCALL #=    69 LV= 1          TN3270 (GE,53)
         DC    AL1(GE,53)
*MEXIT #=    69 LV= 1 TN3270
*MCALL #=    70 LV= 1          TN3270 (GE,54)
         DC    AL1(GE,54)
*MEXIT #=    70 LV= 1 TN3270
*MCALL #=    71 LV= 1          TN3270 (GE,55)
         DC    AL1(GE,55)
*MEXIT #=    71 LV= 1 TN3270
*MCALL #=    72 LV= 1          TN3270 (GE,56)
         DC    AL1(GE,56)
*MEXIT #=    72 LV= 1 TN3270
*MCALL #=    73 LV= 1          TN3270 (GE,57)
         DC    AL1(GE,57)
*MEXIT #=    73 LV= 1 TN3270
*MCALL #=    74 LV= 1          TN3270 (GE,58)
         DC    AL1(GE,58)
*MEXIT #=    74 LV= 1 TN3270
*MCALL #=    75 LV= 1          TN3270 (GE,59)
         DC    AL1(GE,59)
*MEXIT #=    75 LV= 1 TN3270
*MCALL #=    76 LV= 1          TN3270 (GE,60)
         DC    AL1(GE,60)
*MEXIT #=    76 LV= 1 TN3270
*MCALL #=    77 LV= 1          TN3270 (GE,61)
         DC    AL1(GE,61)
*MEXIT #=    77 LV= 1 TN3270
*MCALL #=    78 LV= 1          TN3270 (GE,62)
         DC    AL1(GE,62)
*MEXIT #=    78 LV= 1 TN3270
*MCALL #=    79 LV= 1          TN3270 (GE,63)
         DC    AL1(GE,63)
*MEXIT #=    79 LV= 1 TN3270
*MCALL #=    80 LV= 1          TN3270 (SBA,10,10),(SF,ATT_PA),CL10' ROWX
                5',C'='
         DC    AL1(SBA,75,217)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 5'
         DC    C'='
*MEXIT #=    80 LV= 1 TN3270
*MCALL #=    81 LV= 1          TN3270 (GE,64)
         DC    AL1(GE,64)
*MEXIT #=    81 LV= 1 TN3270
*MCALL #=    82 LV= 1          TN3270 (GE,65)
         DC    AL1(GE,65)
*MEXIT #=    82 LV= 1 TN3270
*MCALL #=    83 LV= 1          TN3270 (GE,66)
         DC    AL1(GE,66)
*MEXIT #=    83 LV= 1 TN3270
*MCALL #=    84 LV= 1          TN3270 (GE,67)
         DC    AL1(GE,67)
*MEXIT #=    84 LV= 1 TN3270
*MCALL #=    85 LV= 1          TN3270 (GE,68)
         DC    AL1(GE,68)
*MEXIT #=    85 LV= 1 TN3270
*MCALL #=    86 LV= 1          TN3270 (GE,69)
         DC    AL1(GE,69)
*MEXIT #=    86 LV= 1 TN3270
*MCALL #=    87 LV= 1          TN3270 (GE,70)
         DC    AL1(GE,70)
*MEXIT #=    87 LV= 1 TN3270
*MCALL #=    88 LV= 1          TN3270 (GE,71)
         DC    AL1(GE,71)
*MEXIT #=    88 LV= 1 TN3270
*MCALL #=    89 LV= 1          TN3270 (GE,72)
         DC    AL1(GE,72)
*MEXIT #=    89 LV= 1 TN3270
*MCALL #=    90 LV= 1          TN3270 (GE,73)
         DC    AL1(GE,73)
*MEXIT #=    90 LV= 1 TN3270
*MCALL #=    91 LV= 1          TN3270 (GE,74)
         DC    AL1(GE,74)
*MEXIT #=    91 LV= 1 TN3270
*MCALL #=    92 LV= 1          TN3270 (GE,75)
         DC    AL1(GE,75)
*MEXIT #=    92 LV= 1 TN3270
*MCALL #=    93 LV= 1          TN3270 (GE,76)
         DC    AL1(GE,76)
*MEXIT #=    93 LV= 1 TN3270
*MCALL #=    94 LV= 1          TN3270 (GE,77)
         DC    AL1(GE,77)
*MEXIT #=    94 LV= 1 TN3270
*MCALL #=    95 LV= 1          TN3270 (GE,78)
         DC    AL1(GE,78)
*MEXIT #=    95 LV= 1 TN3270
*MCALL #=    96 LV= 1          TN3270 (GE,79)
         DC    AL1(GE,79)
*MEXIT #=    96 LV= 1 TN3270
*MCALL #=    97 LV= 1          TN3270 (SBA,11,10),(SF,ATT_PA),CL10' ROWX
                6',C'='
         DC    AL1(SBA,76,233)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 6'
         DC    C'='
*MEXIT #=    97 LV= 1 TN3270
*MCALL #=    98 LV= 1          TN3270 (GE,80)
         DC    AL1(GE,80)
*MEXIT #=    98 LV= 1 TN3270
*MCALL #=    99 LV= 1          TN3270 (GE,81)
         DC    AL1(GE,81)
*MEXIT #=    99 LV= 1 TN3270
*MCALL #=   100 LV= 1          TN3270 (GE,82)
         DC    AL1(GE,82)
*MEXIT #=   100 LV= 1 TN3270
*MCALL #=   101 LV= 1          TN3270 (GE,83)
         DC    AL1(GE,83)
*MEXIT #=   101 LV= 1 TN3270
*MCALL #=   102 LV= 1          TN3270 (GE,84)
         DC    AL1(GE,84)
*MEXIT #=   102 LV= 1 TN3270
*MCALL #=   103 LV= 1          TN3270 (GE,85)
         DC    AL1(GE,85)
*MEXIT #=   103 LV= 1 TN3270
*MCALL #=   104 LV= 1          TN3270 (GE,86)
         DC    AL1(GE,86)
*MEXIT #=   104 LV= 1 TN3270
*MCALL #=   105 LV= 1          TN3270 (GE,87)
         DC    AL1(GE,87)
*MEXIT #=   105 LV= 1 TN3270
*MCALL #=   106 LV= 1          TN3270 (GE,88)
         DC    AL1(GE,88)
*MEXIT #=   106 LV= 1 TN3270
*MCALL #=   107 LV= 1          TN3270 (GE,89)
         DC    AL1(GE,89)
*MEXIT #=   107 LV= 1 TN3270
*MCALL #=   108 LV= 1          TN3270 (GE,90)
         DC    AL1(GE,90)
*MEXIT #=   108 LV= 1 TN3270
*MCALL #=   109 LV= 1          TN3270 (GE,91)
         DC    AL1(GE,91)
*MEXIT #=   109 LV= 1 TN3270
*MCALL #=   110 LV= 1          TN3270 (GE,92)
         DC    AL1(GE,92)
*MEXIT #=   110 LV= 1 TN3270
*MCALL #=   111 LV= 1          TN3270 (GE,93)
         DC    AL1(GE,93)
*MEXIT #=   111 LV= 1 TN3270
*MCALL #=   112 LV= 1          TN3270 (GE,94)
         DC    AL1(GE,94)
*MEXIT #=   112 LV= 1 TN3270
*MCALL #=   113 LV= 1          TN3270 (GE,95)
         DC    AL1(GE,95)
*MEXIT #=   113 LV= 1 TN3270
*MCALL #=   114 LV= 1          TN3270 (SBA,12,10),(SF,ATT_PA),CL10' ROWX
                7',C'='
         DC    AL1(SBA,77,249)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 7'
         DC    C'='
*MEXIT #=   114 LV= 1 TN3270
*MCALL #=   115 LV= 1          TN3270 (GE,96)
         DC    AL1(GE,96)
*MEXIT #=   115 LV= 1 TN3270
*MCALL #=   116 LV= 1          TN3270 (GE,97)
         DC    AL1(GE,97)
*MEXIT #=   116 LV= 1 TN3270
*MCALL #=   117 LV= 1          TN3270 (GE,98)
         DC    AL1(GE,98)
*MEXIT #=   117 LV= 1 TN3270
*MCALL #=   118 LV= 1          TN3270 (GE,99)
         DC    AL1(GE,99)
*MEXIT #=   118 LV= 1 TN3270
*MCALL #=   119 LV= 1          TN3270 (GE,100)
         DC    AL1(GE,100)
*MEXIT #=   119 LV= 1 TN3270
*MCALL #=   120 LV= 1          TN3270 (GE,101)
         DC    AL1(GE,101)
*MEXIT #=   120 LV= 1 TN3270
*MCALL #=   121 LV= 1          TN3270 (GE,102)
         DC    AL1(GE,102)
*MEXIT #=   121 LV= 1 TN3270
*MCALL #=   122 LV= 1          TN3270 (GE,103)
         DC    AL1(GE,103)
*MEXIT #=   122 LV= 1 TN3270
*MCALL #=   123 LV= 1          TN3270 (GE,104)
         DC    AL1(GE,104)
*MEXIT #=   123 LV= 1 TN3270
*MCALL #=   124 LV= 1          TN3270 (GE,105)
         DC    AL1(GE,105)
*MEXIT #=   124 LV= 1 TN3270
*MCALL #=   125 LV= 1          TN3270 (GE,106)
         DC    AL1(GE,106)
*MEXIT #=   125 LV= 1 TN3270
*MCALL #=   126 LV= 1          TN3270 (GE,107)
         DC    AL1(GE,107)
*MEXIT #=   126 LV= 1 TN3270
*MCALL #=   127 LV= 1          TN3270 (GE,108)
         DC    AL1(GE,108)
*MEXIT #=   127 LV= 1 TN3270
*MCALL #=   128 LV= 1          TN3270 (GE,109)
         DC    AL1(GE,109)
*MEXIT #=   128 LV= 1 TN3270
*MCALL #=   129 LV= 1          TN3270 (GE,110)
         DC    AL1(GE,110)
*MEXIT #=   129 LV= 1 TN3270
*MCALL #=   130 LV= 1          TN3270 (GE,111)
         DC    AL1(GE,111)
*MEXIT #=   130 LV= 1 TN3270
*MCALL #=   131 LV= 1          TN3270 (SBA,13,10),(SF,ATT_PA),CL10' ROWX
                8',C'='
         DC    AL1(SBA,79,201)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 8'
         DC    C'='
*MEXIT #=   131 LV= 1 TN3270
*MCALL #=   132 LV= 1          TN3270 (GE,112)
         DC    AL1(GE,112)
*MEXIT #=   132 LV= 1 TN3270
*MCALL #=   133 LV= 1          TN3270 (GE,113)
         DC    AL1(GE,113)
*MEXIT #=   133 LV= 1 TN3270
*MCALL #=   134 LV= 1          TN3270 (GE,114)
         DC    AL1(GE,114)
*MEXIT #=   134 LV= 1 TN3270
*MCALL #=   135 LV= 1          TN3270 (GE,115)
         DC    AL1(GE,115)
*MEXIT #=   135 LV= 1 TN3270
*MCALL #=   136 LV= 1          TN3270 (GE,116)
         DC    AL1(GE,116)
*MEXIT #=   136 LV= 1 TN3270
*MCALL #=   137 LV= 1          TN3270 (GE,117)
         DC    AL1(GE,117)
*MEXIT #=   137 LV= 1 TN3270
*MCALL #=   138 LV= 1          TN3270 (GE,118)
         DC    AL1(GE,118)
*MEXIT #=   138 LV= 1 TN3270
*MCALL #=   139 LV= 1          TN3270 (GE,119)
         DC    AL1(GE,119)
*MEXIT #=   139 LV= 1 TN3270
*MCALL #=   140 LV= 1          TN3270 (GE,120)
         DC    AL1(GE,120)
*MEXIT #=   140 LV= 1 TN3270
*MCALL #=   141 LV= 1          TN3270 (GE,121)
         DC    AL1(GE,121)
*MEXIT #=   141 LV= 1 TN3270
*MCALL #=   142 LV= 1          TN3270 (GE,122)
         DC    AL1(GE,122)
*MEXIT #=   142 LV= 1 TN3270
*MCALL #=   143 LV= 1          TN3270 (GE,123)
         DC    AL1(GE,123)
*MEXIT #=   143 LV= 1 TN3270
*MCALL #=   144 LV= 1          TN3270 (GE,124)
         DC    AL1(GE,124)
*MEXIT #=   144 LV= 1 TN3270
*MCALL #=   145 LV= 1          TN3270 (GE,125)
         DC    AL1(GE,125)
*MEXIT #=   145 LV= 1 TN3270
*MCALL #=   146 LV= 1          TN3270 (GE,126)
         DC    AL1(GE,126)
*MEXIT #=   146 LV= 1 TN3270
*MCALL #=   147 LV= 1          TN3270 (GE,127)
         DC    AL1(GE,127)
*MEXIT #=   147 LV= 1 TN3270
*MCALL #=   148 LV= 1          TN3270 (SBA,14,10),(SF,ATT_PA),CL10' ROWX
                9',C'='
         DC    AL1(SBA,80,217)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 9'
         DC    C'='
*MEXIT #=   148 LV= 1 TN3270
*MCALL #=   149 LV= 1          TN3270 (GE,128)
         DC    AL1(GE,128)
*MEXIT #=   149 LV= 1 TN3270
*MCALL #=   150 LV= 1          TN3270 (GE,129)
         DC    AL1(GE,129)
*MEXIT #=   150 LV= 1 TN3270
*MCALL #=   151 LV= 1          TN3270 (GE,130)
         DC    AL1(GE,130)
*MEXIT #=   151 LV= 1 TN3270
*MCALL #=   152 LV= 1          TN3270 (GE,131)
         DC    AL1(GE,131)
*MEXIT #=   152 LV= 1 TN3270
*MCALL #=   153 LV= 1          TN3270 (GE,132)
         DC    AL1(GE,132)
*MEXIT #=   153 LV= 1 TN3270
*MCALL #=   154 LV= 1          TN3270 (GE,133)
         DC    AL1(GE,133)
*MEXIT #=   154 LV= 1 TN3270
*MCALL #=   155 LV= 1          TN3270 (GE,134)
         DC    AL1(GE,134)
*MEXIT #=   155 LV= 1 TN3270
*MCALL #=   156 LV= 1          TN3270 (GE,135)
         DC    AL1(GE,135)
*MEXIT #=   156 LV= 1 TN3270
*MCALL #=   157 LV= 1          TN3270 (GE,136)
         DC    AL1(GE,136)
*MEXIT #=   157 LV= 1 TN3270
*MCALL #=   158 LV= 1          TN3270 (GE,137)
         DC    AL1(GE,137)
*MEXIT #=   158 LV= 1 TN3270
*MCALL #=   159 LV= 1          TN3270 (GE,138)
         DC    AL1(GE,138)
*MEXIT #=   159 LV= 1 TN3270
*MCALL #=   160 LV= 1          TN3270 (GE,139)
         DC    AL1(GE,139)
*MEXIT #=   160 LV= 1 TN3270
*MCALL #=   161 LV= 1          TN3270 (GE,140)
         DC    AL1(GE,140)
*MEXIT #=   161 LV= 1 TN3270
*MCALL #=   162 LV= 1          TN3270 (GE,141)
         DC    AL1(GE,141)
*MEXIT #=   162 LV= 1 TN3270
*MCALL #=   163 LV= 1          TN3270 (GE,142)
         DC    AL1(GE,142)
*MEXIT #=   163 LV= 1 TN3270
*MCALL #=   164 LV= 1          TN3270 (GE,143)
         DC    AL1(GE,143)
*MEXIT #=   164 LV= 1 TN3270
*MCALL #=   165 LV= 1          TN3270 (SBA,15,10),(SF,ATT_PA),CL10' ROWX
                10',C'='
         DC    AL1(SBA,209,233)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 10'
         DC    C'='
*MEXIT #=   165 LV= 1 TN3270
*MCALL #=   166 LV= 1          TN3270 (GE,144)
         DC    AL1(GE,144)
*MEXIT #=   166 LV= 1 TN3270
*MCALL #=   167 LV= 1          TN3270 (GE,145)
         DC    AL1(GE,145)
*MEXIT #=   167 LV= 1 TN3270
*MCALL #=   168 LV= 1          TN3270 (GE,146)
         DC    AL1(GE,146)
*MEXIT #=   168 LV= 1 TN3270
*MCALL #=   169 LV= 1          TN3270 (GE,147)
         DC    AL1(GE,147)
*MEXIT #=   169 LV= 1 TN3270
*MCALL #=   170 LV= 1          TN3270 (GE,148)
         DC    AL1(GE,148)
*MEXIT #=   170 LV= 1 TN3270
*MCALL #=   171 LV= 1          TN3270 (GE,149)
         DC    AL1(GE,149)
*MEXIT #=   171 LV= 1 TN3270
*MCALL #=   172 LV= 1          TN3270 (GE,150)
         DC    AL1(GE,150)
*MEXIT #=   172 LV= 1 TN3270
*MCALL #=   173 LV= 1          TN3270 (GE,151)
         DC    AL1(GE,151)
*MEXIT #=   173 LV= 1 TN3270
*MCALL #=   174 LV= 1          TN3270 (GE,152)
         DC    AL1(GE,152)
*MEXIT #=   174 LV= 1 TN3270
*MCALL #=   175 LV= 1          TN3270 (GE,153)
         DC    AL1(GE,153)
*MEXIT #=   175 LV= 1 TN3270
*MCALL #=   176 LV= 1          TN3270 (GE,154)
         DC    AL1(GE,154)
*MEXIT #=   176 LV= 1 TN3270
*MCALL #=   177 LV= 1          TN3270 (GE,155)
         DC    AL1(GE,155)
*MEXIT #=   177 LV= 1 TN3270
*MCALL #=   178 LV= 1          TN3270 (GE,156)
         DC    AL1(GE,156)
*MEXIT #=   178 LV= 1 TN3270
*MCALL #=   179 LV= 1          TN3270 (GE,157)
         DC    AL1(GE,157)
*MEXIT #=   179 LV= 1 TN3270
*MCALL #=   180 LV= 1          TN3270 (GE,158)
         DC    AL1(GE,158)
*MEXIT #=   180 LV= 1 TN3270
*MCALL #=   181 LV= 1          TN3270 (GE,159)
         DC    AL1(GE,159)
*MEXIT #=   181 LV= 1 TN3270
*MCALL #=   182 LV= 1          TN3270 (SBA,16,10),(SF,ATT_PA),CL10' ROWX
                11',C'='
         DC    AL1(SBA,210,249)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 11'
         DC    C'='
*MEXIT #=   182 LV= 1 TN3270
*MCALL #=   183 LV= 1          TN3270 (GE,160)
         DC    AL1(GE,160)
*MEXIT #=   183 LV= 1 TN3270
*MCALL #=   184 LV= 1          TN3270 (GE,161)
         DC    AL1(GE,161)
*MEXIT #=   184 LV= 1 TN3270
*MCALL #=   185 LV= 1          TN3270 (GE,162)
         DC    AL1(GE,162)
*MEXIT #=   185 LV= 1 TN3270
*MCALL #=   186 LV= 1          TN3270 (GE,163)
         DC    AL1(GE,163)
*MEXIT #=   186 LV= 1 TN3270
*MCALL #=   187 LV= 1          TN3270 (GE,164)
         DC    AL1(GE,164)
*MEXIT #=   187 LV= 1 TN3270
*MCALL #=   188 LV= 1          TN3270 (GE,165)
         DC    AL1(GE,165)
*MEXIT #=   188 LV= 1 TN3270
*MCALL #=   189 LV= 1          TN3270 (GE,166)
         DC    AL1(GE,166)
*MEXIT #=   189 LV= 1 TN3270
*MCALL #=   190 LV= 1          TN3270 (GE,167)
         DC    AL1(GE,167)
*MEXIT #=   190 LV= 1 TN3270
*MCALL #=   191 LV= 1          TN3270 (GE,168)
         DC    AL1(GE,168)
*MEXIT #=   191 LV= 1 TN3270
*MCALL #=   192 LV= 1          TN3270 (GE,169)
         DC    AL1(GE,169)
*MEXIT #=   192 LV= 1 TN3270
*MCALL #=   193 LV= 1          TN3270 (GE,170)
         DC    AL1(GE,170)
*MEXIT #=   193 LV= 1 TN3270
*MCALL #=   194 LV= 1          TN3270 (GE,171)
         DC    AL1(GE,171)
*MEXIT #=   194 LV= 1 TN3270
*MCALL #=   195 LV= 1          TN3270 (GE,172)
         DC    AL1(GE,172)
*MEXIT #=   195 LV= 1 TN3270
*MCALL #=   196 LV= 1          TN3270 (GE,173)
         DC    AL1(GE,173)
*MEXIT #=   196 LV= 1 TN3270
*MCALL #=   197 LV= 1          TN3270 (GE,174)
         DC    AL1(GE,174)
*MEXIT #=   197 LV= 1 TN3270
*MCALL #=   198 LV= 1          TN3270 (GE,175)
         DC    AL1(GE,175)
*MEXIT #=   198 LV= 1 TN3270
*MCALL #=   199 LV= 1          TN3270 (SBA,17,10),(SF,ATT_PA),CL10' ROWX
                12',C'='
         DC    AL1(SBA,212,201)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 12'
         DC    C'='
*MEXIT #=   199 LV= 1 TN3270
*MCALL #=   200 LV= 1          TN3270 (GE,176)
         DC    AL1(GE,176)
*MEXIT #=   200 LV= 1 TN3270
*MCALL #=   201 LV= 1          TN3270 (GE,177)
         DC    AL1(GE,177)
*MEXIT #=   201 LV= 1 TN3270
*MCALL #=   202 LV= 1          TN3270 (GE,178)
         DC    AL1(GE,178)
*MEXIT #=   202 LV= 1 TN3270
*MCALL #=   203 LV= 1          TN3270 (GE,179)
         DC    AL1(GE,179)
*MEXIT #=   203 LV= 1 TN3270
*MCALL #=   204 LV= 1          TN3270 (GE,180)
         DC    AL1(GE,180)
*MEXIT #=   204 LV= 1 TN3270
*MCALL #=   205 LV= 1          TN3270 (GE,181)
         DC    AL1(GE,181)
*MEXIT #=   205 LV= 1 TN3270
*MCALL #=   206 LV= 1          TN3270 (GE,182)
         DC    AL1(GE,182)
*MEXIT #=   206 LV= 1 TN3270
*MCALL #=   207 LV= 1          TN3270 (GE,183)
         DC    AL1(GE,183)
*MEXIT #=   207 LV= 1 TN3270
*MCALL #=   208 LV= 1          TN3270 (GE,184)
         DC    AL1(GE,184)
*MEXIT #=   208 LV= 1 TN3270
*MCALL #=   209 LV= 1          TN3270 (GE,185)
         DC    AL1(GE,185)
*MEXIT #=   209 LV= 1 TN3270
*MCALL #=   210 LV= 1          TN3270 (GE,186)
         DC    AL1(GE,186)
*MEXIT #=   210 LV= 1 TN3270
*MCALL #=   211 LV= 1          TN3270 (GE,187)
         DC    AL1(GE,187)
*MEXIT #=   211 LV= 1 TN3270
*MCALL #=   212 LV= 1          TN3270 (GE,188)
         DC    AL1(GE,188)
*MEXIT #=   212 LV= 1 TN3270
*MCALL #=   213 LV= 1          TN3270 (GE,189)
         DC    AL1(GE,189)
*MEXIT #=   213 LV= 1 TN3270
*MCALL #=   214 LV= 1          TN3270 (GE,190)
         DC    AL1(GE,190)
*MEXIT #=   214 LV= 1 TN3270
*MCALL #=   215 LV= 1          TN3270 (GE,191)
         DC    AL1(GE,191)
*MEXIT #=   215 LV= 1 TN3270
*MCALL #=   216 LV= 1          TN3270 (SBA,18,10),(SF,ATT_PA),CL10' ROWX
                13',C'='
         DC    AL1(SBA,213,217)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 13'
         DC    C'='
*MEXIT #=   216 LV= 1 TN3270
*MCALL #=   217 LV= 1          TN3270 (GE,192)
         DC    AL1(GE,192)
*MEXIT #=   217 LV= 1 TN3270
*MCALL #=   218 LV= 1          TN3270 (GE,193)
         DC    AL1(GE,193)
*MEXIT #=   218 LV= 1 TN3270
*MCALL #=   219 LV= 1          TN3270 (GE,194)
         DC    AL1(GE,194)
*MEXIT #=   219 LV= 1 TN3270
*MCALL #=   220 LV= 1          TN3270 (GE,195)
         DC    AL1(GE,195)
*MEXIT #=   220 LV= 1 TN3270
*MCALL #=   221 LV= 1          TN3270 (GE,196)
         DC    AL1(GE,196)
*MEXIT #=   221 LV= 1 TN3270
*MCALL #=   222 LV= 1          TN3270 (GE,197)
         DC    AL1(GE,197)
*MEXIT #=   222 LV= 1 TN3270
*MCALL #=   223 LV= 1          TN3270 (GE,198)
         DC    AL1(GE,198)
*MEXIT #=   223 LV= 1 TN3270
*MCALL #=   224 LV= 1          TN3270 (GE,199)
         DC    AL1(GE,199)
*MEXIT #=   224 LV= 1 TN3270
*MCALL #=   225 LV= 1          TN3270 (GE,200)
         DC    AL1(GE,200)
*MEXIT #=   225 LV= 1 TN3270
*MCALL #=   226 LV= 1          TN3270 (GE,201)
         DC    AL1(GE,201)
*MEXIT #=   226 LV= 1 TN3270
*MCALL #=   227 LV= 1          TN3270 (GE,202)
         DC    AL1(GE,202)
*MEXIT #=   227 LV= 1 TN3270
*MCALL #=   228 LV= 1          TN3270 (GE,203)
         DC    AL1(GE,203)
*MEXIT #=   228 LV= 1 TN3270
*MCALL #=   229 LV= 1          TN3270 (GE,204)
         DC    AL1(GE,204)
*MEXIT #=   229 LV= 1 TN3270
*MCALL #=   230 LV= 1          TN3270 (GE,205)
         DC    AL1(GE,205)
*MEXIT #=   230 LV= 1 TN3270
*MCALL #=   231 LV= 1          TN3270 (GE,206)
         DC    AL1(GE,206)
*MEXIT #=   231 LV= 1 TN3270
*MCALL #=   232 LV= 1          TN3270 (GE,207)
         DC    AL1(GE,207)
*MEXIT #=   232 LV= 1 TN3270
*MCALL #=   233 LV= 1          TN3270 (SBA,19,10),(SF,ATT_PA),CL10' ROWX
                14',C'='
         DC    AL1(SBA,214,233)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 14'
         DC    C'='
*MEXIT #=   233 LV= 1 TN3270
*MCALL #=   234 LV= 1          TN3270 (GE,208)
         DC    AL1(GE,208)
*MEXIT #=   234 LV= 1 TN3270
*MCALL #=   235 LV= 1          TN3270 (GE,209)
         DC    AL1(GE,209)
*MEXIT #=   235 LV= 1 TN3270
*MCALL #=   236 LV= 1          TN3270 (GE,210)
         DC    AL1(GE,210)
*MEXIT #=   236 LV= 1 TN3270
*MCALL #=   237 LV= 1          TN3270 (GE,211)
         DC    AL1(GE,211)
*MEXIT #=   237 LV= 1 TN3270
*MCALL #=   238 LV= 1          TN3270 (GE,212)
         DC    AL1(GE,212)
*MEXIT #=   238 LV= 1 TN3270
*MCALL #=   239 LV= 1          TN3270 (GE,213)
         DC    AL1(GE,213)
*MEXIT #=   239 LV= 1 TN3270
*MCALL #=   240 LV= 1          TN3270 (GE,214)
         DC    AL1(GE,214)
*MEXIT #=   240 LV= 1 TN3270
*MCALL #=   241 LV= 1          TN3270 (GE,215)
         DC    AL1(GE,215)
*MEXIT #=   241 LV= 1 TN3270
*MCALL #=   242 LV= 1          TN3270 (GE,216)
         DC    AL1(GE,216)
*MEXIT #=   242 LV= 1 TN3270
*MCALL #=   243 LV= 1          TN3270 (GE,217)
         DC    AL1(GE,217)
*MEXIT #=   243 LV= 1 TN3270
*MCALL #=   244 LV= 1          TN3270 (GE,218)
         DC    AL1(GE,218)
*MEXIT #=   244 LV= 1 TN3270
*MCALL #=   245 LV= 1          TN3270 (GE,219)
         DC    AL1(GE,219)
*MEXIT #=   245 LV= 1 TN3270
*MCALL #=   246 LV= 1          TN3270 (GE,220)
         DC    AL1(GE,220)
*MEXIT #=   246 LV= 1 TN3270
*MCALL #=   247 LV= 1          TN3270 (GE,221)
         DC    AL1(GE,221)
*MEXIT #=   247 LV= 1 TN3270
*MCALL #=   248 LV= 1          TN3270 (GE,222)
         DC    AL1(GE,222)
*MEXIT #=   248 LV= 1 TN3270
*MCALL #=   249 LV= 1          TN3270 (GE,223)
         DC    AL1(GE,223)
*MEXIT #=   249 LV= 1 TN3270
*MCALL #=   250 LV= 1          TN3270 (SBA,20,10),(SF,ATT_PA),CL10' ROWX
                15',C'='
         DC    AL1(SBA,215,249)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 15'
         DC    C'='
*MEXIT #=   250 LV= 1 TN3270
*MCALL #=   251 LV= 1          TN3270 (GE,224)
         DC    AL1(GE,224)
*MEXIT #=   251 LV= 1 TN3270
*MCALL #=   252 LV= 1          TN3270 (GE,225)
         DC    AL1(GE,225)
*MEXIT #=   252 LV= 1 TN3270
*MCALL #=   253 LV= 1          TN3270 (GE,226)
         DC    AL1(GE,226)
*MEXIT #=   253 LV= 1 TN3270
*MCALL #=   254 LV= 1          TN3270 (GE,227)
         DC    AL1(GE,227)
*MEXIT #=   254 LV= 1 TN3270
*MCALL #=   255 LV= 1          TN3270 (GE,228)
         DC    AL1(GE,228)
*MEXIT #=   255 LV= 1 TN3270
*MCALL #=   256 LV= 1          TN3270 (GE,229)
         DC    AL1(GE,229)
*MEXIT #=   256 LV= 1 TN3270
*MCALL #=   257 LV= 1          TN3270 (GE,230)
         DC    AL1(GE,230)
*MEXIT #=   257 LV= 1 TN3270
*MCALL #=   258 LV= 1          TN3270 (GE,231)
         DC    AL1(GE,231)
*MEXIT #=   258 LV= 1 TN3270
*MCALL #=   259 LV= 1          TN3270 (GE,232)
         DC    AL1(GE,232)
*MEXIT #=   259 LV= 1 TN3270
*MCALL #=   260 LV= 1          TN3270 (GE,233)
         DC    AL1(GE,233)
*MEXIT #=   260 LV= 1 TN3270
*MCALL #=   261 LV= 1          TN3270 (GE,234)
         DC    AL1(GE,234)
*MEXIT #=   261 LV= 1 TN3270
*MCALL #=   262 LV= 1          TN3270 (GE,235)
         DC    AL1(GE,235)
*MEXIT #=   262 LV= 1 TN3270
*MCALL #=   263 LV= 1          TN3270 (GE,236)
         DC    AL1(GE,236)
*MEXIT #=   263 LV= 1 TN3270
*MCALL #=   264 LV= 1          TN3270 (GE,237)
         DC    AL1(GE,237)
*MEXIT #=   264 LV= 1 TN3270
*MCALL #=   265 LV= 1          TN3270 (GE,238)
         DC    AL1(GE,238)
*MEXIT #=   265 LV= 1 TN3270
*MCALL #=   266 LV= 1          TN3270 (GE,239)
         DC    AL1(GE,239)
*MEXIT #=   266 LV= 1 TN3270
*MCALL #=   267 LV= 1          TN3270 (SBA,21,10),(SF,ATT_PA),CL10' ROWX
                16',C'='
         DC    AL1(SBA,217,201)
         DC    AL1(SF,ATT_PA)
         DC    CL10' ROW 16'
         DC    C'='
*MEXIT #=   267 LV= 1 TN3270
*MCALL #=   268 LV= 1          TN3270 (GE,240)
         DC    AL1(GE,240)
*MEXIT #=   268 LV= 1 TN3270
*MCALL #=   269 LV= 1          TN3270 (GE,241)
         DC    AL1(GE,241)
*MEXIT #=   269 LV= 1 TN3270
*MCALL #=   270 LV= 1          TN3270 (GE,242)
         DC    AL1(GE,242)
*MEXIT #=   270 LV= 1 TN3270
*MCALL #=   271 LV= 1          TN3270 (GE,243)
         DC    AL1(GE,243)
*MEXIT #=   271 LV= 1 TN3270
*MCALL #=   272 LV= 1          TN3270 (GE,244)
         DC    AL1(GE,244)
*MEXIT #=   272 LV= 1 TN3270
*MCALL #=   273 LV= 1          TN3270 (GE,245)
         DC    AL1(GE,245)
*MEXIT #=   273 LV= 1 TN3270
*MCALL #=   274 LV= 1          TN3270 (GE,246)
         DC    AL1(GE,246)
*MEXIT #=   274 LV= 1 TN3270
*MCALL #=   275 LV= 1          TN3270 (GE,247)
         DC    AL1(GE,247)
*MEXIT #=   275 LV= 1 TN3270
*MCALL #=   276 LV= 1          TN3270 (GE,248)
         DC    AL1(GE,248)
*MEXIT #=   276 LV= 1 TN3270
*MCALL #=   277 LV= 1          TN3270 (GE,249)
         DC    AL1(GE,249)
*MEXIT #=   277 LV= 1 TN3270
*MCALL #=   278 LV= 1          TN3270 (GE,250)
         DC    AL1(GE,250)
*MEXIT #=   278 LV= 1 TN3270
*MCALL #=   279 LV= 1          TN3270 (GE,251)
         DC    AL1(GE,251)
*MEXIT #=   279 LV= 1 TN3270
*MCALL #=   280 LV= 1          TN3270 (GE,252)
         DC    AL1(GE,252)
*MEXIT #=   280 LV= 1 TN3270
*MCALL #=   281 LV= 1          TN3270 (GE,253)
         DC    AL1(GE,253)
*MEXIT #=   281 LV= 1 TN3270
*MCALL #=   282 LV= 1          TN3270 (GE,254)
         DC    AL1(GE,254)
*MEXIT #=   282 LV= 1 TN3270
*MCALL #=   283 LV= 1          TN3270 (GE,255)
         DC    AL1(GE,255)
*MEXIT #=   283 LV= 1 TN3270
LSTREAM  EQU   *-STREAM
INBUF    DS    X
LINBUF   EQU   *-INBUF
*MCALL #=   284 LV= 1 GREEN    GUAM  COLOR,GREEN
GREEN       DS    0H
         DC    AL1(0,0,255,0) RGB GREEN COLOR
*MEXIT #=   284 LV= 1 GUAM
*MCALL #=   285 LV= 1 BLACK    GUAM  COLOR,BLACK
BLACK       DS    0H
         DC    AL1(0,0,0,0) RGB BLACK COLOR
*MEXIT #=   285 LV= 1 GUAM
*MCALL #=   286 LV= 1          GUAM  SYMBOLS
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
*MEXIT #=   286 LV= 1 GUAM
         END
