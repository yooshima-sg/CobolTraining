       IDENTIFICATION DIVISION.
       PROGRAM-ID. REN1201.

       DATA DIVISION.
       WORKING-STORAGE SECTION.
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 DSN       PIC X(256).
       01 TID       PIC 9(6).
       01 TNAME     PIC X(10).
       EXEC SQL END DECLARE SECTION END-EXEC.
       EXEC SQL INCLUDE SQLCA END-EXEC.


       PROCEDURE DIVISION.
           STRING
             "DRIVER={Postgresql Unicode};"                             *> Postgresql ODBC�h���C�o
             "SERVER=db;"                                               *> �y�v�ύX�z�T�[�o������IP�A�h���X
             "DATABASE=test_conn;"                                      *> �y�v�ύX�z�f�[�^�x�[�X��
             "UID=test_conn;"                                           *> �y�v�ύX�z���[�U��
             "PWD=test_conn;"                                           *> �y�v�ύX�z�p�X���[�h
             "CONNSETTINGS=SET CLIENT_ENCODING to 'SJIS';"              *> �N���C�A���g�����R�[�h
             INTO DSN
           END-STRING.

           DISPLAY "CONNECTING DATABASE ..."
           EXEC SQL CONNECT TO :DSN END-EXEC. 
           
           PERFORM SQLCA-DISP-RTN.

           IF SQLCODE NOT = ZERO
             GO TO EXT
           END-IF.

           DISPLAY "SELECTING DATA FROM TABLE ..."
           EXEC SQL
             SELECT id, name
             INTO :TID, :TNAME
             FROM test
             WHERE id='1'
           END-EXEC.
           DISPLAY TID TNAME.

           PERFORM SQLCA-DISP-RTN.
       EXT.
           STOP RUN.

       SQLCA-DISP-RTN  SECTION.
           DISPLAY "SQLCODE: "   SQLCODE
                   " SQLSTATE: " SQLSTATE
                   " SQLERRM: "  SQLERRM.
           EXIT.
      