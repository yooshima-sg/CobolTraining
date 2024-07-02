       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         FETCHDB.
      ******************************************************************
      * システム名    ：研修
      * サブシステム名：
      * プログラム名  ：FETCH
      * 作成日／作成者：２０２３年１月２４日  システム技
      * 変更日／変更者：
      *       変更内容：GnuCOBOL + esqlOC
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
      **********************************************************************
      *******                EMBEDDED SQL VARIABLES                  *******
       77 OCSQL     PIC X(8) VALUE "OCSQL".
       77 OCSQLDIS  PIC X(8) VALUE "OCSQLDIS".
       77 OCSQLPRE  PIC X(8) VALUE "OCSQLPRE".
       77 OCSQLEXE  PIC X(8) VALUE "OCSQLEXE".
       77 OCSQLRBK  PIC X(8) VALUE "OCSQLRBK".
       77 OCSQLCMT  PIC X(8) VALUE "OCSQLCMT".
       77 OCSQLIMM  PIC X(8) VALUE "OCSQLIMM".
       77 OCSQLOCU  PIC X(8) VALUE "OCSQLOCU".
       77 OCSQLCCU  PIC X(8) VALUE "OCSQLCCU".
       77 OCSQLFTC  PIC X(8) VALUE "OCSQLFTC".
       77 OCSQLCAL  PIC X(8) VALUE "OCSQLCAL".
       01 SQLV.
           05 SQL-ARRSZ  PIC S9(9) COMP-5 VALUE 3.
           05 SQL-COUNT  PIC S9(9) COMP-5 VALUE ZERO.
           05 SQL-ADDR   POINTER OCCURS 3 TIMES VALUE NULL.
           05 SQL-LEN    PIC S9(9) COMP-5 OCCURS 3 TIMES VALUE ZERO.
           05 SQL-TYPE   PIC X OCCURS 3 TIMES.
           05 SQL-PREC   PIC X OCCURS 3 TIMES.
      **********************************************************************
       01 SQL-STMT-0.
           05 SQL-IPTR   POINTER VALUE NULL.
           05 SQL-PREP   PIC X VALUE "N".
           05 SQL-OPT    PIC X VALUE "C".
           05 SQL-PARMS  PIC S9(4) COMP-5 VALUE 0.
           05 SQL-STMLEN PIC S9(4) COMP-5 VALUE 44.
           05 SQL-STMT   PIC X(44) VALUE "SELECT USERID,USERNAME,USERAGE
      -    " FROM USERINFO".
           05 SQL-CNAME  PIC X(12) VALUE "USERS-CURSOR".
           05 FILLER     PIC X VALUE LOW-VALUE.
      **********************************************************************
       01 FETCH-CNT        PIC  9(9) PACKED-DECIMAL VALUE 0.
       01 FETCH-END        PIC  X VALUE 'N'.
      ******************************************************************
      *  データベースアクセス関連
      ******************************************************************
      *EXEC SQL BEGIN DECLARE SECTION END-EXEC.
      * DB接続用
       01 DSN              PIC  X(256).

      *EXEC SQL INCLUDE USERS-DECLARE END-EXEC.
      * FETCHした情報を格納するデータ項目の定義
      *EXEC SQL INCLUDE USERS END-EXEC.
       01 USERINFO.
           03  USERID      PIC X(5).
           03  USERNAME    PIC X(32).
           03  USERAGE     PIC X(5).

      * FETCHするカーソルの定義
      *EXEC SQL DECLARE
      *    USERS-CURSOR CURSOR FOR
      *        SELECT USERID, USERNAME, USERAGE
      *        FROM USERINFO
      *END-EXEC.
      *EXEC SQL END DECLARE SECTION END-EXEC.
      *
      *EXEC SQL INCLUDE SQLCA END-EXEC.
       01 SQLCA.
           05 SQLSTATE PIC X(5).
              88  SQL-SUCCESS           VALUE '00000'.
              88  SQL-RIGHT-TRUNC       VALUE '01004'.
              88  SQL-NODATA            VALUE '02000'.
              88  SQL-DUPLICATE         VALUE '23000' THRU '23999'.
              88  SQL-MULTIPLE-ROWS     VALUE '21000'.
              88  SQL-NULL-NO-IND       VALUE '22002'.
              88  SQL-INVALID-CURSOR-STATE VALUE '24000'.
           05 FILLER   PIC X.
           05 SQLVERSN PIC 99 VALUE 03.
           05 SQLCODE  PIC S9(9) COMP-5 VALUE ZERO.
           05 SQLERRM.
               49 SQLERRML PIC S9(4) COMP-5 VALUE ZERO.
               49 SQLERRMC PIC X(486).
           05 SQLERRD OCCURS 6 TIMES PIC S9(9) COMP-5 VALUE ZERO.
           05 FILLER   PIC X(4).
           05 SQL-HCONN USAGE POINTER VALUE NULL.
      ******************************************************************

       PROCEDURE           DIVISION.
           PERFORM INIT-RTN.
           PERFORM MAIN-RTN  UNTIL FETCH-END = "Y".
           PERFORM SUCCESSFUL-TERM-RTN.
           STOP RUN.


       INIT-RTN            SECTION.
           DISPLAY  "*** FETCHDB START ***".
      *
           OPEN OUTPUT OTF-FILE.
      *
      * ESQLOCはODBC経由でDBへ接続するコードを生成するため、データベース
      * への接続にODBC接続文字列を作成する必要がある。詳細は下記URL参
      * https://www.microfocus.co.jp/manuals/ED60/VS2017/GUID-2B444A32-4
      *
      * なお、埋込SQLを処理するプリプロセッサによって、データベース
      * 接続方法が異なるので、その場所で利用しているプリプロセッサ
      * ドキュメントを確認すること。
      *
      * Ubuntu 22.04では、odbc-postgresqlパッケージのインストールが必要
      *
      * 埋込SQLを利用する場合は、COBOL側の文字コードに合わせてデータ
      * 崇徳する必要がある。研修の環境は'SJIS'のため、データ
      * 文字エンコードを'SJIS'に設定する。(しないと文字化けが発生する)
      * 文字エンコードを設定するには、
      *   CONNSETTINGS=SET CLIENT_ENCODING TO 'SJIS'
      * を接続文字列に追加する。
           STRING
             "DRIVER={Postgresql Unicode};"
             "SERVER=db;"
             "DBQ=postgres;"
             "UID=postgres;"
             "PWD=postgres;"
             "CONNSETTINGS=SET CLIENT_ENCODING to 'SJIS';"
             INTO DSN
           END-STRING.

      *    EXEC SQL CONNECT TO :DSN END-EXEC.
           MOVE 256 TO SQL-LEN(1)
           CALL OCSQL    USING DSN
                               SQL-LEN(1)
                               SQLCA
           END-CALL
                                            .
           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.

      *    SQLカーソルを開
      *    EXEC SQL  OPEN USERS-CURSOR  END-EXEC.
           IF SQL-PREP OF SQL-STMT-0 = "N"
               MOVE 0 TO SQL-COUNT
               CALL OCSQLPRE USING SQLV
                                   SQL-STMT-0
                                   SQLCA
           END-IF
           CALL OCSQLOCU USING SQL-STMT-0
                               SQLCA
           END-CALL
                                                .
           PERFORM FETCH-TABLE-RTN.
       EXT.
           EXIT.

       FETCH-TABLE-RTN          SECTION.
      * COBOLによってはFETCHした情報をまとめて集団項目に転記
      * その場合はそれぞれの項目に転記するように記述する。
      *    EXEC SQL
      *        FETCH USERS-CURSOR
      *         INTO :USERID, :USERNAME, :USERAGE
      *    END-EXEC.
           SET SQL-ADDR(1) TO ADDRESS OF
             USERID
           MOVE "X" TO SQL-TYPE(1)
           MOVE 5 TO SQL-LEN(1)
           SET SQL-ADDR(2) TO ADDRESS OF
             USERNAME
           MOVE "X" TO SQL-TYPE(2)
           MOVE 32 TO SQL-LEN(2)
           SET SQL-ADDR(3) TO ADDRESS OF
             USERAGE
           MOVE "X" TO SQL-TYPE(3)
           MOVE 5 TO SQL-LEN(3)
           MOVE 3 TO SQL-COUNT
           CALL OCSQLFTC USING SQLV
                               SQL-STMT-0
                               SQLCA
                   .

           EVALUATE SQLCODE
      *    SQLCODE = 0 は正常終了。
             WHEN 0
               ADD 1 TO FETCH-CNT
      *    SQLCODE = 100 はこれ以上データ
             WHEN 100
               MOVE "Y" TO FETCH-END
      *    上記以外は何らかのエラー。ABEND対象。
             WHEN OTHER
               PERFORM DBERR-TERM-RTN
           END-EVALUATE.
       EXT.
           EXIT.

       MAIN-RTN            SECTION.
           MOVE USERINFO TO OTF-REC.
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
           DISPLAY "SQLCODE = " SQLCODE.
           DISPLAY "SQLERRMC = " SQLERRMC.

           PERFORM TERM-RTN.
       EXT.
           EXIT.

       TERM-RTN            SECTION.
      *    EXEC SQL  CLOSE USERS-CURSOR  END-EXEC.
           CALL OCSQLCCU USING SQL-STMT-0
                               SQLCA
                                                 .
      *    EXEC SQL  DISCONNECT ALL      END-EXEC.
           CALL OCSQLDIS USING SQLCA END-CALL
                                                 .

           CLOSE OTF-FILE.

           DISPLAY "FETCHCNT=" FETCH-CNT.
           DISPLAY "*** FETCHDB END ***".
       EXT.
           EXIT.
      **********************************************************************
      *  : ESQL for GnuCOBOL/OpenCOBOL Version 3 (2024.04.30) Build Jul  2 2024

      *******               EMBEDDED SQL VARIABLES USAGE             *******
      *  DSN                      IN USE CHAR(256)
      *  USERAGE                  IN USE CHAR(5)
      *  USERID                   IN USE CHAR(5)
      *  USERINFO             NOT IN USE
      *  USERINFO.USERAGE     NOT IN USE
      *  USERINFO.USERID      NOT IN USE
      *  USERINFO.USERNAME    NOT IN USE
      *  USERNAME                 IN USE CHAR(32)
      *  USERS-CURSOR             IN USE CURSOR
      **********************************************************************
