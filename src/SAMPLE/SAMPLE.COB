      ******************************************************************
      * プログラムのIDなどをを記述する
      ******************************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. SAMPLE.
      ******************************************************************
      * システム名    ：研修
      * サブシステム名：サンプルプログラム
      * プログラム名  ：サンプルプログラム
      * 作成日／作成者：２０２６年１月５日  技研太郎
      * 変更日／変更者：
      *       変更内容：
      ******************************************************************
      
      ******************************************************************
      * アクセスファイルなどの情報を記載する
      ******************************************************************
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OTF-FILE ASSIGN TO EXTERNAL OTF.

      ******************************************************************
      * ファイルのレコードのデータ構造や、一時的に利用するデータ項目を定義
      ******************************************************************
       DATA DIVISION.
       FILE SECTION.
       FD OTF-FILE.
       01  OTF-MSG     PIC X(100).

       WORKING-STORAGE SECTION.
       01  MSG.
           COPY SAMPLECOPY.

      ******************************************************************
      * プログラムの開始地点
      ******************************************************************
       PROCEDURE DIVISION.
           PERFORM INPUT-YOURNAME UNTIL YOURNAME NOT = SPACE.
           PERFORM DISPMEG.
           PERFORM OUTPUT-FILE.
           STOP RUN.

       INPUT-YOURNAME SECTION.
           DISPLAY "あなたの名前を入力してください。"
           ACCEPT YOURNAME.           
           EXIT.

       DISPMEG SECTION.
           DISPLAY GREETING.
           EXIT.

       OUTPUT-FILE SECTION.
           MOVE MSG TO OTF-MSG.

           OPEN OUTPUT OTF-FILE.
           WRITE OTF-MSG.
           CLOSE OTF-FILE.
           EXIT.
      