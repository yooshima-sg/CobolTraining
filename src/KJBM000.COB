       IDENTIFICATION        DIVISION.
       PROGRAM-ID.           KJBM000.
      ********************************************************
      * システム名　　　：研修
      * サブシステム名　：
      * プログラム名　　：ファイルの転記処理
      * 作成者／作成者　：２０２２年１２月２日  システム技研
      * 変更日／変更者　：
      * 　　　変更内容　：
      ********************************************************
       ENVIRONMENT           DIVISION.
       INPUT-OUTPUT          SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN  TO  EXTERNAL  ITF
                   ORGANIZATION  LINE  SEQUENTIAL.

           SELECT  OTF-FILE  ASSIGN  TO  EXTERNAL  OTF
                   ORGANIZATION  LINE  SEQUENTIAL.
      *
       DATA                  DIVISION.
       FILE                  SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           03  JF010-DATA             PIC   X(10).
      *
       FD  OTF-FILE.
       01  OTF-REC.
           03  JF020-DATA             PIC   X(10).
      *
       WORKING-STORAGE       SECTION.
       01   ITF-END-FLG               PIC   X(1)  VALUE ZERO.
       01   ITF-CNT                   PIC   9(9)  COMP-3  VALUE 0.
       01   OTF-CNT                   PIC   9(9)  COMP-3  VALUE 0.
      *
      ********************************************************
      *    ファイルの転記
      ********************************************************
       PROCEDURE             DIVISION.
            PERFORM   MAIN-RTN.

      ********************************************************
      *    主処理(エントリー)
      ********************************************************
       MAIN-RTN              SECTION.
            DISPLAY  "*** KJBM000 START ***".
      *    対象となるファイルを開く
            OPEN  INPUT   ITF-FILE.
            OPEN  OUTPUT  OTF-FILE.

      *    転記処理
            PERFORM  TENKI-RTN  UNTIL  ITF-END-FLG = "1".

      *    開いたファイルを閉じる
            CLOSE  ITF-FILE.
            CLOSE  OTF-FILE.

      *    読み込んだレコード数、出力したレコード数を表示
            DISPLAY  "*** ITF = " ITF-CNT " ***".
            DISPLAY  "*** OTF = " OTF-CNT " ***".
            DISPLAY  "*** KJBM000 END ***".
            STOP RUN.

      ********************************************************
      *    ファイル転記処理
      ********************************************************
       TENKI-RTN             SECTION.
      *    初期化
            MOVE  SPACE  TO  OTF-REC.

      *    入力ファイルから１レコードを読み込み
            READ  ITF-FILE
                 AT  END
                   MOVE  "1"  TO  ITF-END-FLG
                   GO TO  EXT
                 NOT  AT  END
                   ADD  1  TO  ITF-CNT
            END-READ.

      *    レコードの転記
            MOVE  JF010-DATA  TO  JF020-DATA.
      
      *    転記したレコードを出力先ファイルへ出力
            WRITE  OTF-REC.
            ADD  1  TO  OTF-CNT.
       EXT.
            EXIT.
