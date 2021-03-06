REM RUN bmk\INSTTIME INSTRUCTION TIMING REPORT BY MELVYN MALTZ
REM NOTE THIS PROGRAM REQUIRES SYSPARM DIRECTORY, ASCII, AND MEM(5)
REM SEE bmk\INSTTIME.PDF FOR DOCUMENTATION
REM THIS BAT FILE RUNS ALL TESTS AND TAKES SEVERAL MINUTES TO RUN
REM THE OUTPUT RESULTS ARE CREATED IN BMK\INSTTIME.OUT
PAUSE PRESS ENTER TO COPY BMK\INSTTIME.INS TO BMK\INSTIME.TXT AND START 
COPY bmk\INSTTIME.INS bmk\INSTTIME.TXT
SET GETENV=THE.GETENV.TEST
CALL ASMLG bmk\INSTTIME SYSPARM(bmk) ASCII MEM(5) %1 %2 %3
PAUSE SEE  bmk\INSTTIME.OUT FOR REPORT ON Z390 INSTRUCTION TIMING
