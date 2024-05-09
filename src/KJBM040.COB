       IDENTIFICATION             DIVISION.
       PROGRAM-ID.                KJBM040.
      ********************************************************
      *  �V�X�e����   �F���C
      * �T�u�V�X�e�����F��
      * �v���O������  �F�󒍃f�[�^���Ӑ�R�[�h�`�F�b�N
      * �쐬���^�쐬�ҁF�Q�O�P�R�N�S���R�O��  �V�X�e���Z��
      * �ύX���^�ύX�ҁF
      *       �ύX���e�F
      ********************************************************
       ENVIRONMENT                DIVISION.
       INPUT-OUTPUT               SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN  TO  EXTERNAL  ITF.
           SELECT  IMF-FILE  ASSIGN  TO  EXTERNAL  IMF.
           SELECT  OTF-FILE  ASSIGN  TO  EXTERNAL  OTF.
      *
       DATA                       DIVISION.
       FILE                       SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KJCF020.
       FD  IMF-FILE.
       01  IMF-REC.
           COPY  KCCFTOK.
       FD  OTF-FILE.
       01  OTF-REC.
           COPY  KJCF020.
      *
       WORKING-STORAGE            SECTION.
       01  WK-ITF-KEY             PIC   X(4)  VALUE  LOW-VALUE.
       01  WK-IMF-KEY             PIC   X(4)  VALUE  LOW-VALUE.
       01  WK-OLD-ITF-KEY         PIC   X(4)  VALUE  LOW-VALUE.
       01  ITF-CNT                PIC  S9(9)  VALUE  +0.
       01  IMF-CNT                PIC  S9(9)  VALUE  +0.
       01  OTF-CNT                PIC  S9(9)  VALUE  +0.
      *
      ********************************************************
      *  �󒍃f�[�^���Ӑ�R�[�h�`�F�b�N
      ********************************************************
       PROCEDURE                  DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  TOKU-CHECK-RTN  UNTIL  WK-ITF-KEY  =  HIGH-VALUE.
           PERFORM  TERM-RTN.
           STOP  RUN.
      ********************************************************
      *  �J�n����
      ********************************************************
       INIT-RTN                   SECTION.
           DISPLAY  "*** KJBM040 START ***".
           OPEN  INPUT   ITF-FILE  IMF-FILE.
           OPEN  OUTPUT  OTF-FILE.
           PERFORM  ITF-READ-RTN.
           PERFORM  IMF-READ-RTN.
       EXT.
           EXIT.
      ********************************************************
      *  �g�������͏���
      ********************************************************
       ITF-READ-RTN               SECTION.
           READ  ITF-FILE  AT  END
               MOVE  HIGH-VALUE  TO  WK-ITF-KEY
           NOT  AT  END
               MOVE  JF020-TOKU-COD  OF  ITF-FILE  TO  WK-ITF-KEY
               ADD   +1   TO   ITF-CNT
           END-READ.
       EXT.
           EXIT.
      ********************************************************
      *  �}�X�^���͏���
      ********************************************************
       IMF-READ-RTN               SECTION.
           READ  IMF-FILE  AT  END
               MOVE  HIGH-VALUE  TO  WK-IMF-KEY
           NOT  AT  END
               MOVE  CFTOK-TOKU-COD  TO  WK-IMF-KEY
               ADD   +1   TO   IMF-CNT
           END-READ.
       EXT.
           EXIT.
      ********************************************************
      *  ���Ӑ�`�F�b�N����
      ********************************************************
       TOKU-CHECK-RTN             SECTION.
           EVALUATE  TRUE
             WHEN  WK-ITF-KEY  =  WK-IMF-KEY
               MOVE  WK-ITF-KEY  TO  WK-OLD-ITF-KEY
               PERFORM  MATCH-RTN
               PERFORM  ITF-READ-RTN
             WHEN  WK-ITF-KEY  <  WK-IMF-KEY
               MOVE  WK-ITF-KEY  TO  WK-OLD-ITF-KEY
               PERFORM  UN-MATCH-RTN
               PERFORM  ITF-READ-RTN
             WHEN  WK-ITF-KEY  >  WK-IMF-KEY
               PERFORM  IMF-READ-RTN
           END-EVALUATE.
       EXT.
           EXIT.
      ********************************************************
      *  �}�b�`����
      ********************************************************
       MATCH-RTN                  SECTION.
           IF  JF020-ERR-KBN  OF  ITF-REC  (4)  =  SPACE
             MOVE  CFTOK-TOKU-MEI  TO  JF020-TOKU-MEI  OF  ITF-REC
           END-IF.
           PERFORM  WRITE-RTN.
       EXT.
           EXIT.
      ********************************************************
      *  �A���}�b�`����
      ********************************************************
       UN-MATCH-RTN               SECTION.
           IF  JF020-ERR-KBN  OF  ITF-REC  (4)  =  SPACE
             MOVE  "2"  TO  JF020-ERR-KBN  OF  ITF-REC  (4)
           END-IF.
           PERFORM  WRITE-RTN.
       EXT.
           EXIT.
      ********************************************************
      *  �o�͏���
      ********************************************************
       WRITE-RTN                   SECTION.
           MOVE  ITF-REC  TO  OTF-REC.
           WRITE  OTF-REC.
           ADD  +1  TO  OTF-CNT.
      ********************************************************
      *  �I������
      ********************************************************
       TERM-RTN                    SECTION.
           CLOSE  ITF-FILE  IMF-FILE  OTF-FILE.
           DISPLAY  "*** ITF-CNT="  ITF-CNT.
           DISPLAY  "*** IMF-CNT="  IMF-CNT.
           DISPLAY  "*** OTF-CNT="  OTF-CNT.
           DISPLAY  "*** KJBM040  END ***".
       EXT.
           EXIT.