       IDENTIFICATION DIVISION.
       PROGRAM-ID. PICTURES.
      *
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT OTF-FILE ASSIGN TO EXTERNAL OTF.
      *
       DATA DIVISION.
       FILE SECTION.
       FD OTF-FILE.
       01  OTF-REC.
         03  WHOLENUMBER             PIC  9(4).
         03  INTEGER                 PIC S9(4).
         03  DECIMAL_NUM             PIC 99v99.
         03  SIGNED_DECIMAL_NUM      PIC S99v99.
         03  PD_WHOLENUMBER          PIC  9(4)   PACKED-DECIMAL.
         03  PD_INTEGER              PIC S9(4)   PACKED-DECIMAL.
         03  PD_DECIMAL_NUM          PIC 99v99   PACKED-DECIMAL.
         03  PD_SIGNED_DECIMAL_NUM   PIC S99v99  PACKED-DECIMAL.

       PROCEDURE DIVISION.
           OPEN OUTPUT OTF-FILE.
      *
           MOVE SPACE TO OTF-REC.
      *
           MOVE 1234 TO WHOLENUMBER.
           MOVE -1234 TO INTEGER.
           MOVE 12.34 TO DECIMAL_NUM.
           MOVE -12.34 TO SIGNED_DECIMAL_NUM.
           MOVE 1234 TO PD_WHOLENUMBER.
           MOVE -1234 TO PD_INTEGER.
           MOVE 12.34 TO PD_DECIMAL_NUM.
           MOVE -12.34 TO PD_SIGNED_DECIMAL_NUM.
      *
           WRITE OTF-REC.
           CLOSE OTF-FILE.
      *
           STOP RUN.
