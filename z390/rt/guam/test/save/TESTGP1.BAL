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
*MCALL #=     2 LV= 1          TPUT  MESSAGE,MESGLEN,FULLSCR
         LA    1,MESSAGE
         LA    0,MESGLEN
         ICM   1,8,=B'00000011'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     2 LV= 1 TPUT
         BCT   R2,MAINLOOP
*MCALL #=     3 LV= 1          TGET  INBUFF,80
         LA    1,INBUFF
         LA    0,80
         ICM   1,8,=B'10000000'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     3 LV= 1 TGET
*MCALL #=     4 LV= 1          TPUT  INBUFF,80
         LA    1,INBUFF
         LA    0,80
         ICM   1,8,=B'00000000'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=     4 LV= 1 TPUT
         L     R13,4(,R13)
         LM    R14,R12,12(R13)
         SR    R15,R15
         BR    R14
MESSAGE  DC    X'0311' < X'27F1C311'  DSH CHANGE PREFIX TO WCC_KD
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
