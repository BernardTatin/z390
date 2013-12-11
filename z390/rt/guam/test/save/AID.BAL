AID1     CSECT ,
*MCALL #=     1 LV= 1          SAVE  (14,12),,*
         STM   14,12,12+4*(14-14)(13)
*MEXIT #=     1 LV= 1 SAVE
         LR    12,15
         USING AID1,12
*
         LA    1,SAVEA
         ST    1,8(,13)
         ST    13,4(,1)
         LR    13,1
*
*MCALL #=     2 LV= 1          STFSMODE ON,INITIAL=YES
       DS    0H
*MEXIT #=     2 LV= 1 STFSMODE
*MCALL #=     3 LV= 1          STTMPMD ON
       DS    0H
*MEXIT #=     3 LV= 1 STTMPMD
*
LOOP     DS    0H
*MCALL #=     4 LV= 1          TPUT  STREAM,STREAMLN,FULLSCR
         LA    1,STREAM
         LA    0,STREAMLN
         ICM   1,8,=B'00000011'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     4 LV= 1 TPUT
*
*MCALL #=     5 LV= 1          TGET  INBUF,INBUFLN,ASIS
         LA    1,INBUF
         LA    0,INBUFLN
         ICM   1,8,=B'10000001'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     5 LV= 1 TGET
*
**       CLI   INBUF,X'F3'   IS IT PFK3?
**       BE    EXIT
*
         UNPK  WORK3,INBUF(2)
         TR    WORK3(2),TRTAB-C'0'
         MVC   AIDCHAR,WORK3
*
         UNPK  WORK5,INBUF+1(3)
         TR    WORK5(4),TRTAB-C'0'
         MVC   CURSOR,WORK5
*
         MVI   SETCSR,X'11'          SBA
         MVC   SETCSR+1(2),INBUF+1   CURSOR POSITION
         MVI   SETCSR+3,X'13'        IC (INSERT CUROSR)
*
         B     LOOP
*
EXIT     DS    0H
*MCALL #=     6 LV= 1          STLINENO LINE=1
       DS    0H
*MEXIT #=     6 LV= 1 STLINENO
*MCALL #=     7 LV= 1          STFSMODE OFF
       DS    0H
*MEXIT #=     7 LV= 1 STFSMODE
*MCALL #=     8 LV= 1          STTMPMD OFF
       DS    0H
*MEXIT #=     8 LV= 1 STTMPMD
*
         L     13,4(,13)
         LM    14,12,12(13)
         SLR   15,15
         BR    14
*
STREAM   DS    0C
         DC    X'27'       ESCAPE CHAR
         DC    X'F5'       ERASE/WRITE
         DC    X'C3'       WCC
         DC    X'114BF0'   SBA
         DC    X'1DF8'     SF (PROT,HIGH INTENSITY)
         DC    C'HELLO, WORLD!'
         DC    X'114D40'   SBA
         DC    X'1DF8'     SF
         DC    C'AID='
AIDCHAR  DC    C'  '
         DC    X'114E50'   SBA
         DC    X'1DF8'     SF
         DC    C'CURSOR='
CURSOR   DC    C'    '
SETCSR   DC    C'    '
STREAMLN EQU   *-STREAM
*
INBUF    DS    XL128
INBUFLN  EQU   *-INBUF
*
WORK3    DC    XL3'00'
WORK5    DC    XL5'00'
*
TRTAB    DC    C'0123456789ABCDEF'
*
SAVEA    DS    18F
         END   ,
