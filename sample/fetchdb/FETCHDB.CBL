       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         FETCHDB.
      ******************************************************************
      * システム名    ：研修
      * サブシステム名：
      * プログラム名  ：SQL FETCH を利用したサンプル
      * 作成日／作成者：２０２４年７月５日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ******************************************************************
      *
       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.
           SELECT OTF-FILE ASSIGN EXTERNAL OTF
               ORGANIZATION LINE SEQUENTIAL.
       
       DATA                DIVISION.
       FILE                SECTION.
       FD  OTF-FILE.
       01 OTF-REC.
           03  OUT-USERID      PIC X(5).
           03  OUT-USERNAME    PIC X(32).
           03  OUT-USERAGE     PIC X(5).           

       WORKING-STORAGE     SECTION.
       01 FETCH-CNT        PIC  9(9) PACKED-DECIMAL VALUE 0.
       01 FETCH-END        PIC  X VALUE 'N'.
      ******************************************************************
      *  データベースアクセス関連
      *     ※ COBOL ⇔ DB する変数は DECLARE SECTION で行う。
      ******************************************************************
       EXEC SQL  BEGIN DECLARE SECTION  END-EXEC.
      * DB接続用文字列 
       01 DSN              PIC  X(256).

      *EXEC SQL INCLUDE USERS-DECLARE END-EXEC.
      * FETCHした情報を格納するデータ項目の定義
       EXEC SQL  INCLUDE USERS  END-EXEC.
      
      * FETCHする対象が記載された「カーソル」の定義
       EXEC SQL  DECLARE 
           USERS-CURSOR CURSOR FOR
               SELECT USERID, USERNAME, USERAGE
               FROM USERINFO
       END-EXEC.
      *
       EXEC SQL  END DECLARE SECTION  END-EXEC.
      *
      * DBの状態を保存するデータ項目は DECLARE SECTION 外に記述する。
      * プリコンパイル時にエラーになる。 
       EXEC SQL  INCLUDE SQLCA  END-EXEC.
      ******************************************************************

       PROCEDURE           DIVISION.
           PERFORM INIT-RTN.
           PERFORM WRITE-TO-FILE-RTN  UNTIL FETCH-END = "Y".
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

      *    SQLカーソルを開く
           EXEC SQL  OPEN USERS-CURSOR  END-EXEC.
           PERFORM FETCH-RTN.
       EXT.
           EXIT.
           
       FETCH-RTN          SECTION.
      * カーソルでFETCHしてデータを取得する。
      * COBOLの環境によってはFETCHした情報を集団項目に転記できないため、
      * その場合はそれぞれの項目に転記するように記述する。
           EXEC SQL  
               FETCH USERS-CURSOR 
                INTO :USERID, :USERNAME, :USERAGE
           END-EXEC.

           EVALUATE SQLCODE
      *    SQLCODE = 0 ⇒ 正常終了。
             WHEN 0
               ADD 1 TO FETCH-CNT
      *    SQLCODE = 100 ⇒ これ以上データがない
             WHEN 100
               MOVE "Y" TO FETCH-END
      *    上記以外は何らかのエラー。ABEND対象。
             WHEN OTHER
               PERFORM DBERR-TERM-RTN
           END-EVALUATE.
       EXT.
           EXIT.
       
       WRITE-TO-FILE-RTN            SECTION.
           MOVE USERINFO TO OTF-REC.
           WRITE OTF-REC.
           PERFORM FETCH-RTN.
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
           DISPLAY "SQLCODE = " SQLCODE.
           DISPLAY "SQLERRMC = " SQLERRMC.

           PERFORM TERM-RTN.
       EXT.
           EXIT.

       TERM-RTN            SECTION.
           EXEC SQL  CLOSE USERS-CURSOR  END-EXEC.
           EXEC SQL  DISCONNECT ALL      END-EXEC.
      
           CLOSE OTF-FILE.
      
           DISPLAY "FETCHCNT=" FETCH-CNT.
           DISPLAY "*** FETCHDB END ***".
       EXT.
           EXIT.
