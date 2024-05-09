       IDENTIFICATION           DIVISION.
       PROGRAM-ID.              KJBM050.
      ***********************************************
      *  �V�X�e����    �F���C
      *  �T�u�V�X�e�����F��
      *  �v���O������  �F�󒍃f�[�^�U�蕪��
      *  �쐬���^�쐬�ҁF�Q�O�P�R�N�S���R�O��  �V�X�e���Z��
      *  �ύX���^�ύX�ҁF
      *        �ύX���e�F
      ***********************************************
       ENVIRONMENT              DIVISION.
       INPUT-OUTPUT             SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE   ASSIGN  TO  EXTERNAL  ITF.
           SELECT  OTF1-FILE  ASSIGN  TO  EXTERNAL  OTF1.
           SELECT  OTF2-FILE  ASSIGN  TO  EXTERNAL  OTF2.
      *
       DATA                     DIVISION.
       FILE                     SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KJCF020.
       FD  OTF1-FILE.
       01  OTF1-REC.
           COPY  KJCF020.
       FD  OTF2-FILE.
       01  OTF2-REC.
           COPY  KJCF020.
      *
       WORKING-STORAGE          SECTION.
       01  ITF-END-FLG          PIC   X(1)          VALUE  "0".
       01  ITF-CNT              PIC  S9(9)  COMP-3  VALUE  +0.
       01  OTF1-CNT             PIC  S9(9)  COMP-3  VALUE  +0.
       01  OTF2-CNT             PIC  S9(9)  COMP-3  VALUE  +0.
      *
      *****************************************************
      *  �󒍃f�[�^�U�蕪��
      *****************************************************
       PROCEDURE                DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  DATA-HURIWAKE-RTN  UNTIL  ITF-END-FLG  =  "1".
           PERFORM  TERM-RTN.
           STOP  RUN.
      *****************************************************
      *  �J�n����
      *****************************************************
       INIT-RTN                 SECTION.
           DISPLAY  "*** KJBM050 START ***".
           OPEN  INPUT   ITF-FILE.
           OPEN  OUTPUT  OTF1-FILE  OTF2-FILE.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      *****************************************************
      *  ���͏���
      *****************************************************
       READ-RTN                 SECTION.
           READ  ITF-FILE
             AT  END 
               MOVE  "1"  TO  ITF-END-FLG
             NOT  AT  END
               ADD  +1  TO  ITF-CNT
           END-READ.
       EXT.
           EXIT.
      *****************************************************
      *  �f�[�^�U�蕪������
      *****************************************************
       DATA-HURIWAKE-RTN        SECTION.
           IF  JF020-ERR-KBN-TBL  OF  ITF-REC  =  SPACE
             MOVE  ITF-REC  TO  OTF1-REC
             PERFORM  WRITE1-RTN
           ELSE
             MOVE  ITF-REC  TO  OTF2-REC
             PERFORM  WRITE2-RTN
           END-IF.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      *****************************************************
      *  �o�͏����P
      *****************************************************
       WRITE1-RTN               SECTION.
           WRITE  OTF1-REC.
           ADD  +1  TO  OTF1-CNT.
       EXT.
           EXIT.
      *****************************************************
      *  �o�͏����Q
      *****************************************************
       WRITE2-RTN               SECTION.
           WRITE  OTF2-REC.
           ADD  +1  TO  OTF2-CNT.
       EXT.
           EXIT.
      *****************************************************
      *  �I������
      *****************************************************
       TERM-RTN                 SECTION.
           CLOSE  ITF-FILE  OTF1-FILE  OTF2-FILE.
           DISPLAY  "*** ITF-CNT="  ITF-CNT.
           DISPLAY  "***OTF1-CNT="  OTF1-CNT.
           DISPLAY  "***OTF2-CNT="  OTF2-CNT.
           DISPLAY  "*** KJBM050  END ***".
       EXT.
           EXIT.