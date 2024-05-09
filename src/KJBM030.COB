       IDENTIFICATION              DIVISION.
       PROGRAM-ID.                 KJBM030.
      ********************************************************
      *  �V�X�e����        �F���C
      *  �T�u�V�X�e����    �F��
      *  �v���O������      �F�󒍃f�[�^���i�ԍ��`�F�b�N
      *  �쐬���^�쐬��    �F�Q�O�P�R�N�S���R�O��  �V�X�e���Z��
      *  �ύX���^�ύX��    �F
      *        �ύX���e    �F
      ********************************************************
       ENVIRONMENT                 DIVISION.
       INPUT-OUTPUT                SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN  TO  EXTERNAL  ITF.
           SELECT  IMF-FILE  ASSIGN  TO  EXTERNAL  IMF.
           SELECT  OTF-FILE  ASSIGN  TO  EXTERNAL  OTF.
      *
       DATA                        DIVISION.
       FILE                        SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KJCF020.
       FD  IMF-FILE.
       01  IMF-REC.
           COPY  KCCFSHO.
       FD  OTF-FILE.
       01  OTF-REC.
           COPY  KJCF020.
      *
       WORKING-STORAGE             SECTION.
       01  WK-ITF-KEY              PIC  X(5)          VALUE  LOW-VALUE.
       01  WK-OLD-ITF-KEY          PIC  X(5)          VALUE  LOW-VALUE.
       01  WK-IMF-KEY              PIC  X(5)          VALUE  LOW-VALUE.
       01  ITF-CNT                 PIC S9(9)  COMP-3  VALUE   +0.
       01  IMF-CNT                 PIC S9(9)  COMP-3  VALUE   +0.
       01  OTF-CNT                 PIC S9(9)  COMP-3  VALUE   +0.
      *
      ********************************************************
      *  �󒍃f�[�^���i�ԍ��`�F�b�N
      ********************************************************
       PROCEDURE                   DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  MATCHING-RTN   UNTIL  WK-ITF-KEY  =  HIGH-VALUE.
           PERFORM  TERM-RTN.
           STOP  RUN.
      ********************************************************
      *  �J�n����
      ********************************************************
       INIT-RTN                    SECTION.
           DISPLAY  "*** KJBM030 START ***".
           OPEN  INPUT   ITF-FILE  IMF-FILE.
           OPEN  OUTPUT  OTF-FILE.
           PERFORM  IMF-READ-RTN.
           PERFORM  ITF-READ-RTN.
       EXT.
           EXIT.
      *********************************************************
      *  �}�X�^�t�@�C�����͏���
      *********************************************************
       IMF-READ-RTN                SECTION.
           READ  IMF-FILE  AT  END
             MOVE  HIGH-VALUE       TO  WK-IMF-KEY
           NOT  AT  END
             MOVE  CFSHO-SHOHIN-NO  TO  WK-IMF-KEY
             ADD        +1          TO  IMF-CNT
           END-READ.
       EXT.
           EXIT.
      *********************************************************
      *  �g�����U�N�V�����t�@�C�����͏���
      *********************************************************
       ITF-READ-RTN                SECTION.
           READ  ITF-FILE  AT  END
             MOVE  HIGH-VALUE                   TO  WK-ITF-KEY
           NOT  AT  END
             MOVE  JF020-SHOHIN-NO  OF ITF-REC  TO  WK-ITF-KEY
             ADD           +1                   TO  ITF-CNT
           END-READ.
       EXT.
           EXIT.
      *********************************************************
      *  �ˍ�����
      *********************************************************
       MATCHING-RTN               SECTION.
           IF  (WK-ITF-KEY  NOT =  HIGH-VALUE)
           AND (JF020-ERR-KBN OF ITF-REC (5)  NOT =  SPACE)
             PERFORM  OTF-WRITE-RTN
             PERFORM  ITF-READ-RTN
           ELSE
             EVALUATE  TRUE
      *      �}�b�`�����ꍇ
             WHEN  (WK-ITF-KEY  =  WK-IMF-KEY)
               MOVE  WK-ITF-KEY  TO  WK-OLD-ITF-KEY
               PERFORM  MATCH-RTN
               PERFORM  OTF-WRITE-RTN
               PERFORM  ITF-READ-RTN
      *
             WHEN  (WK-ITF-KEY  <  WK-IMF-KEY)
               MOVE  WK-ITF-KEY  TO  WK-OLD-ITF-KEY
               PERFORM  ITF-UNMATCH-RTN
               PERFORM  OTF-WRITE-RTN
               PERFORM  ITF-READ-RTN
      *
             WHEN  OTHER
               PERFORM  IMF-READ-RTN
             END-EVALUATE
           END-IF.
       EXT.
           EXIT.
      *********************************************************
      *  �}�b�`����
      *********************************************************
       MATCH-RTN                   SECTION.
           IF  JF020-ERR-KBN  OF  ITF-REC  (5)  =  SPACE
             MOVE  CFSHO-SHOHIN-MEI  TO  JF020-SHOHIN-MEI  OF  ITF-REC
             IF  JF020-ERR-KBN  OF  ITF-REC  (6)  =  SPACE
                 COMPUTE  JF020-KINGAKU  OF  ITF-REC  =
                          JF020-SURYO  OF  ITF-REC  *  CFSHO-TANKA
                 END-COMPUTE
             ELSE
                 MOVE  +0  TO  JF020-KINGAKU  OF  ITF-REC
             END-IF
           END-IF.
       EXT.
           EXIT.
      *********************************************************
      *  �h�s�e�A���}�b�`����
      *********************************************************
       ITF-UNMATCH-RTN                SECTION.
           IF  JF020-ERR-KBN  OF  ITF-REC  (5)  =  SPACE
             MOVE  "2"  TO  JF020-ERR-KBN  OF  ITF-REC  (5)
           END-IF.
       EXT.
           EXIT.
      *********************************************************
      *  �o�͏���
      *********************************************************
       OTF-WRITE-RTN               SECTION.
           MOVE   ITF-REC  TO  OTF-REC.
           WRITE  OTF-REC.
           ADD    +1       TO  OTF-CNT.
       EXT.
           EXIT.
      *********************************************************
      *  �I������
      *********************************************************
       TERM-RTN                    SECTION.
           CLOSE  ITF-FILE  IMF-FILE  OTF-FILE.
           DISPLAY  "*** ITF="  ITF-CNT.
           DISPLAY  "*** IMF="  IMF-CNT.
           DISPLAY  "*** OTF="  OTF-CNT.
           DISPLAY  "*** KJBM030  END ***".
       EXT.
           EXIT.