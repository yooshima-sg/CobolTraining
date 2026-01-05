       IDENTIFICATION      DIVISION.
       PROGRAM-ID. PICN.

       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.
           SELECT OTF-FILE ASSIGN TO OTF.

       DATA                DIVISION.
       FILE                SECTION.
       FD  OTF-FILE.
       01  OTF-REC.
      *  ZONED
         03  JMSG          PIC  N(10)  VALUE  SPACE.

       PROCEDURE           DIVISION.
           OPEN  OUTPUT  OTF-FILE.
      *
           MOVE  SPACE    TO OTF-REC.
      *
           MOVE  "‚±‚ñ‚É‚¿‚Í"  TO  JMSG.
      *
           WRITE  OTF-REC.
           CLOSE  OTF-FILE.
      *
           STOP RUN.
