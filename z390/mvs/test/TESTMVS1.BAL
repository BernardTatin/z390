         TITLE 'TESTMVS1 TEST COMMON MVS 3.8 MACROS'
**********************************************************************
* 06/30/09 RPI 1044 ADD MYPGM ENTRY
**********************************************************************
TESTMVS1 CSECT 
         USING *,15
         SR   15,15
         BR   14
* DATA REFERENCES
MYEXIT   DS   0H
MYECB    DS   F
DATA4    DS   F
DATA8    DS   D
DATA16   DS   2D
MYAREA   EQU  *
MYLIST   EQU  *
MYLIMIT  EQU  *
MYNAME   EQU  *
CBUFRSQN DC   CL8'CBUFRCTL'
CBUFRSRN DC   CL4'CBUF'
MYPGM    EQU  *
         ENTRY   MYPGM
*MCALL #=     1 LV= 1          ABEND   111,DUMP
         DS    0H
*MCALL #=     2 LV= 2          IHBINNRA 111             LOAD REG1 WITH X
               COMPCODE
         LA    1,111                              LOAD PARAMETER REG 1
*MEXIT #=     2 LV= 2 IHBINNRA
         LA    0,128(0,0)       PICK UP DUMP/STEP/DUMPOPTS     YM1995
         SLL   0,24(0)            SHIFT TO HIGH ORDER
         OR    1,0                OR IN WITH COMPCODE
         SVC   13                 LINK TO ABEND ROUTINE
*MEXIT #=     1 LV= 1 ABEND
*MCALL #=     3 LV= 1 MYACB    ACB     DDNAME=MYACB
*MCALL #=     4 LV= 2 MYACB    ACBVS DDNAME=MYACB,EXLST=0,MACRF=,JFCB=0X
               ,BUFND=0,BUFNI=0,PASSWD=0,BLKSIZE=0,LRECL=0,BUFSP=0,CCTYX
               PE=,STRNO=1,CATALOG=NO,BSTRNO=0,MAREA=0,MLEN=0,CRA=,AM=,X
               APPLID=0,USERPTR=0,PARMS=,PARM2=,PARM3=
*MCALL #=     5 LV= 3          IDAVSACB MACRF=,CATALOG=NO,CRA=,AM=,CALLX
               ER=ACB        SET VALUES FOR BIT     @ZA34940
*MCALL #=     6 LV= 4          IDAVSCB3 ARG=,ARGNAME=BUFND,KWTC=X'04',MX
               F=   @ZA34940
*MEXIT #=     6 LV= 4 IDAVSCB3
*MCALL #=     7 LV= 4          IDAVSCB3 ARG=,ARGNAME=BUFNI,KWTC=X'05',MX
               F=   @ZA34940
*MEXIT #=     7 LV= 4 IDAVSCB3
*MCALL #=     8 LV= 4          IDAVSCB3 ARG=,ARGNAME=BUFSP,KWTC=X'07',MX
               F=   @ZA34940
*MEXIT #=     8 LV= 4 IDAVSCB3
*MCALL #=     9 LV= 4          IDAVSCB3 ARG=,ARGNAME=EXLST,KWTC=X'0C',MX
               F=   @ZA34940
*MEXIT #=     9 LV= 4 IDAVSCB3
*MCALL #=    10 LV= 4          IDAVSCB3 ARG=,ARGNAME=JFCB,KWTC=X'8D',MFX
               =     @ZA34940
*MEXIT #=    10 LV= 4 IDAVSCB3
*MCALL #=    11 LV= 4          IDAVSCB3 ARG=NO,ARGNAME=CATALOG,KWTC=X'2X
               2',MF=,INDRECT=YES,BIT=YES                      @ZA34940
*MEXIT #=    11 LV= 4 IDAVSCB3
*MEXIT #=     5 LV= 3 IDAVSACB
MYACB    DS    0F
         DC    X'A0' .                  ACB IDENTIFICATION
         DC    AL1(0)              ACB SUBTYPE             X04SVHS
         DC    AL2(76+0) .      ACB LENGTH             X03004HS
         DC    A(0) .                   AMB LIST POINTER
         DC    A(0) .                   INTERFACE ROUTINE POINTER
         DC    B'10010100'              MACRF(1)                X04SVHS
         DC    B'00000000'              MACRF(2)                X04SVHS
         DC    AL1(0) .           NO OF CONCURRENT        X04SVHS
*                                       STRINGS FOR AIX PATH    X04SVHS
         DC    AL1(1) .            NUMBER OF STRINGS       X04SVHS
         DC    AL2(0) .            NUMBER OF DATA BUFFERS
         DC    AL2(0) .            NUMBER OF INDEX BUFFERS
         DC    B'00000000'              MACRF(3)                X04SVHS
         DC    B'00000000' .            MACRF(4)                X04SVHS
         DC    AL2(0) .                 JES BUFFER POOL/NUMBER  X04SVHS
*                                       OF JOURNAL BUFFERS
         DC    X'80' .                  RECFM=A
         DC    B'00000000' .         CONTROL CHARACTER TYPE
         DC    X'0008' .                DSORG=ACB
         DC    A(0)                                             X04SVHS
         DC    A(0) .             PASSWORD POINTER
         DC    A(0) .              EXIT LIST POINTER
         DC    CL8'MYACB' .           DDNAME
         DC    X'02' .                  OFLAGS
         DC    AL1(0) .                 ERFLAGS
         DC    B'00000000'              INFLGS(1)               X04SVHS
         DC    B'00000000'              INFLGS(2)               X04SVHS
         DC    A(0) .               OPENJ JFCB POINTER
         DC    A(0)                BUFFER SPACE
         DC    AL2(0) .          BLOCK SIZE
         DC    AL2(0) .            RECORD SIZE
         DC    A(0) .                   USER WORKAREA POINTER
         DC    A(0)                     CONTROL BLOCK MANIPULATION
*                                       WORKAREA POINTER
         DC    A(0) .                   PTR TO APPLICATION NAME  X03004
*MEXIT #=     4 LV= 2 ACBVS
*MEXIT #=     3 LV= 1 ACB
*MCALL #=    12 LV= 1          ATTACH  EPLOC=(3),ECB=(2),SZERO=YES,JSTCX
               B=NO
* /* MACDATE Y-1 72271                                               */
* /*
         LA    15,IHB0012                         LOAD 15 WITH LIST ADDX
               R
         ST    3,0(0,15)                 STORE EPLOC INTO LIST
         STCM  2,7,9(15)         STORE ECB INTO LIST
         B     60(,15)            BRANCH AROUND LIST             Y02752
IHB0012  DS    0F                                SUP. PARAM. LIST
         DC    A(0)                              DE OR EPLOC ADDRESS
         DC    AL1(0)
         DC    AL3(0)                  DCB ADDRESS                 LCS1
         DC    AL1(8)        FLAGS                          Y02752
         DC    AL3(0)             ECB ADDRESS                    Y02752
         DC    A(0)                              GSPV VALUE OR GSPL ADR
         DC    A(0)                              SHSPL OR SHSPV
         DC    AL1(32)        FLAGS                          Y02752
         DC    AL3(0)                        ETXR ROUT. ADDRESS    RORI
         DC    AL2(0)                            DPMOD VALUE
         DC    AL1(0)                            LPMOD VALUE
         DC    AL1(0)
         DC    CL8' '                                              I270
         DC    AL1(0)              LSQA=0
         DC    AL3(0)              ADDRESS OF JSCB
         DC    AL1(0)              TID=0
         DC    AL3(0)             NO STAI/ESTAI PARM LIST ADDR   Y02752
         DC    A(0)                .NO EXIT ADDR
         DC    A(0)          .TASKLIB DCB ADDRESS.                20021
         DC    X'00'                       NO FLAGS ON         @Z40RP9B
         DC    AL3(60)            LENGTH OF THIS PARM LIST     @Z40RP9B
         DC    A(0)               NSHSPV VALUE OR NSHSPL ADDR    Y02752
         SVC   42                                ISSUE ATTACH SVC
*MEXIT #=    12 LV= 1 ATTACH
*MCALL #=    13 LV= 1          BLDL    MYDCB,MYLIST
*MCALL #=    14 LV= 2          IHBINNRA MYDCB,MYLIST              LOAD X
               REG 1 AND REG 0
         LA    1,MYDCB                              LOAD PARAMETER REG X
               1
         LA    0,MYLIST                              LOAD PARAMETER REGX
                0
*MEXIT #=    14 LV= 2 IHBINNRA
         LA    1,0(1)                     CLEAR HIGH ORDER BYTE ZA00734
         SVC   18                                LINK TO BLDL ROUTINE
*MEXIT #=    13 LV= 1 BLDL
*MCALL #=    15 LV= 1          BUILD   MYAREA,10,4096
*MCALL #=    16 LV= 2          IHBINNRA MYAREA
         LA    1,MYAREA                              LOAD PARAMETER REGX
                1
*MEXIT #=    16 LV= 2 IHBINNRA
         B     *+8                               BRANCH AROUND VALUES
         DC    AL2(10)                          NUMBER OF BUFFERS
         DC    AL2(4096)                         LENGTH OF BUFFERS
         MVC   0(4,1),*-4                        MOVE INTO LIST
*MCALL #=    17 LV= 2          LINK  EP=IECBBFB1
*MCALL #=    18 LV= 3          IHBINNRB IECBBFB1,,,,ERRET=,SF=I
         CNOP  0,4
         BAL   15,*+20          BRANCH AROUND CONSTANTS
         DC    A(*+8)         ADDR. OF PARM. LIST
         DC    A(0)                DCB ADDRESS PARAMETER
         DC    CL8'IECBBFB1'            EP PARAMETER
*MEXIT #=    18 LV= 3 IHBINNRB
         SVC   6                   ISSUE LINK SVC
*MEXIT #=    17 LV= 2 LINK
*MEXIT #=    15 LV= 1 BUILD
*MCALL #=    19 LV= 1          CALL    MYPGM,(MYLIST),VL
         CNOP  0,4
         B     *+8                               BRANCH AROUND VCON
IHB0019B DC    V(MYPGM)                         ENTRY POINT ADDRESS
*MCALL #=    20 LV= 2          IHBOPLST MYPGM,(MYLIST),,MF=I
         CNOP  0,4
         BAL   1,IHB0020A                        LOAD LIST ADDR IN REG1
IHB0020  EQU   *
         DC    B'10000000'                SET VL SWITCH BIT
         DC    AL3(MYLIST)                PROB. PROG. PARAMETER
IHB0020A EQU   *
*MEXIT #=    20 LV= 2 IHBOPLST
         L     15,IHB0019B                       LOAD 15 WITH ENTRY ADR
         BALR  14,15                             BRANCH TO ENTRY POINT
*MEXIT #=    19 LV= 1 CALL
*MCALL #=    21 LV= 1          CHECK   MYDCB
*MCALL #=    22 LV= 2          IHBINNRA MYDCB
         LA    1,MYDCB                              LOAD PARAMETER REG X
               1
*MEXIT #=    22 LV= 2 IHBINNRA
         L     14,8(0,1)                PICK UP DCB ADDR
         L     15,52(0,14)              LOAD CHECK ROUTINE ADDR
         BALR  14,15                    LINK TO CHECK ROUTINE
*MEXIT #=    21 LV= 1 CHECK
*MCALL #=    23 LV= 1          CLOSE   (MYDCB)
         CNOP  0,4                               ALIGN LIST TO FULLWORD
         BAL   1,*+8                         LOAD REG1 W/LIST ADDR
         DC    AL1(128)                        OPTION BYTE
         DC    AL3(MYDCB)                  DCB ADDRESS
         SVC   20                                ISSUE CLOSE SVC
*MEXIT #=    23 LV= 1 CLOSE
*MCALL #=    24 LV= 1          CVT     DSECT=YES
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
CVT      DSECT , -
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
CVTXTNT1 DSECT 
CVTFACHN DC    A(0) -        ADDRESS OF CHAIN OF DCB FIELD AREAS
*                            (ISAM)                              ICB421
CVTRSV87 DS    F -           RESERVED
CVTRSV88 DS    F -           RESERVED
*
*              OS/VS1 - OS/VS2 COMMON EXTENSION
*              ADDRESS OF EXTENSION IS IN CVTEXT2
*
CVTXTNT2 DSECT 
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
*MEXIT #=    24 LV= 1 CVT
TESTMVS1 CSECT 
*MCALL #=    25 LV= 1 MYDCB    DCB     DSORG=PO,MACRF=R,DDNAME=MYDCB
*MCALL #=    26 LV= 2          IHB01 PO,R,,,1,,0,1,0,1,0,0,0,0,0,0,NO,,X
               0,,N
*MEXIT #=    26 LV= 2 IHB01
         SPACE 2
*                       DATA CONTROL BLOCK
*
MYDCB    DC    0F'0'                   ORIGIN ON WORD BOUNDARY
         SPACE 1
*                       DIRECT ACCESS DEVICE INTERFACE
         SPACE 1
         DC    BL16'0'                FDAD,DVTBL
         DC    A(0)                     KEYLE,DEVT,TRBAL
         SPACE 1
*                       COMMON ACCESS METHOD INTERFACE
         SPACE 1
         DC    AL1(0)             BUFNO
         DC    AL3(1)             BUFCB
         DC    AL2(0)         BUFL
         DC    BL2'0000001000000000'  DSORG
         DC    A(1)                IOBAD
         SPACE 1
*                       FOUNDATION EXTENSION
         SPACE 1
         DC    BL1'00000000'  BFTEK,BFLN,HIARCHY
         DC    AL3(1)             EODAD
         DC    BL1'00000000'                   RECFM
         DC    AL3(0)             EXLST
         SPACE 1
*                       FOUNDATION BLOCK
         SPACE 1
         DC    CL8'MYDCB'            DDNAME
         DC    BL1'00000010'           OFLGS
         DC    BL1'00000000'  IFLG
         DC    BL2'0010010000000000'                   MACR
         SPACE 1
*                       BSAM-BPAM-QSAM INTERFACE
         SPACE 1
         DC    BL1'00000000'                                           X
                   RER1
         DC    AL3(1)                  CHECK, GERR, PERR
         DC    A(1)               SYNAD
         DC    H'0'                    CIND1, CIND2
         DC    AL2(0)           BLKSIZE
         DC    F'0'                    WCPO, WCPL, OFFSR, OFFSW
         DC    A(1)                    IOBA
         DC    AL1(0)               NCP
         DC    AL3(1)                  EOBR, EOBAD
         SPACE 1
*                         BSAM-BPAM INTERFACE
         SPACE 1
         DC    A(1)                    EOBW
         DC    H'0'                    DIRCT
         DC    AL2(0)    LRECL
         DC    A(1)                    CNTRL, NOTE, POINT
*MEXIT #=    25 LV= 1 DCB
*MCALL #=    27 LV= 1          DCBD 
*MCALL #=    28 LV= 2          IHBERMAC 173
         MNOTE *,'***  IHB068  NO VALID DSORG SPECIFIED-EXCP ASSUMED'
*MEXIT #=    28 LV= 2 IHBERMAC
         SPACE 2                                                YA03395
*                       DCB SYMBOLIC DEFINITION FOR
*                       EXCP WITH EXTENSION
         SPACE 2                                               @ZA05613
IHADCB   DSECT , -            DCBPTR                           @ZA05613
         SPACE 2                                               @ZA05613
***********************************************************************
*  OS/VS2 RELEASE 02, 02/14/73                                        *
*  OS/VS2 RELEASE 03, 10/23/74                                        *
*  OS/VS2 RELEASE 3.7, 3/15/78                                        *
*C80400037                                                     @ZA33630
*                                                                     *
*  OS/VS2 RELEASE 3.8, 5/15/80    FMID=FDM1133                        *
*                                                                     *
*C(116500),A(116638-116914),D(117000),A(117052-117466)         @ZA46311
*D(117500),A(117604-117880),D(118000),A(118018-118432)         @ZA46311
*D(118500-118510),A(118570-118846)                             @ZA46311
*$F01=UZ59799,FDM1133:DCBDEVT DEFINITION FOR D/T3375 AND D/T3380  @F01A
*                                                                     *
***********************************************************************
         SPACE 1                                               @ZA05613
DCBBIT0  EQU   128                                             @ZA05613
DCBBIT1  EQU   64                                              @ZA05613
DCBBIT2  EQU   32                                              @ZA05613
DCBBIT3  EQU   16                                              @ZA05613
DCBBIT4  EQU   8                                               @ZA05613
DCBBIT5  EQU   4                                               @ZA05613
DCBBIT6  EQU   2                                               @ZA05613
DCBBIT7  EQU   1                                               @ZA05613
         SPACE 1                                               @ZA05613
***********************************************************************
         SPACE 2
***********************************************************************
*                       ACCESS METHOD COMMON INTERFACE
***********************************************************************
         SPACE 1
         ORG   IHADCB+16
DCBRELB  DS    0F -           SAME AS DCBREL BELOW
DCBKEYLE DS    FL1 -          KEY LENGTH OF DATA SET
DCBDEVT  DS    0C -           DEVICE TYPE
DCBDVTRM EQU   X'4F' -        TERMINAL.  (DD CONTAINS TERM=TS)
DCBREL   DS    FL3 -          NUMBER OF RELATIVE TRACKS OR BLOCKS IN
*                             THIS DATA SET (BDAM)
DCBBUFCB DS    0A -           ADDRESS OF BUFFER POOL CONTROL BLOCK
DCBBUFNO DS    FL1 -          NUMBER OF BUFFERS REQUIRED FOR THIS DATA
*                             SET.  MAY RANGE FROM 0 TO 255.  IF
*                             UNBLOCKED SPANNED RECORDS ARE USED,
*                             NUMBER OF SEGMENT WORK AREAS REQUIRED
*                             FOR THIS DATA SET.
DCBBUFCA DS    AL3 -          ADDRESS OF BUFFER POOL CONTROL BLOCK
DCBBUFL  DS    H -            LENGTH OF BUFFER.  MAY RANGE FROM 0 TO
*                             32,767.
DCBDSORG DS    0BL2 -         DATA SET ORGANIZATION BEING USED
DCBDSRG1 DS    BL1 -          FIRST BYTE OF DCBDSORG
DCBDSGIS EQU   DCBBIT0 -      IS - INDEXED SEQUENTIAL ORGANIZATION
DCBDSGPS EQU   DCBBIT1 -      PS - PHYSICAL SEQUENTIAL ORGANIZATION
DCBDSGDA EQU   DCBBIT2 -      DA - DIRECT ORGANIZATION
DCBDSGCX EQU   DCBBIT3 -      CX - BTAM OR QTAM LINE GROUP
DCBDSGPO EQU   DCBBIT6 -      PO - PARTITIONED ORGANIZATION
DCBDSGU  EQU   DCBBIT7 -      U  - UNMOVABLE, THE DATA CONTAINS
*                                  LOCATION DEPENDENT INFORMATION
DCBDSRG2 DS    BL1 -          SECOND BYTE OF DCBDSORG
DCBDSGGS EQU   DCBBIT0 -      GS - GRAPHICS ORGANIZATION
DCBDSGTX EQU   DCBBIT1 -      TX - TCAM LINE GROUP
DCBDSGTQ EQU   DCBBIT2 -      TQ - TCAM MESSAGE QUEUE
DCBACBM  EQU   DCBBIT4 -      ACCESS METHOD CONTROL BLOCK
DCBDSGTR EQU   DCBBIT5 -      TR - TCAM 3705
DCBIOBAD DS    0A -           ADDRESS OF IOB WHEN CHAINED SCHEDULING IS
*                             USED OR FOR 1419/1275
DCBODEB  DS    0A -           ADDRESS OF OLD DEB
DCBLNP   DS    0FL1 -         3525 PRINTER LINE POSITION COUNTER
DCBQSLM  DS    BL1 -          QSAM LOCATE MODE LOGICAL RECORD INTERFACE
*                             INDICATOR BYTE FOR UPDAT PROCESSING OF
*                             SPANNED RECORDS
DCB1DVDS EQU   DCBBIT0 -      ONLY ONE DEVICE IS ALLOCATED TO THIS
*                             DATA SET
DCBUPDCM EQU   DCBBIT1 -      UPDATE COMPLETE, FREE OLD DEB
DCBUPDBT EQU   DCBBIT2+DCBBIT3 - UPDATE BITS
DCBUPDT  EQU   DCBBIT2 -      UPDATE TO TAKE PLACE
DCBNUPD  EQU   DCBBIT2+DCBBIT3 - NO UPDATE TO TAKE PLACE
DCBSVDEB EQU   DCBBIT3 -      OLD DEB ADDRESS MUST BE SAVED
DCBIOBAA DS    0AL3 -         SAME AS DCBIOBAD ABOVE
DCBODEBA DS    AL3 -          ADDRESS OF OLD DEB
         ORG   IHADCB+28
DCBSVCXL DS    0A -           SAME AS DCBSVCXA BELOW
         DS    X -            RESERVED
DCBSVCXA DS    AL3 -          POINTER TO EXIT LIST OF JES
*                             C.I. INTERFACE CONTROL SVC
         SPACE 1
***********************************************************************
*                       FOUNDATION EXTENSION
***********************************************************************
         SPACE 1
DCBEODAD DS    0A -           SAME AS DCBEODA BELOW
DCBHIARC DS    0BL1 -         HIERARCHY BITS
DCBBFTEK DS    0BL1 -         BUFFERING TECHNIQUE BITS
DCBBFALN DS    BL1 -          BUFFER ALIGNMENT BITS
DCBH1    EQU   DCBBIT0 -      HIERARCHY 1 MAIN STORAGE - BIT 5 IS ZERO
DCBBFT   EQU   DCBBIT1+DCBBIT2+DCBBIT3 BUFFERING TECHNIQUE
DCBBFTA  EQU   DCBBIT1+DCBBIT2 - QSAM LOCATE MODE PROCESSING OF SPANNED
*                             RECORDS - OPEN IS TO CONSTRUCT A RECORD
*                             AREA IF IT AUTOMATICALLY CONSTRUCTS
*                             BUFFERS
DCBBFTR  EQU   DCBBIT2 -      FOR BSAM CREATE BDAM PROCESSING OF
*                             UNBLOCKED SPANNED RECORDS - SOFTWARE
*                             TRACK OVERFLOW.  FOR BSAM INPUT
*                             PROCESSING OF UNBLOCKED SPANNED RECORDS
*                             WITH KEYS - RECORD OFFSET PROCESSING.
DCBBFTS  EQU   DCBBIT1 -      SIMPLE BUFFERING - BIT 3 IS ZERO
DCBBFTKR EQU   DCBBIT2 -      UNBLOCKED SPANNED RECORDS - SOFTWARE
*                             TRACK OVERFLOW (BDAM)
DCBBFTE  EQU   DCBBIT3 -      EXCHANGE BUFFERING - BIT 1 IS ZERO
DCBBFTKD EQU   DCBBIT4 -      DYNAMIC BUFFERING (BTAM)
DCBH0    EQU   DCBBIT5 -      HIERARCHY 0 MAIN STORAGE - BIT 0 IS ZERO
DCBBFA   EQU   DCBBIT6+DCBBIT7 - BUFFER ALIGNMENT
DCBBFAD  EQU   DCBBIT6 -      DOUBLEWORD BOUNDARY
DCBBFAF1 EQU   DCBBIT7 -      FULLWORD NOT A DOUBLEWORD BOUNDARY,
*                             CODED IN DCB MACRO INSTRUCTION
DCBBFAF2 EQU   DCBBIT6+DCBBIT7 - FULLWORD NOT A DOUBLEWORD BOUNDARY,
*                             CODED IN DCB MACRO INSTRUCTION
DCBEODA  DS    AL3 -          ADDRESS OF A USER-PROVIDED ROUTINE TO
*                             HANDLE END-OF-DATA CONDITIONS
DCBEXLST DS    0A -           ADDRESS OF USER-PROVIDED LIST OF EXITS
DCBRECFM DS    BL1 -          RECORD FORMAT
DCBRECLA EQU   DCBBIT0+DCBBIT1+DCBBIT2 RECORD LENGTH INDICATOR - ASCII
DCBRECD  EQU   DCBBIT2 -      ASCII VARIABLE RECORD LENGTH
DCBRECL  EQU   DCBBIT0+DCBBIT1 - RECORD LENGTH INDICATOR
DCBRECF  EQU   DCBBIT0 -      FIXED RECORD LENGTH
DCBRECV  EQU   DCBBIT1 -      VARIABLE RECORD LENGTH
DCBRECU  EQU   DCBBIT0+DCBBIT1 - UNDEFINED RECORD LENGTH
DCBRECTO EQU   DCBBIT2 -      TRACK OVERFLOW
DCBRECBR EQU   DCBBIT3 -      BLOCKED RECORDS
DCBRECSB EQU   DCBBIT4 -      FOR FIXED LENGTH RECORD FORMAT - STANDARD
*                             BLOCKS.  FOR VARIABLE LENGTH RECORD
*                             FORMAT - SPANNED RECORDS
DCBRECCC EQU   DCBBIT5+DCBBIT6 - CONTROL CHARACTER INDICATOR
DCBRECCA EQU   DCBBIT5 -      ASA CONTROL CHARACTER
DCBRECCM EQU   DCBBIT6 -      MACHINE CONTROL CHARACTER
DCBRECC  EQU   X'00' -        NO CONTROL CHARACTER
DCBRECKL EQU   DCBBIT7 -      KEY LENGTH (KEYLEN) WAS SPECIFIED IN DCB
*                             MACRO INSTRUCTION
DCBEXLSA DS    AL3 -          ADDRESS OF USER-PROVIDED LIST OF EXITS
         SPACE 1
         SPACE 1
***********************************************************************
*                       FOUNDATION BEFORE OPEN
***********************************************************************
         SPACE 1
         ORG   IHADCB+40
DCBDDNAM DS    CL8 -          NAME ON THE DD STATEMENT WHICH DEFINES
*                             THE DATA SET ASSOCIATED WITH THIS DCB
DCBOFLGS DS    BL1 -          FLAGS USED BY OPEN ROUTINE
DCBOFLWR EQU   DCBBIT0 -      IF ZERO, LAST I/O OPERATION WAS READ OR
*                             POINT.  IF ONE, LAST I/O OPERATION WAS
*                             WRITE.
DCBOFIOD EQU   DCBBIT0 -      DATA SET IS BEING OPENED FOR INPUT OR
*                             OUTPUT (BDAM)
DCBOFLRB EQU   DCBBIT1 -      LAST I/O OPERATION WAS IN READ BACKWARD
*                             MODE
DCBOFEOV EQU   DCBBIT2 -      SET TO 1 BY EOV WHEN IT CALLS CLOSE
*                             ROUTINE FOR CONCATENATION OF DATA SETS
*                             WITH UNLIKE ATTRIBUTES
DCBOFOPN EQU   DCBBIT3 -      AN OPEN HAS BEEN SUCCESSFULLY COMPLETED
DCBOFPPC EQU   DCBBIT4 -      SET TO 1 BY PROBLEM PROGRAM TO INDICATE A
*                             CONCATENATION OF UNLIKE ATTRIBUTES
DCBOFTM  EQU   DCBBIT5 -      TAPE MARK HAS BEEN READ
DCBOFUEX EQU   DCBBIT6 -      SET TO 0 BY AN I/O SUPPORT FUNCTION WHEN
*                             THAT FUNCTION TAKES A USER EXIT. SET TO 1
*                             ON RETURN FROM USER EXIT TO THE I/O
*                             SUPPORT FUNCTION WHICH TOOK THE EXIT.
DCBOFIOF EQU   DCBBIT7 -      SET TO 1 BY AN I/O SUPPORT FUNCTION IF
*                             DCB IS TO BE PROCESSED BY THAT FUNCTION
DCBIFLG  DS    BL1 -          FLAGS USED BY IOS IN COMMUNICATING ERROR
*                             CONDITIONS AND IN DETERMINING CORRECTIVE
*                             PROCEDURES
DCBIBEC  EQU   DCBBIT0+DCBBIT1 - ERROR CORRECTION INDICATOR
DCBIFNEP EQU   X'00' -        NOT IN ERROR PROCEDURE
DCBEX    EQU   DCBBIT1 -      ERROR CORRECTION OR IOS PAGE FIX IN
*                             PROCESS
DCBIFPEC EQU   DCBBIT0+DCBBIT1 - PERMANENT ERROR CORRECTION
DCBIBPCT EQU   DCBBIT2+DCBBIT3 - PRINTER CARRIAGE TAPE PUNCH INDICATOR
DCBIFC9  EQU   DCBBIT2 -      CHANNEL 9 PRINTER CARRIAGE TAPE PUNCH
*                             SENSED
DCBIFC12 EQU   DCBBIT3 -      CHANNEL 12 PRINTER CARRIAGE TAPE PUNCH
*                             SENSED
DCBIBIOE EQU   DCBBIT4+DCBBIT5 - IOS ERROR ROUTINE USE INDICATOR
DCBIFER  EQU   X'00' -        ALWAYS USE I/O SUPERVISOR ERROR ROUTINE
DCBIFNE1 EQU   DCBBIT5 -      NEVER USE I/O SUPERVISOR ERROR ROUTINE
DCBIFTIM EQU   DCBBIT5 -      TEST IOS MASK (IMSK) FOR ERROR PROCEDURE
*                             (BTAM)
DCBIFNE2 EQU   DCBBIT4 -      NEVER USE I/O SUPERVISOR ERROR ROUTINE
DCBIFNE3 EQU   DCBBIT4+DCBBIT5 - NEVER USE I/O SUPERVISOR ERROR ROUTINE
DCBMACR  DS    0BL2 -         MACRO INSTRUCTION REFERENCE
DCBMACR1 DS    BL1 -          FIRST BYTE OF DCBMACR
DCBMRECP EQU   DCBBIT0 -      EXECUTE CHANNEL PROGRAM (EXCP) ---
*                             ALWAYS ZERO (BSAM, QSAM, BPAM, BISAM,
*                             QISAM, BDAM) --- RESERVED (QTAM, BTAM)
DCBMRFE  EQU   DCBBIT1 -      FOUNDATION EXTENSION IS PRESENT (EXCP)
DCBMRGET EQU   DCBBIT1 -      GET (QSAM, QISAM, TCAM)
DCBMRPTQ EQU   DCBBIT1 -      PUT FOR MESSAGE GROUP (QTAM) ---
*                             ALWAYS ZERO (BSAM, BPAM, BISAM, BDAM) ---
*                             RESERVED (BTAM)
DCBMRAPG EQU   DCBBIT2 -      APPENDAGES ARE REQUIRED (EXCP)
DCBMRRD  EQU   DCBBIT2 -      READ (BSAM, BPAM, BISAM, BDAM, BTAM)
DCBMRWRQ EQU   DCBBIT2 -      WRITE FOR LINE GROUP (QTAM) ---
*                             ALWAYS ZERO (QSAM, QISAM)
DCBMRCI  EQU   DCBBIT3 -      COMMON INTERFACE (EXCP)
DCBMRMVG EQU   DCBBIT3 -      MOVE MODE OF GET (QSAM, QISAM)
DCBMRRDK EQU   DCBBIT3 -      KEY SEGMENT WITH READ (BDAM) ---
*                             ALWAYS ZERO (BISAM) ---
*                             RESERVED (BSAM, BPAM, QTAM, BTAM)
DCBMRLCG EQU   DCBBIT4 -      LOCATE MODE OF GET (QSAM, QISAM)
DCBMRRDI EQU   DCBBIT4 -      ID ARGUMENT WITH READ (BDAM) ---
*                             ALWAYS ZERO (BISAM) ---
*                             RESERVED (EXCP, BSAM, BPAM, QTAM, BTAM)
DCBMRABC EQU   DCBBIT5 -      USER'S PROGRAM MAINTAINS ACCURATE BLOCK
*                             COUNT (EXCP)
DCBMRPT1 EQU   DCBBIT5 -      POINT (WHICH IMPLIES NOTE) (BSAM, BPAM)
DCBMRSBG EQU   DCBBIT5 -      SUBSTITUTE MODE OF GET (QSAM)
DCBMRDBF EQU   DCBBIT5 -      DYNAMIC BUFFERING (BISAM, BDAM) ---
*                             ALWAYS ZERO (QISAM) ---
*                             RESERVED (QTAM, BTAM)
DCBPGFXA EQU   DCBBIT6 -      PAGE FIX APPENDAGE IS SPECIFIED (EXCP)
DCBMRCRL EQU   DCBBIT6 -      CNTRL (BSAM, QSAM)
DCBMRCHK EQU   DCBBIT6 -      CHECK (BISAM)
DCBMRRDX EQU   DCBBIT6 -      READ EXCLUSIVE (BDAM) ---
*                             RESERVED (BPAM, QISAM, QTAM, BTAM)
DCBMRDMG EQU   DCBBIT7 -      DATA MODE OF GET (QSAM)
DCBMRCK  EQU   DCBBIT7 -      CHECK (BDAM) --- RESERVED (EXCP, BSAM,
*                             BPAM, BISAM, QISAM, QTAM, BTAM)
DCBMACR2 DS    BL1 -          SECOND BYTE OF DCBMACR
DCBMRSTL EQU   DCBBIT0 -      SETL (QISAM) --- ALWAYS ZERO (BSAM, QSAM,
*                             BPAM, BISAM, BDAM) ---
*                             RESERVED (EXCP, QTAM, BTAM)
DCBMRPUT EQU   DCBBIT1 -      PUT (QSAM, TCAM) - PUT OR PUTX (QISAM)
DCBMRGTQ EQU   DCBBIT1 -      GET FOR MESSAGE GROUP (QTAM) ---
*                             ALWAYS ZERO (BSAM, BPAM, BISAM, BDAM) ---
*                             RESERVED (EXCP, BTAM)
DCBMRWRT EQU   DCBBIT2 -      WRITE (BSAM, BPAM, BISAM, BDAM, BTAM)
DCBMRRDQ EQU   DCBBIT2 -      READ FOR LINE GROUP (QTAM) ---
*                             ALWAYS ZERO (QSAM, QISAM) ---
*                             RESERVED (EXCP)
DCBMRMVP EQU   DCBBIT3 -      MOVE MODE OF PUT (QSAM, QISAM)
DCBMRWRK EQU   DCBBIT3 -      KEY SEGMENT WITH WRITE (BDAM) ---
*                             ALWAYS ZERO (BISAM) ---
*                             RESERVED (EXCP, BSAM, BPAM, QTAM, BTAM)
DCBMR5WD EQU   DCBBIT4 -      FIVE-WORD DEVICE INTERFACE (EXCP)
DCBMRLDM EQU   DCBBIT4 -      LOAD MODE BSAM (CREATE BDAM DATA SET)
*                             (BSAM)
DCBMRLCP EQU   DCBBIT4 -      LOCATE MODE OF PUT (QSAM, QISAM)
DCBMRIDW EQU   DCBBIT4 -      ID ARGUMENT WITH WRITE (BDAM) ---
*                             ALWAYS ZERO (BISAM) ---
*                             RESERVED (BPAM, QTAM, BTAM)
DCBMR4WD EQU   DCBBIT5 -      FOUR-WORD DEVICE INTERFACE (EXCP)
DCBMRPT2 EQU   DCBBIT5 -      POINT (WHICH IMPLIES NOTE) (BSAM, BPAM)
DCBMRTMD EQU   DCBBIT5 -      SUBSTITUTE MODE (QSAM)
DCBMRUIP EQU   DCBBIT5 -      UPDATE IN PLACE (PUTX) (QISAM) ---
*                             ALWAYS ZERO (BISAM) ---
*                             RESERVED (BDAM, QTAM, BTAM)
DCBMR3WD EQU   DCBBIT6 -      THREE-WORD DEVICE INTERFACE (EXCP)
DCBMRCTL EQU   DCBBIT6 -      CNTRL (BSAM, QSAM)
DCBMRSTK EQU   DCBBIT6 -      SETL BY KEY (QISAM)
DCBMRAWR EQU   DCBBIT6 -      ADD TYPE OF WRITE (BDAM) ---
*                             ALWAYS ZERO (BISAM) ---
*                             RESERVED (BPAM, QTAM, BTAM)
DCBMR1WD EQU   DCBBIT7 -      ONE-WORD DEVICE INTERFACE (EXCP)
DCBMRSWA EQU   DCBBIT7 -      USER'S PROGRAM HAS PROVIDED A SEGMENT
*                             WORK AREA POOL (BSAM CREATE BDAM, BDAM)
DCBMRDMD EQU   DCBBIT7 -      DATA MODE (QSAM)
DCBMRSTI EQU   DCBBIT7 -      SETL BY ID (QISAM) ---
*                             ALWAYS ZERO (BISAM) ---
*                             RESERVED (BPAM, QTAM, BTAM)
         SPACE 1
***********************************************************************
*                       FOUNDATION AFTER OPEN
***********************************************************************
         SPACE 1
         ORG   IHADCB+40
DCBTIOT  DS    H -            OFFSET FROM TIOT ORIGIN TO TIOELNGH FIELD
*                             IN TIOT ENTRY FOR DD STATEMENT ASSOCIATED
*                             WITH THIS DCB
DCBMACRF DS    0BL2 -         SAME AS DCBMACR BEFORE OPEN
DCBMACF1 DS    BL1 -          FIRST BYTE OF DCBMACRF
DCBMACF2 DS    BL1 -          SECOND BYTE OF DCBMACRF
DCBDEBAD DS    0A -           ADDRESS OF ASSOCIATED DEB
DCBIFLGS DS    BL1 -          SAME AS DCBIFLG BEFORE OPEN
DCBIFEC  EQU   DCBBIT0+DCBBIT1 - ERROR CORRECTION INDICATOR
DCBIFPCT EQU   DCBBIT2+DCBBIT3 - PRINTER CARRIAGE TAPE PUNCH INDICATOR
DCBIFIOE EQU   DCBBIT4+DCBBIT5 - IOS ERROR ROUTINE USE INDICATOR
DCBIFLDT EQU   DCBBIT6 -      3800 PRINTER LOST DATA INDICATOR @G38ESMH
DCBDEBA  DS    AL3 -          ADDRESS OF ASSOCIATED DEB
         SPACE 1
         SPACE 1
         SPACE 1
         ORG   IHADCB+52
DCBOPTCD DS    0BL1 -                   OPTION CODE
         SPACE 1
*MEXIT #=    27 LV= 1 DCBD
TESTMVS1 CSECT 
*MCALL #=    29 LV= 1          DELETE EP=MYPGM
         BAL   0,*+12                            LOAD ADDR OF EP SYMBOL
         DC    CL8'MYPGM'                          EP SYMBOL
         SVC   9                                 ISSUE DELETE SVC
*MEXIT #=    29 LV= 1 DELETE
*MCALL #=    30 LV= 1          DEQ  (CBUFRSQN,CBUFRSRN,4,STEP),MF=L
*MCALL #=    31 LV= 2          ENQ   (CBUFRSQN,CBUFRSRN,4,STEP),GENERICX
               =NO,MF=L                    X02113
         DS    0F                      ESTABLISH A FULLWORD BOUNBARY
         DC    AL1(192)            LISTEND BYTE              X02113
         DC    AL1(4)            RNAME LENGTH
         DC    BL1'00000000'  OPTIONS
         DC    AL1(0)                  RETURN CODE FIELD
         DC    A(CBUFRSQN)              QNAME ADDRESS
         DC    A(CBUFRSRN)              RNAME ADDRESS
*MEXIT #=    31 LV= 2 ENQ
*MEXIT #=    30 LV= 1 DEQ
*MCALL #=    32 LV= 1          DETACH  4(2)
* /* MACDATE Y-1 72271                                               */
* /*
*MCALL #=    33 LV= 2          IHBINNRA 4(2)                      LOAD X
               REG 1
         LA    1,4(2)                              LOAD PARAMETER REG 1
*MEXIT #=    33 LV= 2 IHBINNRA
        SVC   62             ISSUE DETACH SVC
*MEXIT #=    32 LV= 1 DETACH
*MCALL #=    34 LV= 1          DYNALLOC 
*        MACDATE Y-2 73082
         SVC   99 CALL DYNAMIC ALLOCATION
*MEXIT #=    34 LV= 1 DYNALLOC
*MCALL #=    35 LV= 1          ESETL MYDCB
*MCALL #=    36 LV= 2          IHBINNRA MYDCB
         LA    1,MYDCB                              LOAD PARAMETER REG X
               1
*MEXIT #=    36 LV= 2 IHBINNRA
         L     15,84(0,1)                        LOAD ESETL ROUT. ADDR.
         BALR  14,15                             LINK TO ESETL ROUTINE
*MEXIT #=    35 LV= 1 ESETL
*MCALL #=    37 LV= 1          ESPIE SET,MYEXIT,5
        SR     15,15
        IPM    0  GET CURRENT PGM MASK
        SPM    0 TURN ON ANY MASKS REQUIRED
        L      0,=B'00000100000000000000000000000000'
        LA     1,MYEXIT
        SVC    X'6D' ESPIE R0=INT BITS R1=EXIT R15=PARAM
*MEXIT #=    37 LV= 1 ESPIE
*MCALL #=    38 LV= 1          ESTAE MYEXIT
*    MACDATE Y-1 75302
         CNOP  0,4                     ESTAB. FULL WD. BOUND. ALIGN.
         BAL   1,*+20             LIST ADDR IN REG1 SKIP LIST
IHB0038  EQU   *
         DC    AL1(22)             FLAGS FOR TCB, PURGE, ASYNCH
         DC    AL3(MYEXIT)              STAE EXIT ROUTINE ADDR.
         DC    A(0)                    SPACE FOR PARM LIST ADDR
         DC    A(0)                    SPACE FOR TCB ADDR
         DC    AL1(0)            FLAGS FOR TERM AND RECORD
         DC    AL3(0)                  RESERVED
         SLR   0,0                     INDICATE CREATE OPTION
         LA    1,0(0,1)                MAKE REG1 POS.  XCTL=NO
         SVC   60                      ISSUE STAE SVC
*MEXIT #=    38 LV= 1 ESTAE
*MCALL #=    39 LV= 1 MYEXLST  EXLST EODAD=(MYEXIT,A)
*MCALL #=    40 LV= 2 MYEXLST  EXLVS EODAD=(MYEXIT,A),SCIP=,LERAD=,AM=,X
               JRNAD=,SYNAD=,OPENAD=,LOGON=,RELREQ=,NSEXIT=,ATTN=,TPENDX
               =,LOSTERM=,DFASY=,RESP=,UPAD=,PARMS=,PARM2=,PARM3=
MYEXLST  DS    0F
         DC    X'81'                    EXLIST IDENTIFICATION
         DC    AL1(0)              EXLST SUBTYPE           X04SVHS
         DC    H'10'               EXLST LIST LENGTH
         DC    X'00'                    EXLST FLAGS
         DC    AL1(192)               EODAD ENTRY DESCRIPTION
         DC    AL4(MYEXIT)           POINTER TO EODAD EXIT
*MEXIT #=    40 LV= 2 EXLVS
*MEXIT #=    39 LV= 1 EXLST
*MCALL #=    41 LV= 1          EXTRACT DATA8,FIELDS=(TIOT)
         CNOP  0,4
         BAL   1,*+16                            BRANCH AROUND LIST
         DC    A(DATA8)                          LIST ADDRESS
         DC    A(0)                              TCB ADDRESS
         DC    AL1(2)                         FIELD BYTE
         DC    AL1(0)    .         FIELD BYTE 2               20021
         DC    AL2(0) .                                           20021
         SVC   40                                ISSUE EXTRACT SVC
*MEXIT #=    41 LV= 1 EXTRACT
*MCALL #=    42 LV= 1          FREEMAIN R,LV=(3),A=(4)
*      OS/VS2 RELEASE 3 VERSION  -- 10/25/74
         LR    0,3                          LOAD LENGTH
         LA    1,0(0,4)                      LOAD AREA ADDRESS
         SVC   10                             ISSUE FREEMAIN SVC
*MEXIT #=    42 LV= 1 FREEMAIN
*MCALL #=    43 LV= 1          GETMAIN RU,LV=(2),LOC=BELOW
*      OS/VS2 RELEASE 4 VERSION -- 10/21/75
         CNOP  0,4
         B     *+12-4*1-2*0                BRANCH AROUND DATA
IHB0043F DC    AL1(0)                            RESERVED
         DC    AL1(0)                            RESERVED
         DC    AL1(0)                            SUBPOOL
         DC    BL1'00000010'            MODE BYTE
         LR    0,2                          LOAD LENGTH   @ZA07133
         L     15,IHB0043F                    LOAD GETMAIN PARMS
         SR    1,1                               ZERO RESERVED REG 1
         SVC   120                             ISSUE GETMAIN SVC
*MEXIT #=    43 LV= 1 GETMAIN
*MCALL #=    44 LV= 1          GETMAIN R,LV=(2),LOC=BELOW
*      OS/VS2 RELEASE 4 VERSION -- 10/21/75
         LR    0,2                          LOAD LENGTH
         BAL   1,*+4                             INDICATE GETMAIN
         SVC   10                             ISSUE GETMAIN SVC
*MEXIT #=    44 LV= 1 GETMAIN
*MCALL #=    45 LV= 1          ENQ  (CBUFRSQN,CBUFRSRN,E,4,STEP),MF=L
         DS    0F                      ESTABLISH A FULLWORD BOUNBARY
         DC    AL1(192)            LISTEND BYTE              X02113
         DC    AL1(4)            RNAME LENGTH
         DC    BL1'00000000'  OPTIONS
         DC    AL1(0)                  RETURN CODE FIELD
         DC    A(CBUFRSQN)              QNAME ADDRESS
         DC    A(CBUFRSRN)              RNAME ADDRESS
*MEXIT #=    45 LV= 1 ENQ
*MCALL #=    46 LV= 1          GENCB BLK=RPL,ACB=MYACB
*MCALL #=    47 LV= 2          IDACB2 CALLER=GEN,BLKTYPE=RPL,LABEL=,MF=X
               ,BUFND=,BUFNI=,BUFSP=,DDNAME=,EXLST=,MACRF=,PASSWD=,STRNX
               O=,CATALOG=,EODAD=,JRNAD=,LERAD=,SYNAD=,ACB=MYACB,AREA=,X
               AREALEN=,ARG=,ECB=,KEYLEN=,MSGAREA=,MSGLEN=,NXTRPL=,OPTCX
               D=,RECLEN=,JFCB=,USERPTR=,APPLID=,LOGON=,LOSTERM=,RELREQX
               =,ATTN=,NSEXIT=,TPEND=,AAREA=,AAREALN=,ARECLEN=,EXIT=,NIX
               B=,BRANCH=,NAME=,USERFLD=,MODE=,LISTEND=,CONDN=,PROC=,AMX
               =,CHNGDIR=,STYPE=,RTYPE=,CHAIN=,POST=,RESPOND=,CONTROL=,X
               OBSQAC=,IBSQAC=,OBSQVAL=,IBSQVAL=,SEQNO=,SSENSEO=,USENSEX
               O=,RESPLIM=,SDT=,SCIP=,DFASY=,RESP=,BRACKET=,SSENSMO=,TRX
               ANSID=,BSTRNO=,CRA=,MAREA=,MLEN=,LOGMODE=,BNDAREA=,SIGDAX
               TA=,CODESEL=,CRYPT=,ENCR=                         @G40AKX
               CM
*MCALL #=    48 LV= 3          IDACBRPL AM=,MF=,CALLER=GEN,ACB=MYACB,ARX
               EA=,AREALEN=,ARG=,ECB=,FDBK=,MSGAREA=,MSGLEN=,NXTRPL=,OPX
               TCD=,RBA=,RECLEN=,IO=,RPLLEN=,AAREA=,AAREALN=,ARECLEN=,EX
               XIT=,KEYLEN=,NIB=,BRANCH=,USER=,RTNCD=,FDBK2=,SENSE=,REQX
               =,DATAFLG=,TRANSID=,AIXPC=,FTNCD=,AIXFLAG=,CHNGDIR=,STYPX
               E=,RTYPE=,CHAIN=,POST=,RESPOND=,CONTROL=,OBSQAC=,IBSQAC=X
               ,OBSQVAL=,IBSQVAL=,SEQNO=,SSENSEO=,SSENSEI=,USENSEO=,USEX
               NSEI=,BRACKET=,SSENSMO=,SSENSMI=,SIGDATA=,CODESEL=,CRYPTX
               =                                    @G40AKSL
*MCALL #=    49 LV= 4          IDACB3 ARG=MYACB,ARGNAME=ACB,KWTC=X'2B',X
               MF=          X04SVHS
*MCALL #=    50 LV= 5          IDACB1 ARG=MYACB,ARGNAME=ACB,MF=,CALLER=X
               ,TYPE=                                       X04SVHS
*MEXIT #=    50 LV= 5 IDACB1
*MEXIT #=    49 LV= 4 IDACB3
*MCALL #=    51 LV= 4          IDACB3 ARG=,ARGNAME=AREA,KWTC=X'2C',MF= X
                      X04SVHS
*MEXIT #=    51 LV= 4 IDACB3
*MCALL #=    52 LV= 4          IDACB3 ARG=,ARGNAME=AREALEN,KWTC=X'2D',MX
               F=  X04SVHS
*MEXIT #=    52 LV= 4 IDACB3
*MCALL #=    53 LV= 4          IDACB3 ARG=,ARGNAME=ARG,KWTC=X'2E',MF=  X
                       X04SVHS
*MEXIT #=    53 LV= 4 IDACB3
*MCALL #=    54 LV= 4          IDACB3 ARG=,ARGNAME=ECB,KWTC=X'2F',MF=  X
                       X04SVHS
*MEXIT #=    54 LV= 4 IDACB3
*MCALL #=    55 LV= 4          IDACB3 ARG=,ARGNAME=KEYLEN,KWTC=X'30',MFX
               =    X04SVHS
*MEXIT #=    55 LV= 4 IDACB3
*MCALL #=    56 LV= 4          IDACB3 ARG=,ARGNAME=MSGAREA,KWTC=X'31',MX
               F=  X04SVHS
*MEXIT #=    56 LV= 4 IDACB3
*MCALL #=    57 LV= 4          IDACB3 ARG=,ARGNAME=MSGLEN,KWTC=X'32',MFX
               =    X04SVHS
*MEXIT #=    57 LV= 4 IDACB3
*MCALL #=    58 LV= 4          IDACB3 ARG=,ARGNAME=NXTRPL,KWTC=X'33',MFX
               =    X04SVHS
*MEXIT #=    58 LV= 4 IDACB3
*MCALL #=    59 LV= 4          IDACBOPT OPTCD=,AM=,MF=,CALLER=GEN     XX
               04SVHS
*MEXIT #=    59 LV= 4 IDACBOPT
*MCALL #=    60 LV= 4          IDACB3 ARG=,ARGNAME=SSENSMO,KWTC=X'86',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    60 LV= 4 IDACB3
*MCALL #=    61 LV= 4          IDACB3 ARG=,ARGNAME=SSENSMI,KWTC=X'87',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    61 LV= 4 IDACB3
*MCALL #=    62 LV= 4          IDACB3 ARG=,ARGNAME=SIGDATA,KWTC=X'88',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    62 LV= 4 IDACB3
*MCALL #=    63 LV= 4          IDACB3 ARG=,ARGNAME=OBSQVAL,KWTC=X'6E',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    63 LV= 4 IDACB3
*MCALL #=    64 LV= 4          IDACB3 ARG=,ARGNAME=IBSQVAL,KWTC=X'6F',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    64 LV= 4 IDACB3
*MCALL #=    65 LV= 4          IDACB3 ARG=,ARGNAME=SEQNO,KWTC=X'70',MF=X
               ,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    65 LV= 4 IDACB3
*MCALL #=    66 LV= 4          IDACB3 ARG=,ARGNAME=USENSEO,KWTC=X'73',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    66 LV= 4 IDACB3
*MCALL #=    67 LV= 4          IDACB3 ARG=,ARGNAME=USENSEI,KWTC=X'74',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    67 LV= 4 IDACB3
*MCALL #=    68 LV= 4          IDACB3 ARG=,ARGNAME=RECLEN,KWTC=X'35',MFX
               =    X04SVHS
*MEXIT #=    68 LV= 4 IDACB3
*MCALL #=    69 LV= 4          IDACB3 ARG=,ARGNAME=AAREA,KWTC=X'57',MF=X
               ,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    69 LV= 4 IDACB3
*MCALL #=    70 LV= 4          IDACB3 ARG=,ARGNAME=AAREALN,KWTC=X'49',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    70 LV= 4 IDACB3
*MCALL #=    71 LV= 4          IDACB3 ARG=,ARGNAME=ARECLEN,KWTC=X'4A',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    71 LV= 4 IDACB3
*MCALL #=    72 LV= 4          IDACB3 ARG=,ARGNAME=EXIT,KWTC=X'4B',MF=,X
               CHKAM=VTAM,AM=                                          X
                X04SVHS
*MEXIT #=    72 LV= 4 IDACB3
*MCALL #=    73 LV= 4          IDACB3 ARG=,ARGNAME=NIB,KWTC=X'4F',MF=,CX
               HKAM=VTAM,AM=                                           X
               X04SVHS
*MEXIT #=    73 LV= 4 IDACB3
*MCALL #=    74 LV= 4          IDACB3 ARG=,ARGNAME=TRANSID,KWTC=X'5F',MX
               F=  X04SVHS
*MEXIT #=    74 LV= 4 IDACB3
*MEXIT #=    48 LV= 3 IDACBRPL
         CNOP  0,4
         BAL   1,IDA0047A+28         BRANCH AROUND CONSTANTS
IDA0047A DC    A(*+8)             ADDRESS OF HEADER
         DC    A(IDA0047A+20+X'80000000') ADDRESS OF LAST ELEMENT
         DC    AL1(192)               BLOCK TYPE CODE
         DC    AL1(1)               FUNCTION TYPE CODE
         DC    AL2(1) HEADER FIELD VALUE
         DC    AL4(0)        HEADER FIELD VALUE
         DC    AL2(0)        HEADER FIELD VALUE
         DC    AL2(0)        HEADER FIELD VALUE
         DC    AL2(0)           ELEMENT ID
         DC    AL2(0)                  RESERVED                  X03004
         DC    A(MYACB)         ELEMENT VALUE
IDA0047B     L     15,16                  POINT TO CVT         X03004HS
         L     15,256(,15)             POINT TO AMCBS
         L     15,12(,15)              POINT TO CB MANIPULATION ROUTINE
         BAL   14,12(,15)         BRANCH TO ROUTINE       @Z40BHCJ
*MEXIT #=    47 LV= 2 IDACB2
*MEXIT #=    46 LV= 1 GENCB
*MCALL #=    75 LV= 1          GET  MYDCB,MYAREA
*MCALL #=    76 LV= 2          IHBINNRA MYDCB,MYAREA                   X
                                 XL03123
         LA    1,MYDCB                              LOAD PARAMETER REG X
               1
         LA    0,MYAREA                              LOAD PARAMETER REGX
                0
*MEXIT #=    76 LV= 2 IHBINNRA
         L     15,48(0,1)               LOAD GET ROUTINE ADDR
         BALR  14,15                    LINK TO GET ROUTINE
*MEXIT #=    75 LV= 1 GET
*MCALL #=    77 LV= 1          IDENTIFY EP=MYEXIT,ENTRY=MYEXIT
         BAL   0,*+12                            LOAD EP SYMBOL ADDR
         DC    CL8'MYEXIT'                          EP SYMBOL
*MCALL #=    78 LV= 2          IHBINNRA MYEXIT                    LOAD X
               REG 0
         LA    1,MYEXIT                              LOAD PARAMETER REGX
                1
*MEXIT #=    78 LV= 2 IHBINNRA
         SVC   41                                ISSUE IDENTIFY SVC
*MEXIT #=    77 LV= 1 IDENTIFY
*MCALL #=    79 LV= 1          LINK EP=MYPGM
*MCALL #=    80 LV= 2          IHBINNRB MYPGM,,,,ERRET=,SF=I
         CNOP  0,4
         BAL   15,*+20          BRANCH AROUND CONSTANTS
         DC    A(*+8)         ADDR. OF PARM. LIST
         DC    A(0)                DCB ADDRESS PARAMETER
         DC    CL8'MYPGM'            EP PARAMETER
*MEXIT #=    80 LV= 2 IHBINNRB
         SVC   6                   ISSUE LINK SVC
*MEXIT #=    79 LV= 1 LINK
*MCALL #=    81 LV= 1          LOAD EP=MYPGM
         CNOP  0,4
         LA    0,*+8              LOAD PARAMETER INTO REGISTER ZERO
         B     *+12               BRANCH AROUND CONSTANT(S)
         DC    CL8'MYPGM'           ENTRY POINT NAME
         SR    1,1                SHOW NO DCB PRESENT
         SVC   8
*MEXIT #=    81 LV= 1 LOAD
*MCALL #=    82 LV= 1          LOCATE MYLIST
*MCALL #=    83 LV= 2          IHBINNRA MYLIST                     LOADX
                REG 1
         LA    1,MYLIST                              LOAD PARAMETER REGX
                1
*MEXIT #=    83 LV= 2 IHBINNRA
         SVC   26                                LINK TO SERVICE ROUT.
*MEXIT #=    82 LV= 1 LOCATE
*MCALL #=    84 LV= 1          MODCB ACB=MYACB,EXLST=MYEXLST
*MCALL #=    85 LV= 2          IDACB1 ARG=MYACB,ARGNAME=ACB,MF=
*MEXIT #=    85 LV= 2 IDACB1
*MCALL #=    86 LV= 2          IDACB2 CALLER=MOD,BLKTYPE=ACB,LABEL=,MF=X
               ,BUFND=,BUFNI=,BUFSP=,DDNAME=,EXLST=MYEXLST,MACRF=,PASSWX
               D=,STRNO=,ACB=MYACB,AREA=,AREALEN=,ARG=,ECB=,KEYLEN=,MSGX
               AREA=,MSGLEN=,NXTRPL=,OPTCD=,RECLEN=,CATALOG=,EODAD=,JRNX
               AD=,LERAD=,SYNAD=,USERPTR=,JFCB=,APPLID=,LOGON=,LOSTERM=X
               ,RELREQ=,ATTN=,TPEND=,NSEXIT=,AAREA=,AAREALN=,ARECLEN=,EX
               XIT=,NIB=,BRANCH=,NAME=,USERFLD=,MODE=,LISTEND=,CONDN=,PX
               ROC=,AM=,CHNGDIR=,STYPE=,RTYPE=,CHAIN=,POST=,RESPOND=,COX
               NTROL=,OBSQAC=,IBSQAC=,OBSQVAL=,IBSQVAL=,SEQNO=,SSENSEO=X
               ,USENSEO=,RESPLIM=,SDT=,SCIP=,DFASY=,RESP=,BRACKET=,SSENX
               SMO=,TRANSID=,CRA=,BSTRNO=,MAREA=,MLEN=,LOGMODE=,BNDAREAX
               =,SIGDATA=,CODESEL=,CRYPT=,ENCR=                        X
                @G40AKSL
*MCALL #=    87 LV= 3          IDACBACB AM=,MF=,CALLER=MOD,ACBLEN=,ATRBX
               =,AVSPAC=,BUFND=,BUFNI=,BUFNO=,BUFSP=,CINV=,DDNAME=,ENDRX
               BA=,ERROR=,EXLST=MYEXLST,FS=,KEYLEN=,LRECL=,MACRF=,NCIS=X
               ,NDELR=,NEXCP=,NEXT=,NINSR=,NIXL=,NLOGR=,NRETR=,NSSS=,NUX
               PDR=,OFLAGS=,PASSWD=,RKP=,BSTRNO=,CRA=,OPENOBJ=,AIXRKP=,X
               STRNO=,STMST=,CATALOG=,USERPTR=,JFCB=,APPLID=,MAREA=,MLEX
               N=
*MCALL #=    88 LV= 4          IDACB3 ARG=,ARGNAME=BUFND,KWTC=X'04',MF=X
                     X04SVHS
*MEXIT #=    88 LV= 4 IDACB3
*MCALL #=    89 LV= 4          IDACB3 ARG=,ARGNAME=BUFNI,KWTC=X'05',MF=X
                     X04SVHS
*MEXIT #=    89 LV= 4 IDACB3
*MCALL #=    90 LV= 4          IDACB3 ARG=,ARGNAME=BUFSP,KWTC=X'07',MF=X
                     X04SVHS
*MEXIT #=    90 LV= 4 IDACB3
*MCALL #=    91 LV= 4          IDACB3 ARG=MYEXLST,ARGNAME=EXLST,KWTC=X'X
               0C',MF=      X04SVHS
*MCALL #=    92 LV= 5          IDACB1 ARG=MYEXLST,ARGNAME=EXLST,MF=,CALX
               LER=,TYPE=                                       X04SVHS
*MEXIT #=    92 LV= 5 IDACB1
*MEXIT #=    91 LV= 4 IDACB3
*MCALL #=    93 LV= 4          IDACB3 ARG=,ARGNAME=JFCB,KWTC=X'8D',MF= X
                     @XM01140
*MEXIT #=    93 LV= 4 IDACB3
*MCALL #=    94 LV= 4          IDACB3 ARG=,ARGNAME=PASSWD,KWTC=X'1E',MFX
               =    X04SVHS
*MEXIT #=    94 LV= 4 IDACB3
*MCALL #=    95 LV= 4          IDACB3 ARG=,ARGNAME=STRNO,KWTC=X'20',MF=X
                     X04SVHS
*MEXIT #=    95 LV= 4 IDACB3
*MCALL #=    96 LV= 4          IDACB3 ARG=,ARGNAME=APPLID,KWTC=X'41',MFX
               =,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=    96 LV= 4 IDACB3
*MCALL #=    97 LV= 4          IDACB3 ARG=,ARGNAME=MAREA,KWTC=X'0E',MF=X
                     X04SVHS
*MEXIT #=    97 LV= 4 IDACB3
*MCALL #=    98 LV= 4          IDACB3 ARG=,ARGNAME=MLEN,KWTC=X'0F',MF= X
                      X04SVHS
*MEXIT #=    98 LV= 4 IDACB3
*MCALL #=    99 LV= 4          IDACB3 ARG=,ARGNAME=BSTRNO,KWTC=X'24',MFX
               =    X04SVHS
*MEXIT #=    99 LV= 4 IDACB3
*MEXIT #=    87 LV= 3 IDACBACB
         CNOP  0,4
         BAL   1,IDA0086A+24         BRANCH AROUND CONSTANTS
IDA0086A DC    A(*+8)             ADDRESS OF HEADER
         DC    A(IDA0086A+16+X'80000000') ADDRESS OF LAST ELEMENT
         DC    AL1(160)               BLOCK TYPE CODE
         DC    AL1(2)               FUNCTION TYPE CODE
         DC    AL2(0)        HEADER FIELD VALUE
         DC    AL4(MYACB) HEADER FIELD VALUE
         DC    AL2(0)           ELEMENT ID
         DC    AL2(0)                  RESERVED                  X03004
         DC    A(MYEXLST)         ELEMENT VALUE
IDA0086B     L     15,16                  POINT TO CVT         X03004HS
         L     15,256(,15)             POINT TO AMCBS
         L     15,12(,15)              POINT TO CB MANIPULATION ROUTINE
         BAL   14,24(,15)         BRANCH TO ROUTINE       @Z40BHCJ
*MEXIT #=    86 LV= 2 IDACB2
*MEXIT #=    84 LV= 1 MODCB
*MCALL #=   100 LV= 1          OPEN (MYDCB)
         CNOP  0,4                               ALIGN LIST TO FULLWORD
         BAL   1,*+8                         LOAD REG1 W/LIST ADDR.
         DC    AL1(128)                        OPTION BYTE
         DC    AL3(MYDCB)                  DCB ADDRESS
         SVC   19                                ISSUE OPEN SVC
*MEXIT #=   100 LV= 1 OPEN
*MCALL #=   101 LV= 1          POINT RPL=MYRPL
         DS    0H
         LA    1,MYRPL                   LOAD RPL ADDR
         LA    0,X'03'                  INDICATE POINT IN REG
         L     15,24(1)                 LOAD ACB ADDR FROM RPL
         L     15,8(15)                 LOAD JES INTERFACE MOD ADDR
         BALR  14,15                    LINK TO INTERFACE ROUTINE
*MEXIT #=   101 LV= 1 POINT
*MCALL #=   102 LV= 1          POST MYECB
         SR    0,0                    . SET POST CODE REG ZERO
         LA    1,MYECB                 . LOAD ECB ADDRESS IN REG 1
         SVC   2                      . ISSUE THE POST SVC
*MEXIT #=   102 LV= 1 POST
*MCALL #=   103 LV= 1          PUT  MYDCB,MYAREA
*MCALL #=   104 LV= 2          IHBINNRA MYDCB,MYAREA
         LA    1,MYDCB                              LOAD PARAMETER REG X
               1
         LA    0,MYAREA                              LOAD PARAMETER REGX
                0
*MEXIT #=   104 LV= 2 IHBINNRA
         L     15,48(0,1)               LOAD PUT ROUTINE ADDR
         BALR  14,15                    LINK TO PUT ROUTINE
*MEXIT #=   103 LV= 1 PUT
*MCALL #=   105 LV= 1          PUTX MYDCB
*MCALL #=   106 LV= 2          IHBINNRA MYDCB,
         LA    1,MYDCB                              LOAD PARAMETER REG X
               1
*MEXIT #=   106 LV= 2 IHBINNRA
         L     15,48(0,1)                        LOAD REG 15 FROM DCB
         BAL   14,4(0,15)                        LINK TO PUTX ROUTINE
*MEXIT #=   105 LV= 1 PUTX
*MCALL #=   107 LV= 1          RDJFCB MYDCB
*MCALL #=   108 LV= 2          OPEN  MYDCB,MF=I
         CNOP  0,4                               ALIGN LIST TO FULLWORD
         BAL   1,*+8                         LOAD REG1 W/LIST ADDR.
         DC    AL1(128)                        OPTION BYTE
         DC    AL3(MYDCB)                  DCB ADDRESS
*MEXIT #=   108 LV= 2 OPEN
         SVC   64                                ISSUE RDJFCB SVC
*MEXIT #=   107 LV= 1 RDJFCB
*MCALL #=   109 LV= 1          READ  DECB1,SF,MYDCB,MYAREA,'S'
*MCALL #=   110 LV= 2          IHBRDWRS DECB1,SF,MYDCB,MYAREA,'S',,,,,,X
               ,,MF=I   XL03127
         CNOP  0,4
         BAL   1,*+24                LOAD DECB ADDRESS
DECB1    DC    F'0'                              EVENT CONTROL BLOCK
         DC    X'80'                             TYPE FIELD
         DC    X'80'                           TYPE FIELD
         DC    AL2(0)                            LENGTH
         DC    A(MYDCB)                           DCB ADDRESS
         DC    A(MYAREA)                          AREA ADDRESS
         DC    A(0)                              RECORD POINTER WORD
         L     15,8(1,0)           LOAD DCB ADDRESS
         L     15,48(0,15)                       LOAD RDWR ROUTINE ADDR
         BALR  14,15                             LINK TO RDWR ROUTINE
*MEXIT #=   110 LV= 2 IHBRDWRS
*MEXIT #=   109 LV= 1 READ
*MCALL #=   111 LV= 1 MYRPL    RPL   ACB=MYACB
*MCALL #=   112 LV= 2 MYRPL    RPLVS ACBDATA=,AREA=0,ARG=0,NXTRPL=0,KEYX
               LEN=0,ECB=,BUFL=,LEN=,MSGLEN=0,ERRMSG=,CCHAR=0,OPTCD=,NIX
               B=,BRANCH=,ACB=MYACB,AREALEN=,MSGAREA=,RECLEN=,AM=,AAREAX
               =0,AAREALN=0,EXIT=,ARECLEN=0,SEQNO=0,USENSEO=0,IBSQVAL=0X
               ,OBSQVAL=0,POST=,RESPOND=,CHAIN=,CONTROL=,CHNGDIR=,BRACKX
               ET=,SSENSMO=0,TRANSID=0,SSENSEO=,RTYPE=,STYPE=,IBSQAC=,OX
               BSQAC=,SIGDATA=0,CODESEL=,CRYPT=,PARMS=,PARM2=,PARM3=
MYRPL    DS    0F
         DC    AL1(0)                   RPL IDENTIFICATION
         DC    AL1(16)            RPL SUBTYPE             X04SVHS
         DC    AL1(0)                   RPL REQUEST TYPE
         DC    AL1(76)               RPL LENGTH               X03004
*MCALL #=   113 LV= 3          IDAVSRPL OPTCD=,BRANCH=,POST=,RESPOND=,CX
               HAIN=,CONTROL=,CHNGDIR=,BRACKET=,SSENSEO=,CODESEL=,RTYPEX
               =,STYPE=,IBSQAC=,OBSQAC=,CALLER=RPL,AM=,CRYPT=          X
                                         @G40AKCM
*MCALL #=   114 LV= 4          IDAVSCB3 ARG=,ARGNAME=ACB,KWTC=X'2B',MF=X
                      @ZA34940
*MEXIT #=   114 LV= 4 IDAVSCB3
*MCALL #=   115 LV= 4          IDAVSCB3 ARG=,ARGNAME=AREA,KWTC=X'2C',MFX
               =     @ZA34940
*MEXIT #=   115 LV= 4 IDAVSCB3
*MCALL #=   116 LV= 4          IDAVSCB3 ARG=,ARGNAME=AREALEN,KWTC=X'2D'X
               ,MF=                                          @ZA34940
*MEXIT #=   116 LV= 4 IDAVSCB3
*MCALL #=   117 LV= 4          IDAVSCB3 ARG=,ARGNAME=ARG,KWTC=X'2E',MF=X
                      @ZA34940
*MEXIT #=   117 LV= 4 IDAVSCB3
*MCALL #=   118 LV= 4          IDAVSCB3 ARG=,ARGNAME=ECB,KWTC=X'2F',MF=X
                      @ZA34940
*MEXIT #=   118 LV= 4 IDAVSCB3
*MCALL #=   119 LV= 4          IDAVSCB3 ARG=,ARGNAME=KEYLEN,KWTC=X'30',X
               MF= @ZA34940
*MEXIT #=   119 LV= 4 IDAVSCB3
*MCALL #=   120 LV= 4          IDAVSCB3 ARG=,ARGNAME=MSGAREA,KWTC=X'31'X
               ,MF=                                          @ZA34940
*MEXIT #=   120 LV= 4 IDAVSCB3
*MCALL #=   121 LV= 4          IDAVSCB3 ARG=,ARGNAME=MSGLEN,KWTC=X'32',X
               MF= @ZA34940
*MEXIT #=   121 LV= 4 IDAVSCB3
*MCALL #=   122 LV= 4          IDAVSCB3 ARG=,ARGNAME=NXTRPL,KWTC=X'33',X
               MF= @ZA34940
*MEXIT #=   122 LV= 4 IDAVSCB3
*MCALL #=   123 LV= 4          IDAVSOPT OPTCD=,AM=,MF=,CALLER=RPL    @ZX
               A34940
*MEXIT #=   123 LV= 4 IDAVSOPT
*MCALL #=   124 LV= 4          IDAVSCB3 ARG=,ARGNAME=SSENSMO,KWTC=X'86'X
               ,MF=,CHKAM=VTAM,AM=                        @ZA34940
*MEXIT #=   124 LV= 4 IDAVSCB3
*MCALL #=   125 LV= 4          IDAVSCB3 ARG=,ARGNAME=SSENSMI,KWTC=X'87'X
               ,MF=,CHKAM=VTAM,AM=                        @ZA34940
*MEXIT #=   125 LV= 4 IDAVSCB3
*MCALL #=   126 LV= 4          IDAVSCB3 ARG=,ARGNAME=SIGDATA,KWTC=X'88'X
               ,MF=,CHKAM=VTAM,AM=                        @ZA34940
*MEXIT #=   126 LV= 4 IDAVSCB3
*MCALL #=   127 LV= 4          IDAVSCB3 ARG=,ARGNAME=OBSQVAL,KWTC=X'6E'X
               ,MF=,CHKAM=VTAM,AM=                        @ZA34940
*MEXIT #=   127 LV= 4 IDAVSCB3
*MCALL #=   128 LV= 4          IDAVSCB3 ARG=,ARGNAME=IBSQVAL,KWTC=X'6F'X
               ,MF=,CHKAM=VTAM,AM=                        @ZA34940
*MEXIT #=   128 LV= 4 IDAVSCB3
*MCALL #=   129 LV= 4          IDAVSCB3 ARG=,ARGNAME=SEQNO,KWTC=X'70',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=   129 LV= 4 IDAVSCB3
*MCALL #=   130 LV= 4          IDAVSCB3 ARG=,ARGNAME=USENSEO,KWTC=X'73'X
               ,MF=,CHKAM=VTAM,AM=                        @ZA34940
*MEXIT #=   130 LV= 4 IDAVSCB3
*MCALL #=   131 LV= 4          IDAVSCB3 ARG=,ARGNAME=USENSEI,KWTC=X'74'X
               ,MF=,CHKAM=VTAM,AM=                        @ZA34940
*MEXIT #=   131 LV= 4 IDAVSCB3
*MCALL #=   132 LV= 4          IDAVSCB3 ARG=,ARGNAME=RECLEN,KWTC=X'35',X
               MF= @ZA34940
*MEXIT #=   132 LV= 4 IDAVSCB3
*MCALL #=   133 LV= 4          IDAVSCB3 ARG=,ARGNAME=AAREA,KWTC=X'57',MX
               F=,CHKAM=VTAM,AM=                                X04SVHS
*MEXIT #=   133 LV= 4 IDAVSCB3
*MCALL #=   134 LV= 4          IDAVSCB3 ARG=,ARGNAME=AAREALN,KWTC=X'49'X
               ,MF=,CHKAM=VTAM,AM=                        @ZA34940
*MEXIT #=   134 LV= 4 IDAVSCB3
*MCALL #=   135 LV= 4          IDAVSCB3 ARG=,ARGNAME=ARECLEN,KWTC=X'4A'X
               ,MF=,CHKAM=VTAM,AM=                        @ZA34940
*MEXIT #=   135 LV= 4 IDAVSCB3
*MCALL #=   136 LV= 4          IDAVSCB3 ARG=,ARGNAME=EXIT,KWTC=X'4B',MFX
               =,CHKAM=VTAM,AM=                               @ZA34940
*MEXIT #=   136 LV= 4 IDAVSCB3
*MCALL #=   137 LV= 4          IDAVSCB3 ARG=,ARGNAME=NIB,KWTC=X'4F',MF=X
               ,CHKAM=VTAM,AM=                               @ZA34940
*MEXIT #=   137 LV= 4 IDAVSCB3
*MEXIT #=   113 LV= 3 IDAVSRPL
         DC    A(0) .                   POINTER TO PLACEHOLDER
         DC    A(0) .                   ECB
         DC    BL1'0' .                 STATUS BYTE
         DC    XL3'0'                   FEEDBACK CODES
         DC    AL2(0) .           KEY LENGTH
         DC    AL2(0) .          TRANSID                 X04SVHS
         DC    A(0)                POINTER TO CONTROL CHARACTER
         DC    A(MYACB) .                POINTER TO ACB
         DC    A(0) .                   POINTER TO TCB
         DC    A(0) .               POINTER TO RECORD AREA
         DC    A(0) .                POINTER TO ARGUMENT
         DC    B'00100000' .        OPTCD BYTE 1
         DC    B'10000000' .            OPTCD BYTE 2
         DC    AL1(0) .                 OPTCD BYTE 3            X04SVHS
         DC    AL1(0) .                 OPTCD BYTE 4            X04SVHS
         DC    A(0) .             POINTER TO NEXT RPL
         DC    A(0) .                   RESERVED FOR LOGICAL REC LEN
         DC    A(0) .                   RESERVED FOR BUFFER LENGTH
*                                       OPTCD BYTES 5-8          X03004
         DC    B'00000000' .            BYTE 5                  X04SVHS
         DC    B'00000000' .            BYTE 6                  X04SVHS
         DC    B'00000000' .            BYTE 7                  X04SVHS
         DC    B'00000000' .            BYTE 8                  X04SVHS
         DC    XL8'0' .                 RBA
         DC    B'01000000'      @G40AKSL
         DC    AL1(0)                   ACTIVE INDICATOR
         DC    AL2(0) .           MAXIMUM ERROR MSG LENGTH
         DC    A(0) .                   RESERVED FOR MESSAGE AREA PTR
*MEXIT #=   112 LV= 2 RPLVS
*MEXIT #=   111 LV= 1 RPL
*MCALL #=   138 LV= 1          RETURN (14,12)
         LM    14,12,12(13)           RESTORE THE REGISTERS
         BR    14                                RETURN
*MEXIT #=   138 LV= 1 RETURN
*MCALL #=   139 LV= 1          SAVE   (14,12)
         DS    0H
         STM   14,12,12(13)           SAVE REGISTERS
*MEXIT #=   139 LV= 1 SAVE
*MCALL #=   140 LV= 1          SETL    MYDCB,K,MYLIMIT
*MCALL #=   141 LV= 2          IHBINNRA MYDCB,MYLIMIT
         LA    1,MYDCB                              LOAD PARAMETER REG X
               1
         LA    0,MYLIMIT                              LOAD PARAMETER REX
               G 0
*MEXIT #=   141 LV= 2 IHBINNRA
         LA    14,128                       PICK UP TYPE BYTE
         SLL   14,24                         SHIFT TO HI-ORDER BYTE
         OR    0,14                              PACK IN WITH LOW.LIM.
         L     15,76(0,1)                    LOAD SETL RTN ADDR
         BALR  14,15                             LINK TO SETL ROUTINE
*MEXIT #=   140 LV= 1 SETL
*MCALL #=   142 LV= 1          SHOWCAT ACB=MYACB,AREA=DATA16,FWLEN=NO,NX
               AME=MYNAME
         CNOP  0,4                      SHOWCAT MACRO ALIGNMENT
         BAL   1,IGG0142                  BRANCH AROUND PARM LIST
         DC    X'80'                    SHOW CAT FLAGS
         DC    X'000000'                RESERVED
         DC    A(MYNAME)                 NAME ADDRESS
         DC    A(MYACB)                  ACB ADDRESS
         DC    A(DATA16)                 RETURN AREA ADDRESS
IGG0142  DS    0H                       END OF PARM LIST
*MCALL #=   143 LV= 2          LINK  EP=IGG0CLA0              PASS CONTX
               ROL TO SHOWCAT MODULE
*MCALL #=   144 LV= 3          IHBINNRB IGG0CLA0,,,,ERRET=,SF=I
         CNOP  0,4
         BAL   15,*+20          BRANCH AROUND CONSTANTS
         DC    A(*+8)         ADDR. OF PARM. LIST
         DC    A(0)                DCB ADDRESS PARAMETER
         DC    CL8'IGG0CLA0'            EP PARAMETER
*MEXIT #=   144 LV= 3 IHBINNRB
         SVC   6                   ISSUE LINK SVC
*MEXIT #=   143 LV= 2 LINK
*MEXIT #=   142 LV= 1 SHOWCAT
*MCALL #=   145 LV= 1          SHOWCB  ACB=MYACB,AREA=DATA16,LENGTH=16,X
               FIELDS=(DDNAME)
*MCALL #=   146 LV= 2          IDACB1 ARG=MYACB,ARGNAME=ACB,MF=
*MEXIT #=   146 LV= 2 IDACB1
*MCALL #=   147 LV= 2          IDACB1 ARG=DATA16,ARGNAME=AREA,MF=
*MEXIT #=   147 LV= 2 IDACB1
*MCALL #=   148 LV= 2          IDACB1 ARG=16,ARGNAME=LENGTH,MF=
*MEXIT #=   148 LV= 2 IDACB1
*MCALL #=   149 LV= 2          IDACB2 CALLER=SHOW,BLKTYPE=ACB,LABEL=,MFX
               =,AM=                                            X03004
         CNOP  0,4
         BAL   1,IDA0149A+28         BRANCH AROUND CONSTANTS
IDA0149A DC    A(*+8)             ADDRESS OF HEADER
         DC    A(IDA0149A+24+X'80000000') ADDRESS OF LAST ELEMENT
         DC    AL1(160)               BLOCK TYPE CODE
         DC    AL1(3)               FUNCTION TYPE CODE
         DC    AL2(0)        HEADER FIELD VALUE
         DC    AL4(MYACB) HEADER FIELD VALUE
         DC    AL4(DATA16) HEADER FIELD VALUE
         DC    AL2(16) HEADER FIELD VALUE
         DC    AL2(0)        HEADER FIELD VALUE
         DC    AL2(9)           ELEMENT ID
         DC    AL2(0)                  RESERVED                  X03004
IDA0149B     L     15,16                  POINT TO CVT         X03004HS
         L     15,256(,15)             POINT TO AMCBS
         L     15,12(,15)              POINT TO CB MANIPULATION ROUTINE
         BAL   14,0(,15)               BRANCH TO ROUTINE       @ZA07565
*MEXIT #=   149 LV= 2 IDACB2
*MEXIT #=   145 LV= 1 SHOWCB
*MCALL #=   150 LV= 1          SNAP    DCB=MYDCB,STORAGE=(DATA8,DATA16)
* /* MACDATE Y-1 72179  LAST UPDATED -02/03/81 EBB1102 - APAR OZ51152*/
         CNOP  0,4
         BAL   1,IHB0150            BRANCH AROUND PARAM LIST
         DC    AL1(0)              ID NUMBER
         DC    AL1(114)        OPTION FLAGS                  Y02705
         DC    H'0'                RESERVED                      Y02705
         DC    AL1(0)        SDATA FLAGS ONE               Y02705
         DC    AL1(0)        SDATA FLAGS TWO              G33SPHW
         DC    AL1(0)        PDATA FLAGS                   Y02705
         DC    AL1(0)              RESERVED                      Y02705
         DC    A(MYDCB)             DCB ADDRESS
         DC    A(0)                TCB ADDRESS
         DC    A(*+8)              ADDRESS OF SNAP-SHOT LIST
         DC    A(0)                ADDRESS OF HEADER LIST       G33SPHW
         DC    A(DATA8)  STARTING/ENDING ADDRESS
         DC    A(DATA16)  STARTING/ENDING ADDRESS
IHB0150  DS    0H
         OI    28(1),X'80'     SET END OF LIST INDICATOR     Y02705
         SVC   51
*MEXIT #=   150 LV= 1 SNAP
*MCALL #=   151 LV= 1          STIMER WAIT,BINTVL=DATA4
* /* MACDATE Y-1 72277                                               */
*MCALL #=   152 LV= 2          IHBINNRA DATA4,
         LA    1,DATA4                              LOAD PARAMETER REG X
               1
*MEXIT #=   152 LV= 2 IHBINNRA
         LA    0,17(0,0)                       LOAD FLAG BYTE
         SLL   0,24(0)                           SHIFT TO HI-ORDER BYTE
         SVC   47                                ISSUE STIMER SVC
*MEXIT #=   151 LV= 1 STIMER
*MCALL #=   153 LV= 1          TGET  DATA16,16,ASIS
         LA    1,DATA16
         LA    0,16
         ICM   1,8,=B'10000001'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=   153 LV= 1 TGET
*MCALL #=   154 LV= 1          TIME  DEC
* /* MACDATE Y-1 72277                                               */
* /*
         LA    1,2(0,0)                      LOAD 1 TO SPECIFY UNIT
         SVC   11                                ISSUE TIME SVC
*MEXIT #=   154 LV= 1 TIME
*MCALL #=   155 LV= 1          TPUT  DATA16,16,FULLSCR
         LA    1,DATA16
         LA    0,16
         ICM   1,8,=B'00000011'
         SVC   93 R0=(ASID,LENGTH) R1=(FLAGS,ADDR)
*MEXIT #=   155 LV= 1 TPUT
*MCALL #=   156 LV= 1          TTIMER CANCEL,TU
* /* MACDATE Y-1 72277                                               */
* /*
         LA    1,1(0,0)                 LOAD 1 TO SET FLAG BYTE
         SVC   46                           ISSUE TTIMER
*MEXIT #=   156 LV= 1 TTIMER
*MCALL #=   157 LV= 1          WRITE DECB2,SF,MYDCB,MYAREA,'S'
*MCALL #=   158 LV= 2          IHBRDWRS DECB2,SF,MYDCB,MYAREA,'S',,,MF=X
               I
         CNOP  0,4
         BAL   1,*+24                LOAD DECB ADDRESS
DECB2    DC    F'0'                              EVENT CONTROL BLOCK
         DC    X'80'                             TYPE FIELD
         DC    X'20'                           TYPE FIELD
         DC    AL2(0)                            LENGTH
         DC    A(MYDCB)                           DCB ADDRESS
         DC    A(MYAREA)                          AREA ADDRESS
         DC    A(0)                              RECORD POINTER WORD
         L     15,8(1,0)           LOAD DCB ADDRESS
         L     15,48(0,15)                       LOAD RDWR ROUTINE ADDR
         BALR  14,15                             LINK TO RDWR ROUTINE
*MEXIT #=   158 LV= 2 IHBRDWRS
*MEXIT #=   157 LV= 1 WRITE
*MCALL #=   159 LV= 1          WTO   'HELLO WORLD'
         CNOP  0,4
         BAL   1,IHB0159A                        BRANCH AROUND MESSAGE
         DC    AL2(15)           TEXT LENGTH
         DC    B'0000000000000000'     MCS FLAGS
         DC    C'HELLO WORLD'
IHB0159A DS    0H
         SVC   35
*MEXIT #=   159 LV= 1 WTO
*MCALL #=   160 LV= 1          WTOR  'ENTER',DATA8,8,MYECB
         CNOP  0,4
         BAL   1,IHB0160A                        BRANCH AROUND LIST
         DC    AL1(8)                      REPLY LENGTH
         DC    AL3(DATA8)                        REPLY ADDRESS
         DC    A(MYECB)                           ECB ADDRESS
*MCALL #=   161 LV= 2          WTO   'ENTER',MF=I,MSGTYP=,ROUTCDE=,DESCX
               =,MCSFLAG=,QID=                         X02050
         DC    AL2(9)           TEXT LENGTH
         DC    B'0000000000000000'     MCS FLAGS
         DC    C'ENTER'
*MEXIT #=   161 LV= 2 WTO
IHB0160A DS    0H
         SVC   35                                ISSUE WTOR SVC
*MEXIT #=   160 LV= 1 WTOR
*MCALL #=   162 LV= 1          XCTL  EP=MYPGM
*MCALL #=   163 LV= 2          IHBINNRB  MYPGM,,,,,SF=I
         CNOP  0,4
         BAL   15,*+20          BRANCH AROUND CONSTANTS
         DC    A(*+8)         ADDR. OF PARM. LIST
         DC    A(0)                DCB ADDRESS PARAMETER
         DC    CL8'MYPGM'            EP PARAMETER
*MEXIT #=   163 LV= 2 IHBINNRB
         SVC   7                                 ISSUE XCTL SVC
*MEXIT #=   162 LV= 1 XCTL
*MCALL #=   164 LV= 1          XLATE DATA16,16,TO=A
         LA    1,DATA16                  ADDRESS OF AREA TO TRANSLATE
         LA    0,16(,0)           LENGTH TO TRANSLATE
         LA    15,X'80'                 CONSTRUCT BIT MASK
         SLL   15,24                    IN HIGH ORDER BYTE
         OR    1,15                     SET EBCDIC TO ASCII INDICATOR
         SVC   103                      ISSUE XLATE SVC
*MEXIT #=   164 LV= 1 XLATE
*MCALL #=   165 LV= 1          YREGS 
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
*MEXIT #=   165 LV= 1 YREGS
         END 
