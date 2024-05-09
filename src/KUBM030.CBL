       IDENTIFICATION             DIVISION.
       PROGRAM-ID.                KUBM030.
      ************************************************
      * システム名    ：研修
      * サブシステム名：売上
      * プログラム名  ：売上更新
      * 作成日／作成者：２０１３年４月３０日  システム技研
      * 変更日／変更者：２０２３年５月９日
      *       変更内容：oceSQLプリコンパイラ用に記述を変更。
      *                 ただし、実行ファイルは作成できるものの動作しないので注意。
      ************************************************
       ENVIRONMENT                DIVISION.
       INPUT-OUTPUT               SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN  TO  ITF.
      *
       DATA                       DIVISION.
       FILE                       SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KUCF020.
      *
       WORKING-STORAGE            SECTION.
       01  ITF-CNT                PIC  S9(9)  COMP-3  VALUE  +0.
       01  KOSHIN-CNT             PIC  S9(9)  COMP-3  VALUE  +0.
       01  ITF-END-FLG            PIC   X(1)          VALUE  "0".
           EXEC  SQL  BEGIN  DECLARE  SECTION  END-EXEC.
       COPY  KCCMTOK.
       01  DBNAME              PIC  X(64) VALUE "$$DBNAME$$@$$SERVER$$".        *> 【要変更】データべ須名@サーバ名
       01  USERNAME            PIC  X(32) VALUE "$$USERNAME$$".                 *> 【要変更】ユーザ名
       01  PASSWORD            PIC  X(32) VALUE "$$PASSWORD$$".                 *> 【要変更】パスワード
       01  SQLSTATE               PIC   X(5).
           EXEC  SQL  END  DECLARE  SECTION  END-EXEC.

           EXEC SQL INCLUDE SQLCA END-EXEC.

      *
      *****************************************************
      * 売上更新
      *****************************************************
       PROCEDURE                  DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  MAIN-RTN
             UNTIL  ITF-END-FLG  =  "1".
           PERFORM  TERM-RTN.
           STOP  RUN.
      *****************************************************
      * 開始処理
      *****************************************************
       INIT-RTN                   SECTION.
           DISPLAY  "*** KUBM030  START ***".
           OPEN  INPUT  ITF-FILE.
           EXEC  SQL
             CONNECT  :USER-NAME
               IDENTIFIED  BY  :PASSWORD
               USING  :DBNAME
           END-EXEC.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      *****************************************************
      * 入力処理
      *****************************************************
       READ-RTN                   SECTION.
           READ  ITF-FILE
             AT  END
               MOVE  "1"  TO  ITF-END-FLG
             NOT  AT  END
               ADD  +1  TO  ITF-CNT
           END-READ.
       EXT.
           EXIT.
      *****************************************************
      * 更新処理
      *****************************************************
       MAIN-RTN                   SECTION.
           EXEC  SQL
             WHENEVER  NOT  FOUND  GO  TO  :KYOUSEI-END-RTN
           END-EXEC.
           MOVE  UF020-TOKU-COD    TO  CMTOK-TOKU-COD.
           MOVE  UF020-JUCHU-DATE  TO  CMTOK-URIKAKE-YM.
           MOVE  UF020-KINGAKU     TO  CMTOK-URIAGE-GAKU.
           EXEC  SQL
             UPDATE  ktbltok
               SET  urikake_zan  =  urikake_zan  +  :CMTOK-URIAGE-GAKU ,
                    uriage_gaku  =  uriage_gaku  +  :CMTOK-URIAGE-GAKU
               WHERE   toku_cod  =  :CMTOK-TOKU-COD
               AND   urikake_ym  =  :CMTOK-URIKAKE-YM
           END-EXEC.
           ADD  +1  TO  KOSHIN-CNT.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      *****************************************************
      * 強制終了処理
      *****************************************************
       KYOUSEI-END-RTN            SECTION.
           CLOSE  ITF-FILE.
           EXEC  SQL
             ROLLBACK  WORK
           END-EXEC.
           EXEC  SQL
             DISCONNECT  ALL
           END-EXEC.
           DISPLAY  "!!! KUBM030 ABEND!!! TCODE=" UF020-TOKU-COD
                   ", YM=" UF020-JUCHU-DATE  ", GAKU=" UF020-KINGAKU.
           STOP  RUN.
      ******************************************************
      * 終了処理
      *****************************************************
       TERM-RTN                   SECTION.
           CLOSE  ITF-FILE.
           EXEC  SQL
             COMMIT  WORK
           END-EXEC.
           EXEC  SQL
             DISCONNECT  ALL
           END-EXEC.
           DISPLAY  "***    ITF-CNT=" ITF-CNT.
           DISPLAY  "*** KOSHIN-CNT=" KOSHIN-CNT.
           DISPLAY  "*** KUBM030   END  ***".
       EXT.
           EXIT.
