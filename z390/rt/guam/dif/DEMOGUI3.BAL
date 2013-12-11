Comparing files GUAM\DEMO\DEMOGUI3.BAL and RT\GUAM\DEMO\SAVE\DEMOGUI3.BAL
***** GUAM\DEMO\DEMOGUI3.BAL
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI3 SUBENTRY 
DEMOGUI3 CSECT 
         STM   14,12,12(13)
***** RT\GUAM\DEMO\SAVE\DEMOGUI3.BAL
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI3 SUBENTRY
DEMOGUI3    CSECT
         STM   14,12,12(13)
*****

***** GUAM\DEMO\DEMOGUI3.BAL
         DC    AL2(WTO#0002_EOT-*,0),C'DEMOGUI3 STARTING'
WTO#0002_EOT     EQU *
         SVC   35
***** RT\GUAM\DEMO\SAVE\DEMOGUI3.BAL
         DC    AL2(WTO#0002_EOT-*,0),C'DEMOGUI3 STARTING'
WTO#0002_EOT EQU *
         SVC   35
*****

***** GUAM\DEMO\DEMOGUI3.BAL
         DC    AL2(WTO#0007_EOT-*,0),C'DEMOGUI3 ENDING'
WTO#0007_EOT     EQU *
         SVC   35
***** RT\GUAM\DEMO\SAVE\DEMOGUI3.BAL
         DC    AL2(WTO#0007_EOT-*,0),C'DEMOGUI3 ENDING'
WTO#0007_EOT EQU *
         SVC   35
*****

***** GUAM\DEMO\DEMOGUI3.BAL
*MEXIT #=     7 LV= 1 WTO
*MCALL #=     8 LV= 1          SUBEXIT 
         LA    15,0
***** RT\GUAM\DEMO\SAVE\DEMOGUI3.BAL
*MEXIT #=     7 LV= 1 WTO
*MCALL #=     8 LV= 1          SUBEXIT
         LA    15,0
*****

***** GUAM\DEMO\DEMOGUI3.BAL
MSG3L    EQU   *-MSG3
         END 
***** RT\GUAM\DEMO\SAVE\DEMOGUI3.BAL
MSG3L    EQU   *-MSG3
         END
*****

