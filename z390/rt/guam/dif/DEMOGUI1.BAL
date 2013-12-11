Comparing files GUAM\DEMO\DEMOGUI1.BAL and RT\GUAM\DEMO\SAVE\DEMOGUI1.BAL
***** GUAM\DEMO\DEMOGUI1.BAL
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI1 SUBENTRY 
DEMOGUI1 CSECT 
         STM   14,12,12(13)
***** RT\GUAM\DEMO\SAVE\DEMOGUI1.BAL
*********************************************************************
*MCALL #=     1 LV= 1 DEMOGUI1 SUBENTRY
DEMOGUI1    CSECT
         STM   14,12,12(13)
*****

***** GUAM\DEMO\DEMOGUI1.BAL
               LOOP'
WTO#0002_EOT     EQU *
         SVC   35
***** RT\GUAM\DEMO\SAVE\DEMOGUI1.BAL
               LOOP'
WTO#0002_EOT EQU *
         SVC   35
*****

***** GUAM\DEMO\DEMOGUI1.BAL
         DC    AL2(WTOR#0003_EOT-*,0),C'ENTER TEXT TO DISPLAY OR END'
WTOR#0003_EOT     EQU *
         LA    0,REPLY
***** RT\GUAM\DEMO\SAVE\DEMOGUI1.BAL
         DC    AL2(WTOR#0003_EOT-*,0),C'ENTER TEXT TO DISPLAY OR END'
WTOR#0003_EOT EQU *
         LA    0,REPLY
*****

***** GUAM\DEMO\DEMOGUI1.BAL
*MCALL #=     6 LV= 1 EOF      WTO   'DEMOGUI1 ENDING OK'
EOF      DS    0H
         BRAS  1,*+(WTO#0006_EOT-*+1)/2*2
***** RT\GUAM\DEMO\SAVE\DEMOGUI1.BAL
*MCALL #=     6 LV= 1 EOF      WTO   'DEMOGUI1 ENDING OK'
EOF       DS    0H
         BRAS  1,*+(WTO#0006_EOT-*+1)/2*2
*****

***** GUAM\DEMO\DEMOGUI1.BAL
         DC    AL2(WTO#0006_EOT-*,0),C'DEMOGUI1 ENDING OK'
WTO#0006_EOT     EQU *
         SVC   35
***** RT\GUAM\DEMO\SAVE\DEMOGUI1.BAL
         DC    AL2(WTO#0006_EOT-*,0),C'DEMOGUI1 ENDING OK'
WTO#0006_EOT EQU *
         SVC   35
*****

***** GUAM\DEMO\DEMOGUI1.BAL
*MEXIT #=     6 LV= 1 WTO
*MCALL #=     7 LV= 1          SUBEXIT 
         LA    15,0
***** RT\GUAM\DEMO\SAVE\DEMOGUI1.BAL
*MEXIT #=     6 LV= 1 WTO
*MCALL #=     7 LV= 1          SUBEXIT
         LA    15,0
*****

***** GUAM\DEMO\DEMOGUI1.BAL
WTOEND1  EQU   *
         END 
***** RT\GUAM\DEMO\SAVE\DEMOGUI1.BAL
WTOEND1  EQU   *
         END
*****

