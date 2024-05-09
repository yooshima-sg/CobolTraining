       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         KUBM030B.
      ******************************************************************
      * システム名    ：研修
      * サブシステム名：売上
      * プログラム名  ：売上更新
      * 作成日／作成者：２０２３年１月２４日  システム技研
      * 変更日／変更者：
      *       変更内容：GnuCOBOL + esqlOC 向け
      ******************************************************************
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
       EXEC SQL INCLUDE KCCMTOK END-EXEC.
      *
       01 DSN                PIC  X(256).
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
      * ESQLOCはODBC経由でDBへ接続するコードを生成するため、データベース
      * への接続にODBC接続文字列を作成する必要がある。詳細は下記URL参照。
      * https://www.microfocus.co.jp/manuals/ED60/VS2017/GUID-2B444A32-4991-4396-B9F1-68AB643B5EBA.html
      *
      * なお、埋込SQLを処理するプリプロセッサによって、データベースへの
      * 接続方法が異なるので、その場所で利用しているプリプロセッサの
      * ドキュメントを確認すること。
      *
      * Ubuntu 22.04では、odbc-postgresqlパッケージのインストールが必要。
      *
      * 埋込SQLを利用する場合は、COBOL側の文字コードに合わせてデータを
      * 崇徳する必要がある。研修の環境は'SJIS'のため、データ取得時の
      * 文字エンコードを'SJIS'に設定する。(しないと文字化けが発生する)
      * 文字エンコードを設定するには、
      *   CONNSETTINGS=SET CLIENT_ENCODING TO 'SJIS'
      * を接続文字列に追加する。
           STRING
             "DRIVER={Postgresql Unicode};"                             *> Postgresql ODBCドライバ
             "SERVER=$$SERVER$$;"                                       *> 【要変更】サーバ名又はIPアドレス
             "DATABASE=$$DATABSE$$"                                     *> 【要変更】データベース名
             "USER=$$USER$$;"                                           *> 【要変更】ユーザ名
             "PASSWORD=$$PASSWORD$$;"                                   *> 【要変更】パスワード
             "CONNSETTINGS=SET CLIENT_ENCODING to 'SJIS';"              *> クライアント文字コード
             INTO DSN
           END-STRING.
      
           EXEC SQL CONNECT TO :DSN END-EXEC.
           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.
      *
           PERFORM READ-RTN.
       EXT.
           EXIT.

       MAIN-RTN            SECTION.
      * UPDATE命令実行時に更新対象となるレコードが0件だった時
      * それが、NOT FOUND 条件に当てはまるかどうかは、RDBMSの実装に
      * よって異なるため、利用する場合は事前にRDBMSのマニュアル等を
      * チェックしておくこと。
      *
           EXEC SQL
             WHENEVER NOT FOUND PERFORM DBERR-TERM-RTN
           END-EXEC.
      *
           MOVE UF020-TOKU-COD TO CMTOK-TOKU-COD.
           MOVE UF020-JUCHU-DATE TO CMTOK-URIKAKE-YM.
           MOVE UF020-KINGAKU TO CMTOK-URIAGE-GAKU.

           EXEC SQL
             UPDATE KCCMTOK
             SET
               CMTOK_URIAGE_GAKU =
                   CMTOK_URIAGE_GAKU + :CMTOK-URIAGE-GAKU,
               CMTOK_URIKAKE_ZAN =
                   CMTOK_URIKAKE_ZAN + :CMTOK-URIAGE-GAKU,
               CMTOK_TOKU_MEI = '更新完了'
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
           EXEC SQL COMMIT END-EXEC.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       DBERR-TERM-RTN      SECTION.
           EXEC SQL ROLLBACK END-EXEC.
           DISPLAY "!!! KUBM030 ABEND !!! TCODE=" CMTOK-TOKU-COD
                   ",YM=" CMTOK-URIKAKE-YM ",GAKU=" CMTOK-URIAGE-GAKU.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       TERM-RTN            SECTION.
           EXEC SQL DISCONNECT ALL END-EXEC.
      *
           CLOSE ITF-FILE.
      *
           DISPLAY "   ITF=" WK-ITF-CNT.
           DISPLAY "UPDATE=" WK-DBUPDATE-CNT.
           DISPLAY "*** KUBM030 END ***".
       EXT.
           STOP RUN.
