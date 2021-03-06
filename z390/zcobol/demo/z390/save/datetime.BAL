*    ZCOBOL PGM='zcobol\demo\datetime' VER=V1.5.06 MM/DD/YY  
*    ZCOBOL OPTIONS=() 
         COPY  datetime_ZC_LABELS.CPY
*        IDENTIFICATION DIVISION.
*        PROGRAM-ID.  FORMAT-DATE-EXAMPLE.
         PRINT NOLIST,NOGEN,NOLISTUSE    SET LIST OPTION FOR INTERNAL CX
               ODE
FORMAT_DATE_EXAMPLE CSECT ,                CSECT WITH PROCEDURE CODE ANX
               D WS
         USING *,ZC_R15
         STM   14,12,12+4*(14-14)(13)
         CNOP  4,8             FORCE ZC390PVT TO DOUBLEWORD BOUNDARY
         BRAS  ZC_R8,ZC_LOAD
         USING *,ZC_R8            BASE FOR LOAD AND CICS V5 USE
*
*  THESE FIELDS MUST BE KEPT IN SYNC WITH zcobol\ZC390PVT.CPY
*
         DC    CL8'FORMAT_DATE_EXAMPLE'    PVTPGM   ZCOBOL PGM NAME
         DC    CL8'01/02/05'   PVTDATE  ZCOBOL COMPILE DATE
         DC    CL8'22.33'   PVTTIME  ZCOBOL COMPILE TIME
         DC    CL8'V1.5.06'    PVTVER   ZCOBOL COMPILER VERSION
         DC    C'0'     PVTCICS  ZCOBOL EXEC CICS PGM
         DC    C'1'   PVTEXTND ZCOBOL EXTENDED PRECISION
         DC    C'0'    PVTTRUNC ZCOBOL TRUNCATE TO PICTURE
         DC    C'1'      PVTR64   ZCOBOL USE 64 BIT REGISTERS
         DC    H'80' MAX DISPLAY LINE LEN  RPI 1118
         DS    XL10            RESERVED
ZC_LOAD  DS    0H
         LA    0,=CL8'ZC390LIB'
         SR    15,15 USE DEFAULT SYS390 SEARCH
         SVC   8 LOAD R0=A(NAME) R15=DDNAME/DSNAME ADDR OR 0
         LTR   ZC_R15,ZC_R15
         JZ    ZC_LOAD_OK
         BRAS  1,*+(WTO#0011_EOT-*+1)/2*2
         DC    AL2(WTO#0011_EOT-*,0),C'ZC390LIB NOT FOUND'
WTO#0011_EOT     EQU *
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
         BRAS  1,*+(WTO#0012_EOT-*+1)/2*2
         DC    AL2(WTO#0012_EOT-*,0),C'ZC390LIB ZCVT VERIFY ERROR'
WTO#0012_EOT     EQU *
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
         L     ZC_R2,24(ZC_R13) SET ZC_R2=PARMLIST ADDRESS AFTER LOAD
         LARL  ZC_R1,ZC_WS     ZC_R2=A(WORKING STORAGE WITH SAVEAREA)
         ST    ZC_R1,8(ZC_R13) FORWARD  SAVE CHAIN
         ST    ZC_R13,4(ZC_R1) BACKWARD SAVE CHAIN
         LR    ZC_R13,ZC_R1    LINK SAVE AREA IN ZC390CVT
         USING ZC_WS,ZC_R13    BASE FOR ZCOBOL WS (SEE GEN_SYM_RX.MAC)
         ST    ZC_R13,ZC_WS_START  SAVE ADDR WS IN WS PREFIX
         LARL  ZC_R0,ZC_WS_END
         SR    ZC_R0,ZC_R13
         ST    ZC_R0,ZC_WS_LEN     SAVE LENGTH OF WS IN WS PREFIX
         DROP  ZC_R15              RPI 1042
ZC_WSLOC LOCTR 
ZC_WS    DS    0D           START WORKING STORAGE
ZC390CVT DSECT 
ZCVT_ID            DC    C'ZCVT'             ZCVT ID  VERIFIED BY ZCOB
ZCVT_LEN           DC    A(ZCVT_END-ZCVT_ID) ZCVT LEN VERIFIED BY ZCOB
ZCVT_VER           DC    CL8'V1.5.06'    ZCVT VER VERIFIED BY ZC390NUC
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
ZCVT_PVTMAXDL  DS H          MAXIMUM DISPLAY LINE LENGTH  RPI 1118
               DS 0D
ZCVT_ZERO      DC XL16'00'   BINARY ZEROS
ZCVT_HIGH_VALUES DC 0XL16,16X'FF' BINARY FF'S     RPI 1181
ZCVT_PWORK     DS PL8        CVD/CVB WORK
ZCVT_PWORK1    DS PL16       DIV DIVIDEND, CVDG/CVBG WORK
ZCVT_PWORK2    DS PL16       DIV DIVISOR
ZCVT_PWORK3    DS PL16       DIV QUOTIENT
ZCVT_PWORK4    DS PL16       DIV REMAINDER
ZCVT_NDDX      DS XL16       DIV DIVIDEND HOLD AREA
ZCVT_WORKAREA  DS XL256      GEN_INSPECT PARMS, GEN_EDIT WORK, ETC.
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
PVTMAXDL DS    H    ZCOBOL MAX DISPLAY LINE LENGTH
         DS    XL10 RESERVED
ZC_WSLOC LOCTR              CONTINUE WS FOR FD AND DATA
*        AUTHOR.      BILL ROGERS.
*      * http://web.sxu.edu/rogers/cobol/datetime.html
*        ENVIRONMENT DIVISION.
*        DATA DIVISION.
         PRINT DATA
*        WORKING-STORAGE SECTION.
*        01 SYSTEM-WEEKDAY            PIC 9.
*        01 SYSTEM-DATE.
*           02 SYSTEM-YEAR            PIC 99.
*           02 SYSTEM-MONTH           PIC 99.
*           02 SYSTEM-DAY             PIC 99.
*        01 SYSTEM-TIME.
*           02 SYSTEM-HOUR            PIC 99.
*           02 SYSTEM-MINUTE          PIC 99.
*           02 SYSTEM-SECOND          PIC 99.
*           02 SYSTEM-HUNDREDTH       PIC 99.
*        01 HEADER-LINE.
*           02 HEADER-WEEKDAY         PIC X(3).
*           02                        PIC X        VALUE SPACE.
*           02 HEADER-MONTH           PIC X(3).
*           02                        PIC X        VALUE SPACE.
*           02 HEADER-DAY             PIC Z9.
*           02                        PIC X        VALUE SPACE.
*           02 HEADER-HOUR            PIC Z9.
*           02                        PIC X        VALUE ':'.
*           02 HEADER-MINUTE          PIC 99.
*           02                        PIC X        VALUE SPACE.
*           02 HEADER-AM-PM           PIC X(2).
*        PROCEDURE DIVISION.
*ZC   PROCEDURE DIVISION
         PRINT LIST,GEN,LISTUSE TURN PRINT LISTING ON FOR USER CODE GEN
FORMAT_DATE_EXAMPLE CSECT     SWITCH TO PROCEDURE CODE AHEAD OF WS
*        MAINLINE.
PG_MAINLINE DS 0H
*            DISPLAY 'DATETIME STARTED'
*ZC     32         DISPLAY 'DATETIME STARTED'
         BRAS  1,*+(WTO#0135_EOT-*+1)/2*2
         DC    AL2(WTO#0135_EOT-*,0),C'DATETIME STARTED'
WTO#0135_EOT     EQU *
         SVC   35
*            ACCEPT SYSTEM-WEEKDAY FROM DAY-OF-WEEK.
*ZC     33         ACCEPT SYSTEM_WEEKDAY,FROM,DAY_OF_WEEK
         LA    ZC_R2,SYSTEM_WEEKDAY
         LARL  ZC_R1,=A(ZCVT_ACCEPT_DOW,1)
         L     ZC_R15,ZCVT_ACCEPT
         BASR  ZC_R14,ZC_R15
*            ACCEPT SYSTEM-DATE FROM DATE.
*ZC     34         ACCEPT SYSTEM_DATE,FROM,DATE
         LA    ZC_R2,SYSTEM_DATE
         LARL  ZC_R1,=A(ZCVT_ACCEPT_DATE,6)
         L     ZC_R15,ZCVT_ACCEPT
         BASR  ZC_R14,ZC_R15
*            ACCEPT SYSTEM-TIME FROM TIME.
*ZC     35         ACCEPT SYSTEM_TIME,FROM,TIME
         LA    ZC_R2,SYSTEM_TIME
         LARL  ZC_R1,=A(ZCVT_ACCEPT_TIME,8)
         L     ZC_R15,ZCVT_ACCEPT
         BASR  ZC_R14,ZC_R15
*            EVALUATE SYSTEM-WEEKDAY
*ZC     36         EVALUATE SYSTEM_WEEKDAY
*                WHEN  2  MOVE 'Mon' TO HEADER-WEEKDAY
*ZC     37         WHEN  2
PG_EVAL1_WHEN1 DS  0H  &TYPE
         CLI   SYSTEM_WEEKDAY,C'2'
         BRC   ZC_NE,PG_EVAL1_WHEN2
*ZC     37         MOVE  'Mon',TO,HEADER_WEEKDAY
         LARL  ZC_R1,=CL4'Mon'
          MVC   HEADER_WEEKDAY,0(ZC_R1)
*                WHEN  3  MOVE 'Tue' TO HEADER-WEEKDAY
*ZC     38         WHEN  3
         J     PG_EVAL1_END
PG_EVAL1_WHEN2 DS  0H  &TYPE
         CLI   SYSTEM_WEEKDAY,C'3'
         BRC   ZC_NE,PG_EVAL1_WHEN3
*ZC     38         MOVE  'Tue',TO,HEADER_WEEKDAY
         LARL  ZC_R1,=CL4'Tue'
          MVC   HEADER_WEEKDAY,0(ZC_R1)
*                WHEN  4  MOVE 'Wed' TO HEADER-WEEKDAY
*ZC     39         WHEN  4
         J     PG_EVAL1_END
PG_EVAL1_WHEN3 DS  0H  &TYPE
         CLI   SYSTEM_WEEKDAY,C'4'
         BRC   ZC_NE,PG_EVAL1_WHEN4
*ZC     39         MOVE  'Wed',TO,HEADER_WEEKDAY
         LARL  ZC_R1,=CL4'Wed'
          MVC   HEADER_WEEKDAY,0(ZC_R1)
*                WHEN  5  MOVE 'Thu' TO HEADER-WEEKDAY
*ZC     40         WHEN  5
         J     PG_EVAL1_END
PG_EVAL1_WHEN4 DS  0H  &TYPE
         CLI   SYSTEM_WEEKDAY,C'5'
         BRC   ZC_NE,PG_EVAL1_WHEN5
*ZC     40         MOVE  'Thu',TO,HEADER_WEEKDAY
         LARL  ZC_R1,=CL4'Thu'
          MVC   HEADER_WEEKDAY,0(ZC_R1)
*                WHEN  6  MOVE 'Fri' TO HEADER-WEEKDAY
*ZC     41         WHEN  6
         J     PG_EVAL1_END
PG_EVAL1_WHEN5 DS  0H  &TYPE
         CLI   SYSTEM_WEEKDAY,C'6'
         BRC   ZC_NE,PG_EVAL1_WHEN6
*ZC     41         MOVE  'Fri',TO,HEADER_WEEKDAY
         LARL  ZC_R1,=CL4'Fri'
          MVC   HEADER_WEEKDAY,0(ZC_R1)
*                WHEN  7  MOVE 'Sat' TO HEADER-WEEKDAY
*ZC     42         WHEN  7
         J     PG_EVAL1_END
PG_EVAL1_WHEN6 DS  0H  &TYPE
         CLI   SYSTEM_WEEKDAY,C'7'
         BRC   ZC_NE,PG_EVAL1_WHEN7
*ZC     42         MOVE  'Sat',TO,HEADER_WEEKDAY
         LARL  ZC_R1,=CL4'Sat'
          MVC   HEADER_WEEKDAY,0(ZC_R1)
*                WHEN  1  MOVE 'Sun' TO HEADER-WEEKDAY
*ZC     43         WHEN  1
         J     PG_EVAL1_END
PG_EVAL1_WHEN7 DS  0H  &TYPE
         CLI   SYSTEM_WEEKDAY,C'1'
         BRC   ZC_NE,PG_EVAL1_WHEN8
*ZC     43         MOVE  'Sun',TO,HEADER_WEEKDAY
         LARL  ZC_R1,=CL4'Sun'
          MVC   HEADER_WEEKDAY,0(ZC_R1)
*            END-EVALUATE.
*ZC     44         END_EVALUATE
PG_EVAL1_WHEN8 DS  0H  &TYPE
PG_EVAL1_END DS    0H  &TYPE
*            EVALUATE SYSTEM-MONTH
*ZC     45         EVALUATE SYSTEM_MONTH
*                WHEN  1  MOVE 'Jan' TO HEADER-MONTH
*ZC     46         WHEN  1
PG_EVAL2_WHEN1 DS  0H  &TYPE
         LARL  ZC_R1,=C'01'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN2
*ZC     46         MOVE  'Jan',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Jan'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN  2  MOVE 'Feb' TO HEADER-MONTH
*ZC     47         WHEN  2
         J     PG_EVAL2_END
PG_EVAL2_WHEN2 DS  0H  &TYPE
         LARL  ZC_R1,=C'02'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN3
*ZC     47         MOVE  'Feb',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Feb'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN  3  MOVE 'Mar' TO HEADER-MONTH
*ZC     48         WHEN  3
         J     PG_EVAL2_END
PG_EVAL2_WHEN3 DS  0H  &TYPE
         LARL  ZC_R1,=C'03'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN4
*ZC     48         MOVE  'Mar',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Mar'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN  4  MOVE 'Apr' TO HEADER-MONTH
*ZC     49         WHEN  4
         J     PG_EVAL2_END
PG_EVAL2_WHEN4 DS  0H  &TYPE
         LARL  ZC_R1,=C'04'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN5
*ZC     49         MOVE  'Apr',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Apr'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN  5  MOVE 'May' TO HEADER-MONTH
*ZC     50         WHEN  5
         J     PG_EVAL2_END
PG_EVAL2_WHEN5 DS  0H  &TYPE
         LARL  ZC_R1,=C'05'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN6
*ZC     50         MOVE  'May',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'May'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN  6  MOVE 'Jun' TO HEADER-MONTH
*ZC     51         WHEN  6
         J     PG_EVAL2_END
PG_EVAL2_WHEN6 DS  0H  &TYPE
         LARL  ZC_R1,=C'06'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN7
*ZC     51         MOVE  'Jun',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Jun'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN  7  MOVE 'Jul' TO HEADER-MONTH
*ZC     52         WHEN  7
         J     PG_EVAL2_END
PG_EVAL2_WHEN7 DS  0H  &TYPE
         LARL  ZC_R1,=C'07'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN8
*ZC     52         MOVE  'Jul',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Jul'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN  8  MOVE 'Aug' TO HEADER-MONTH
*ZC     53         WHEN  8
         J     PG_EVAL2_END
PG_EVAL2_WHEN8 DS  0H  &TYPE
         LARL  ZC_R1,=C'08'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN9
*ZC     53         MOVE  'Aug',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Aug'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN  9  MOVE 'Sep' TO HEADER-MONTH
*ZC     54         WHEN  9
         J     PG_EVAL2_END
PG_EVAL2_WHEN9 DS  0H  &TYPE
         LARL  ZC_R1,=C'09'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN10
*ZC     54         MOVE  'Sep',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Sep'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN 10  MOVE 'Oct' TO HEADER-MONTH
*ZC     55         WHEN  10
         J     PG_EVAL2_END
PG_EVAL2_WHEN10 DS 0H  &TYPE
         LARL  ZC_R1,=C'10'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN11
*ZC     55         MOVE  'Oct',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Oct'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN 11  MOVE 'Nov' TO HEADER-MONTH
*ZC     56         WHEN  11
         J     PG_EVAL2_END
PG_EVAL2_WHEN11 DS 0H  &TYPE
         LARL  ZC_R1,=C'11'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN12
*ZC     56         MOVE  'Nov',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Nov'
          MVC   HEADER_MONTH,0(ZC_R1)
*                WHEN 12  MOVE 'Dec' TO HEADER-MONTH
*ZC     57         WHEN  12
         J     PG_EVAL2_END
PG_EVAL2_WHEN12 DS 0H  &TYPE
         LARL  ZC_R1,=C'12'
         CLC   SYSTEM_MONTH,0(ZC_R1)
         BRC   ZC_NE,PG_EVAL2_WHEN13
*ZC     57         MOVE  'Dec',TO,HEADER_MONTH
         LARL  ZC_R1,=CL4'Dec'
          MVC   HEADER_MONTH,0(ZC_R1)
*            END-EVALUATE.
*ZC     58         END_EVALUATE
PG_EVAL2_WHEN13 DS 0H  &TYPE
PG_EVAL2_END DS    0H  &TYPE
*            MOVE SYSTEM-DAY TO HEADER-DAY.
*ZC     59         MOVE  SYSTEM_DAY,TO,HEADER_DAY
         PACK  ZCVT_PWORK(8),0+SYSTEM_DAY(2) PACK #1 NORMAL
         LARL  ZC_R1,=AL1(C' ',X'20',X'21',X'20')
         MVC   ZCVT_WORKAREA(4),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(4),8-2+ZCVT_PWORK
         MVC   HEADER_DAY,ZCVT_WORKAREA+2
*            IF SYSTEM-HOUR IS LESS THAN 12
*ZC     60         IF    SYSTEM_HOUR,IS,LESS,THAN,12
         LARL  ZC_R1,=C'12'
         CLC   SYSTEM_HOUR,0(ZC_R1)
         BRC   15-ZC_L,PG_IF_1_1
*               MOVE 'AM' TO HEADER-AM-PM
*            ELSE
*ZC     61         MOVE  'AM',TO,HEADER_AM_PM
         LARL  ZC_R1,=CL2'AM'
          MVC   HEADER_AM_PM,0(ZC_R1)
*               MOVE 'PM' TO HEADER-AM-PM
*ZC     63         ELSE
         J     PG_IF_1_E
PG_IF_1_1    DS    0H  &TYPE
*ZC     63         MOVE  'PM',TO,HEADER_AM_PM
         LARL  ZC_R1,=CL2'PM'
          MVC   HEADER_AM_PM,0(ZC_R1)
*               IF SYSTEM-HOUR IS NOT LESS THAN 13
*ZC     64         IF    SYSTEM_HOUR,IS,NOT,LESS,THAN,13
         LARL  ZC_R1,=C'13'
         CLC   SYSTEM_HOUR,0(ZC_R1)
         BRC   15-ZC_GE,PG_IF_2_1
*                  SUBTRACT 12 FROM SYSTEM-HOUR
*               END-IF
*ZC     65         SUBTRACT 12,FROM,SYSTEM_HOUR
         PACK  ZCVT_PWORK1(2),0+SYSTEM_HOUR(2) PACK #1 NORMAL
         LARL  ZC_R14,=PL4'12'
         SP    ZCVT_PWORK1(2),0(4,ZC_R14)
         UNPK  0+SYSTEM_HOUR(2),0+ZCVT_PWORK1(2) UNPK #1 NORMAL
         OI    2-1+SYSTEM_HOUR,X'F0'  RPI 1065
*            END-IF.
*ZC     67         END_IF
PG_IF_2_1    DS    0H  &TYPE
*ZC     67         END_IF
PG_IF_1_E    DS    0H  &TYPE
*            MOVE SYSTEM-HOUR TO HEADER-HOUR.
*ZC     68         MOVE  SYSTEM_HOUR,TO,HEADER_HOUR
         PACK  ZCVT_PWORK(8),0+SYSTEM_HOUR(2) PACK #1 NORMAL
         LARL  ZC_R1,=AL1(C' ',X'20',X'21',X'20')
         MVC   ZCVT_WORKAREA(4),0(ZC_R1) MOVE MASK FOR ED
         ED    ZCVT_WORKAREA(4),8-2+ZCVT_PWORK
         MVC   HEADER_HOUR,ZCVT_WORKAREA+2
*            MOVE SYSTEM-MINUTE TO HEADER-MINUTE.
*ZC     69         MOVE  SYSTEM_MINUTE,TO,HEADER_MINUTE
         MVC   HEADER_MINUTE,2-2+SYSTEM_MINUTE ALN RIGHT 9ZP
*            DISPLAY HEADER-LINE.
*ZC     70         DISPLAY HEADER_LINE
         LA    ZC_R3,ZCVT_WORKAREA  ZC_R3=CVT LIST WORK AREA
         LA    ZC_R0,HEADER_LINE
         LA    ZC_R1,19  RPI 1182 WAS &SYM_LEN(&FIELD_IX)
         LA    ZC_R2,C'X'
         STM   ZC_R0,ZC_R2,0(ZC_R3)  SET DISPLAY LIST ENTRY
         OI    12-4(ZC_R3),X'80' SET VL BIT IN LAST WORD OF PARM LIST
         LR    ZC_R1,ZC_R3
         L     ZC_R15,ZCVT_DISPLAY
         BASR  ZC_R14,ZC_R15
*            DISPLAY 'DATATIME ENDED OK'
*ZC     71         DISPLAY 'DATATIME ENDED OK'
         BRAS  1,*+(WTO#0452_EOT-*+1)/2*2
         DC    AL2(WTO#0452_EOT-*,0),C'DATATIME ENDED OK'
WTO#0452_EOT     EQU *
         SVC   35
*            STOP RUN.
*ZC     72         STOP  RUN
         LH    ZC_R1,RETURN_CODE      PASS RETURN CODE IN R1
         L     ZC_R15,ZCVT_GOBACK
         BR    ZC_R15
PG_MAINLINE_END L ZC_R15,ZCVT_PMCHECK
         BASR  ZC_R14,ZC_R15 CHECK FOR END OF CURRENT PERFORM
SN_END_PROCEDURE DS 0H SECTION
*        PROCEDURE END
         LH    ZC_R1,RETURN_CODE
         L     ZC_R15,ZCVT_GOBACK
         BASR  ZC_R14,ZC_R15
         LTORG 
*    ZCOBOL WORKING STORAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
*    01  ZC_SAVEAREA                    00000000 00000048 1   X   X(72)X
                      
*    01  ZC_WS_ID                       00000048 00000008 1   X   X(8) X
                     ''WS*WS*WS'' 
*    01  ZC_WS_START                    00000050 00000004 1   A        X
                      
*    01  ZC_WS_LEN                      00000054 00000004 1   F   9(9) X
                      
*    01  FILLER                         00000058 00000000 1   X        X
                      
*    01  SYSTEM_WEEKDAY                 00000058 00000001 1   Z   9    X
                      
*    01  SYSTEM_DATE                    00000059 00000006 1   X        X
                      
*    02  SYSTEM_YEAR                    00000059 00000002 1   Z   99   X
                      
*    02  SYSTEM_MONTH                   0000005B 00000002 1   Z   99   X
                      
*    02  SYSTEM_DAY                     0000005D 00000002 1   Z   99   X
                      
*    01  SYSTEM_TIME                    0000005F 00000008 1   X        X
                      
*    02  SYSTEM_HOUR                    0000005F 00000002 1   Z   99   X
                      
*    02  SYSTEM_MINUTE                  00000061 00000002 1   Z   99   X
                      
*    02  SYSTEM_SECOND                  00000063 00000002 1   Z   99   X
                      
*    02  SYSTEM_HUNDREDTH               00000065 00000002 1   Z   99   X
                      
*    01  HEADER_LINE                    00000067 00000013 1   X        X
                      
*    02  HEADER_WEEKDAY                 00000067 00000003 1   X   X(3) X
                      
*    02  FILLER                         0000006A 00000001 1   X   X    X
                     SPACE 
*    02  HEADER_MONTH                   0000006B 00000003 1   X   X(3) X
                      
*    02  FILLER                         0000006E 00000001 1   X   X    X
                     SPACE 
*    02  HEADER_DAY                     0000006F 00000002 1   X   Z9   X
                      
*    02  FILLER                         00000071 00000001 1   X   X    X
                     SPACE 
*    02  HEADER_HOUR                    00000072 00000002 1   X   Z9   X
                      
*    02  FILLER                         00000074 00000001 1   X   X    X
                     '':'' 
*    02  HEADER_MINUTE                  00000075 00000002 1   Z   99   X
                      
*    02  FILLER                         00000077 00000001 1   X   X    X
                     SPACE 
*    02  HEADER_AM_PM                   00000078 00000002 1   X   X(2) X
                      
*    01  DEBUG_ITEM                     0000007A 00000058 1   X        X
                      
*    02  DEBUG_LINE                     0000007A 00000006 1   X   X(6) X
                      
*    02  FILLER                         00000080 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_NAME                     00000081 0000001E 1   X   X(30)X
                      
*    02  FILLER                         0000009F 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_1                    000000A0 00000004 1   Z   9999 X
                      
*    02  FILLER                         000000A4 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_2                    000000A5 00000004 1   Z   9999 X
                      
*    02  FILLER                         000000A9 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_SUB_3                    000000AA 00000004 1   Z   9999 X
                      
*    02  FILLER                         000000AE 00000001 1   X   X    X
                     SPACE 
*    02  DEBUG_CONTENTS                 000000AF 00000023 1   X   X(35)X
                      
*    01  TRUE                           000000D2 00000001 1   Z   9    X
                     1 
*    01  FALSE                          000000D3 00000001 1   Z   9    X
                     0 
*    01  RETURN_CODE                    000000D4 00000002 1   H   9(4) X
                     0 
ZC_WSLOC LOCTR 
ZC_WS_LOC_1  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_SAVEAREA DS CL72
ZC_WS_LOC_2  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_WS_ID DC CL8'WS*WS*WS'
ZC_WS_LOC_3  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_WS_START DS AL4
ZC_WS_LOC_4  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
ZC_WS_LEN DS FL4
ZC_WS_LOC_5  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DS  0CL0
ZC_WS_LOC_6  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SYSTEM_WEEKDAY DS ZL1
ZC_WS_LOC_7  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SYSTEM_DATE DS 0CL6
ZC_WS_LOC_8  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SYSTEM_YEAR DS ZL2
ZC_WS_LOC_9  EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SYSTEM_MONTH DS ZL2
ZC_WS_LOC_10 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SYSTEM_DAY DS ZL2
ZC_WS_LOC_11 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SYSTEM_TIME DS 0CL8
ZC_WS_LOC_12 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SYSTEM_HOUR DS ZL2
ZC_WS_LOC_13 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SYSTEM_MINUTE DS ZL2
ZC_WS_LOC_14 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SYSTEM_SECOND DS ZL2
ZC_WS_LOC_15 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
SYSTEM_HUNDREDTH DS ZL2
ZC_WS_LOC_16 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
HEADER_LINE DS 0CL19
ZC_WS_LOC_17 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
HEADER_WEEKDAY DS CL3
ZC_WS_LOC_18 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_19 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
HEADER_MONTH DS CL3
ZC_WS_LOC_20 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_21 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
HEADER_DAY DS CL2
ZC_WS_LOC_22 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_23 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
HEADER_HOUR DS CL2
ZC_WS_LOC_24 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1':'
ZC_WS_LOC_25 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
HEADER_MINUTE DS ZL2
ZC_WS_LOC_26 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_27 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
HEADER_AM_PM DS CL2
ZC_WS_LOC_28 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_ITEM DS 0CL88
ZC_WS_LOC_29 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_LINE DS CL6
ZC_WS_LOC_30 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_31 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_NAME DS CL30
ZC_WS_LOC_32 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_33 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_1 DS ZL4
ZC_WS_LOC_34 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_35 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_2 DS ZL4
ZC_WS_LOC_36 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_37 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_SUB_3 DS ZL4
ZC_WS_LOC_38 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
         DC CL1' '
ZC_WS_LOC_39 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
DEBUG_CONTENTS DS CL35
ZC_WS_LOC_40 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
TRUE     DC CL1'1'
ZC_WS_LOC_41 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
FALSE    DC CL1'0'
ZC_WS_LOC_42 EQU *-ZC_WS CHECK &SYM_NAME(&I) WS LOC
RETURN_CODE DC AL2(0)                  RPI 1065
*    ZCOBOL LINKAGE SECTION DATA ITEMS 
*    LVL DATA NAME                      ADDR     LEN      DUP TYP PIC  X
                     VALUE 
ZC_WSLOC LOCTR 
ZC_WSLOC LOCTR 
ZC_WS_DIFF EQU  *-ZC_WS-214  DIFF BETWEEN ALLOC AND CALC WS
ZC_WS_END DS   0D
         MNOTE *,'ZCOBOL TOTAL SYMBOLS                 = 42'
         MNOTE *,'ZCOBOL TOTAL SYMBOL DUPLICATES       = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL MAX DUP CHAIN    = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LEVEL 88         = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL SET INDEXES      = 0'
         MNOTE *,'ZCOBOL TOTAL SYMBOL LINKAGE SECTIONS = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE SECTIONS      = 0'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPHS    = 1'
         MNOTE *,'ZCOBOL TOTAL PROCEDURE PARAGRAPH DUP = 0'
         END 
