TESTCVT1 CSECT 
         USING *,15
         L     1,=V(TESTCVTX)
         SR    15,15
         BR    14
*MCALL #=     1 LV= 1          CVT 
*%CVTL1 : ;
*/*                                                                  */
*/*      COMMUNICATION VECTOR TABLE                                  */
*/*                                                                  */
*/*      OS/VS2 SU64, 04/24/80, LEVEL=6                              */
*/*                                                                  */
*/*  METHOD OF ACCESS                                                */
*/*      PL/S - DCL CVTPTR PTR                                       */
*/*      BAL  - DSECT=YES SHOULD BE SPECIFIED ON MACRO CALL EXCEPT   */
*/*             WHEN CALLED DURING SYSGEN TO CREATE CSECT.  CVT FOR  */
*/*             OS/VS2 IS MAPPED UNLESS SYS=AOS1 IS SPECIFIED.  THE  */
*/*             PREFIX IS NOT MAPPED UNLESS PREFIX=YES IS SPECIFIED. */
*/*             A USING ON CVTMAP OR DSECT NAME WILL ESTABLISH       */
*/*             ADDRESSABILITY FOR ALL SYMBOLS EXCEPT IN THE 2       */
*/*             EXTENSIONS.  TO ESTABLISH ADDRESSABILITY FOR THE     */
*/*             OS - OS/VS COMMON EXTENSION, YOU SHOULD CODE         */
*/*                                                                  */
*/*             L     REG,CVTEXT1                                    */
*/*             USING CVTXTNT1,REG                                   */
*/*                                                                  */
*/*             TO ESTABLISH ADDRESSABILITY FOR THE OS/VS1 - OS/VS2  */
*/*             COMMON EXTENSION, YOU SHOULD CODE                    */
*/*                                                                  */
*/*             L     REG,CVTEXT2                                    */
*/*             USING CVTXTNT2,REG                                   */
*/*                                                                  */
*/*             WHERE REG IN EITHER CASE IS ANY REGISTER OTHER       */
*/*             THAN ZERO.                                           */
*/*                                                                  */
*/*             WHEN LISTING IS SUPPRESSED, YOU CAN DETERMINE WHICH  */
*/*             DSECT A SYMBOL IS IN BY USING THE STATEMENT NUMBER   */
*/*             IN THE DEFN COLUMN IN THE CROSS REFERENCE LISTING.   */
*/*             FOR EXAMPLE, ANY SYMBOL DEFINED BETWEEN THE          */
*/*             STATEMENT NUMBERS FOR CVTXTNT1 AND CVTXTNT2 IS IN    */
*/*             THE OS - OS/VS COMMON EXTENSION.                     */
*/*                                                                  */
*/*  F.E.'S                                                          */
*/*      MICROFICHE LISTING - CVT                                    */
*/*                                                                  */
*/*  DEVELOPERS                                                      */
*/*      BAL LISTING  - SPECIFY LIST=YES ON MACRO CALL               */
*/*      PL/S LISTING - SPECIFY %IHALIST='YES' BEFORE INCLUDE        */
*/*                                                                  */
*/*      FOR INTEGRATION, A LISTING MUST NOT BE REQUESTED UNLESS     */
*/*      YOUR MODULE CREATES THE CSECT.                              */
*
*%GOTO CVTL2;   /*
         PUSH  PRINT
         PRINT OFF
CVTPTR   EQU   16 -          ABSOLUTE ADDRESS OF POINTER TO CVT
*
*              BEGINNING OF CVT PROPER
*
         DS    0F
CVTMAP   EQU   * -           CVTPTR CONTENT POINTS HERE
*
CVTTCBP  DC    V(IEATCBP) -  ADDRESS OF A DOUBLE WORD, THE FIRST
*                            CONTAINING THE NEXT-TO-BE-DISPATCHED TCB
*                            ADDRESS, THE SECOND CONTAINING THE LAST
*                            (CURRENT) TCB ADDRESS.  BOTH WORDS ARE
*                            IDENTICAL UNLESS THE TASK GOES INTO A
*                            WAIT STATE.  WHEN IN A WAIT STATE, THE
*                            FIRST WORD IS SET TO ZERO UNTIL THE
*                            WAITING IS OVER AND THEN BOTH WORDS ARE
*                            ONCE AGAIN IDENTICAL.  (OS/VS1)
*                            ADDRESS OF 4-WORD LIST OF ADDRESSES -
*                            THE NEXT TCB, THE CURRENT TCB, THE NEXT
*                            ASCB AND THE CURRENT ASCB, IN THAT
*                            ORDER (OS/VS2)                      MDC026
CVT0EF00 DC    V(IEA0EF00) - ADDRESS OF ROUTINE TO SCHEDULE
*                            ASYNCHRONOUS EXITS
CVTLINK  DC    V(IEFLINK) -  ADDRESS OF DCB FOR SYS1.LINKLIB DATA SET
         DC    A(0) -        ** CVTJOB FIELD UNUSED IN MVS **
*                            (MDC083)                          @Z40AQ9A
CVTBUF   DC    A(0) -        ADDRESS OF THE BUFFER OF THE RESIDENT
*                            CONSOLE INTERRUPT ROUTINE
CVTXAPG  DC    V(IECXAPG) -  ADDRESS OF I/O SUPERVISOR APPENDAGE VECTOR
*                            TABLE
CVT0VL00 DC    V(IEA0VL00) - ADDRESS OF ENTRY POINT OF THE TASK
*                            SUPERVISOR'S ADDRESS VALIDITY CHECKING
*                            ROUTINE
CVTPCNVT DC    V(IECPCNVT) - ADDRESS OF ENTRY POINT OF THE ROUTINE
*                            WHICH CONVERTS A RELATIVE TRACK ADDRESS
*                            (TTR) TO AN ABSOLUTE TRACK ADDRESS
*                            (MBBCCHHR)
CVTPRLTV DC    V(IECPRLTV) - ADDRESS OF ENTRY POINT OF THE ROUTINE
*                            WHICH CONVERTS AN ABSOLUTE TRACK ADDRESS
*                            (MBBCCHHR) TO A RELATIVE TRACK ADDRESS
*                            (TTR)
CVTILK1  DC    V(IECILK1) -  ADDRESS OF THE CHANNEL AND CONTROL UNIT
*                            PORTION OF THE UCB LOOKUP TABLE
CVTILK2  DC    V(IECILK2) -  ADDRESS OF THE UCB HALFWORD ADDRESS LIST
*                            PORTION OF THE UCB LOOKUP TABLE
CVTXTLER DC    V(IECXTLER) - ADDRESS OF ERROR RECOVERY PROCEDURE (ERP)
*                            LOADER (IECVERPL) ENTRY POINT IECXTLER
*                            (MDC349)                          @Z40AQ9A
CVTSYSAD DC    A(0) -        ADDRESS OF THE SYSTEM RESIDENCE VOLUME
*                            ENTRY IN THE UCB LOOKUP TABLE
CVTBTERM DC    V(IEAVTRT1) - ADDRESS OF ENTRY POINT OF THE ABTERM
*                            ROUTINE                             MDC084
CVTDATE  DC    F'0' -        CURRENT DATE IN PACKED DECIMAL
CVTMSLT  DC    V(IEEMSER) -  ADDRESS OF THE MASTER COMMON AREA IN
*                            MASTER SCHEDULER RESIDENT DATA AREA.
*                              NOTE - USE CVTMSER INSTEAD TO ADDRESS
*                              MASTER SCHEDULER RESIDENT DATA AREA
CVTZDTAB DC    V(IECZDTAB) - ADDRESS OF I/O DEVICE CHARACTERISTIC TABLE
CVTXITP  DC    V(IECXITP) -  ADDRESS OF ERROR INTERPRETER ROUTINE
         DC    A(0) -        ** CVTDAR FIELD UNUSED IN MVS **
*                            (MDC029)                          @Z40AQ9A
CVT0FN00 DC    A(0) -        RESERVED (OS/VS2)
CVTEXIT  SVC   3 -           EXIT TO DISPATCHER
CVTBRET  BR    14 -          RETURN TO CALLER (USED BY DATA MANAGEMENT
*                            ROUTINES)
CVTSVDCB DC    V(IEASVDCB) - ADDRESS OF THE DCB FOR THE SYS1.SVCLIB
*                            DATA SET
CVTTPC   DC    V(IEATPC) -   ADDRESS OF THE TIMER SUPERVISOR WORK AREA
CVTNIPSV DS    H         -      RESERVED MVS                   @ZA51978
CVTICPID DC    H'0'      -   IPL'ED CPU PHYSICAL ID            @ZA51978
CVTSJQ   DC    A(0) -        RESERVED (OS/VS2)
CVTCUCB  DC    V(IEECUCB) -  ADDRESS OF THE TABLE THAT CONTAINS THE
*                            CURRENT CONSOLE UCB ADDRESSES
CVTQTE00 DC    V(IEAQTE00) - ADDRESS OF THE TIMER ENQUEUE ROUTINE FOR
*                            INTERVAL TIMER
CVTQTD00 DC    V(IEAQTD00) - ADDRESS OF THE TIMER DEQUEUE ROUTINE FOR
*                            INTERVAL TIMER
CVTSTB   DC    V(IECSTB) -   ADDRESS OF THE I/O DEVICE STATISTICS TABLE
CVTDCB   DC    XL1'13' -     OPERATING SYSTEM                    MDC132
CVTRSV08 EQU   X'80',,C'X' - RESERVED
CVT1SSS  EQU   X'40' -       OPTION 1 (PCP) SSS
CVT2SPS  EQU   X'20' -       OPTION 2 (MFT) SPS, OS/VS1
CVT4MS1  EQU   X'10' -       OPTION 4 (MVT) MS1, OS/VS2
CVTRSV09 EQU   X'08',,C'X' - RESERVED
CVT4MPS  EQU   X'04' -       MODEL 65 MULTIPROCESSING
CVT6DAT  EQU   X'02' -       DYNAMIC ADDRESS TRANSLATION BY CPU
*                            (OS/VS1, OS/VS2)
CVTMVS2  EQU   X'01' -       MULTIPLE MEMORY OPTION OF OS/VS2 IS
*                            PRESENT                             MDC131
CVT8AOS2 EQU   CVT4MS1+CVT6DAT - OS/VS2 SYSTEM
CVTDCBA  DC    VL3(IFBDCB) - ADDRESS OF THE DCB FOR THE SYS1.LOGREC
*                            (OUTBOARD RECORDER) DATA SET FOR SYSTEM
*                            ENVIRONMENT RECORDING (SER)
CVTSV76M DC    F'0' -        SVC 76 MESSAGE COUNT FIELD (OS/VS2)
*                            (MDC372)                          @ZA18857
CVTIXAVL DC    V(IECIXAVL) - ADDRESS OF THE I/O SUPERVISOR'S FREELIST
*                            POINTER WHICH CONTAINS THE ADDRESS OF THE
*                            NEXT REQUEST ELEMENT  (OS/VS1)
*                            ADDRESS OF THE I/O SUPERVISOR'S
*                            COMMUNICATION AREA (IOCOM)  (OS/VS2)
CVTNUCB  DC    A(0) -        LOWEST ADDRESS NOT IN THE NUCLEUS (ON PAGE
*                            BOUNDARY FOR OS/VS1)  (ON SEGMENT BOUNDARY
*                            FOR OS/VS2)  (MDC318)             @Z30AQ9A
CVTFBOSV DC    A(0) -        ADDRESS OF PROGRAM FETCH ROUTINE
*                            (MDC222)                            YM4043
CVT0DS   DC    V(IEA0DS) -   ADDRESS OF ENTRY POINT OF THE DISPATCHER
CVTILCH  DC    V(IECILCH) -  ADDRESS OF THE LOGICAL CHANNEL WORD TABLE
CVTRV516 DC    A(0) -        ** CVTIERLC FIELD UNUSED IN MVS **
*                            (MDC218)                            YM4043
CVTMSER  DC    V(IEEMSER) -  ADDRESS OF DATA AREA OF MASTER SCHEDULER
*                            RESIDENT DATA AREA
CVT0PT01 DC    V(IEA0PT01) - ADDRESS OF BRANCH ENTRY POINT OF POST
*                            ROUTINE
CVTRSV11 DS    A -           ** CVTTRMTB FIELD UNUSED IN OS/VS **
CVTSV76C DC    XL4'00' -     SVC 76 MESSAGE CONTROL FIELD.  HIGH-ORDER
*                            BIT IS DEFINED, AND ALL OTHER BITS ARE
*                            ZERO.  (OS/VS2)  (MDC373)         @ZA18857
CVTSV76Q EQU   X'80' -       SVC 76 ENQUEUE SWITCH.  THIS IS THE
*                            HIGH-ORDER BIT OF CVTSV76C.  (OS/VS2)
*                            (MDC374)                          @ZA18857
CVTMZ00  DC    X'00FFFFFF' - HIGHEST ADDRESS IN VIRTUAL STORAGE FOR
*                            THIS MACHINE
CVT1EF00 DC    A(0) -        ADDRESS OF ROUTINE WHICH CREATES IRB'S
*                            FOR EXITS
CVTQOCR  DC    A(0) -        GRAPHICS INTERFACE TASK (GFX) FIELD.
*                            ADDRESS OF SEVENTH WORD OF GFX PARAMETER
*                            LIST, IF GFX IS ACTIVE.  ZERO IF GFX IS
*                            NOT ACTIVE
CVTQMWR  DC    V(IEFQMWR) -  ADDRESS OF QUEUE MANAGER'S SYSTEM OUTPUT
*                            COMMUNICATIONS-DATA-AREA (CDA), WHICH IS
*                            STORED ON AN EXTERNAL DEVICE
CVTSNCTR DC    H'0' -        SERIAL NUMBER COUNTER FOR ASSIGNING SERIAL
*                            NUMBERS TO NON-SPECIFIC, UNLABELED
*                            MAGNETIC TAPE VOLUMES
CVTOPTA  DC    AL1(00) -  OPTION INDICATORS
CVTCCH   EQU   X'80' -       CHANNEL CHECK HANDLER (CCH) OPTION PRESENT
*                            - RECOVERY MANAGEMENT SUPPORT (RMS) XM4686
CVTAPR   EQU   X'40' -       ALTERNATE PATH RETRY (APR) OPTION PRESENT
*                            - RECOVERY MANAGEMENT SUPPORT (RMS)
CVTDDR   EQU   X'20' -       DYNAMIC DEVICE RECONFIGURATION (DDR)
*                            OPTION PRESENT - RECOVERY MANAGEMENT
*                            SUPPORT (RMS)  (OS/VS1)
*                            DDR SYSTEM-INITIATED SWAP ACTIVE  (OS/VS2)
*                                                                MDC126
CVTNIP   EQU   X'10' -       NIP IS EXECUTING
CVTRSV12 EQU   X'08',,C'X' - RESERVED
CVT121TR EQU   X'04',,C'X'   DO NOT TRANSLATE EXCP V=R       @ZA45816
CVTASCII EQU   X'02' -       ASCII TAPE PROCESSING IS GENERATED IN
*                            THIS SYSTEM
CVTXPFP  EQU   X'01' -       CPU HAS EXTENDED PRECISION FLOATING POINT
*                            FEATURE
CVTOPTB  DC    AL1(00) - MISCELLANEOUS FLAGS
CVTPROT  EQU   X'80' -       CPU HAS STORE PROTECTION FEATURE (OS/VS1)
CVTCTIMS EQU   X'40' -       IF ON, HARDWARE HAS THE CLOCK COMPARATOR
*                            AND CPU TIMER FEATURE INSTALLED, AND
*                            OS/VS1 SYSGEN HAS SPECIFIED THIS FEATURE
*                            (OS/VS1)                            MDC127
CVTTOD   EQU   X'20' -       CPU HAS TIME-OF-DAY CLOCK FEATURE
CVTNLOG  EQU   X'10' -       SYS1.LOGREC IS UNAVAILABLE FOR ERROR
*                            RECORDING.  ALWAYS SET TO ZERO FOR
*                            OS/VS1.                             MDC127
CVTAPTHR EQU   X'08' -       NIP SETS THIS BIT TO 1 WHEN DEVICE TESTING
*                            IS COMPLETE.  IF 1, I/O SUPERVISOR USES
*                            AN ALTERNATE PATH TO A DEVICE WHEN A
*                            CONDITION CODE OF 3 EXISTS.  THIS BIT IS
*                            RESET TO 0 BY NIP AFTER THE LINK PACK
*                            AREA IS INITIALIZED.                YM2670
CVTFP    EQU   X'04' -       CPU HAS FETCH PROTECTION FEATURE (OS/VS1)
*                                                                ICB427
CVTVS1A  EQU   X'02' -       VS1 ASSIST IS AVAILABLE FOR USE (OS/VS1)
*                            (MDC353)                          @X60CA9A
CVTVS1B  EQU   X'01' -       VS1 ASSIST SUBSET IS AVAILABLE FOR USE
*                            (OS/VS1)  (MDC365)                @X60KU9A
CVTQCDSR DC    V(IEAQCDSR) - CDE SEARCH ROUTINE ADDRESS  (OS/VS2)
CVTQLPAQ DC    V(IEAQLPAQ) - ADDRESS OF POINTER TO MOST RECENT ENTRY
*                            ON LINK PACK AREA CDE QUEUE  (OS/VS2)
CVTRSV18 DC    A(0) -        ** CVTMPCVT FIELD UNUSED IN OS/VS **
CVTSMCA  DC    A(0) -        ADDRESS OF THE SYSTEM MANAGEMENT CONTROL
*                            AREA (SMCA) IF THE SYSTEM MANAGEMENT
*                            FACILITIES (SMF) OPTION IS PRESENT IN THE
*                            SYSTEM.  OTHERWISE, ZERO.
CVTABEND DC    V(IEABEND) -  ADDRESS OF SECONDARY CVT FOR ABEND IN EOT
*                            (OS/VS2)
CVTUSER  DC    A(0) -        A WORD AVAILABLE TO THE USER
CVTMDLDS DC    A(0) -        RESERVED FOR MODEL-DEPENDENT SUPPORT
CVTQABST SVC   13 -          AN ABEND INVOCATION (OS/VS2)
CVTLNKSC SVC   6 -           A LINK INVOCATION                   ICB369
CVTTSCE  DC    A(0) -        ADDRESS OF THE FIRST TIME SLICE CONTROL
*                            ELEMENT (TSCE)
CVTPATCH DC    V(IEAPATCH) - ADDRESS OF A 200-BYTE FE PATCH AREA
CVTRMS   DC    V(IGFRVT) -   RECOVERY MANAGEMENT SUPPORT (RMS)
*                            COMMUNICATIONS VECTOR.  ADDRESS OF A
*                            MACHINE STATUS BLOCK.
CVTRV515 DC    A(0) -        ** CVTTSCVT FIELD UNUSED IN MVS **
*                            (MDC037)                          @Z40AQ9A
CVT0SCR1 DC    A(0) -        ADDRESS OF THE SECTOR CALCULATION ROUTINE
*                            FOR ROTATIONAL POSITION SENSING (RPS)
CVTGTF   DS    0A -          GENERALIZED TRACE FACILITY (GTF) CONTROL
*                            WORD                                ICB312
CVTGTFST DC    AL1(0) -      GTF FLAG BYTES                      ICB312
CVTGTFAV EQU   X'80' -       IF ZERO, GTF NOT ACTIVE.  IF ONE, GTF
*                            ACTIVE.  (OS/VS2)                   MDC098
CVTRV315 EQU   X'40',,C'X' - RESERVED (OS/VS2)
CVTRV316 EQU   X'20',,C'X' - RESERVED (OS/VS2)
CVTRV317 EQU   X'10',,C'X' - RESERVED (OS/VS2)
CVTRV318 EQU   X'08',,C'X' - RESERVED (OS/VS2)
CVTUSR   EQU   X'04' -       TRACE=USR SPECIFIED.  USER-REQUESTED TRACE
*                            DATA IS TO BE INCLUDED IN THE TRACE DATA
*                            SET.  (MDC317)                    @Z30AP9A
CVTRNIO  EQU   X'02' -       GTF IS ACTIVE AND TRACING RNIO EVENTS
*                                                                MDC187
CVTRSV27 EQU   X'01',,C'X' - RESERVED
CVTGTFA  DC    VL3(AHLHEAD) -ADDRESS OF MAIN MONITOR CALL ROUTING
*                            TABLE, MCHEAD  (OS/VS2)             MDC156
CVTAQAVT DS    0A -          ADDRESS OF THE FIRST WORD OF THE TCAM
*                            DISPATCHER WHICH CONTAINS THE ADDRESS OF
*                            THE ADDRESS VECTOR TABLE (AVT).  IF ZERO,
*                            TCAM IS NOT STARTED.
CVTTCMFG DC    X'00' -       TCAM FLAGS
CVTTCRDY EQU   X'80' -       TCAM IS READY TO ACCEPT USERS
CVTLDEV  EQU   X'40' -       LOCAL DEVICE ATTACHED TO TCAM
*                            (MDC357)                          @Z40XA9A
CVTRSV29 EQU   X'20',,C'X' - RESERVED
CVTRSV30 EQU   X'10',,C'X' - RESERVED
CVTRSV31 EQU   X'08',,C'X' - RESERVED
CVTRSV32 EQU   X'04',,C'X' - RESERVED
CVTRSV33 EQU   X'02',,C'X' - RESERVED
CVTRSV34 EQU   X'01',,C'X' - RESERVED
CVTAQAVB DC    AL3(0) -      SAME AS CVTAQAVT ABOVE
CVTVOLM2 DS    0A -          ADDRESS OF TABLE FOR POWER WARNING FEATURE
*                            (PWF)  (OS/VS2)  (MDC308)         @Z30AQ9A
CVTVOLF2 DC    X'80' -       PWF FLAG BYTE.  THIS BYTE IS OVERLAID BY
*                            CVTVOLM2 AFTER PWF INITIALIZATION.
*                            (OS/VS2)  (MDC309)                @Z30AQ9A
CVTVOLI2 EQU   X'80' -       PWF INITIALIZATION HAS NOT OCCURRED
*                            (OS/VS2)  (MDC310)                @Z30AQ9A
CVTVOLT2 DC    AL3(0) -  PWF RECHECK TIME DELAY.  THIS VALUE IS
*                            OVERLAID BY CVTVOLM2 AFTER PWF
*                            INITIALIZATION. (OS/VS2) (MDC311) @Z30AQ9A
         DC    A(0) -        RESERVED  (OS/VS2)
CVTEXT1  DC    A(CVTXTNT1) - ADDRESS OF OS - OS/VS COMMON EXTENSION
*                                                                ICB421
CVTCBSP  DC    A(0) -        ADDRESS OF ACCESS METHOD CONTROL BLOCK
*                            STRUCTURE                           MDC195
CVTPURG  DS    0A -          ADDRESS OF SUBSYSTEM PURGE ROUTINE  ICB330
CVTRSV35 DS    XL1 -         RESERVED                            ICB330
CVTPURGA DC    AL3(0) -      ADDRESS OF SUBSYSTEM PURGE ROUTINE  ICB330
CVTAMFF  DC    XL4'00' -     RESERVED FOR ACCESS METHOD FLAGS    ICB436
CVTQMSG  DS    0A -          ADDRESS OF INFORMATION TO BE PRINTED
*                            BY ABEND                            ICB307
CVTRSV36 DS    XL1 -         RESERVED                            ICB307
CVTQMSGA DC    VL3(IEAQMSGS) ADDRESS OF INFORMATION TO BE PRINTED
*                            BY ABEND                            ICB449
CVTDMSR  DS    0A -          SAME AS CVTDMSRA BELOW              ICB346
CVTDMSRF DC    XL1'00' -     OPEN/CLOSE/EOV FLAG BYTE.  SETTING BOTH
*                            BIT 0 AND BIT 1 ON WILL CAUSE BOTH KINDS
*                            OF DUMPS TO BE TAKEN.  THESE BITS ARE USED
*                            DURING TESTING AND DEBUGGING WHEN OTHER
*                            DEBUG METHODS ARE INEFFECTIVE.  (OS/VS2)
*                            (MDC350)                          @Z40AQ9A
CVTSDUMP EQU   X'80' -       SET BY COREZAP.  WILL CAUSE AN SDUMP TO BE
*                            TAKEN AND IEC999I MESSAGE ISSUED FOR EVERY
*                            ABEND ISSUED WITHIN AN OPEN/CLOSE/EOV OR
*                            DADSM FUNCTION. (OS/VS2) (MDC351) @Z40AQ9A
CVTUDUMP EQU   X'40' -       SET BY COREZAP.  WILL CAUSE AN ABEND DUMP
*                            TO BE TAKEN FOR EVERY ABEND ISSUED WITHIN
*                            AN OPEN/CLOSE/EOV OR DADSM FUNCTION.
*                            (OS/VS2)  (MDC352)                @Z40AQ9A
CVTRV629 EQU   X'20',,C'X' - RESERVED (OS/VS2)                 @Z40AQ9A
CVTRV630 EQU   X'10',,C'X' - RESERVED (OS/VS2)                 @Z40AQ9A
CVTRV631 EQU   X'08',,C'X' - RESERVED (OS/VS2)                 @Z40AQ9A
CVTRV632 EQU   X'04',,C'X' - RESERVED (OS/VS2)                 @Z40AQ9A
CVTRV633 EQU   X'02',,C'X' - RESERVED (OS/VS2)                 @Z40AQ9A
CVTRV634 EQU   X'01',,C'X' - RESERVED (OS/VS2)                 @Z40AQ9A
CVTDMSRA DC    AL3(0) -      ADDRESS OF THE OPEN/CLOSE/EOV SUPERVISORY
*                            ROUTINE IN THE NUCLEUS.  THIS ROUTINE
*                            HANDLES THE ROUTING OF CONTROL AMONG THE
*                            I/O SUPPORT ROUTINES.               ICB346
CVTRSV38 DS    F -           RESERVED
CVTRSV39 DS    F -           RESERVED
*
*              OS/VS1 - OS/VS2 COMMON SECTION
*
CVTREAL  DC    A(0) -    ADDRESS OF THE VIRTUAL STORAGE BYTE
*                            FOLLOWING THE HIGHEST VIRTUAL=REAL
*                            STORAGE ADDRESS                     ICB368
CVTPTRV  DC    V(IEAPTRV) -  ADDRESS OF PAGING SUPERVISOR GENERAL
*                            ROUTINE TO TRANSLATE REAL ADDRESSES TO
*                            VIRTUAL ADDRESSES
         DC    A(0) -        RESERVED (WAS CVTMODE) (OS/VS2)
*                            (MDC217)                            YM4244
CVTJESCT DC    V(IEFJESCT) - ADDRESS OF JOB ENTRY SUBSYSTEM (JES)
*                            CONTROL TABLE                       ICB342
         DS    A -           RESERVED (WAS CVTJEPS) (OS/VS2)     YM2702
CVTTZ    DC    F'0' -   DIFFERENCE BETWEEN LOCAL TIME AND
*                            GREENWICH MEAN TIME IN BINARY UNITS OF
*                            1.048576 SECONDS
CVTMCHPR DS    A -           ADDRESS OF MACHINE CHECK PARAMETER LIST
CVTEORM  DC    A(0) - POTENTIAL REAL HIGH STORAGE         YM3613
*                            ADDRESS (OS/VS2)                    YM3613
CVTRV517 DC    A(0) -        ** CVTERPV FIELD UNUSED IN MVS **
*                            (MDC219)                            YM4043
CVTRV518 DC    A(0) -        ** CVTINTLA FIELD UNUSED IN MVS **
*                            (MDC220)                            YM4043
CVTAPF   DS    0A -          SAME AS CVTAPFA BELOW               ICB360
CVTRSV40 DS    X -           RESERVED                            ICB360
CVTAPFA  DC    VL3(IEAVTEST) ADDRESS OF BRANCH ENTRY POINT IN
*                            AUTHORIZED PROGRAM FACILITY (APF) ROUTINE
CVTEXT2  DS    0A -          ADDRESS OF OS/VS1 - OS/VS2 COMMON
*                            EXTENSION                           ICB330
CVTRSV41 DS    XL1 -         RESERVED                            ICB330
CVTEXT2A DC    AL3(CVTXTNT2) SAME AS CVTEXT2 ABOVE               ICB330
CVTHJES  DS    0A -          SAME AS CVTHJESA BELOW              ICB454
CVTRSV42 DS    X -           RESERVED                            ICB454
CVTHJESA DC    AL3(0) -      ADDRESS OF OPTIONAL JOB ENTRY SUBSYSTEM
*                            (JES) COMMUNICATION VECTOR TABLE    ICB454
CVTRSV43 DS    H -           RESERVED
CVTRSV44 DS    H -           RESERVED
CVTRSV45 DS    F -           RESERVED
CVTRSV46 DS    F -           RESERVED
*
*              OS/VS2 OVERLAY
*
CVTGETL  DC    A(0) -        ADDRESS OF IKJGETL, TSO GET LINE ROUTINE
*                            (MDC206)                            YM2225
CVTLPDSR DC    V(IEAVVMSR) - ADDRESS OF LINK PACK AREA (LPA) DIRECTORY
*                            SEARCH ROUTINE
CVTPVTP  DC    V(CSECPVT) -  ADDRESS OF PAGE VECTOR TABLE
CVTLPDIA DS    0A -          ADDRESS OF LINK PACK AREA (LPA) DIRECTORY
*                            (ON PAGE BOUNDARY)
CVTDIRST DS    B -           FLAG BYTE
CVTDICOM EQU   X'80' -       LPA DIRECTORY HAS BEEN INITIALIZED BY NIP
CVTRSV63 EQU   X'40',,C'X' - RESERVED
CVTRSV64 EQU   X'20',,C'X' - RESERVED
CVTRSV65 EQU   X'10',,C'X' - RESERVED
CVTRSV66 EQU   X'08',,C'X' - RESERVED
CVTRSV67 EQU   X'04',,C'X' - RESERVED
CVTRSV68 EQU   X'02',,C'X' - RESERVED
CVTRSV69 EQU   X'01',,C'X' - RESERVED
CVTLPDIR DS    AL3 -         ADDRESS OF LINK PACK AREA (LPA) DIRECTORY
*                            (ON PAGE BOUNDARY)
CVTPSAD0 DC    V(IGFPSAD0) - PSA PROTECT DISABLE (MDC393)      @ZA36872
CVTPSAE0 DC    V(IGFPSAE0) - PSA PROTECT ENABLE (MDC394)       @ZA36872
CVTSLIDA DS    0CL4 -        IDENTITY OF TCB CAUSING SUPERVISOR LOCK
*                            BYTE (CVTSYLK) TO BE SET OR IDENTITY OF
*                            TCB THAT SECOND EXIT PROCESSING IS FOR
*                            WHEN CVTSEIC=1
CVTSYLK  DS    C -           SUPERVISOR LOCK.  ONLY ENABLED TASKS MAY
*                            BE DISPATCHED
CVTSYLKS EQU   X'FF' -       SET LOCK BYTE
CVTSYLKR EQU   X'00' -       RESET LOCK BYTE
CVTSLID  DS    CL3 -         SAME AS CVTSLIDA ABOVE
CVTRV322 DC    A(0) -        RESERVED FOR FUTURE USE  (MDC343) @Z40AQ9A
CVTRV328 DC    A(0) -        ** CVTSEG AND CVTSEGA FIELDS UNUSED IN
*                            MVS **  (MDC139)                  @Z40AQ9A
CVTVLDWT DC    V(IEEVLDWT) - ADDRESS OF STOP/RESTART INTERFACE ROUTINE
*                            (MDC392)                          @G64UP9A
CVTEXSLF DC    F'20000000' - EXCESSIVE SPIN LENGTH FACTOR
*                            (MDC385)                          @G64UP9A
CVTEXSNR DC    V(IEEVEXSN) - ADDRESS OF EXCESSIVE SPIN NOTIFICATION
*                            ROUTINE  (MDC386)                 @G64UP9A
CVTEXSNL DC    XL1'00' -     SERIALIZATION BYTE FOR EXCESSIVE SPIN
*                            NOTIFICATION ROUTINE  (MDC387)    @G64UP9A
CVTSPVLK DS    FL1 -         NUMBER OF TASKS WHICH HAVE TERMINATED
*                            WHILE OWNING SUPERVISOR LOCK WITHOUT
*                            OPERATOR HAVING YET BEEN NOTIFIED
CVTCTLFG DC    AL1(00) SYSTEM CONTROL FLAGS
CVTRV323 EQU   X'80',,C'X' - ** CVTPSIC BIT UNUSED IN MVS **
*                            (MDC118)                          @Z40AQ9A
CVTRV333 EQU   X'40',,C'X' - ** CVTAPGB BIT UNUSED IN MVS **
*                            (MDC151)                          @Z40AQ9A
CVTRSV78 EQU   X'20',,C'X' - RESERVED
CVTDSTAT EQU   X'10' -       DEVSTAT OPTION IN EFFECT.  DEVICE ADDRESS
*                            FOR 2319, 3330, 2314, 3330-1, 3340 CAN
*                            VARY ACROSS SYSTEMS                 MDC189
CVTRSV79 EQU   X'08',,C'X' - RESERVED
CVTNOMP  EQU   X'04' -       MULTIPROCESSING CODE IS NOT IN THE SYSTEM
*                                                                MDC176
CVTGTRCE EQU   X'02' -       GENERALIZED TRACE FACILITY (GTF) HAS
*                            SUPPRESSED SUPERVISOR TRACE         ICB446
CVTSDTRC EQU   X'01' -       SVC DUMP HAS SUPPRESSED SUPERVISOR TRACE
*                                                                ICB446
CVTAPG   DC    FL1'7' -      DISPATCHING PRIORITY OF AUTOMATIC PRIORITY
*                            GROUP (APG)                         MDC152
CVTTRACE BR    11 -          BRANCH ON REGISTER INSTRUCTION.  SET BY
*                            NIP.  REGISTER TEN FOR TRACE.  REGISTER
*                            ELEVEN FOR NO TRACE.
CVTTRAC2 BR    11 -          THIS ALLOWS FOR SUPPRESSING TRACE
*                            DYNAMICALLY BY SETTING CONDITION CODE
*                            MASK TO ZERO IN FIRST INSTRUCTION
*                            (CVTTRACE)
CVTRSCN  DC    V(IEATRSCN) - ADDRESS OF ROUTINE TO SCAN TCB TREE
CVTTAS   DC    A(0) -        ADDRESS OF ROUTINE TO TRANSFER ADDRESS
*                            SPACE                               YM2706
CVTRV332 DC    A(0) -        ** CVTPVALD FIELD UNUSED IN MVS **
*                            (MDC148)                          @Z40AQ9A
CVTSHRVM DS    A -           LOWEST ADDRESS OF SHARED VIRTUAL STORAGE
*                            AREA.  THIS ADDRESS WILL BE THE BEGINNING
*                            OF THE COMMON SERVICE AREA (CSA)
*                            (MDC324)                          @Z30AQ9A
CVT0VL01 DC    V(IEA0VL01) - ENTRY POINT ADDRESS OF VALIDITY CHECK
*                            ROUTINE (IEA0VL01) USED TO COMPARE
*                            PROTECT KEY OF AN ADDRESS WITH TCB
*                            PROTECT KEY
CVTPPGMX DC    V(IEAPPGMX) - ADDRESS OF A BRANCH ENTRY POINT   @ZA58427
*                            TO PROGRAM MANAGER RESOURCE       @ZA58427
*                            MANAGEMENT ROUTINES               @ZA58427
CVTRV325 DC    A(0) -        ** CVTPFIXR FIELD UNUSED IN MVS **
*                            (MDC120)                          @Z40AQ9A
CVTRV326 DC    A(0) -        ** CVTPFIXP FIELD UNUSED IN MVS **
*                            (MDC121)                          @Z40AQ9A
CVTASCRF DC    A(0) -        CREATED ASCB QUEUE HEADER
*                            (MDC337)                          @ZA04120
CVTASCRL DC    A(0) -        CREATED ASCB QUEUE TRAILER
*                            (MDC338)                          @ZA04120
CVTPUTL  DC    A(0) -        ADDRESS OF IKJPUTL, TSO PUT LINE ROUTINE
*                            (MDC207)                            YM2225
CVTSRBRT DC    V(IEAPDSRT) - DISPATCHER RETURN ADDRESS FOR SRB ROUTINES
*                                                                MDC130
CVTOLT0A DC    V(IFDOLT0A) - BRANCH ENTRY TO OLTEP MEMORY TERMINATION
*                            RESOURCE MANAGER                    MDC129
CVTSMFEX DC    V(IEASMFEX) - BRANCH ENTRY TO SYSTEM MANAGEMENT
*                            FACILITIES (SMF) EXCP COUNTING ROUTINE
*                            FOR VAM WINDOW INTERCEPT            MDC133
CVTCSPIE DC    A(0) -        FOR CHECKPOINT/RESTART, BRANCH ENTRY TO
*                            SPIE                                MDC149
CVTPTGT  DC    A(0) -        ADDRESS OF IKJPTGT, TSO PUTGET ROUTINE
*                            (MDC208)                            YM2225
CVTIOSPL DS    FL1 -         PRIORITY LEVEL OF I/O SUPERVISOR CHANNEL
*                            SCHEDULER                           MDC019
CVTRV513 DS    XL1 -         RESERVED                            MDC165
CVTDSSAC DC    XL1'00' -     DYNAMIC SUPPORT SYSTEM (DSS) ACTIVATED
*                            FLAG - USED BY RESTART FLIH.  IF X'00',
*                            DSS NOT INITIALIZED.  IF X'FF', DSS HAS
*                            BEEN INITIALIZED.                   MDC163
CVTRV139 DS    XL1 -         RESERVED
CVTSTCK  DC    A(0) -        ADDRESS OF IKJSTCK, TSO STACK ROUTINE
*                            (MDC209)                            YM2225
CVTMAXMP DC    H'1' -        FOR MEASUREMENT FACILITY (MF/1), MAXIMUM
*                            PHYSICAL CPU ADDRESS SUPPORTED BY THIS
*                            RELEASE                             MDC165
CVTRV144 DS    H -           RESERVED
CVTSCAN  DC    A(0) -        ADDRESS OF IKJSCAN, TSO SCAN ROUTINE
*                            (MDC210)                            YM2225
CVTAUTHL DS    A -           POINTER TO AUTHORIZED LIBRARY TABLE MDC001
CVTBLDCP DC    V(IEAVBLDP) - BRANCH ENTRY TO BUILD POOL          MDC003
CVTGETCL DC    V(IEAVGTCL) - BRANCH ENTRY TO GET CELL            MDC004
CVTFRECL DC    V(IEAVFRCL) - BRANCH ENTRY TO FREE CELL           MDC005
CVTDELCP DC    V(IEAVDELP) - BRANCH ENTRY TO DELETE POOL         MDC006
CVTCRMN  DC    V(CRBRANCH) - BRANCH ENTRY TO SVC 120 (GETMAIN/FREEMAIN
*                            CRBRANCH)                           MDC007
CVTCRAS  DC    V(IEAVGCAS) - BRANCH ENTRY TO 'CREATE ADDRESS SPACE'
*                                                                MDC008
CVTQSAS  DC    V(IEAQSPET) - BRANCH ENTRY TO TASK TERMINATION    MDC009
CVTFRAS  DC    V(IEAVGFAS) - BRANCH ENTRY TO 'FREE ADDRESS SPACE'
*                                                                MDC010
CVTS1EE  DC    V(IGC043BR) - BRANCH ENTRY TO STAGE 1 EXIT EFFECTOR
*                                                                MDC011
CVTPARS  DC    A(0) -        ADDRESS OF IKJPARS, TSO PARSE ROUTINE
*                            (MDC211)                            YM2225
CVTQUIS  DC    V(IEAVAR02) - BRANCH ENTRY TO QUIESCE             MDC013
CVTSTXU  DC    A(0) -        BRANCH ENTRY TO ATTENTION EXIT EPILOGUE
*                            (MDC321)                          @Z30HP9A
CVTOPTE  DC    V(IRARMI00) - BRANCH ENTRY ADDRESS TO SYSEVENT    MDC015
CVTSDRM  DS    A -           BRANCH ENTRY ADDRESS OF THE RESOURCE
*                            MANAGER ROUTINE FOR SVC DUMP.  THIS
*                            ROUTINE CAN BE INVOKED BY MEMORY
*                            TERMINATION                         MDC077
CVTIOSCS DS    A -           ENTRY POINT OF I/O SUPERVISOR CHANNEL
*                            SCHEDULER                           MDC018
CVTAQTOP DC    V(IEFAQTOP) - POINTER TO AREA CONTAINING QUIESCE
*                            DESCRIPTOR BLOCK (QDB'S) FOR DEVICE
*                            ALLOCATION                          MDC021
CVTVVMDI DS    A -           CONSTANT USED BY PAGED LINK PACK AREA
*                            (LPA) DIRECTORY SEARCH ALGORITHM    MDC022
CVTASVT  DS    A -           POINTER TO ADDRESS SPACE VECTOR TABLE
*                            (ASVT)                              MDC070
CVTGDA   DS    A -           POINTER TO GLOBAL DATA AREA (GDA) IN SQA
*                                                                MDC024
CVTASCBH DC    V(IEAMASCB) - POINTER TO HIGHEST PRIORITY ADDRESS SPACE
*                            CONTROL BLOCK (ASCB) ON THE ASCB
*                            DISPATCHING QUEUE (HEAD OF ASCB QUEUE)
*                                                                MDC027
CVTASCBL DC    V(IEAMASCB) - POINTER TO LOWEST PRIORITY ASCB ON THE
*                            ASCB DISPATCHING QUEUE (MDC339)   @Z40WP9A
CVTRTMCT DS    A -           POINTER TO RECOVERY/TERMINATION CONTROL
*                            TABLE                               MDC031
CVTSV60  DS    A -           ADDRESS OF SVC 60 BRANCH ENTRY POINT
*                            (MDC354)                          @Z40FP9A
CVTSDMP  DC    V(IEAVTSDX) - ADDRESS OF SVC DUMP BRANCH ENTRY POINT
*                                                                MDC033
CVTSCBP  DC    V(IEAVTSBP) - ADDRESS OF SCB PURGE RESOURCE MANAGER
*                                                                MDC034
CVTSDBF  DC    X'80000000' - ADDRESS OF 4K SQA BUFFER USED BY SVC
*                            DUMP.  HIGH-ORDER BIT OF THIS CVT WORD
*                            IS USED AS LOCK TO INDICATE BUFFER IS
*                            IN USE                              MDC035
CVTRTMS  DC    A(0) -        ADDRESS OF SERVICABILITY LEVEL INDICATOR
*                            PROCESSING (SLIP) HEADER (MDC358) @G17SP9A
CVTTPIOS DS    A -           ADDRESS OF THE TELEPROCESSING I/O
*                            SUPERVISOR ROUTINE (TPIOS)          MDC078
CVTSIC   DS    A -           BRANCH ADDRESS OF THE ROUTINE TO SCHEDULE
*                            SYSTEM INITIALIZED CANCEL           MDC042
CVTOPCTP DC    V(IRARMCNS) - ADDRESS OF SYSTEM RESOURCES MANAGER (SRM)
*                            CONTROL TABLE                       MDC043
CVTEXPRO DC    V(IEAVEXPR) - ADDRESS OF EXIT PROLOGUE/TYPE 1 EXIT
*                                                                MDC044
CVTGSMQ  DC    V(IEAGSMQ) -  ADDRESS OF GLOBAL SERVICE MANAGER QUEUE
*                                                                MDC045
CVTLSMQ  DC    V(IEALSMQ) -  ADDRESS OF LOCAL SERVICE MANAGER QUEUE
*                                                                MDC046
CVTGSPL  DC    V(IEAGSPL) -  ADDRESS OF GLOBAL SYSTEM PRIORITY LIST
*                            QUEUE                               MDC047
CVTVWAIT DC    V(IEAVWAIT) - ADDRESS OF WAIT ROUTINE             MDC048
CVTPARRL DC    V(IEAPPGMA) - ADDRESS OF PARTIALLY LOADED DELETE QUEUE
*                                                                MDC049
CVTAPFT  DS    A -           ADDRESS OF AUTHORIZED PROGRAM FACILITY
*                            (APF) TABLE.  INITIALIZED BY NIP.   MDC050
CVTQCS01 DC    V(IEAQCS01) - BRANCH ENTRY ADDRESS TO PROGRAM MANAGER
*                            USED BY ATTACH                      MDC051
CVTFQCB  DS    A -           POINTER TO FIRST MAJOR QCB FOR ENQ  MDC052
CVTLQCB  DS    A -           POINTER TO LAST MAJOR QCB FOR ENQ   MDC053
CVTRENQ  DC    V(IEAVENQ2) - RESOURCE MANAGER ADDRESS FOR ENQ    MDC054
CVTRSPIE DC    A(0) -        RESOURCE MANAGER FOR SPIE           MDC055
CVTLKRMA DC    V(IEAVELRM) - RESOURCE MANAGER ADDRESS FOR LOCK MANAGER
*                                                                MDC056
CVTCSD   DS    A -           VIRTUAL ADDRESS OF COMMON SYSTEM DATA AREA
*                            (CSD).  INITIALIZED BY NIP.         MDC057
CVTDQIQE DC    V(IEADQIQE) - RESOURCE MANAGER FOR EXIT EFFECTORS MDC058
CVTRPOST DC    V(IEARPOST) - RESOURCE MANAGER FOR POST           MDC059
CVT062R1 DC    V(IGC062R1) - BRANCH ENTRY TO DETACH              MDC060
CVTVEAC0 DC    V(IEAVEAC0) - ASCBCHAP BRANCH ENTRY               MDC061
CVTGLMN  DC    V(GLBRANCH) - GLOBAL BRANCH ENTRY ADDRESS FOR
*                            GETMAIN/FREEMAIN                    MDC062
CVTSPSA  DC    V(IEAVGWSA) - POINTER TO GLOBAL WORK/SAVE AREA VECTOR
*                            TABLE (WSAG)                        MDC071
CVTWSAL  DC    V(IEAVWSAL) - ADDRESS OF TABLE OF LENGTHS OF LOCAL
*                            WORK/SAVE AREAS                     MDC072
CVTWSAG  DC    V(IEAVWSAG) - ADDRESS OF TABLE OF LENGTHS OF GLOBAL
*                            WORK/SAVE AREAS  (MDC391)         @G64UP9A
CVTWSAC  DC    V(IEAVWSAC) - ADDRESS OF TABLE OF LENGTHS OF CPU
*                            WORK/SAVE AREAS                     MDC074
CVTRECRQ DC    V(IEAVTRER) - ADDRESS OF THE RECORDING REQUEST FACILITY
*                            (PART OF RTM1 - CALLED BY RTM2 AND RMS)
*                                                                MDC075
CVTASMVT DC    V(ASMVT) -    POINTER TO AUXILIARY STORAGE MANAGEMENT
*                            VECTOR TABLE (AMVT)  (MDC340)     @Z40WP9A
CVTIOBP  DC    V(IDA121CV) - ADDRESS OF THE BLOCK PROCESSOR CVT
*                            (MDC079)                            YM0029
CVTSPOST DC    V(IEASPOST) - POST RESOURCE MANAGER TERMINATION ROUTINE
*                            (RMTR) ENTRY POINT                  MDC085
CVTRSTWD DC    F'0' -        RESTART RESOURCE MANAGEMENT WORD -
*                            CONTAINS IDENTIFIER OF USER IF RESTART IS
*                            IN USE.  OTHERWISE, ZERO.           MDC161
CVTFETCH DC    V(IEWMSEPT) - ADDRESS OF ENTRY POINT FOR BASIC FETCH
*                                                                MDC196
CVT044R2 DC    V(IGC044R2) - ADDRESS OF IGC044R2 IN CHAP SERVICE
*                            ROUTINE                             MDC197
CVTPERFM DC    A(0) -        ADDRESS OF THE PERFORMANCE WORK AREA.
*                            SET BY IGX00018.                    MDC205
CVTDAIR  DC    A(0) -        ADDRESS OF IKJDAIR, TSO DYNAMIC
*                            ALLOCATION INTERFACE ROUTINE  (MDC212)
*                                                                YM2225
CVTEHDEF DC    A(0) -        ADDRESS OF IKJEHDEF, TSO DEFAULT SERVICE
*                            ROUTINE  (MDC213)                   YM2225
CVTEHCIR DC    A(0) -        ADDRESS OF IKJEHCIR, TSO CATALOG
*                            INFORMATION ROUTINE  (MDC214)       YM2225
CVTSSAP  DS    A -           ADDRESS OF SYSTEM SAVE AREA         MDC063
CVTAIDVT DS    A -           POINTER TO APPENDAGE ID VECTOR TABLE
*                                                                MDC064
CVTIPCDS DC    V(IEAVEDR) -  BRANCH ENTRY FOR DIRECT SIGNAL
*                            SERVICE ROUTINE                     MDC065
CVTIPCRI DC    V(IEAVERI) -  BRANCH ENTRY FOR REMOTE IMMEDIATE
*                            SIGNAL SERVICE ROUTINE              MDC066
CVTIPCRP DC    V(IEAVERP) -  BRANCH ENTRY FOR REMOTE PENDABLE
*                            SIGNAL SERVICE ROUTINE              MDC067
CVTPCCAT DS    A -           POINTER TO PHYSICAL CCA VECTOR TABLE
*                                                                MDC068
CVTLCCAT DS    A -           POINTER TO LOGICAL CCA VECTOR TABLE MDC069
CVTRV210 DS    B -           RESERVED
CVTRV211 EQU   X'80',,C'X' - RESERVED
CVTRV212 EQU   X'40',,C'X' - RESERVED
CVTRV213 EQU   X'20',,C'X' - RESERVED
CVTRV214 EQU   X'10',,C'X' - RESERVED
CVTRV215 EQU   X'08',,C'X' - RESERVED
CVTRV216 EQU   X'04',,C'X' - RESERVED
CVTRV217 EQU   X'02',,C'X' - RESERVED
CVTRV218 EQU   X'01',,C'X' - RESERVED
CVTRV219 DS    B -           RESERVED
CVTRV220 EQU   X'80',,C'X' - RESERVED
CVTRV221 EQU   X'40',,C'X' - RESERVED
CVTRV222 EQU   X'20',,C'X' - RESERVED
CVTRV223 EQU   X'10',,C'X' - RESERVED
CVTRV224 EQU   X'08',,C'X' - RESERVED
CVTRV225 EQU   X'04',,C'X' - RESERVED
CVTRV226 EQU   X'02',,C'X' - RESERVED
CVTRV227 EQU   X'01',,C'X' - RESERVED
CVTRV228 DS    B -           RESERVED
CVTRV229 EQU   X'80',,C'X' - RESERVED
CVTRV230 EQU   X'40',,C'X' - RESERVED
CVTRV231 EQU   X'20',,C'X' - RESERVED
CVTRV232 EQU   X'10',,C'X' - RESERVED
CVTRV233 EQU   X'08',,C'X' - RESERVED
CVTRV234 EQU   X'04',,C'X' - RESERVED
CVTRV235 EQU   X'02',,C'X' - RESERVED
CVTRV236 EQU   X'01',,C'X' - RESERVED
CVTRV237 DS    B -           RESERVED
CVTRV238 EQU   X'80',,C'X' - RESERVED
CVTRV239 EQU   X'40',,C'X' - RESERVED
CVTRV240 EQU   X'20',,C'X' - RESERVED
CVTRV241 EQU   X'10',,C'X' - RESERVED
CVTRV242 EQU   X'08',,C'X' - RESERVED
CVTRV243 EQU   X'04',,C'X' - RESERVED
CVTRV244 EQU   X'02',,C'X' - RESERVED
CVTRV245 EQU   X'01',,C'X' - RESERVED
CVTRV246 DS    XL1 -         RESERVED
CVTRV247 DS    XL1 -         RESERVED
CVTRV248 DS    XL1 -         RESERVED
CVTRV249 DS    XL1 -         RESERVED
CVTRV250 DS    XL1 -         RESERVED
CVTRV251 DS    XL1 -         RESERVED
CVTRV252 DS    AL2 -         RESERVED
CVTRV253 DS    H -           RESERVED
CVTRV254 DS    H -           RESERVED
CVTPWI   DC    A(0) -        ADDRESS OF THE WINDOW INTERCEPT ROUTINE
*                            (MDC104)                            YM4043
CVTPVBP  DC    A(0) -        ADDRESS OF THE VIRTUAL BLOCK PROCESSOR
*                            (MDC105)                            YM4043
CVTMFCTL DC    A(0) -        POINTER TO MEASUREMENT FACILITY CONTROL
*                            BLOCK                               MDC100
CVTMFRTR DC    A(CVTBRET) -  IF MEASUREMENT FACILITY IS ACTIVE,
*                            CONTAINS ADDRESS OF MEASUREMENT FACILITY
*                            ROUTINE.  OTHERWISE, ADDRESS OF CVTBRET.
*                                                                MDC101
CVTMFACT EQU   X'80' -       IF ONE, I/O SUPERVISOR AND TIMER SECOND
*                            LEVEL INTERRUPT HANDLER HOOKS BRANCH
*                            TO MEASUREMENT FACILITY ROUTER.  USED TO
*                            SET HIGH-ORDER BIT OF CVTMFRTR.     MDC102
CVTVPSIB DC    V(IEAVPSIB) - BRANCH ENTRY TO PAGE SERVICES       MDC108
CVTVSI   DC    V(IEAVAMSI) - BRANCH ENTRY TO VAM SERVICES        MDC109
CVTVFP   DC    V(IEAVFP1) -  BRANCH ENTRY TO FINDPAGE            MDC110
CVTRV262 DS    B -           RESERVED
CVTRV263 EQU   X'80',,C'X' - RESERVED
CVTRV264 EQU   X'40',,C'X' - RESERVED
CVTRV265 EQU   X'20',,C'X' - RESERVED
CVTRV266 EQU   X'10',,C'X' - RESERVED
CVTRV267 EQU   X'08',,C'X' - RESERVED
CVTRV268 EQU   X'04',,C'X' - RESERVED
CVTRV269 EQU   X'02',,C'X' - RESERVED
CVTRV270 EQU   X'01',,C'X' - RESERVED
CVTRV271 DS    B -           RESERVED
CVTRV272 EQU   X'80',,C'X' - RESERVED
CVTRV273 EQU   X'40',,C'X' - RESERVED
CVTRV274 EQU   X'20',,C'X' - RESERVED
CVTRV275 EQU   X'10',,C'X' - RESERVED
CVTRV276 EQU   X'08',,C'X' - RESERVED
CVTRV277 EQU   X'04',,C'X' - RESERVED
CVTRV278 EQU   X'02',,C'X' - RESERVED
CVTRV279 EQU   X'01',,C'X' - RESERVED
CVTRV280 DS    B -           RESERVED
CVTRV281 EQU   X'80',,C'X' - RESERVED
CVTRV282 EQU   X'40',,C'X' - RESERVED
CVTRV283 EQU   X'20',,C'X' - RESERVED
CVTRV284 EQU   X'10',,C'X' - RESERVED
CVTRV285 EQU   X'08',,C'X' - RESERVED
CVTRV286 EQU   X'04',,C'X' - RESERVED
CVTRV287 EQU   X'02',,C'X' - RESERVED
CVTRV288 EQU   X'01',,C'X' - RESERVED
CVTRV289 DS    B -           RESERVED
CVTRV290 EQU   X'80',,C'X' - RESERVED
CVTRV291 EQU   X'40',,C'X' - RESERVED
CVTRV292 EQU   X'20',,C'X' - RESERVED
CVTRV293 EQU   X'10',,C'X' - RESERVED
CVTRV294 EQU   X'08',,C'X' - RESERVED
CVTRV295 EQU   X'04',,C'X' - RESERVED
CVTRV296 EQU   X'02',,C'X' - RESERVED
CVTRV297 EQU   X'01',,C'X' - RESERVED
CVTTRCA  DC    A(0) -        ADDRESS OF TRACE TABLE HEADER
*                            (MDC327)                          @ZA02352
CVTRV302 DS    AL2 -         RESERVED
CVTRV303 DS    AL2 -         RESERVED
CVTRV304 DS    H -           RESERVED
CVTRV305 DS    H -           RESERVED
CVTRV306 DS    H -           RESERVED
CVTRV307 DS    H -           RESERVED
CVTVIOP  DC    V(IEAVPIOP) - ENTRY POINT OF PAGE I/O POST        MDC111
CVTRMBR  DC    V(RMBRANCH) - ADDRESS OF REGMAIN BRANCH ENTRY     MDC123
CVTLFRM  DC    V(FMBRANCH) - LIST FORMAT FREEMAIN BRANCH ENTRY POINT
*                                                                MDC124
CVTGMBR  DC    V(GMBRANCH) - LIST FORMAT GETMAIN BRANCH ENTRY POINT
*                                                                MDC125
CVT0TC0A DC    A(0) -        ADDRESS OF TASK CLOSE MODULE IFG0TC0A
*                                                                MDC128
CVTRLSTG DC    F'0' -        SIZE OF ACTUAL REAL STORAGE ONLINE AT
*                            IPL TIME IN 'K'.  VALUE PLACED HERE BY
*                            IEAVNIP0.                           MDC153
CVTSPFRR DC    V(IEAVESPR) - 'SUPER FRR' ADDRESS (ADDRESS OF FUNCTIONAL
*                            RECOVERY ROUTINE ESTABLISHED AT NIP0 TIME
*                            TO PROTECT SUPERVISOR CONTROL PROGRAM)
*                                                                MDC154
CVTVEMS0 DC    V(IEAVEMS0) - ADDRESS OF MEMORY SWITCH ROUTINE    MDC155
CVTJRECM DC    A(0) -        ADDRESS OF SUBSYSTEM INTERFACE RESOURCE
*                            MANAGER                             MDC157
CVTIRECM DC    A(0) -        ADDRESS OF INITIATOR RESOURCE MANAGER
*                                                                MDC158
CVTDARCM DC    A(0) -        ADDRESS OF DEVICE ALLOCATION RESOURCE
*                            MANAGER                             MDC159
CVT0PT02 DC    V(IEA0PT02) - ADDRESS OF POST ENTRY POINT IEA0PT02
*                                                                MDC160
CVTSTPRS DC    V(IEESTPRS) - ENTRY POINT OF STOP AND RESTART
*                            SUBROUTINE                          MDC162
CVTWTCB  DC    V(IEAWTCB) -  ADDRESS OF WAIT STATE TCB           MDC164
CVTVACR  DC    A(0) -        ACR/VARY CPU CHANNEL RECOVERY ROUTINE
*                            ADDRESS.  ADDRESS FILLED IN BY VARY CPU
*                            PROCESSOR.                          MDC178
CVTQUIT  DC    A(0) -        VARY CPU SHUTDOWN ROUTINE ADDRESS.
*                            ADDRESS FILLED IN BY VARY CPU PROCESSOR.
*                                                                MDC179
CVTGTFR8 DC    V(AHLVCCR8) - GENERALIZED TRACE FACILITY (GTF) CONTROL
*                            REGISTER 8 INITIALIZATION ROUTINE ADDRESS
*                                                                MDC180
CVTVSTOP DC    V(IEEVSTOP) - ADDRESS OF VARY CPU STOP CPU ROUTINE
*                                                                MDC169
CVTVPSA  DC    A(0) -        ADDRESS OF COPY OF SYSGEN'ED PSA - PLACED
*                            HERE BY NIP                         MDC170
CVTRMPTT DC    A(0) -        ADDRESS OF ISTRAMA1, THE VTAM RESOURCE
*                            MANAGER FOR NORMAL AND ABNORMAL TASK
*                            TERMINATION  (MDC322)             @Z30AP9A
CVTRMPMT DC    A(0) -        ADDRESS OF ISTRAMA2, THE VTAM RESOURCE
*                            MANAGER FOR NORMAL AND ABNORMAL MEMORY
*                            TERMINATION  (MDC323)             @Z30AP9A
CVTEXP1  DC    V(IEAVEXP1) - ADDRESS OF EXIT PROLOGUE WHICH RETURNS TO
*                            THE DISPATCHER                      MDC173
CVTCSDRL DC    A(0) -        REAL ADDRESS OF COMMON SYSTEM DATA AREA
*                            (CSD).  INITIALIZED BY NIP.         MDC174
CVTSSRB  DC    V(IGC07903) - STATUS STOP SRB ENTRY               MDC175
CVTRPT   DC    A(0) -        ADDRESS OF IGARPT01 MODULE OF RADIX
*                            PARTITION TREE SERVICES.  INITIALIZED
*                            BY NIP.                             MDC177
CVTQV1   DC    V(IEAVEQV1) - ADDRESS OF QUEUE VERIFICATION FOR SINGLE
*                            THREADED QUEUES WITH HEADERS ONLY   MDC181
CVTQV2   DC    V(IEAVEQV2) - ADDRESS OF QUEUE VERIFICATION FOR SINGLE
*                            THREADED QUEUES WITH HEADER AND TRAILER
*                                                                MDC182
CVTQV3   DC    V(IEAVEQV3) - ADDRESS OF QUEUE VERIFICATION FOR DOUBLE
*                            THREADED QUEUES                     MDC183
CVTGSDA  DC    F'0' -        ADDRESS OF GLOBAL SYSTEM DUPLEX AREA.
*                            ADDRESS FILLED IN BY NIP0.          MDC184
CVTGSDAB EQU   X'80' -       IF HIGH-ORDER BIT IS ONE, THERE IS A VALID
*                            VALUE IN FOLLOWING 31 BITS          MDC185
CVTADV   DC    V(IEAVEADV) - ADDRESS OF ADDRESS VERIFICATION ROUTINE
*                                                                MDC186
CVTTPIO  DC    V(IGC124) -   ADDRESS OF VTAM TPIO (SVC 124) ROUTINE
*                                                                MDC193
CVTCRCA  DC    A(0) -        WHEN CHANNEL RECONFIGURATION HARDWARE
*                            (CRH) IS ACTIVE, ADDRESS OF CRH
*                            COMMUNICATION AREA IECVCRCA.
*                            OTHERWISE, ZERO.  (MDC306)        @Z30CQ9A
CVTEVENT DC    V(IEAVEVT0) - BRANCH ENTRY ADDRESS TO EVENTS (FAST
*                            MULTIPLE WAIT ROUTINE)  (MDC316)  @Z30HP9A
CVTSSCR  DC    A(0) -        ADDRESS OF STORAGE SYSTEM CONTROLLER
*                            RECOVERY MANAGER CLEANUP ROUTINE
*                            (SSC RMCR)  (MDC319)              @Z30LP9A
CVTCBBR  DC    V(CBBRANCH) - BRANCH ENTRY ADDRESS TO GETMAIN/FREEMAIN
*                            (MDC325)                          @Z30EN9A
CVTEFF02 DC    A(0) -        ADDRESS OF IKJEFF02, TSO MESSAGE ISSUER
*                            SERVICE ROUTINE  (MDC326)         @ZM30972
CVTRV604 DC    A(0) -        RESERVED  (MDC307)                @Z30AQ9A
CVTRV605 DC    A(0) -        RESERVED  (MDC307)                @Z30AQ9A
CVTHSM   DC    A(0) -        POINTER TO HIERARCHICAL STORAGE MANAGER
*                            (HSM) QUEUE CONTROL TABLE
*                            (MDC375)                          @ZA27771
CVTRAC   DC    A(0) -        ADDRESS OF ACCESS CONTROL CVT
*                            (MDC320)                          @Z40RP9A
CVTCGK   DC    V(IEAVCKEY) - ADDRESS OF ROUTINE USED TO CHANGE THE KEY
*                            OF VIRTUAL PAGES  (MDC331)        @Z40EP9A
CVTRV609 DC    A(0) -        RESERVED  (MDC332)                @Z40AQ9A
CVT0PT0E DC    V(IEA0PT0E) - ENTRY POINT TO IDENTIFY POST EXIT ROUTINES
*                            (MDC334)                          @Z40EP9A
CVT0PT03 DC    V(IEA0PT03) - POST REINVOCATION ENTRY POINT FROM POST
*                            EXIT ROUTINES  (MDC335)           @Z40EP9A
CVTTCASP DC    A(0) -        RESERVED FOR FUTURE USE  (MDC336) @Z40DQ9A
CVTASMRM DC    V(ILRTERMR) - ADDRESS OF AUXILIARY STORAGE MANAGEMENT
*                            RESOURCE MANAGER FOR ADDRESS SPACE
*                            TERMINATION  (MDC341)             @Z40WP9A
CVTJTERM DC    V(ILRJTERM) - ADDRESS OF AUXILIARY STORAGE MANAGEMENT
*                            JOB TERMINATION RESOURCE MANAGER
*                            (MDC342)                          @Z40WP9A
CVTRSUME DC    V(IEAVRSME) - ADDRESS OF RESUME FUNCTION
*                            (MDC344)                          @Z40FP9A
CVTTCTL  DC    V(IEAVTCTL) - ADDRESS OF TRANSFER CONTROL (TCTL)
*                            FUNCTION  (MDC345)                @Z40FP9A
CVTCDAL  DC    A(0) -        ADDRESS OF COMMON DISPATCHER ACTIVE LIST
*                            (MDC346)                          @Z40FP9A
CVTT6SVC DC    V(IEAVET6E) - ENTRY POINT ADDRESS FOR TYPE 6 SVC EXIT
*                            FUNCTION  (MDC347)                @Z40FP9A
CVTSUSP  DC    V(IEAVSPND) - ADDRESS OF SUSPEND ROUTINE
*                            (MDC348)                          @Z40FP9A
CVTIHASU DC    V(IEAIHASU) - ADDRESS OF BIT STRING  (MDC355)   @Z404P9A
CVTVDCCR DC    V(IEEVDCCR) - ADDRESS OF DISABLED CONSOLE COMMUNICATION
*                            ROUTINE (IEEVDCCR)  (MDC384)      @G64UP9A
CVTCST   DC    A(0) -        ADDRESS OF CHANNEL SET TABLE (CST)
*                            (MDC377)                          @G64AP9A
CVTRV623 DC    A(0) -        RESERVED  (MDC307)                @Z30AQ9A
CVTRV624 DC    A(0) -        RESERVED  (MDC307)                @Z30AQ9A
CVTRV625 DC    A(0) -        RESERVED  (MDC307)                @Z30AQ9A
CVTRV626 DC    A(0) -        RESERVED  (MDC307)                @Z30AQ9A
CVTRV627 DC    A(0) -        RESERVED  (MDC307)                @Z30AQ9A
CVTRV628 DC    A(0) -        RESERVED  (MDC307)                @Z30AQ9A
*
*              OS - OS/VS COMMON EXTENSION
*              ADDRESS OF EXTENSION IS IN CVTEXT1
*
CVTXTNT1 EQU   * -           START OF OS - OS/VS EXTENSION       ICB421
CVTFACHN DC    A(0) -        ADDRESS OF CHAIN OF DCB FIELD AREAS
*                            (ISAM)                              ICB421
CVTRSV87 DS    F -           RESERVED
CVTRSV88 DS    F -           RESERVED
*
*              OS/VS1 - OS/VS2 COMMON EXTENSION
*              ADDRESS OF EXTENSION IS IN CVTEXT2
*
CVTXTNT2 EQU   * -           START OF OS/VS1 - OS/VS2 EXTENSION  ICB330
CVTDSSV  DS    0A -          ADDRESS OF THE DYNAMIC SUPPORT SYSTEM
*                            (DSS) VECTOR TABLE                  ICB313
CVTRSV89 DS    XL1 -         RESERVED                            ICB313
CVTDSSVA DC    VL3(IQADSV00) ADDRESS OF THE DYNAMIC SUPPORT SYSTEM
*                            (DSS) VECTOR TABLE                  ICB393
CVTNUCLS DS    C -           IDENTIFICATION OF THE NUCLEUS MEMBER
*                            NAME                                ICB322
CVTFLGBT DC    XL1'00' -     FLAG BYTE  (OS/VS1)  (MDC301)     @X04EP9A
CVTNPE   EQU   X'80' -       INDICATES NON-PAGING ENVIRONMENT (VM
*                            HANDSHAKING)  (OS/VS1)  (MDC302)  @X04EP9A
CVTVME   EQU   X'40' -       INDICATES MACHINE IS OPERATING IN VM
*                            ENVIRONMENT  (OS/VS1)  (MDC303)   @X04EP9A
CVTBAH   EQU   X'20' -       INDICATES THAT THE VM/370 - OS/VS1 BTAM
*                            AUTOPOLL HANDSHAKE IS OPERATIONAL
*                            (OS/VS1)  (MDC356)                @X60KL9A
CVTRSV9D EQU   X'10',,C'X' - RESERVED
CVTRSV9E EQU   X'08',,C'X' - RESERVED
CVTRSV9F EQU   X'04',,C'X' - RESERVED
CVTRSV9G EQU   X'02',,C'X' - RESERVED
CVTRSV9H EQU   X'01',,C'X' - RESERVED
CVTRSV91 DS    H -           RESERVED
CVTDEBVR DC    V(IFGDEBVR) - ADDRESS OF BRANCH ENTRY POINT OF DEB
*                            VALIDITY CHECK ROUTINE (ICB380)     XM9028
CVTRSV92 DC    A(0) -        RESERVED  (MDC190)                  YM2278
CVTRSV93 DS    F -           RESERVED
CVTRSV94 DS    F -           RESERVED
CVTQID   DS    0A -          SAME AS CVTQIDA BELOW               ICB381
CVTRSV95 DC    XL1'00' -     RESERVED                            ICB381
CVTQIDA  DC    AL3(0) -      ADDRESS OF QUEUE IDENTIFICATION (QID)
*                            TABLE PREFIX                        ICB381
CVTOLTEP DS    A -           POINTER TO CONTROL BLOCK CREATED BY SVC 59
*                            TO POINT TO PSEUDO-DEB'S            ICB423
CVTRSV96 DS    H -           RESERVED
CVTRSV97 DS    H -           RESERVED
CVTRSV98 DS    F -           RESERVED
CVTCCVT  DC    A(0) -        ADDRESS OF CRYPTOGRAPHIC FACILITY CVT
*                            (MDC370)                          @ZA27771
CVTSKTA  DC    A(0) -        ADDRESS OF STORAGE KEY TABLE (VM
*                            HANDSHAKING)  (OS/VS1)  (MDC304)  @X04EP9A
CVTICB   DC    A(0) -        ADDRESS OF MASS STORAGE SYSTEM (MSS)
*                            CONTROL BLOCK  (MDC305)           @Z30LP9A
CVTRV400 DS    B -           RESERVED
CVTRV401 EQU   X'80',,C'X' - RESERVED
CVTRV402 EQU   X'40',,C'X' - RESERVED
CVTRV403 EQU   X'20',,C'X' - RESERVED
CVTRV404 EQU   X'10',,C'X' - RESERVED
CVTRV405 EQU   X'08',,C'X' - RESERVED
CVTRV406 EQU   X'04',,C'X' - RESERVED
CVTRV407 EQU   X'02',,C'X' - RESERVED
CVTRV408 EQU   X'01',,C'X' - RESERVED
CVTRV409 DS    B -           RESERVED
CVTRV410 EQU   X'80',,C'X' - RESERVED
CVTRV411 EQU   X'40',,C'X' - RESERVED
CVTRV412 EQU   X'20',,C'X' - RESERVED
CVTRV413 EQU   X'10',,C'X' - RESERVED
CVTRV414 EQU   X'08',,C'X' - RESERVED
CVTRV415 EQU   X'04',,C'X' - RESERVED
CVTRV416 EQU   X'02',,C'X' - RESERVED
CVTRV417 EQU   X'01',,C'X' - RESERVED
CVTRV418 DS    XL1 -         RESERVED
CVTRV419 DS    XL1 -         RESERVED
CVTRV420 DS    AL2 -         RESERVED
CVTRV421 DS    H -           RESERVED
CVTRV422 DS    H -           RESERVED
CVTRV423 DS    H -           RESERVED
CVTATCVT DS    A -           POINTER TO VTAM'S CVT               MDC080
CVTATACT EQU   X'80'         IF ON, VTAM IS ACTIVE               MDC081
CVTRV425 DS    A -           RESERVED
CVTRV426 DS    A -           RESERVED
CVTRV427 DS    A -           RESERVED
CVTRV428 DS    F -           RESERVED
CVTRV429 DS    B -           RESERVED
CVTRV430 EQU   X'80',,C'X' - RESERVED
CVTRV431 EQU   X'40',,C'X' - RESERVED
CVTRV432 EQU   X'20',,C'X' - RESERVED
CVTRV433 EQU   X'10',,C'X' - RESERVED
CVTRV434 EQU   X'08',,C'X' - RESERVED
CVTRV435 EQU   X'04',,C'X' - RESERVED
CVTRV436 EQU   X'02',,C'X' - RESERVED
CVTRV437 EQU   X'01',,C'X' - RESERVED
CVTRV438 DS    B -           RESERVED
CVTRV439 EQU   X'80',,C'X' - RESERVED
CVTRV440 EQU   X'40',,C'X' - RESERVED
CVTRV441 EQU   X'20',,C'X' - RESERVED
CVTRV442 EQU   X'10',,C'X' - RESERVED
CVTRV443 EQU   X'08',,C'X' - RESERVED
CVTRV444 EQU   X'04',,C'X' - RESERVED
CVTRV445 EQU   X'02',,C'X' - RESERVED
CVTRV446 EQU   X'01',,C'X' - RESERVED
CVTRV447 DS    XL1 -         RESERVED
CVTRV448 DS    XL1 -         RESERVED
CVTRV449 DS    AL2 -         RESERVED
CVTRV450 DS    H -           RESERVED
CVTRV451 DS    H -           RESERVED
CVTRV452 DS    H -           RESERVED
CVTRV453 DS    A -           RESERVED
CVTRV454 DS    A -           RESERVED
CVTRV455 DS    A -           RESERVED
CVTRV456 DS    A -           RESERVED
CVTRV457 DS    B -           RESERVED
CVTRV458 EQU   X'80',,C'X' - RESERVED
CVTRV459 EQU   X'40',,C'X' - RESERVED
CVTRV460 EQU   X'20',,C'X' - RESERVED
CVTRV461 EQU   X'10',,C'X' - RESERVED
CVTRV462 EQU   X'08',,C'X' - RESERVED
CVTRV463 EQU   X'04',,C'X' - RESERVED
CVTRV464 EQU   X'02',,C'X' - RESERVED
CVTRV465 EQU   X'01',,C'X' - RESERVED
CVTRV466 DS    B -           RESERVED
CVTRV467 EQU   X'80',,C'X' - RESERVED
CVTRV468 EQU   X'40',,C'X' - RESERVED
CVTRV469 EQU   X'20',,C'X' - RESERVED
CVTRV470 EQU   X'10',,C'X' - RESERVED
CVTRV471 EQU   X'08',,C'X' - RESERVED
CVTRV472 EQU   X'04',,C'X' - RESERVED
CVTRV473 EQU   X'02',,C'X' - RESERVED
CVTRV474 EQU   X'01',,C'X' - RESERVED
CVTRV475 DS    XL1 -         RESERVED
CVTRV476 DS    XL1 -         RESERVED
CVTRV477 DS    XL1 -         RESERVED
CVTRV478 DS    XL1 -         RESERVED
CVTRV479 DS    H -           RESERVED
CVTRV480 DS    A -           RESERVED
CVTRV481 DS    A -           RESERVED
CVTRV482 DS    A -           RESERVED
*
*              END OF CVT
         POP   PRINT
*MEXIT #=     1 LV= 1 CVT
         END 
