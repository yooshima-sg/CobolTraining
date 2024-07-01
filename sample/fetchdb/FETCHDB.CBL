       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         FETCHDB.
      ******************************************************************
      * システム名    ：研修
      * サブシステム名：
      * プログラム名  ：FETCH
      * 作成日／作成者：２０２３年１月２４日  システム技研
      * 変更日／変更者：
      *       変更内容：GnuCOBOL + esqlOC 向け
      ******************************************************************
      *
       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.
      *
       SELECT OTF-FILE ASSIGN EXTERNAL OTF.
      *
       DATA                DIVISION.
       FILE                SECTION.
       FD  OTF-FILE.
       COPY USERS.

       WORKING-STORAGE     SECTION.
       01 WK-OTF-END-FLG   PIC  X VALUE "N".
       01 WK-OTF-CNT       PIC  9(9) PACKED-DECIMAL VALUE 0.
      *
       01 WK-DBERR-FLG     PIC  X VALUE "N".
       01 WK-DBUPDATE-CNT  PIC  9(9) PACKED-DECIMAL VALUE 0.
      *
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       EXEC SQL INCLUDE USERS-DECLARE END-EXEC.
      *
       01 DSN                PIC  X(256).
       EXEC SQL END DECLARE SECTION END-EXEC.
      *
       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE           DIVISION.
           PERFORM INIT-RTN.
           PERFORM MAIN-RTN UNTIL WK-OTF-END-FLG = "Y".
           PERFORM SUCCESSFUL-TERM-RTN.
      *
       INIT-RTN            SECTION.
           DISPLAY  "*** FETCHDB START ***".
      *
           OPEN OUTPUT OTF-FILE.
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
             "SERVER=db;"                                               *> 【要変更】サーバ名又はIPアドレス
             "DATABASE=postgres;"                                       *> 【要変更】データベース名
             "USER=postgres;"                                           *> 【要変更】ユーザ名
             "PASSWORD=postgres;"                                       *> 【要変更】パスワード
             "CONNSETTINGS=SET CLIENT_ENCODING to 'SJIS';"              *> クライアント文字コード
             INTO DSN
           END-STRING.

           EXEC SQL CONNECT TO :DSN END-EXEC.
           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.
       EXT.
           EXIT.

       MAIN-RTN            SECTION.
      * UPDATE命令実行時に更新対象となるレコードが0件だった時
      * それが、NOT FOUND 条件に当てはまるかどうかは、RDBMSの実装に
      * よって異なるため、利用する場合は事前にRDBMSのマニュアル等を
      * チェックしておくこと。
       EXT.
           EXIT.
           
       READ-TABLE          SECTION.
           EXEC SQL OPEN 

       EXT.
           EXIT.
       
       SUCCESSFUL-TERM-RTN  SECTION.
           EXEC SQL COMMIT END-EXEC.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       DBERR-TERM-RTN      SECTION.
           EXEC SQL ROLLBACK END-EXEC.
           DISPLAY "!!! FETCHDB ABEND !!!"
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       TERM-RTN            SECTION.
           EXEC SQL DISCONNECT ALL END-EXEC.
      *
           CLOSE OTF-FILE.
      *
           DISPLAY "   OTF=" WK-OTF-CNT.
           DISPLAY "UPDATE=" WK-DBUPDATE-CNT.
           DISPLAY "*** FETCHDB END ***".
       EXT.
           STOP RUN.
