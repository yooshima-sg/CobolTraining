       IDENTIFICATION DIVISION.
       PROGRAM-ID. HELLOWORLD.
       
       DATA DIVISION.
       WORKING-STORAGE SECTION.
       01  MSG PIC X(32) VALUE 'HELLO, WORLD'.

       PROCEDURE DIVISION.
           PERFORM INIT.
           PERFORM DISPMEG.
           STOP RUN.

       INIT SECTION.
           EXIT.

       DISPMEG SECTION.
           DISPLAY MSG.
           EXIT.
