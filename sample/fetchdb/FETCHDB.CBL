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
           SELECT OTF-FILE ASSIGN EXTERNAL OTF.
       
       DATA                DIVISION.
       FILE                SECTION.
       FD  OTF-FILE.
       01 OTF-REC.
           03  OUT-USERID  PIC X(5).
           

       WORKING-STORAGE     SECTION.
       01 WK-FETCH-CNT     PIC  9(9) PACKED-DECIMAL VALUE 0.
       01 WK-FETCH-END     PIC  X VALUE 'N'.
      * 
      ******************************************************************
      *  データベースアクセス関連
      ******************************************************************
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 DSN                PIC  X(256).
      *
      *EXEC SQL INCLUDE USERS-DECLARE END-EXEC.
       EXEC SQL INCLUDE USERS END-EXEC.
       EXEC SQL DECLARE 
           USERS-CURSOR CURSOR FOR
               SELECT USERID, USERNAME, USERAGE
               FROM USERINFO
       END-EXEC.
       EXEC SQL END DECLARE SECTION END-EXEC.
      *
       EXEC SQL INCLUDE SQLCA END-EXEC.
      ******************************************************************

       PROCEDURE           DIVISION.
           PERFORM INIT-RTN.
           PERFORM MAIN-RTN  UNTIL WK-FETCH-END = "Y".
           PERFORM SUCCESSFUL-TERM-RTN.
           STOP RUN.

      
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
             "DBQ=postgres;"                                            *> 【要変更】データベース名
             "UID=postgres;"                                            *> 【要変更】ユーザ名
             "PWD=postgres;"                                            *> 【要変更】パスワード
             "CONNSETTINGS=SET CLIENT_ENCODING to 'SJIS';"              *> クライアント文字コード
             INTO DSN
           END-STRING.

           EXEC SQL CONNECT TO :DSN END-EXEC.
           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.

           EXEC SQL  OPEN USERS-CURSOR  END-EXEC.
           PERFORM FETCH-TABLE-RTN.
       EXT.
           EXIT.
           
       FETCH-TABLE-RTN          SECTION.
      * COBOLによってはFETCHした情報をまとめて集団項目に転記できないため、
      * その場合はそれぞれの項目に転記するように記述する。
           EXEC SQL  
               FETCH USERS-CURSOR 
                INTO :USERID, :USERNAME, :USERAGE
           END-EXEC.
           EVALUATE SQLCODE
      *    SQLCODE = 0 は正常終了。
             WHEN 0
               ADD 1 TO WK-FETCH-CNT
      *    SQLCODE = 100 はこれ以上データがない
             WHEN 100
                MOVE "Y" TO WK-FETCH-END
             WHEN OTHER
               PERFORM DBERR-TERM-RTN
           END-EVALUATE.
       EXT.
           EXIT.
       
       MAIN-RTN            SECTION.
           MOVE USERID TO OUT-USERID.
           WRITE OTF-REC.
           PERFORM FETCH-TABLE-RTN.
       EXT.
           EXIT.

       SUCCESSFUL-TERM-RTN  SECTION.
      *     EXEC SQL COMMIT END-EXEC.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       DBERR-TERM-RTN      SECTION.
      *     EXEC SQL ROLLBACK END-EXEC.
           DISPLAY "!!! FETCHDB ABEND : DATABSE ACCESS ERRROR !!!"
           DISPLAY SQLCODE.
           DISPLAY SQLERRMC.

           PERFORM TERM-RTN.
       EXT.
           EXIT.

       TERM-RTN            SECTION.
           EXEC SQL  CLOSE USERS-CURSOR  END-EXEC.
           EXEC SQL  DISCONNECT ALL      END-EXEC.
      
           CLOSE OTF-FILE.
      
           DISPLAY "FETCHCNT=" WK-FETCH-CNT.
           DISPLAY "*** FETCHDB END ***".
       EXT.
           EXIT.
