       IDENTIFICATION           DIVISION.
       PROGRAM-ID.              KJBM020.
      ********************************************************
      *  �V�X�e����      �F���C
      *  �T�u�V�X�e����  �F��
      *  �v���O������    �F�󒍃f�[�^�`���`�F�b�N
      *  �쐬���^�쐬��  �F�Q�O�P�R�N�S���R�O��  �V�X�e���Z��
      *  �ύX���^�ύX��  �F
      *        �ύX���e  �F
      ********************************************************
       ENVIRONMENT              DIVISION.
       INPUT-OUTPUT             SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN  TO  EXTERNAL  ITF.
           SELECT  OTF-FILE  ASSIGN  TO  EXTERNAL  OTF.
      *
       DATA                     DIVISION.
       FILE                     SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KJCF020.
       FD  OTF-FILE.
       01  OTF-REC.
           COPY  KJCF020.
      *
       WORKING-STORAGE          SECTION.
       01  ITF-END-FLG          PIC  X(1)   VALUE  "0".
       01  ITF-CNT              PIC S9(9)   VALUE  0.
       01  OTF-CNT              PIC S9(9)   VALUE  0.
           COPY  KCBS010P.
      *
      ********************************************************
      *  �󒍃f�[�^�`���`�F�b�N
      ********************************************************
       PROCEDURE                DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  CHECK-RTN  UNTIL  ITF-END-FLG  = "1".
           PERFORM  TERM-RTN.
           STOP  RUN.
      ********************************************************
      *  �J�n����
      ********************************************************
       INIT-RTN                 SECTION.
           DISPLAY  "*** KJBM020 START ***".
           OPEN  INPUT   ITF-FILE.
           OPEN  OUTPUT  OTF-FILE.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      ********************************************************
      *  ���͏���
      ********************************************************
       READ-RTN                SECTION.
           READ  ITF-FILE
             AT  END
                 MOVE  "1"  TO  ITF-END-FLG
             NOT  AT  END
                 ADD    1   TO  ITF-CNT
           END-READ.
       EXT.
           EXIT.
      ********************************************************
      *�`�F�b�N����
      ********************************************************
       CHECK-RTN                SECTION.
           MOVE  ITF-REC  TO  OTF-REC.
      *
      *    �f�[�^�敪
           IF  NOT  (JF020-DATA-KBN  OF  ITF-REC   =  1  OR  9)
               MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC  (1)
           END-IF.
      *
      *    �󒍔ԍ�
           IF  JF020-JUCHU-NO  OF  ITF-REC  IS  NOT  NUMERIC
               MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC  (2)
           ELSE 
               IF  JF020-JUCHU-NO  OF  ITF-REC  =  ZERO
                   MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC  (2)
               END-IF
           END-IF.
      *
      *    �󒍓��t
           MOVE  JF020-JUCHU-DATE  OF  ITF-REC  TO  S010-DATE.
           CALL  "KCBS010"  USING  KCBS010-P1.
           IF  S010-RCD  =  "E"
               MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC  (3)
           ELSE
               MOVE  S010-DATE8  TO  JF020-JUCHU-DATE  OF  OTF-REC
           END-IF.
      *
      *    ���Ӑ�R�[�h
           IF  JF020-TOKU-COD  OF  ITF-REC  =  SPACE
               MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC  (4)
           END-IF.
      *
      *    ���i�ԍ�
           IF  JF020-SHOHIN-NO  OF  ITF-REC  IS  NOT  NUMERIC
               MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC  (5)
           ELSE
               IF  JF020-SHOHIN-NO  OF  ITF-REC  =  ZERO
                   MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC  (5)
               END-IF
           END-IF.
      *
      *    ����
           IF  JF020-SURYO  OF  ITF-REC  IS  NOT  NUMERIC
               MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC  (6)
           ELSE
               IF  JF020-SURYO  OF  ITF-REC  <  1  OR  >  999
                   MOVE  "1"  TO  JF020-ERR-KBN  OF  OTF-REC  (6)
               END-IF
           END-IF.
      *
           PERFORM  WRITE-RTN.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      ***************************************************
      *  �o�͏���
      ***************************************************
       WRITE-RTN                SECTION.
           WRITE  OTF-REC.
           ADD   1   TO  OTF-CNT.
       EXT.
           EXIT.
      ***************************************************
      *  �I������
      ***************************************************
       TERM-RTN                 SECTION.
           CLOSE  ITF-FILE  OTF-FILE.
           DISPLAY  "*** ITF-CNT="  ITF-CNT.
           DISPLAY  "*** OTF-CNT="  OTF-CNT.
           DISPLAY  "*** KJBM020  END ***".
       EXT.
           EXIT.