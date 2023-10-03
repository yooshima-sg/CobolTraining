       IDENTIFICATION DIVISION.
       PROGRAM-ID. SAMPLE.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY SAMPLE.

       PROCEDURE DIVISION.
       MAIN      SECTION.
           PERFORM DISPMEG.
       EXT.
           STOP RUN.

       DISPMEG  SECTION.
           DISPLAY MSG.
           EXIT.
