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
      *
       SELECT OTF-FILE ASSIGN EXTERNAL OTF.
      *
       DATA                DIVISION.
       FILE                SECTION.
       FD  OTF-FILE.
       COPY USERS.

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
           05 SQL-ARRSZ  PIC S9(9) COMP-5 VALUE 2.
           05 SQL-COUNT  PIC S9(9) COMP-5 VALUE ZERO.
           05 SQL-ADDR   POINTER OCCURS 2 TIMES VALUE NULL.
           05 SQL-LEN    PIC S9(9) COMP-5 OCCURS 2 TIMES VALUE ZERO.
           05 SQL-TYPE   PIC X OCCURS 2 TIMES.
           05 SQL-PREC   PIC X OCCURS 2 TIMES.
      **********************************************************************
       01 WK-OTF-END-FLG   PIC  X VALUE "N".
       01 WK-OTF-CNT       PIC  9(9) PACKED-DECIMAL VALUE 0.
      *
       01 WK-DBERR-FLG     PIC  X VALUE "N".
       01 WK-DBUPDATE-CNT  PIC  9(9) PACKED-DECIMAL VALUE 0.
      *
      *EXEC SQL BEGIN DECLARE SECTION END-EXEC.
      *EXEC SQL INCLUDE USERS-DECLARE END-EXEC.
      *EXEC SQL DECLARE USERINFO TABLE (
      *    USERID      CHAR(5)  NOT NULL  PRIMARY KEY,
      *    USERNAME    CHAR(32) NOT NULL,
      *    USERAGE     CHAR(5)  NOT NULL
      *) END-EXEC.
      *
       01 DSN                PIC  X(256).
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
             "DATABASE=postgres;"
             "USER=postgres;"
             "PASSWORD=postgres;"
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
       EXT.
           EXIT.

       MAIN-RTN            SECTION.
      * UPDATE命令実行時に更新対象となるレコードが0
      * それが、NOT FOUND 条件に当てはまるかどうかは、RDBMS
      * よって異なるため、利用する場合は事前にRDBMSのマニュア
      * チェックしておくこと。
       EXT.
           EXIT.

       SUCCESSFUL-TERM-RTN  SECTION.
      *    EXEC SQL COMMIT END-EXEC.
           CALL OCSQLCMT USING SQLCA END-CALL
                                   .
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       DBERR-TERM-RTN      SECTION.
      *    EXEC SQL ROLLBACK END-EXEC.
           CALL OCSQLRBK USING SQLCA END-CALL
                                     .
           DISPLAY "!!! FETCHDB ABEND !!!"
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       TERM-RTN            SECTION.
      *    EXEC SQL DISCONNECT ALL END-EXEC.
           CALL OCSQLDIS USING SQLCA END-CALL
                                           .
      *
           CLOSE OTF-FILE.
      *
           DISPLAY "   OTF=" WK-OTF-CNT.
           DISPLAY "UPDATE=" WK-DBUPDATE-CNT.
           DISPLAY "*** FETCHDB END ***".
       EXT.
           STOP RUN.
      **********************************************************************
      *  : ESQL for GnuCOBOL/OpenCOBOL Version 3 (2024.04.30) Build Jun 29 2024

      *******               EMBEDDED SQL VARIABLES USAGE             *******
      *  DSN                      IN USE CHAR(256)
      **********************************************************************
