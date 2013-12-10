Comparing files GUAM\DEMO\DEMOGUI4.BAL and RT\GUAM\DEMO\SAVE\DEMOGUI4.BAL
***** GUAM\DEMO\DEMOGUI4.BAL
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI4 SUBENTRY 
DEMOGUI4 CSECT 
         STM   14,12,12(13)
***** RT\GUAM\DEMO\SAVE\DEMOGUI4.BAL
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI4 SUBENTRY
DEMOGUI4    CSECT
         STM   14,12,12(13)
*****

***** GUAM\DEMO\DEMOGUI4.BAL
EXIT     EQU   *
*MCALL #=    11 LV= 1          SUBEXIT 
         LA    15,0
***** RT\GUAM\DEMO\SAVE\DEMOGUI4.BAL
EXIT     EQU   *
*MCALL #=    11 LV= 1          SUBEXIT
         LA    15,0
*****

***** GUAM\DEMO\DEMOGUI4.BAL
               ATT_PA)
MSG1     EQU   *
         DC    AL1(ESC,WRT_EW,WCC_KD)
***** RT\GUAM\DEMO\SAVE\DEMOGUI4.BAL
               ATT_PA)
MSG1       EQU   *
         DC    AL1(ESC,WRT_EW,WCC_KD)
*****

***** GUAM\DEMO\DEMOGUI4.BAL
*MCALL #=    13 LV= 1 MSG2     TN3270 WCC_KD
MSG2     EQU   *
         DC    AL1(WCC_KD)
***** RT\GUAM\DEMO\SAVE\DEMOGUI4.BAL
*MCALL #=    13 LV= 1 MSG2     TN3270 WCC_KD
MSG2       EQU   *
         DC    AL1(WCC_KD)
*****

***** GUAM\DEMO\DEMOGUI4.BAL
*MCALL #=    17 LV= 1 MSG3     TN3270 WCC_KD,(SBA,6,10),(SF,ATT_PA)
MSG3     EQU   *
         DC    AL1(WCC_KD)
***** RT\GUAM\DEMO\SAVE\DEMOGUI4.BAL
*MCALL #=    17 LV= 1 MSG3     TN3270 WCC_KD,(SBA,6,10),(SF,ATT_PA)
MSG3       EQU   *
         DC    AL1(WCC_KD)
*****

***** GUAM\DEMO\DEMOGUI4.BAL
*MEXIT #=    20 LV= 1 GUAM
*MCALL #=    21 LV= 1          EQUREGS 
R0     EQU 0
R1     EQU 1
R2     EQU 2
R3     EQU 3
R4     EQU 4
R5     EQU 5
R6     EQU 6
R7     EQU 7
R8     EQU 8
R9     EQU 9
R10    EQU 10
R11    EQU 11
R12    EQU 12
R13    EQU 13
R14    EQU 14
R15    EQU 15
*MEXIT #=    21 LV= 1 EQUREGS
         END 
***** RT\GUAM\DEMO\SAVE\DEMOGUI4.BAL
*MEXIT #=    20 LV= 1 GUAM
*MCALL #=    21 LV= 1          EQUREGS
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
*MEXIT #=    21 LV= 1 EQUREGS
         END
*****

