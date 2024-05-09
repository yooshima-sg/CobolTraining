       IDENTIFICATION             DIVISION.
       PROGRAM-ID.                KJBM040.
      ********************************************************
      *  システム名   ：研修
      * サブシステム名：受注
      * プログラム名  ：受注データ得意先コードチェック
      * 作成日／作成者：２０１３年４月３０日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ********************************************************
       ENVIRONMENT                DIVISION.
       INPUT-OUTPUT               SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN  TO  EXTERNAL  ITF.
           SELECT  IMF-FILE  ASSIGN  TO  EXTERNAL  IMF.
           SELECT  OTF-FILE  ASSIGN  TO  EXTERNAL  OTF.
      *
       DATA                       DIVISION.
       FILE                       SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KJCF020.
       FD  IMF-FILE.
       01  IMF-REC.
           COPY  KCCFTOK.
       FD  OTF-FILE.
       01  OTF-REC.
           COPY  KJCF020.
      *
       WORKING-STORAGE            SECTION.
       01  WK-ITF-KEY             PIC   X(4)  VALUE  LOW-VALUE.
       01  WK-IMF-KEY             PIC   X(4)  VALUE  LOW-VALUE.
       01  WK-OLD-ITF-KEY         PIC   X(4)  VALUE  LOW-VALUE.
       01  ITF-CNT                PIC  S9(9)  VALUE  +0.
       01  IMF-CNT                PIC  S9(9)  VALUE  +0.
       01  OTF-CNT                PIC  S9(9)  VALUE  +0.
      *
      ********************************************************
      *  受注データ得意先コードチェック
      ********************************************************
       PROCEDURE                  DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  TOKU-CHECK-RTN  UNTIL  WK-ITF-KEY  =  HIGH-VALUE.
           PERFORM  TERM-RTN.
           STOP  RUN.
      ********************************************************
      *  開始処理
      ********************************************************
       INIT-RTN                   SECTION.
           DISPLAY  "*** KJBM040 START ***".
           OPEN  INPUT   ITF-FILE  IMF-FILE.
           OPEN  OUTPUT  OTF-FILE.
           PERFORM  ITF-READ-RTN.
           PERFORM  IMF-READ-RTN.
       EXT.
           EXIT.
      ********************************************************
      *  トラン入力処理
      ********************************************************
       ITF-READ-RTN               SECTION.
           READ  ITF-FILE  AT  END
               MOVE  HIGH-VALUE  TO  WK-ITF-KEY
           NOT  AT  END
               MOVE  JF020-TOKU-COD  OF  ITF-FILE  TO  WK-ITF-KEY
               ADD   +1   TO   ITF-CNT
           END-READ.
       EXT.
           EXIT.
      ********************************************************
      *  マスタ入力処理
      ********************************************************
       IMF-READ-RTN               SECTION.
           READ  IMF-FILE  AT  END
               MOVE  HIGH-VALUE  TO  WK-IMF-KEY
           NOT  AT  END
               MOVE  CFTOK-TOKU-COD  TO  WK-IMF-KEY
               ADD   +1   TO   IMF-CNT
           END-READ.
       EXT.
           EXIT.
      ********************************************************
      *  得意先チェック処理
      ********************************************************
       TOKU-CHECK-RTN             SECTION.
           EVALUATE  TRUE
             WHEN  WK-ITF-KEY  =  WK-IMF-KEY
               MOVE  WK-ITF-KEY  TO  WK-OLD-ITF-KEY
               PERFORM  MATCH-RTN
               PERFORM  ITF-READ-RTN
             WHEN  WK-ITF-KEY  <  WK-IMF-KEY
               MOVE  WK-ITF-KEY  TO  WK-OLD-ITF-KEY
               PERFORM  UN-MATCH-RTN
               PERFORM  ITF-READ-RTN
             WHEN  WK-ITF-KEY  >  WK-IMF-KEY
               PERFORM  IMF-READ-RTN
           END-EVALUATE.
       EXT.
           EXIT.
      ********************************************************
      *  マッチ処理
      ********************************************************
       MATCH-RTN                  SECTION.
           IF  JF020-ERR-KBN  OF  ITF-REC  (4)  =  SPACE
             MOVE  CFTOK-TOKU-MEI  TO  JF020-TOKU-MEI  OF  ITF-REC
           END-IF.
           PERFORM  WRITE-RTN.
       EXT.
           EXIT.
      ********************************************************
      *  アンマッチ処理
      ********************************************************
       UN-MATCH-RTN               SECTION.
           IF  JF020-ERR-KBN  OF  ITF-REC  (4)  =  SPACE
             MOVE  "2"  TO  JF020-ERR-KBN  OF  ITF-REC  (4)
           END-IF.
           PERFORM  WRITE-RTN.
       EXT.
           EXIT.
      ********************************************************
      *  出力処理
      ********************************************************
       WRITE-RTN                   SECTION.
           MOVE  ITF-REC  TO  OTF-REC.
           WRITE  OTF-REC.
           ADD  +1  TO  OTF-CNT.
      ********************************************************
      *  終了処理
      ********************************************************
       TERM-RTN                    SECTION.
           CLOSE  ITF-FILE  IMF-FILE  OTF-FILE.
           DISPLAY  "*** ITF-CNT="  ITF-CNT.
           DISPLAY  "*** IMF-CNT="  IMF-CNT.
           DISPLAY  "*** OTF-CNT="  OTF-CNT.
           DISPLAY  "*** KJBM040  END ***".
       EXT.
           EXIT.
