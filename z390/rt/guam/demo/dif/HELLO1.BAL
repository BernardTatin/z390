Comparing files GUAM\DEMO\HELLO1.BAL and RT\GUAM\DEMO\SAVE\HELLO1.BAL
***** GUAM\DEMO\HELLO1.BAL
*MCALL #=     2 LV= 1          STFSMODE ON,INITIAL=YES
         DS    0H
*MEXIT #=     2 LV= 1 STFSMODE
***** RT\GUAM\DEMO\SAVE\HELLO1.BAL
*MCALL #=     2 LV= 1          STFSMODE ON,INITIAL=YES
       DS    0H
*MEXIT #=     2 LV= 1 STFSMODE
*****

***** GUAM\DEMO\HELLO1.BAL
*MCALL #=     3 LV= 1          STTMPMD ON
         DS    0H
*MEXIT #=     3 LV= 1 STTMPMD
***** RT\GUAM\DEMO\SAVE\HELLO1.BAL
*MCALL #=     3 LV= 1          STTMPMD ON
       DS    0H
*MEXIT #=     3 LV= 1 STTMPMD
*****

***** GUAM\DEMO\HELLO1.BAL
*MCALL #=     6 LV= 1          STLINENO LINE=1
         DS    0H
*MEXIT #=     6 LV= 1 STLINENO
***** RT\GUAM\DEMO\SAVE\HELLO1.BAL
*MCALL #=     6 LV= 1          STLINENO LINE=1
       DS    0H
*MEXIT #=     6 LV= 1 STLINENO
*****

***** GUAM\DEMO\HELLO1.BAL
*MCALL #=     7 LV= 1          STFSMODE OFF
         DS    0H
*MEXIT #=     7 LV= 1 STFSMODE
***** RT\GUAM\DEMO\SAVE\HELLO1.BAL
*MCALL #=     7 LV= 1          STFSMODE OFF
       DS    0H
*MEXIT #=     7 LV= 1 STFSMODE
*****

***** GUAM\DEMO\HELLO1.BAL
*MCALL #=     8 LV= 1          STTMPMD OFF
         DS    0H
*MEXIT #=     8 LV= 1 STTMPMD
***** RT\GUAM\DEMO\SAVE\HELLO1.BAL
*MCALL #=     8 LV= 1          STTMPMD OFF
       DS    0H
*MEXIT #=     8 LV= 1 STTMPMD
*****

***** GUAM\DEMO\HELLO1.BAL
SAVEA    DS    18F
         END 
***** RT\GUAM\DEMO\SAVE\HELLO1.BAL
SAVEA    DS    18F
         END
*****

