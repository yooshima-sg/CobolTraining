       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         KUBM030A.
      ************************************************
      * システム名    ：研修
      * サブシステム名：売上
      * プログラム名  ：売上更新
      * 作成日／作成者：２０２３年１月２４日  システム技研
      * 変更日／変更者：
      *       変更内容：GnuCOBOL + OpenCOBOL ESQL向け
      *                 いくつかサポートしていない機能を代替。
      ************************************************
      *
       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.
      *
       SELECT ITF-FILE ASSIGN EXTERNAL ITF.
      *
       DATA                DIVISION.
       FILE                SECTION.
       FD ITF-FILE.
       01 ITF-REC.
         COPY KUCF020.

       WORKING-STORAGE     SECTION.
       01 WK-ITF-END-FLG   PIC  X VALUE "N".
       01 WK-ITF-CNT       PIC  9(9) PACKED-DECIMAL VALUE 0.
      *
       01 WK-DBERR-FLG     PIC  X VALUE "N".
       01 WK-DBUPDATE-CNT  PIC  9(9) PACKED-DECIMAL VALUE 0.
      *
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
      * ocesqlが COPY句の解析に未対応のため、テーブル更新に必要な
      * 一意名の定義をCOPYファイルから拝借して利用する。
      * COPY句が解釈できるプリプロセッサを利用している場合は、必ず
      * COPY句を使うこと。
      *
      * COPY KCCMTOK.
       01 CMTOK-TOKU-COD     PIC  X(04).
       01 CMTOK-URIKAKE-YM   PIC  X(06).
       01 CMTOK-URIAGE-GAKU  PIC S9(09).
       01 WK-DB-DUMMY        PIC  X(4).
      *
       01 DBNAME           PIC  X(32) VALUE "$$DBNAME$$@$$SERVER$$".    *> 【要変更】データベース@接続先サーバ名
       01 USERNAME         PIC  X(32) VALUE "$$USERNAME$$".             *> 【要変更】ユーザ名
       01 PASSWORD         PIC  X(32) VALUE "$$PASSWORD$$".             *> 【要変更】パスワード
       EXEC SQL END DECLARE SECTION END-EXEC.
      *
       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE           DIVISION.
           PERFORM INIT-RTN.
           PERFORM MAIN-RTN UNTIL WK-ITF-END-FLG = "Y".
           PERFORM SUCCESSFUL-TERM-RTN.
      *
       INIT-RTN            SECTION.
           DISPLAY  "*** KUBM030 START ***".
      *
           OPEN INPUT ITF-FILE.
      *
           EXEC SQL
             CONNECT :USERNAME
             IDENTIFIED BY :PASSWORD
             USING :DBNAME
           END-EXEC.
           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.
      *
           PERFORM READ-RTN.
       EXT.
           EXIT.

       MAIN-RTN            SECTION.
      * ocesql プリプロセッサがWHENEVER文をサポートしていない為、
      * 代替案として、事前にキー項目を持つデータが存在するかSELECTし、
      * 確認する方法(1)をとる。
      *
      * なお、UPDATE命令実行時に更新対象となるレコードが0件だった時
      * それが、NOT FOUND 条件に当てはまるかどうかは、RDBMSの実装に
      * よって異なるため、利用する場合は事前にマニュアル等をチェック
      * しておくこと。
      *    EXEC SQL
      *      WHENEVER NOT FOUND GO TO :DBERR-TERM-RTN
      *    END-EXEC.

           MOVE UF020-TOKU-COD TO CMTOK-TOKU-COD.
           MOVE UF020-JUCHU-DATE TO CMTOK-URIKAKE-YM.
           MOVE UF020-KINGAKU TO CMTOK-URIAGE-GAKU.
      * (1) ここから ----
           EXEC SQL
             SELECT CMTOK_TOKU_COD INTO :WK-DB-DUMMY
               FROM KCCMTOK
               WHERE CMTOK_TOKU_COD = :CMTOK-TOKU-COD AND
                     CMTOK_URIKAKE_YM = :CMTOK-URIKAKE-YM
           END-EXEC.
           PERFORM DISPLAY-SQLCA-RTN.
           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.
      * (1) ここまで ---
           EXEC SQL
             UPDATE KCCMTOK
             SET
               CMTOK_URIAGE_GAKU =
                   CMTOK_URIAGE_GAKU + :CMTOK-URIAGE-GAKU,
               CMTOK_URIKAKE_ZAN =
                   CMTOK_URIKAKE_ZAN + :CMTOK-URIAGE-GAKU
             WHERE
               CMTOK_TOKU_COD = :CMTOK-TOKU-COD AND
               CMTOK_URIKAKE_YM = :CMTOK-URIKAKE-YM
           END-EXEC.
           ADD +1 TO WK-DBUPDATE-CNT.
      *
           PERFORM READ-RTN.
       EXT.
           EXIT.

       READ-RTN            SECTION.
           READ ITF-FILE
             AT END
               MOVE "Y" TO WK-ITF-END-FLG
             NOT AT END
               ADD +1 TO WK-ITF-CNT
           END-READ.
       EXT.
           EXIT.

       DISPLAY-SQLCA-RTN    SECTION.
           DISPLAY "SQLCA:CODE=" SQLCODE
                   ", STATE=" SQLSTATE
                   ",ERRM=" SQLERRM.
       EXT.
           EXIT.

       SUCCESSFUL-TERM-RTN  SECTION.
           EXEC SQL
             COMMIT
           END-EXEC.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       DBERR-TERM-RTN      SECTION.
           EXEC SQL
             ROLLBACK
           END-EXEC.
           DISPLAY "!!! KUBM030 ABEND !!! TCODE=" CMTOK-TOKU-COD
                   ",YM=" CMTOK-URIKAKE-YM ",GAKU=" CMTOK-URIAGE-GAKU.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       TERM-RTN            SECTION.
           EXEC SQL
               DISCONNECT ALL
           END-EXEC.
      *
           CLOSE ITF-FILE.
      *
           DISPLAY "   ITF=" WK-ITF-CNT.
           DISPLAY "UPDATE=" WK-DBUPDATE-CNT.
           DISPLAY "*** KUBM030 END ***".
       EXT.
           STOP RUN.
