* ZCOBOL PGM='RT\CICS\TEST\TESTBEC7' VER=V1.5.01a MM/DD/YY 
* ZCOBOL OPTIONS=(CICS)
         COPY  TESTBEC7_ZC_LABELS.CPY
*      ****************************************************************X
                              *
*      * Copyright 2006 Automated Software Tools Corporation           X
                              *
*      * This source code is part of z390 assembler/emulator package   X
                              *
*      * The z390 package is distributed under GNU general public      X
                              *
*      * license                                                       X
                              *
*      * Author - Don Higgins                                          X
                              *
*      ****************************************************************X
                              *
*         IDENTIFICATION DIVISION.
*      * 1) HANDLE ABEND BY PROGRAM
*      * 2) LINKED PROGRAM TO DEMO COMPLEX HANDLE ABEND
*         PROGRAM-ID. TESTBEC7.
         PRINT NOLIST,NOGEN,NOLISTUSE    SET LIST OPTION FOR INTERNAL CX
               ODE
DFHEIBR  EQU   11
         USING DFHEIBLK_DSECT,DFHEIBR
*
* TERMINAL CONTROL TABLE - TERMINAL ENTRY
*
DFHTCTTE DSECT
TCTTEHED DS    CL8         'DFHTCTTE'
TCTTETI  DS    CL4         TERMINAL ID
TCTTEDA  DS    AL4         A(TIOA)
TCTTETC  DS    CL4         NEXT TRANSID
TCTTEINT DS    CL4         INITIAL TRANSID
TCTTECA  DS    AL4         RETURN COMMAREA ADDRESS
TCTTECAL DS    XL2         RETURN COMMAREA ADDRESS LENGTH
TCTTELNK DS    XL2         RETURN LINK LEVEL, 0 RETURNS TO Z390KCP
TCTTELKA DS    AL4         LINK LEVEL AREA POINTER
*                          EACH 4-BYTE ENTRY HAS THE DSA ADDRESS
TCTTEABD DS    AL4         HANDLE ABEND BLOCK
TCTTESCC DS    AL4         STORAGE CONTROL CHAIN
TCTTEIMM DS    X           FF=RETURN IMMEDIATE
TCTTETS  DS    X           FF=SHUTDOWN REQUEST
TCTTETYP DS    C           TRANSID START TYPE (FROM Z390KCP/KCPGOTYP)
*                             A = .INI INITIAL TRANSID
*                             B = SCREEN INPUT
*                             C = RETURN TRANSID()
*                             D = IC START-NO DATA
*                             E = IC START-DATA
TCTTECND DS    X           FF=XCTL COMMAREA MUST BE FREED ON RETURN
TCTTEEDF DS    X           FF=EDF IS ACTIVE
TCTTEEBA DS    X           00='BEFORE'  FF='AFTER' CEDF INTERCEPT
TCTTEEDL DS    X           00=NORMAL LINKAGE  FF=DIRECT LINKAGE
TCTTEEDT DS    CL4         TERMID FOR EDF OUTPUT
TCTTEEDA DS    AL4         ADDRESS OF EDF PROCESSOR LCLCEDF
TCTTEQFN DS    PL3         SEQUENTIAL TERMINAL FILE NUMBER
TCTTEQFO DS    X           FF=CURRENT SEQUENTIAL FILE IS OPEN
TCTTEQFL DS    AL4         ADDRESS OF SEQUENTIAL TERMINAL FILENAME
TCTTEQDI DS    AL4         ADDRESS OF RECEIVE DCB
TCTTEQDO DS    AL4         ADDRESS OF SEND DCB
TCTTECWA DS    AL4         ADDRESS OF LOCAL CWA COPY
TCTTECWL DS    XL4         LENGTH OF LOCAL CWA COPY
TCTTELCL DS    AL4         ADDRESS OF LCL MODULE INDEXER
TCTTEIQF DS    X           FF=INQUIRE FILE BROWSE IN PROGRESS
TCTTEIFN DS    CL8         INQUIRE FILE CURRENT POSITION
* FIELDS FOR ASSIGN
TCTTEABP DS    X           ABDUMP INDICATOR
TCTTEABG DS    CL8         ABENDING PROGRAM
TCTTEPSW DS    XL8         ASRA PSW
TCTTEASR DS    XL64        ASRA REGS
TCTTEINV DS    CL8         INVOKING PROGRAM
TCTTERET DS    CL8         RETURN PROGRAM
TCTTELNA EQU   *-TCTTEABP  ASSIGN FIELDS TO CLEAR
TCTTEABC DS    CL4         ABCODE OR BLANK
TCTTENXT DS    CL4         RETURN TRANSID OR BLANK
TCTTEMCL DS    AL2         MAP COLUMN
TCTTEMHT DS    AL2         MAP HEIGHT
TCTTEMLN DS    AL2         MAP LINE
TCTTEMWH DS    AL2         MAP WIDTH
TCTTELEN EQU   *-DFHTCTTE
TCTTEAR  EQU   10
         USING DFHTCTTE,TCTTEAR
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
TESTBEC7       CSECT
*            R1 >>> A(EIB,COMMAREA)
* TCTTEAR (R10) >>> TCTTE
* DFHEIBR (R11) >>> EIB
*         (R14) >>> RETURN ADDRESS (LINK ONLY)
*
         LR    R2,R1              R2=SAVE USER PARM POINTER
* ENTRY IS ONLY BY DIRECT BRANCH FROM MODULES LCL0E02 (LINK)
* OR LCL0E04 (XCTL)
*
* DON'T SAVE THE REGS IF XCTL, THIS ISN'T A NEW LINK LEVEL
         CHHSI EIBFN,X'0E04'      XCTL ?
         JE    CICS_EIENT_0011_NOSAVE EXIT IF IT IS
* FIND LAST LINKER AND ESTABLISH LINKAGE
         LH    R15,TCTTELNK       R15=CURRENT LINK LEVEL
         AHI   R15,-1             -1
         SLL   R15,2              *4
         L     R1,TCTTELKA        R0=LKA ADDRESS
         AR    R1,R15             INDEX TO LAST LINK-LEVEL ENTRY
         L     R13,0(R1)          SAVE AREA OF LAST LINK-LEVEL
         STM   14,12,12+4*(14-14)(13)
CICS_EIENT_0011_NOSAVE EQU *
*
* GETMAIN THE DSA, AND SET UP THE CHAIN
*
         LAY   R1,(DFHEIEND-DFHEISTG) R1=DSA LENGTH
         LA    0,B'00'
         SVC   4 GMAIN R0=(X'02'=31B,X'01'=COND),R1=LEN OUT(R0=L,R1=A)
         ST    R1,8(R13)          SAVE NEW DSA SAVE AREA IN PRIOR SAVE
         ST    R13,4(R1)          SAVE OLD SAVE AREA IN NEW DSA SAVE
         LR    R13,R1             DSA BASE 1
         USING DFHEISTG,R13
         XC    DFHEICAP(DFHEIUSR-DFHEICAP),DFHEICAP CLEAR PREFIX DSA
*
* SAVE DSA LENGTH
*
         ST    R0,DFHEILEN        SAVE DSA LENGTH FOR FREEMAIN
*
* SET EIB AND COMMAREA ADDRESSES
*
         MVC   DFHEIEIB,0(R2)     SET EIB ADDRESS IN DSA
         MVC   DFHEICAP,4(R2)     SET COMMAREA ADDRESS IN DSA
*
* IF WE CAME FROM XCTL, WE MUST FREE THE PARM STORAGE AREA
*
         CHHSI EIBFN,X'0E04'      XCTL ?
         JNE   CICS_EIENT_0011_01 EXIT IF NOT
         LA    R0,8               LENGTH OF 8
         LR    1,R2
         SVC   5 FREEMAIN R0=LEN, R1=ADDR
         LA    R2,DFHEIEIB        SET UP THE PARM AGAIN
CICS_EIENT_0011_01 DS 0H
*
* FIND OUR LKA ENTRY AND STORE OUR DSA ADDRESS
*
         LH    R15,TCTTELNK       R15=CURRENT LINK LEVEL
         SLL   R15,2              *4
         L     R1,TCTTELKA        R1=LKA ADDRESS
         AR    R1,R15             INDEX TO OUR LINK LEVEL ENTRY
         ST    R13,0(R1)          SAVE OUR DSA ADDRESS
         MVC   DFHEIINV,TCTTEINV  SET INVOKING PROGRAM FOR ASSIGN
         MVC   DFHEIRET,TCTTERET  SET RETURN PROGRAM FOR ASSIGN
*
         CNOP  4,8             FORCE ZC390PVT TO DOUBLEWORD BOUNDARY
         BRAS  ZC_R8,ZC_LOAD
         USING *,ZC_R8            BASE FOR LOAD AND CICS V5 USE
*
*  THESE FIELDS MUST BE KEPT IN SYNC WITH zcobol\ZC390PVT.CPY
*
         DC    CL8'TESTBEC7'    PVTPGM   ZCOBOL PGM NAME
         DC    CL8'01/02/05'   PVTDATE  ZCOBOL COMPILE DATE
         DC    CL8'22.33'   PVTTIME  ZCOBOL COMPILE TIME
         DC    CL8'V1.5.01a'    PVTVER   ZCOBOL COMPILER VERSION
         DC    C'1'     PVTCICS  ZCOBOL EXEC CICS PGM
         DC    C'1'   PVTEXTND ZCOBOL EXTENDED PRECISION
         DC    C'0'    PVTTRUNC ZCOBOL TRUNCATE TO PICTURE
         DC    C'1'      PVTR64   ZCOBOL USE 64 BIT REGISTERS
ZC_LOAD  DS    0H
         LA    0,=CL8'ZC390LIB'
         SR    15,15 USE DEFAULT SYS390 SEARCH
         SVC   8 LOAD R0=A(NAME) R15=DDNAME/DSNAME ADDR OR 0
         LTR   ZC_R15,ZC_R15
         JZ    ZC_LOAD_OK
         BRAS  1,*+(WTO#0021_EOT-*+1)/2*2
         DC    AL2(WTO#0021_EOT-*,0),C'ZC390LIB NOT FOUND'
WTO#0021_EOT EQU *
         SVC   35
         LA  ZC_R15,16
         SVC 3      EXIT TO CALLER WITH RC=16
ZC_LOAD_OK DS  0H
         LR    ZC_R9,ZC_R0
         USING ZC390CVT,ZC_R9    R9=CVT
         CLC   ZCVT_ID,=C'ZCVT'              CHECK ZCVT ID AND LENGTH
         JNE   ZC_VER_ERR                    IN ZC390LIB.390 MATCH
         CLC   ZCVT_LEN,=A(ZCVT_END-ZCVT_ID) ZCOBOL PGM COMPILED ID/LEN
         BNE   ZC_VER_ERR
         L     ZC_R15,ZCVT_ZC390NUC
         BASR  ZC_R14,ZC_R15 CALL ZC390NUC TO VERIFY VER, OPTIONS
         J     ZC_VER_OK
ZC_VER_ERR DS 0H
         BRAS  1,*+(WTO#0022_EOT-*+1)/2*2
         DC    AL2(WTO#0022_EOT-*,0),C'ZC390LIB ZCVT VERIFY ERROR'
WTO#0022_EOT EQU *
         SVC   35
         LA  ZC_R15,16
         SVC 3      EXIT TO CALLER WITH RC=16
         LTORG
         PUSH  PRINT,NOPRINT
         PRINT OFF,NOPRINT
ZC_R0    EQU   0
ZC_R1    EQU   1
ZC_R2    EQU   2
ZC_R3    EQU   3
ZC_R4    EQU   4
ZC_R5    EQU   5
ZC_R6    EQU   6
ZC_R7    EQU   7
ZC_R8    EQU   8
ZC_R9    EQU   9
ZC_R10   EQU  10
ZC_R11   EQU  11
ZC_R12   EQU  12
ZC_R13   EQU  13
ZC_R14   EQU  14
ZC_R15   EQU  15
ZC_F0    EQU   0
ZC_F1    EQU   1
ZC_F2    EQU   2
ZC_F3    EQU   3
ZC_F4    EQU   4
ZC_F5    EQU   5
ZC_F6    EQU   6
ZC_F7    EQU   7
ZC_F8    EQU   8
ZC_F9    EQU   9
ZC_F10   EQU  10
ZC_F11   EQU  11
ZC_F12   EQU  12
ZC_F13   EQU  13
ZC_F14   EQU  14
ZC_F15   EQU  15
ZC_H     EQU   2   HIGH
ZC_L     EQU   4   LOW
ZC_E     EQU   8   EQUAL
ZC_NH    EQU   13  NOT HIGHT
ZC_NL    EQU   11  NOT LOW
ZC_NE    EQU   7   NOT EQUAL
ZC_O     EQU   1   OVERFLOW
ZC_P     EQU   2   POSITIVE
ZC_M     EQU   4   MINUS
ZC_Z     EQU   8   ZERO
ZC_NP    EQU   13  NOT POSITIVE
ZC_NM    EQU   11  NOT MINUS
ZC_NZ    EQU   7   NOT ZERO
ZC_NO    EQU   14  NOT OVERFLOW
ZC_EQ    EQU   8   EQUAL
ZC_GT    EQU   2   GREATER THAN
ZC_LT    EQU   4   LESS    THAN
ZC_GE    EQU   11  GREATER THAN OR EQUAL
ZC_LE    EQU   13  LESS    THAN OR EQUAL
         POP   PRINT,NOPRINT
PFPO_TEST    EQU  X'80' PFPO TEST IF VALID OPCODE (NOT SUPPORTED YET)
PFPO_RADIX   EQU  1 PFPO OPCODE - CONVERT FROM ONE RADIX TO ANOTHER
PFPO_RND     EQU  0 PFOP ROUNDING OPTION (ONLY DEFAULT ALLOWED)
PFPO_TYPE_EH EQU  0 EH HFP SHORT     32 BITS 7  DIGITS
PFPO_TYPE_DH EQU  1 ED HFP LONG      64 BITS 15 DIGITS
PFPO_TYPE_LH EQU  2 EL HFP EXTENDED 128 BITS 30 DIGITS
PFPO_TYPE_EB EQU  5 EB BFP SHORT     32 BITS 7  DIGITS
PFPO_TYPE_DB EQU  6 DB BFP LONG      64 BITS 16 DIGITS
PFPO_TYPE_LB EQU  7 LB BFP EXTENDED 128 BITS 34 DIGITS
PFPO_TYPE_ED EQU  8 ED DFP SHORT     32 BITS 7  DIGITS
PFPO_TYPE_DD EQU  9 DD DFP LONG      64 BITS 16 DIGITS
PFPO_TYPE_LD EQU 10 LD DFP EXTENDED 128 BITS 34 DIGITS
ZC_VER_OK DS   0H
ZC390CVT DSECT                ZCOBOL CVT AT ENTRY TO ZC390LIB.390
ZCVT_ID            DC    C'ZCVT'             ZCVT ID  VERIFIED BY ZCOB
ZCVT_LEN           DC    A(ZCVT_END-ZCVT_ID) ZCVT LEN VERIFIED BY ZCOB
ZCVT_VER           DC    CL8'V1.5.01a'    ZCVT VER VERIFIED BY ZC390NUC
ZCVT_ZC390NUC  DC V(ZC390NUC)      MODULE  SYSTEM ROUTINE MODULE INIT
ZCVT_CALL           DC V(CALL)       ENTRY R0=A(PGM),R1=A(PARMLIST)
ZCVT_CMP64R32       DC V(CMP64R32)   ENTRY COMPARE R0-1=FLD1 R2-3=FLD2
ZCVT_CVTLBTQ        DC V(CVTLBTQ)    ENTRY CVT LB IN F4-6 TO Q IN R0-1
ZCVT_CVTLDTP        DC V(CVTLDTP)    ENTRY CVT LD IN F0-2 TO PL31 R0-1
ZCVT_CVTQTLB        DC V(CVTQTLB)    ENTRY CVT Q IN R0-1 TO LB IN F4-6
ZCVT_DIV64R32       DC V(DIV64R32)   ENTRY DIVIDE R0-1=N64, R2-3=MAX64
ZCVT_DIVQ128        DC V(DIVQ128)    ENTRY DIVIDE Q128 R0-R1 BY R2-R3
ZCVT_GOBACK         DC V(GOBACK)     ENTRY R1=RC
ZCVT_MPYQ128        DC V(MPYQ128)    ENTRY MULTIPLY Q128 R0-R1 BY R2-R3
ZCVT_OSE64R32       DC V(OSE64R32)   ENTRY ON SIZE ERR R0-1=N, R2-3=MAX
ZCVT_PERFORM        DC V(PERFORM)    ENTRY R14=PGTAR,R0=PGEXT,R1=PMRET
ZCVT_PMCHECK        DC V(PMCHECK)    ENTRY R14=RETURN TO NEXT INSTR.
ZCVT_ROUNDF         DC V(ROUNDF)     ENTRY R0=REM,R1=QUO,R2=DIVISOR
ZCVT_STACKORG       DC V(STACKORG)   ENTRY PERFORM STACK ORIGIN
ZCVT_STACKPTR       DC V(STACKPTR)   ENTRY CUR ENTRY A(PG_END+4,RET)
ZCVT_STACKEND       DC V(STACKEND)   ENTRY PERFORM STACK END
ZCVT_STOPRUN        DC V(STOPRUN)    ENTRY R1=RC
ZCVT_TALPHAX        DC V(TALPHAX)    ENTRY TEST ALPHABETIC X
ZCVT_TNUMP          DC V(TNUMP)      ENTRY TEST NUMERIC P
ZCVT_TNUMX          DC V(TNUMX)      ENTRY TEST NUMERIC X
ZCVT_TNUMZ          DC V(TNUMZ)      ENTRY TEST NUMERIC Z
*
* ADDITIONAL SEPARATE MODULES LINKED WITH Z390NUC IN ZC390LIB.390
*
ZCVT_ABORT     DC V(ABORT)         MODULE  R1=ABORT ERROR MSG #
ZCVT_ABORT_ALTER   EQU    1 ABORT ALTER DUE TO BRC NOT FOUND AT TARGET
ZCVT_ABORT_CALL    EQU    2 ABORT DYNAMIC CALL - PGM NOT FOUND
ZCVT_ABORT_DISPLAY EQU    3 ABORT DISPLAY DUE TO BUFFER EXCEEDED
ZCVT_ABORT_OPEN    EQU    4 ABORT OPEN  INVALID DCB
ZCVT_ABORT_STACK   EQU    6 ABORT PEROFRM STACK OVERFLOW
ZCVT_ABORT_VERSION EQU    7 ABORT ZC390NUC INIT ZCOBOL VERSION ERROR
ZCVT_ABORT_INT128  EQU    8 ABORT INTEGER 128 CONVERSION OVERFLO
ZCVT_ABORT_DIVQ    EQU    9 ABORT DIVIDE Q IF DIVISOR 0 OR > 2**63
ZCVT_ABORT_CICS    EQU   10 ABORT THIS PGM REQUIRES EXEC CICS TRANS MGR
ZCVT_ABORT_ACCEPT  EQU   11 ABORT ACCEPT EOF
ZCVT_ABORT_MAXERR  EQU   11 ABORT MAX ERROR CODE
ZCVT_ACCEPT    DC V(ACCEPT)        MODULE  R1=A(TYPE,FLD_ADD,FLD_LEN)
ZCVT_ACCEPT_DEFAULT EQU   1 INPUT DEFAULT DDNAME=SYSIN
ZCVT_ACCEPT_CONSOLE EQU   2 INPUT VIA WTOR FROM CONSOLE
ZCVT_ACCEPT_DDNAME  EQU   3 INPUT FROM DDNAME WITH DDNAME ADDR IN R3
ZCVT_ACCEPT_DATE    EQU   4 RETURN DAY OF WEEK PIC 9(8) MMDDYYYY
ZCVT_ACCEPT_TIME    EQU   5 RETURN DAY OF WEEK PIC 9(8) HHMMSSTH
ZCVT_ACCEPT_DOW     EQU   6 RETURN DAY OF WEEK PIC 9 1-7
ZCVT_DISPLAY   DC V(DISPLAY)       MODULE  R1=A(ADDR,LEN,TYPE)
ZCVT_INSPECT   DC V(INSPECT)       MODULE  R0=TYPE,R1=PARMLIST
ZCVT_TALLYING      EQU   0 INSPECT TALLYING
ZCVT_REPLACING     EQU   4 INSPECT REPLACING
ZCVT_CONVERTING    EQU   8 INSPECT CONVERTING
*
* SHARED DATA AREAS
*
               DS 0D
ZCVT_ZERO      DC XL16'00'   BINARY ZEROS
ZCVT_HIGH_VALUES DC XL16'00' BINARY FF'S
ZCVT_PWORK     DS PL8     CVD/CVB WORK
ZCVT_PWORK1    DS PL16    DIV DIVIDEND, CVDG/CVBG WORK
ZCVT_PWORK2    DS PL16    DIV DIVISOR
ZCVT_PWORK3    DS PL16    DIV QUOTIENT
ZCVT_PWORK4    DS PL16    DIV REMAINDER
ZCVT_NDDX      DS XL16    DIV DIVIDEND HOLD AREA
ZCVT_WORKAREA  DS XL256   GEN_INSPECT PARMS, GEN_EDIT WORK, ETC.
*
* END OF ZC390CVT
*
ZCVT_END   EQU   *
ZC390PVT DSECT
PVTPGM   DS    CL8  ZCOBOL PGM NAME
PVTDATE  DS    CL8  ZCOBOL COMPILE DATE
PVTTIME  DS    CL8  ZCOBOL COMPILE TIME
PVTVER   DS    CL8  ZCOBOL COMPILER VERSION
PVTCICS  DS    C    ZCOBOL EXEC CICS PGM
PVTEXTND DS    C    ZCOBOL EXTENDED PRECISION
PVTTRUNC DS    C    ZCOBOL TRUNCATE TO PICTURE
PVTR64   DS    C    ZCOBOL USE 64 BIT REGISTERS
DFHEISTG DSECT
         DS    18F  SAVE AREA
DFHEIEIB DS    A    EIB POINTER
DFHEICAP DS    A    COMMAREA POINTER
DFHEICAL DS    H    COMMAREA LENGTH, COPY OF EIBCALEN
DFHEILEN DS    A    LENGTH OF DSA SET BY DFHEIENT
DFHEIAID DS    A    ADDRESS OF HANDLE AID BLOCK (DSECT=DFHADBLK)
DFHEIHCN DS    A    ADDRESS OF HANDLE CONDITION BLOCK (DSECT=DFHHCBLK)
DFHEIINV DS    CL8  INVOKING PROGRAM FOR ASSIGN
DFHEIRET DS    CL8  RETURN PROGRAM FOR ASSIGN
DFHEIUSR DS    0D   USER PROGRAM STORAGE (SEE DFHEIEND FOR END)
ZC_WS    EQU   DFHEISTG
*         ENVIRONMENT DIVISION.
*         DATA DIVISION.
*         WORKING-STORAGE SECTION.
*         01  TEST1.
*             02  FILLER  PIC X(4)  VALUE X'C311C761'.
*             02  FILLER  PIC X(35)
*                         VALUE 'TESTBEC7 IN TRANSID BEC4 SAYS HELLO'.
*             02  FILLER  PIC X(3)  VALUE X'114AC1'.
*             02  FILLER  PIC X(34)
*                         VALUE 'BEC4 COMPLETED OK, NOW PRESS CLEAR'.
*         77  TEST1L   PIC 9(4) COMP.
*         01  TEST2.
*             02  FILLER  PIC X(4)  VALUE X'C311C261'.
*             02  FILLER  PIC X(51)
*            VALUE 'TESTBEC7 IN TRANSID BEC5 SAYS HELLO AND ABENDS ASRAX
               '.
*         77  TEST2L   PIC 9(4) COMP.
*         01  TEST3.
*             02  FILLER  PIC X(4)  VALUE X'C311C761'.
*             02  FILLER  PIC X(51)
*            VALUE 'TESTBEC7 IN TRANSID BEC5 SAYS HELLO AND ABENDS AEI0X
               '.
*         77  TEST3L   PIC 9(4) COMP.
*         77  BADFLD1  PIC 9(4) COMP VALUE 0.
*         77  BADFLD2  PIC S9(3) REDEFINES BADFLD1 COMP-3.
*      * EXEC INTERFACE BLOCK
*            02  EIBHEAD  PIC X(8).
*            02  EIBTIME  PIC 9(7) COMP-3.
*            02  EIBDATE  PIC 9(7) COMP-3.
*            02  EIBTRNID PIC X(4).
*            02  EIBTASKN PIC 9(7) COMP-3.
*            02  EIBTRMID PIC X(4).
*            02  FILLER   PIC X(2).
*            02  EIBCPOSN PIC 9(4) COMP.
*            02  EIBCALEN PIC 9(4) COMP.
*            02  EIBAID   PIC X.
*            02  EIBFN    PIC 9(4) COMP.
*            02  EIBRCODE PIC X(6).
*            02  EIBREQID PIC X(8).
*            02  EIBDS    PIC X(8).
*            02  EIBRSRCE PIC X(8).
*            02  EIBRESP  PIC 9(9) COMP.
*            02  EIBRESP2 PIC 9(9) COMP.
*            02  EIBPROG  PIC X(8).
*            02  EIBDTFRM PIC X.
         PRINT LIST,GEN,LISTUSE TURN PRINT LISTING ON FOR USER CODE GEN
TESTBEC7  CSECT                SWITCH TO PROCEDURE CODE AHEAD OF WS
         L     ZC_R0,0(ZC_R2)          LOAD PARM ADDR FROM PARMLIST
         ST    ZC_R0,ZC_DFHEIBLK_PTR STORE PARM POINTER
         L     ZC_R0,4(ZC_R2)          LOAD PARM ADDR FROM PARMLIST
         ST    ZC_R0,ZC_DFHCOMMAREA_PTR STORE PARM POINTER
         LARL  ZC_R1,=XL4'C311C761'
         MVC   ZC_FILLER_V1,0(ZC_R1)
         LARL  ZC_R1,=CL36'TESTBEC7 IN TRANSID BEC4 SAYS HELLO'
         MVC   ZC_FILLER_V2,0(ZC_R1)
         LARL  ZC_R1,=XL4'114AC1'
         MVC   ZC_FILLER_V3,1(ZC_R1)
         LARL  ZC_R1,=CL34'BEC4 COMPLETED OK, NOW PRESS CLEAR'
         MVC   ZC_FILLER_V4,0(ZC_R1)
         LARL  ZC_R1,=XL4'C311C261'
         MVC   ZC_FILLER_V5,0(ZC_R1)
         LARL  ZC_R1,=CL52'TESTBEC7 IN TRANSID BEC5 SAYS HELLO AND ABENX
               DS ASRA'
         MVC   ZC_FILLER_V6,0(ZC_R1)
         LARL  ZC_R1,=XL4'C311C761'
         MVC   ZC_FILLER_V7,0(ZC_R1)
         LARL  ZC_R1,=CL52'TESTBEC7 IN TRANSID BEC5 SAYS HELLO AND ABENX
               DS AEI0'
         MVC   ZC_FILLER_V8,0(ZC_R1)
         MVHHI BADFLD1,0
         MVI   ZC_FILLER_V9,C' '
         MVI   ZC_FILLER_V10,C' '
         MVI   ZC_FILLER_V11,C' '
         MVI   ZC_FILLER_V12,C' '
         MVI   ZC_FILLER_V13,C' '
         MVHHI RETURN_CODE,0
*             MOVE LENGTH OF TEST1   TO TEST1L.
*ZC     62         MOVE  LENGTH,OF,TEST1,TO,TEST1L
         MVHHI TEST1L,76
*             MOVE LENGTH OF TEST2   TO TEST2L.
*ZC     63         MOVE  LENGTH,OF,TEST2,TO,TEST2L
         MVHHI TEST2L,55
*             MOVE LENGTH OF TEST3   TO TEST3L.
*      *  CLC   EIBTRNID,=C'BEC5'  SECOND TEST TRANSID ?
*      *  BE    BEC5               EXIT IF IT IS
*ZC     64         MOVE  LENGTH,OF,TEST3,TO,TEST3L
         MVHHI TEST3L,55
*             IF EIBTRNID = 'BEC5' THEN GO TO BEC5.
*ZC     67         IF    EIBTRNID,=,'BEC5',THEN
         LARL  ZC_R1,=CL4'BEC5'
         CLC   EIBTRNID,0(ZC_R1)
         BRC   15-ZC_EQ,PG_IF_1_1
*      * BEC4 ABEND HANDLER
*ZC     67         GO    TO,BEC5
         J     PG_BEC5
PG_IF_1_1  DS    0H  END_IF
*             EXEC CICS SEND FROM(TEST1) LENGTH(TEST1L) END-EXEC.
*ZC     69         EXEC  CICS,SEND,FROM(TEST1),LENGTH(TEST1L)
         LARL  R1,P0404         ADDRESS SOURCE
         LARL  R15,P0404        ADDRESS TARGET
         XC    0(P0404END-P0404,R15),0(R1) XC IT
         LARL  R1,=X'0404'         ADDRESS SOURCE
         LARL  R15,P0404FN        ADDRESS TARGET
         MVC   0(L'P0404FN,R15),0(R1) MVC IT
         LARL  R15,P0404LEN       ADDRESS TARGET
         MVC   0(2,R15),TEST1L   SET LENGTH FROM LABEL
         LA    R0,TEST1           FROM ADDRESS
         LARL  R1,P0404FRM         ADDRESS TARGET
         ST    R0,0(R1)      ST IT
         LARL  R1,P0404EIB         ADDRESS TARGET
         ST    DFHEIBR,0(R1)      ST IT
         LARL  R1,P0404TCT         ADDRESS TARGET
         ST    TCTTEAR,0(R1)      ST IT
         L     R15,TCTTELCL       R15=LCL MODULE INDEXER
         LARL  R1,=A(P0404)       R1=LCL MODULE PARAMETER LIST
         BAKR  0,R15              STACK REGS AND GO
         J     P0404BYP_0252   EXIT
*
P0404    DS    0H
P0404FN  DS    XL2                FUNCTION CODE
P0404EIB DS    AL4                EIB
P0404TCT DS    AL4                TCTTE
P0404FRM DS    AL4                FROM
P0404LEN DS    AL2                LENGTH
P0404NOH DS    X                  FF=NOHANDLE
         DS    X
P0404RSP DS    AL4                RESP
P0404RS2 DS    AL4                RESP2
P0404END EQU   *                  END MARKER
*
P0404BYP_0252 DS 0H
*             EXEC CICS RETURN END-EXEC.
*ZC     70         EXEC  CICS,RETURN
         LARL  R1,P0E08         ADDRESS SOURCE
         LARL  R15,P0E08        ADDRESS TARGET
         XC    0(P0E08END-P0E08,R15),0(R1) XC IT
         LARL  R1,=X'0E08'         ADDRESS SOURCE
         LARL  R15,P0E08FN        ADDRESS TARGET
         MVC   0(L'P0E08FN,R15),0(R1) MVC IT
* SPECIAL LINKAGE
         LARL  R1,P0E08           R1=PARAMETER LIST
         LARL  R14,P0E08RTN_0261 RETURN ADDRESS
         LRL   R15,=V(LCL0E08)    R15=EXTERNAL RETURN MODULE ADDRESS
         BR    R15                GO TO IT
*
P0E08RTN_0261 EQU *
         OC    EIBRESP,EIBRESP    ANY BAD RESPONSE ?
         JZ    P0E08BYP_0261   EXIT IF NONE
* INVREQ
         DC    AL3(0),C'ABEND'    MARKER FOR Z390KCP ESTAE
         DC    AL4(0)             IGNORE HERE IS NOT PERMITTED
*
P0E08    DS    0H
P0E08FN  DS    XL2                FUNCTION CODE
P0E08TRN DS    CL4                TRANSID
P0E08COM DS    AL4                COMMAREA ADDRESS
P0E08CLN DS    XL2                COMMAREA LENGTH
P0E08IMM DS    X                  FF=IMMEDIATE
         DS    X
P0E08CNR DS    X                  FF=CLEANER
         DS    X
P0E08RSP DS    AL4                RESP
P0E08RS2 DS    AL4                RESP2
P0E08END EQU   *                  END MARKER
         DS    0H
*
P0E08BYP_0261 DS 0H
*      * ABEND PRODUCER FOR TRANSID BEC5
*      * BEC5     EQU   *
*         BEC5.
*      *  OC    DFHEICAP,DFHEICAP  ANY COMMAREA ?
*      *  BNZ   BEC5COMM           EXIT IF WE HAVE
PG_BEC5  DS    0H
*             IF EIBCALEN NOT = 0 THEN GO TO BEC5COMM.
*ZC     78         IF    EIBCALEN,NOT,=,0,THEN
         LH    0,EIBCALEN
         CHI   0,0
         BRC   15-ZC_NE,PG_IF_2_1
*      * CAUSE ASRA TO BE HANDLED BY TESTBEC6
*ZC     78         GO    TO,BEC5COMM
         J     PG_BEC5COMM
PG_IF_2_1  DS    0H  END_IF
*             EXEC CICS SEND FROM(TEST2) LENGTH(TEST2L) END-EXEC.
*ZC     80         EXEC  CICS,SEND,FROM(TEST2),LENGTH(TEST2L)
         LARL  R1,P0404         ADDRESS SOURCE
         LARL  R15,P0404        ADDRESS TARGET
         XC    0(P0404END-P0404,R15),0(R1) XC IT
         LARL  R1,=X'0404'         ADDRESS SOURCE
         LARL  R15,P0404FN        ADDRESS TARGET
         MVC   0(L'P0404FN,R15),0(R1) MVC IT
         LARL  R15,P0404LEN       ADDRESS TARGET
         MVC   0(2,R15),TEST2L   SET LENGTH FROM LABEL
         LA    R0,TEST2           FROM ADDRESS
         LARL  R1,P0404FRM         ADDRESS TARGET
         ST    R0,0(R1)      ST IT
         LARL  R1,P0404EIB         ADDRESS TARGET
         ST    DFHEIBR,0(R1)      ST IT
         LARL  R1,P0404TCT         ADDRESS TARGET
         ST    TCTTEAR,0(R1)      ST IT
         L     R15,TCTTELCL       R15=LCL MODULE INDEXER
         LARL  R1,=A(P0404)       R1=LCL MODULE PARAMETER LIST
         BAKR  0,R15              STACK REGS AND GO
*      *  DC    H'0'
*             ADD 1 TO BADFLD2.
*      * BEC5COMM EQU   *
*ZC     82         ADD   1,TO,BADFLD2
         BRAS  ZC_R14,3 SET ZC_R1 TO A(INLINE LIT) AND SKIP OVER IT
         DC    PL2'1'
         AP    BADFLD2,0(2,ZC_R14)
*         BEC5COMM.
PG_BEC5_END  L     ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
PG_BEC5COMM  DS    0H
*             EXEC CICS HANDLE ABEND PROGRAM('TESTBEC8') END-EXEC.
*ZC     85         EXEC  CICS,HANDLE,ABEND,PROGRAM('TESTBEC8')
         LARL  R1,P0E0E         ADDRESS SOURCE
         LARL  R15,P0E0E        ADDRESS TARGET
         XC    0(P0E0EEND-P0E0E,R15),0(R1) XC IT
         LARL  R1,=X'0E0E'         ADDRESS SOURCE
         LARL  R15,P0E0EFN        ADDRESS TARGET
         MVC   0(L'P0E0EFN,R15),0(R1) MVC IT
         LARL  R1,P0E0EEIB         ADDRESS TARGET
         ST    DFHEIBR,0(R1)      ST IT
         LARL  R1,P0E0ETCT         ADDRESS TARGET
         ST    TCTTEAR,0(R1)      ST IT
         LARL  R1,=CL8'TESTBEC8'         ADDRESS SOURCE
         LARL  R15,P0E0EPGM        ADDRESS TARGET
         MVC   0(L'P0E0EPGM,R15),0(R1) MVC IT
         LARL  R15,P0E0ECAP       ADDRESS TARGET
         MVC   0(4,R15),DFHEICAP  SET ANY COMMAREA ADDRESS
         LARL  R15,P0E0EREG       ADDRESS TARGET
         STM   R2,R13,0(R15)      SAVE CALLERS REGS
         L     R15,TCTTELCL       R15=LCL MODULE INDEXER
         LARL  R1,=A(P0E0E)       R1=LCL MODULE PARAMETER LIST
         BAKR  0,R15              STACK REGS AND GO
         J     P0E0EBYP_0296   EXIT
*
P0E0E    DS    0H
P0E0EFN  DS    XL2                FUNCTION CODE
P0E0EEIB DS    AL4                EIB
P0E0ETCT DS    AL4                TCTTE
P0E0ECAN DS    X                  FF=CANCEL
         DS    X
P0E0ERES DS    X                  FF=RESET
         DS    X
P0E0ELAB DS    AL4                LABEL
P0E0EPGM DS    CL8                PROGRAM
P0E0ECAP DS    AL4                COMMAREA ADDRESS FROM DFHEICAP
P0E0EREG DS    12AL4              CALLERS REGS R2-R13
P0E0ERSP DS    AL4                RESP
P0E0ERS2 DS    AL4                RESP2
P0E0EEND EQU   *                  END MARKER
         DS    0H
*
P0E0EBYP_0296 DS 0H
*             EXEC CICS SEND FROM(TEST3) LENGTH(TEST3L) END-EXEC.
*ZC     86         EXEC  CICS,SEND,FROM(TEST3),LENGTH(TEST3L)
         LARL  R1,P0404         ADDRESS SOURCE
         LARL  R15,P0404        ADDRESS TARGET
         XC    0(P0404END-P0404,R15),0(R1) XC IT
         LARL  R1,=X'0404'         ADDRESS SOURCE
         LARL  R15,P0404FN        ADDRESS TARGET
         MVC   0(L'P0404FN,R15),0(R1) MVC IT
         LARL  R15,P0404LEN       ADDRESS TARGET
         MVC   0(2,R15),TEST3L   SET LENGTH FROM LABEL
         LA    R0,TEST3           FROM ADDRESS
         LARL  R1,P0404FRM         ADDRESS TARGET
         ST    R0,0(R1)      ST IT
         LARL  R1,P0404EIB         ADDRESS TARGET
         ST    DFHEIBR,0(R1)      ST IT
         LARL  R1,P0404TCT         ADDRESS TARGET
         ST    TCTTEAR,0(R1)      ST IT
         L     R15,TCTTELCL       R15=LCL MODULE INDEXER
         LARL  R1,=A(P0404)       R1=LCL MODULE PARAMETER LIST
         BAKR  0,R15              STACK REGS AND GO
*      * CAUSE AEI0
*      * THIS IS 'REPLACED' BY XCTL TO TESTBEC8 WITH OUR COMMAREA
*             EXEC CICS LOAD PROGRAM('BADPROG7') END-EXEC.
*ZC     89         EXEC  CICS,LOAD,PROGRAM('BADPROG7')
         LARL  R1,P0E06         ADDRESS SOURCE
         LARL  R15,P0E06        ADDRESS TARGET
         XC    0(P0E06END-P0E06,R15),0(R1) XC IT
         LARL  R1,=X'0E06'         ADDRESS SOURCE
         LARL  R15,P0E06FN        ADDRESS TARGET
         MVC   0(L'P0E06FN,R15),0(R1) MVC IT
         LARL  R1,P0E06EIB         ADDRESS TARGET
         ST    DFHEIBR,0(R1)      ST IT
         LARL  R1,P0E06TCT         ADDRESS TARGET
         ST    TCTTEAR,0(R1)      ST IT
         LARL  R1,=CL8'BADPROG7'         ADDRESS SOURCE
         LARL  R15,P0E06PGM        ADDRESS TARGET
         MVC   0(L'P0E06PGM,R15),0(R1) MVC IT
         L     R15,TCTTELCL       R15=LCL MODULE INDEXER
         LARL  R1,=A(P0E06)       R1=LCL MODULE PARAMETER LIST
         BAKR  0,R15              STACK REGS AND GO
         LARL  R1,P0E06NOH         ADDRESS TARGET
         CLI   0(R1),X'FF'      CLI IT
         JE    P0E06IGN_0312   EXIT IF IT IS
         OC    EIBRESP,EIBRESP    ANY BAD RESPONSE ?
         JZ    P0E06IGN_0312   EXIT IF NONE
* PGMIDERR
         DC    AL3(0),C'ABEND'    MARKER FOR Z390KCP ESTAE
         DC    AL4(P0E06IGN_0312) ENTRYPOINT FOR IGNORE CONDITION
*
P0E06IGN_0312 EQU *
         J     P0E06BYP_0312   EXIT
*
P0E06    DS    0H
P0E06FN  DS    XL2                FUNCTION CODE
P0E06EIB DS    AL4                EIB
P0E06TCT DS    AL4                TCTTE
P0E06PGM DS    CL8                PROGRAM
P0E06LEN DS    AL4                ADDRESS OF LENGTH
P0E06FLN DS    AL4                ADDRESS OF FLENGTH
P0E06ENT DS    AL4                ENTRY POINT
P0E06NOH DS    X                  FF=NOHANDLE
         DS    X
P0E06RSP DS    AL4                RESP
P0E06RS2 DS    AL4                RESP2
P0E06END EQU   *                  END MARKER
         DS    0H
*
P0E06BYP_0312 DS 0H
PG_BEC5COMM_END  L     ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
SN_END_PROCEDURE  DS 0H SECTION
*        PROCEDURE END
         LH    ZC_R1,RETURN_CODE
         L     ZC_R15,ZCVT_GOBACK
         BASR  ZC_R14,ZC_R15
         LTORG
* ZCOBOL WORKING STORAGE SECTION DATA ITEMS
* LVL DATA NAME                      ADDR     LEN      DUP TYP PIC     X
                  VALUE
* 01  TEST1                          00000070 0000004C 1   X           X
                  
* 02  ZC_FILLER_V1                   00000070 00000004 1   X   X(4)    X
                  X''C311C761''
* 02  ZC_FILLER_V2                   00000074 00000023 1   X   X(35)   X
                  ''TESTBEC7 IN TRANSID BEC4 SAYS HELLO''
* 02  ZC_FILLER_V3                   00000097 00000003 1   X   X(3)    X
                  X''114AC1''
* 02  ZC_FILLER_V4                   0000009A 00000022 1   X   X(34)   X
                  ''BEC4 COMPLETED OK, NOW PRESS CLEAR''
* 01  TEST1L                         000000BC 00000002 1   H   9(4)    X
                  
* 01  TEST2                          000000BE 00000037 1   X           X
                  
* 02  ZC_FILLER_V5                   000000BE 00000004 1   X   X(4)    X
                  X''C311C261''
* 02  ZC_FILLER_V6                   000000C2 00000033 1   X   X(51)   X
                  ''TESTBEC7 IN TRANSID BEC5 SAYS HELLO AND ABENDS ASRAX
               ''
* 01  TEST2L                         000000F5 00000002 1   H   9(4)    X
                  
* 01  TEST3                          000000F7 00000037 1   X           X
                  
* 02  ZC_FILLER_V7                   000000F7 00000004 1   X   X(4)    X
                  X''C311C761''
* 02  ZC_FILLER_V8                   000000FB 00000033 1   X   X(51)   X
                  ''TESTBEC7 IN TRANSID BEC5 SAYS HELLO AND ABENDS AEI0X
               ''
* 01  TEST3L                         0000012E 00000002 1   H   9(4)    X
                  
* 01  BADFLD1                        00000130 00000002 1   H   9(4)    X
                  0
* 01  BADFLD2                        00000130 00000002 1   P   9(3)    X
                  
* 01  DEBUG_ITEM                     00000132 00000058 1   X           X
                  
* 02  DEBUG_LINE                     00000132 00000006 1   X   X(6)    X
                  
* 02  ZC_FILLER_V9                   00000138 00000001 1   X   X       X
                  SPACE
* 02  DEBUG_NAME                     00000139 0000001E 1   X   X(30)   X
                  
* 02  ZC_FILLER_V10                  00000157 00000001 1   X   X       X
                  SPACE
* 02  DEBUG_SUB_1                    00000158 00000004 1   Z   9999    X
                  
* 02  ZC_FILLER_V11                  0000015C 00000001 1   X   X       X
                  SPACE
* 02  DEBUG_SUB_2                    0000015D 00000004 1   Z   9999    X
                  
* 02  ZC_FILLER_V12                  00000161 00000001 1   X   X       X
                  SPACE
* 02  DEBUG_SUB_3                    00000162 00000004 1   Z   9999    X
                  
* 02  ZC_FILLER_V13                  00000166 00000001 1   X   X       X
                  SPACE
* 02  DEBUG_CONTENTS                 00000167 00000023 1   X   X(35)   X
                  
* 01  RETURN_CODE                    0000018A 00000002 1   H   9(4)    X
                  0
* 01  ZC_DFHCOMMAREA_PTR             0000018C 00000004 1   A           X
                  
* 01  ZC_DFHEIBLK_PTR                00000190 00000004 1   A           X
                  
* 01  ZC_ZC_LK_END_PTR               00000194 00000004 1   A           X
                  
DFHEISTG DSECT
ZC_WS_LOC_1 EQU *-ZC_WS CHECK TEST1 WS LOC
TEST1       DS  0CL76
ZC_WS_LOC_2 EQU *-ZC_WS CHECK ZC_FILLER_V1 WS LOC
ZC_FILLER_V1    DC XL4'C311C761'
ZC_WS_LOC_3 EQU *-ZC_WS CHECK ZC_FILLER_V2 WS LOC
ZC_FILLER_V2    DC CL35'TESTBEC7 IN TRANSID BEC4 SAYS HELLO'
ZC_WS_LOC_4 EQU *-ZC_WS CHECK ZC_FILLER_V3 WS LOC
ZC_FILLER_V3    DC XL3'114AC1'
ZC_WS_LOC_5 EQU *-ZC_WS CHECK ZC_FILLER_V4 WS LOC
ZC_FILLER_V4    DC CL34'BEC4 COMPLETED OK, NOW PRESS CLEAR'
ZC_WS_LOC_6 EQU *-ZC_WS CHECK TEST1L WS LOC
TEST1L      DS  HL2
ZC_WS_LOC_7 EQU *-ZC_WS CHECK TEST2 WS LOC
TEST2       DS  0CL55
ZC_WS_LOC_8 EQU *-ZC_WS CHECK ZC_FILLER_V5 WS LOC
ZC_FILLER_V5    DC XL4'C311C261'
ZC_WS_LOC_9 EQU *-ZC_WS CHECK ZC_FILLER_V6 WS LOC
ZC_FILLER_V6    DC CL51'TESTBEC7 IN TRANSID BEC5 SAYS HELLO AND ABENDS X
               ASRA'
ZC_WS_LOC_10 EQU *-ZC_WS CHECK TEST2L WS LOC
TEST2L      DS  HL2
ZC_WS_LOC_11 EQU *-ZC_WS CHECK TEST3 WS LOC
TEST3       DS  0CL55
ZC_WS_LOC_12 EQU *-ZC_WS CHECK ZC_FILLER_V7 WS LOC
ZC_FILLER_V7    DC XL4'C311C761'
ZC_WS_LOC_13 EQU *-ZC_WS CHECK ZC_FILLER_V8 WS LOC
ZC_FILLER_V8    DC CL51'TESTBEC7 IN TRANSID BEC5 SAYS HELLO AND ABENDS X
               AEI0'
ZC_WS_LOC_14 EQU *-ZC_WS CHECK TEST3L WS LOC
TEST3L      DS  HL2
ZC_WS_LOC_15 EQU *-ZC_WS CHECK BADFLD1 WS LOC
BADFLD1     DC AL2(0)                  RPI 1065
         ORG   BADFLD1  START REDEFINE
ZC_WS_LOC_16 EQU *-ZC_WS CHECK BADFLD2 WS LOC
BADFLD2     DS  PL2
ZC_WS_LOC_39 EQU *-ZC_WS CHECK DEBUG_ITEM WS LOC
DEBUG_ITEM    DS  0CL88
ZC_WS_LOC_40 EQU *-ZC_WS CHECK DEBUG_LINE WS LOC
DEBUG_LINE    DS  CL6
ZC_WS_LOC_41 EQU *-ZC_WS CHECK ZC_FILLER_V9 WS LOC
ZC_FILLER_V9    DC CL1' '
ZC_WS_LOC_42 EQU *-ZC_WS CHECK DEBUG_NAME WS LOC
DEBUG_NAME    DS  CL30
ZC_WS_LOC_43 EQU *-ZC_WS CHECK ZC_FILLER_V10 WS LOC
ZC_FILLER_V10    DC CL1' '
ZC_WS_LOC_44 EQU *-ZC_WS CHECK DEBUG_SUB_1 WS LOC
DEBUG_SUB_1    DS  ZL4
ZC_WS_LOC_45 EQU *-ZC_WS CHECK ZC_FILLER_V11 WS LOC
ZC_FILLER_V11    DC CL1' '
ZC_WS_LOC_46 EQU *-ZC_WS CHECK DEBUG_SUB_2 WS LOC
DEBUG_SUB_2    DS  ZL4
ZC_WS_LOC_47 EQU *-ZC_WS CHECK ZC_FILLER_V12 WS LOC
ZC_FILLER_V12    DC CL1' '
ZC_WS_LOC_48 EQU *-ZC_WS CHECK DEBUG_SUB_3 WS LOC
DEBUG_SUB_3    DS  ZL4
ZC_WS_LOC_49 EQU *-ZC_WS CHECK ZC_FILLER_V13 WS LOC
ZC_FILLER_V13    DC CL1' '
ZC_WS_LOC_50 EQU *-ZC_WS CHECK DEBUG_CONTENTS WS LOC
DEBUG_CONTENTS    DS  CL35
ZC_WS_LOC_51 EQU *-ZC_WS CHECK RETURN_CODE WS LOC
RETURN_CODE    DC AL2(0)                  RPI 1065
ZC_WS_LOC_52 EQU *-ZC_WS CHECK ZC_DFHCOMMAREA_PTR WS LOC
ZC_DFHCOMMAREA_PTR    DS  AL4
ZC_WS_LOC_53 EQU *-ZC_WS CHECK ZC_DFHEIBLK_PTR WS LOC
ZC_DFHEIBLK_PTR    DS  AL4
ZC_WS_LOC_54 EQU *-ZC_WS CHECK ZC_ZC_LK_END_PTR WS LOC
ZC_ZC_LK_END_PTR    DS  AL4
* ZCOBOL LINKAGE SECTION DATA ITEMS
* LVL DATA NAME                      ADDR     LEN      DUP TYP PIC     X
                  VALUE
* 01  DFHCOMMAREA                    00000000 00000054 1   X           X
                  
* 01  DFHEIBLK                       00000000 00000054 1   X           X
                  
* 02  EIBHEAD                        00000000 00000008 1   X   X(8)    X
                  
* 02  EIBTIME                        00000008 00000004 1   P   9(7)    X
                  
* 02  EIBDATE                        0000000C 00000004 1   P   9(7)    X
                  
* 02  EIBTRNID                       00000010 00000004 1   X   X(4)    X
                  
* 02  EIBTASKN                       00000014 00000004 1   P   9(7)    X
                  
* 02  EIBTRMID                       00000018 00000004 1   X   X(4)    X
                  
* 02  FILLER                         0000001C 00000002 1   X   X(2)    X
                  
* 02  EIBCPOSN                       0000001E 00000002 1   H   9(4)    X
                  
* 02  EIBCALEN                       00000020 00000002 1   H   9(4)    X
                  
* 02  EIBAID                         00000022 00000001 1   X   X       X
                  
* 02  EIBFN                          00000023 00000002 1   H   9(4)    X
                  
* 02  EIBRCODE                       00000025 00000006 1   X   X(6)    X
                  
* 02  EIBREQID                       0000002B 00000008 1   X   X(8)    X
                  
* 02  EIBDS                          00000033 00000008 1   X   X(8)    X
                  
* 02  EIBRSRCE                       0000003B 00000008 1   X   X(8)    X
                  
* 02  EIBRESP                        00000043 00000004 1   F   9(9)    X
                  
* 02  EIBRESP2                       00000047 00000004 1   F   9(9)    X
                  
* 02  EIBPROG                        0000004B 00000008 1   X   X(8)    X
                  
* 02  EIBDTFRM                       00000053 00000001 1   X   X       X
                  
* 01  ZC_LK_END                      00000000 00000001 1   X   X       X
                  
DFHEISTG DSECT
DFHCOMMAREA_DSECT   DSECT
ZC_LK_LOC_17 EQU *-DFHCOMMAREA CHECK DFHCOMMAREA LK LOC
DFHCOMMAREA    DS  0CL84
DFHEIBLK_DSECT   DSECT
ZC_LK_LOC_18 EQU *-DFHEIBLK CHECK DFHEIBLK LK LOC
DFHEIBLK    DS  0CL84
ZC_LK_LOC_19 EQU *-DFHEIBLK CHECK EIBHEAD LK LOC
EIBHEAD     DS  CL8
ZC_LK_LOC_20 EQU *-DFHEIBLK CHECK EIBTIME LK LOC
EIBTIME     DS  PL4
ZC_LK_LOC_21 EQU *-DFHEIBLK CHECK EIBDATE LK LOC
EIBDATE     DS  PL4
ZC_LK_LOC_22 EQU *-DFHEIBLK CHECK EIBTRNID LK LOC
EIBTRNID    DS  CL4
ZC_LK_LOC_23 EQU *-DFHEIBLK CHECK EIBTASKN LK LOC
EIBTASKN    DS  PL4
ZC_LK_LOC_24 EQU *-DFHEIBLK CHECK EIBTRMID LK LOC
EIBTRMID    DS  CL4
ZC_LK_LOC_25 EQU *-DFHEIBLK CHECK FILLER LK LOC
            DS  CL2
ZC_LK_LOC_26 EQU *-DFHEIBLK CHECK EIBCPOSN LK LOC
EIBCPOSN    DS  HL2
ZC_LK_LOC_27 EQU *-DFHEIBLK CHECK EIBCALEN LK LOC
EIBCALEN    DS  HL2
ZC_LK_LOC_28 EQU *-DFHEIBLK CHECK EIBAID LK LOC
EIBAID      DS  CL1
ZC_LK_LOC_29 EQU *-DFHEIBLK CHECK EIBFN LK LOC
EIBFN       DS  HL2
ZC_LK_LOC_30 EQU *-DFHEIBLK CHECK EIBRCODE LK LOC
EIBRCODE    DS  CL6
ZC_LK_LOC_31 EQU *-DFHEIBLK CHECK EIBREQID LK LOC
EIBREQID    DS  CL8
ZC_LK_LOC_32 EQU *-DFHEIBLK CHECK EIBDS LK LOC
EIBDS       DS  CL8
ZC_LK_LOC_33 EQU *-DFHEIBLK CHECK EIBRSRCE LK LOC
EIBRSRCE    DS  CL8
ZC_LK_LOC_34 EQU *-DFHEIBLK CHECK EIBRESP LK LOC
EIBRESP     DS  FL4
ZC_LK_LOC_35 EQU *-DFHEIBLK CHECK EIBRESP2 LK LOC
EIBRESP2    DS  FL4
ZC_LK_LOC_36 EQU *-DFHEIBLK CHECK EIBPROG LK LOC
EIBPROG     DS  CL8
ZC_LK_LOC_37 EQU *-DFHEIBLK CHECK EIBDTFRM LK LOC
EIBDTFRM    DS  CL1
ZC_LK_END_DSECT   DSECT
ZC_LK_LOC_38 EQU *-ZC_LK_END CHECK ZC_LK_END LK LOC
ZC_LK_END    DS  CL1
DFHEISTG DSECT
ZC_WS_DIFF EQU  *-ZC_WS-408  DIFF BETWEEN ALLOC AND CALC WS
ZC_WS_END DS   0D
         MNOTE *,'ZCOBOL TOTAL SYMBOLS                 = 54'
         MNOTE *,'ZCOBOL TOTAL SYMBOL DUPLICATES       = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL MAX DUP CHAIN    = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LEVEL 88         = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL SET INDEXES      = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LINKAGE SECTIONS = 3'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE SECTIONS      = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPHS    = 2'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPH DUP = 0'
DFHEISTG DSECT
         ORG
DFHEIEND EQU   *
         END
