  SET CICSPATH=cics
  SET ZC39PATH=zcobol\z390
  SET PROGPATH=linklib
  SET PROGRAM=TESTBEC1
  CALL ZC390CL %CICSPATH%\%PROGRAM% CICS BAL SYSMAC(%CICSPATH%+ZCOBOL+%ZC39PATH%+CICS+MAC) SYSCPY(%CICSPATH%+ZCOBOL+%ZC39PATH%+MAC+.)
  IF ERRORLEVEL 1 GOTO WRONG
  SET PRNFILE=%CICSPATH%\%PROGRAM%.PRN
  SET URFFILE=%CICSPATH%\%PROGRAM%.URF
  CALL EZ390 %PROGPATH%\UNREF ASCII %1 %2
  IF ERRORLEVEL 1 GOTO WRONG
