       IDENTIFICATION      DIVISION.
       PROGRAM-ID. PICTURES.
      ****************************************************************
      * 数値項目がファイルに保存したときの状態を確認するプログラム
      ****************************************************************
       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.
           SELECT OTF-FILE ASSIGN TO OTF.
      *
       DATA                DIVISION.
       FILE                SECTION.
       FD OTF-FILE.
       01  OTF-REC.
      *  ZONED
         03  WHOLENUMBER             PIC  9(4).
         03  INTEGER-NUM-PLUS        PIC S9(4).
         03  INTEGER-NUM-MINUS       PIC S9(4).
         03  DECIMAL-NUM             PIC 99v99.
         03  SIGNED-DECIMAL-NUM      PIC S99v99.
      *  PACKED
         03  PD-WHOLENUMBER          PIC  9(4)   PACKED-DECIMAL.
         03  PD-INTEGER              PIC S9(4)   PACKED-DECIMAL.
         03  PD-DECIMAL-NUM          PIC 99v99   PACKED-DECIMAL.
         03  PD-SIGNED-DECIMAL-NUM   PIC S99v99  PACKED-DECIMAL.

       PROCEDURE           DIVISION.
           OPEN  OUTPUT  OTF-FILE.
      *
           MOVE SPACE    TO OTF-REC.
      *
           MOVE  1234    TO  WHOLENUMBER.
           MOVE  1234    TO  INTEGER-NUM-PLUS.
           MOVE -1234    TO  INTEGER-NUM-MINUS.
           MOVE    12.34 TO  DECIMAL-NUM.
           MOVE   -12.34 TO  SIGNED-DECIMAL-NUM.
           MOVE  1234    TO  PD-WHOLENUMBER.
           MOVE -1234    TO  PD-INTEGER.
           MOVE    12.34 TO  PD-DECIMAL-NUM.
           MOVE   -12.34 TO  PD-SIGNED-DECIMAL-NUM.
      *
           WRITE  OTF-REC.
           CLOSE  OTF-FILE.
      *
           STOP RUN.
