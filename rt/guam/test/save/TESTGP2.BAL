GREGTEST TITLE ' MY FIRST Z390 TEST'
*MCALL #=     1 LV= 1          YREGS
R0       EQU   0
R1       EQU   1
R2       EQU   2
R3       EQU   3
R4       EQU   4
R5       EQU   5
R6       EQU   6
R7       EQU   7
R8       EQU   8
R9       EQU   9
R10      EQU   10
R11      EQU   11
R12      EQU   12
R13      EQU   13
R14      EQU   14
R15      EQU   15
*MEXIT #=     1 LV= 1 YREGS
GREGTEST CSECT
GREGTEST AMODE 31
GREGTEST RMODE 24
         STM   R14,R12,12(R13)
         LR    R11,R15
         USING GREGTEST,R11
         LA    R2,SAVE
         ST    R13,4(,R2)
         ST    R2,8(,R13)
         LR    R13,R2
         LA    R2,1920   <=== SCREEN SIZE
MAINLOOP LR    R0,R2
         BCTR  R0,0
         STC   R0,SBA2
         SRL   R0,6
         STC   R0,SBA1
         NI    SBA2,X'3F'
         TR    SBA1(2),TABLE
         LA    R0,MESGLEN
         LA    R1,MESSAGE
         ICM   R1,8,=X'03' TPUT,FULLSCR
*MCALL #=     2 LV= 1          TPUT  (1),(0),R
*MCALL #=     3 LV= 2          ZOPTLR 1,1
*MEXIT #=     3 LV= 2 ZOPTLR
*MCALL #=     4 LV= 2          ZOPTLR 0,0
*MEXIT #=     4 LV= 2 ZOPTLR
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     2 LV= 1 TPUT
         BCT   R2,MAINLOOP
         LA    R1,INBUFF
         LA    R0,80
         ICM   R1,8,=X'80' TGET EDIT MODE
*MCALL #=     5 LV= 1          TGET  (1),(0),R
*MCALL #=     6 LV= 2          ZOPTLR 1,1
*MEXIT #=     6 LV= 2 ZOPTLR
*MCALL #=     7 LV= 2          ZOPTLR 0,0
*MEXIT #=     7 LV= 2 ZOPTLR
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     5 LV= 1 TGET
         ICM   R1,8,=X'00' TPUT EDIT MODE
*MCALL #=     8 LV= 1          TGET  (1),(0),R
*MCALL #=     9 LV= 2          ZOPTLR 1,1
*MEXIT #=     9 LV= 2 ZOPTLR
*MCALL #=    10 LV= 2          ZOPTLR 0,0
*MEXIT #=    10 LV= 2 ZOPTLR
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     8 LV= 1 TGET
         L     R13,4(,R13)
         LM    R14,R12,12(R13)
         SR    R15,R15
         BR    R14
MESSAGE  DC    X'0311' < X'27F1C311'  DSH CHANGE TO WCC_KD
SBA1     DC    X'40'
SBA2     DC    X'40'
         DC    C'@',X'13'
MESGLEN  EQU   *-MESSAGE
         LTORG
         DC    0D'0'
TABLE    DC    X'40C1C2C3C4C5C6C7C8C94A4B4C4D4E4F'
         DC    X'50D1D2D3D4D5D6D7D8D95A5B5C5D5E5F'
         DC    X'6061E2E3E4E5E6E7E8E96A6B6C6D6E6F'
         DC    X'F0F1F2F3F4F5F6F7F8F97A7B7C7D7E7F'
SAVE     DC    18F'0'
INBUFF   DC    CL80' '
         END   GREGTEST
