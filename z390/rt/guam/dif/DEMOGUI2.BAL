Comparing files GUAM\DEMO\DEMOGUI2.BAL and RT\GUAM\DEMO\SAVE\DEMOGUI2.BAL
***** GUAM\DEMO\DEMOGUI2.BAL
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI2 SUBENTRY 
DEMOGUI2 CSECT 
         STM   14,12,12(13)
***** RT\GUAM\DEMO\SAVE\DEMOGUI2.BAL
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI2 SUBENTRY
DEMOGUI2    CSECT
         STM   14,12,12(13)
*****

***** GUAM\DEMO\DEMOGUI2.BAL
               -PROCESSING'
WTO#0002_EOT     EQU *
         SVC   35
***** RT\GUAM\DEMO\SAVE\DEMOGUI2.BAL
               -PROCESSING'
WTO#0002_EOT EQU *
         SVC   35
*****

***** GUAM\DEMO\DEMOGUI2.BAL
         DC    AL2(WTOR#0003_EOT-*,0),C'ENTER TEXT TO DISPLAY OR END'
WTOR#0003_EOT     EQU *
         LA    0,REPLY
***** RT\GUAM\DEMO\SAVE\DEMOGUI2.BAL
         DC    AL2(WTOR#0003_EOT-*,0),C'ENTER TEXT TO DISPLAY OR END'
WTOR#0003_EOT EQU *
         LA    0,REPLY
*****

***** GUAM\DEMO\DEMOGUI2.BAL
*MCALL #=    14 LV= 1 EOF      WTO   'DEMOGUI2 ENDING OK'
EOF      DS    0H
         BRAS  1,*+(WTO#0014_EOT-*+1)/2*2
***** RT\GUAM\DEMO\SAVE\DEMOGUI2.BAL
*MCALL #=    14 LV= 1 EOF      WTO   'DEMOGUI2 ENDING OK'
EOF       DS    0H
         BRAS  1,*+(WTO#0014_EOT-*+1)/2*2
*****

***** GUAM\DEMO\DEMOGUI2.BAL
         DC    AL2(WTO#0014_EOT-*,0),C'DEMOGUI2 ENDING OK'
WTO#0014_EOT     EQU *
         SVC   35
***** RT\GUAM\DEMO\SAVE\DEMOGUI2.BAL
         DC    AL2(WTO#0014_EOT-*,0),C'DEMOGUI2 ENDING OK'
WTO#0014_EOT EQU *
         SVC   35
*****

***** GUAM\DEMO\DEMOGUI2.BAL
*MEXIT #=    14 LV= 1 WTO
*MCALL #=    15 LV= 1          SUBEXIT 
         LA    15,0
***** RT\GUAM\DEMO\SAVE\DEMOGUI2.BAL
*MEXIT #=    14 LV= 1 WTO
*MCALL #=    15 LV= 1          SUBEXIT
         LA    15,0
*****

***** GUAM\DEMO\DEMOGUI2.BAL
WTOEND7  EQU   *
*MCALL #=    16 LV= 1          EQUREGS 
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
*MEXIT #=    16 LV= 1 EQUREGS
         END 
***** RT\GUAM\DEMO\SAVE\DEMOGUI2.BAL
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
*****

