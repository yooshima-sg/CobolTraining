       IDENTIFICATION DIVISION.
       PROGRAM-ID. SAMPLE.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       COPY SMPLCPY.

       PROCEDURE DIVISION.
           PERFORM INIT.
           PERFORM DISPMEG.
           STOP RUN.

       INIT SECTION.
           EXIT.

       DISPMEG SECTION.
           DISPLAY MSG.
           EXIT.
