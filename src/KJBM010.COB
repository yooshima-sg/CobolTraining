       IDENTIFICATION        DIVISION.
       PROGRAM-ID.           KJBM010.
      ********************************************************
      * �V�X�e����      �F���C
      * �T�u�V�X�e����  �F��
      * �v���O������    �F�󒍃`�F�b�N�t�@�C���쐬
      * �쐬�ҁ^�쐬��  �F�Q�O�P�R�N�S���R�O��  �V�X�e���Z��
      * �ύX���^�ύX��  �F
      *       �ύX���e  �F
      ********************************************************
       ENVIRONMENT           DIVISION.
       INPUT-OUTPUT          SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN TO  EXTERNAL  ITF
                   ORGANIZATION  LINE  SEQUENTIAL.
           SELECT  OTF-FILE  ASSIGN TO  EXTERNAL  OTF.
      *
       DATA                  DIVISION.
       FILE                  SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY KJCF010.

       FD  OTF-FILE.
       01  OTF-REC.
           COPY KJCF020.
      *
       WORKING-STORAGE       SECTION.
       01  ITF-END-FLG               PIC   X(1)  VALUE SPACE.
       01  ITF-CNT                   PIC   9(9)  VALUE 0.
       01  OTF-CNT                   PIC   9(9)  VALUE 0.
      *
      ********************************************************
      *    �󒍃`�F�b�N�t�@�C���쐬
      ********************************************************
       PROCEDURE             DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  READ-RTN.
           PERFORM  MAIN-RTN  UNTIL  ITF-END-FLG = "1".
           PERFORM  TERM-RTN.
           STOP  RUN.
      ********************************************************
      *    �J�n����
      ********************************************************
       INIT-RTN              SECTION.
           DISPLAY  "*** KJBM010 START ***".
           OPEN  INPUT   ITF-FILE.
           OPEN  OUTPUT  OTF-FILE.
       EXT.
           EXIT.
      ********************************************************
      *    ���͏���
      ********************************************************
       READ-RTN              SECTION.
           READ  ITF-FILE
             AT  END
               MOVE  "1"  TO  ITF-END-FLG
             NOT  AT  END
               ADD  1  TO  ITF-CNT
           END-READ.
       EXT.
           EXIT.
      ********************************************************
      *    �ҏW����
      ********************************************************
       MAIN-RTN           SECTION.
      *    ������
           MOVE  SPACE  TO  OTF-REC.
           MOVE  ZERO   TO  JF020-JUCHU-Y1.
           MOVE  ZERO   TO  JF020-TANKA.
           MOVE  ZERO   TO  JF020-KINGAKU.
      *    �f�[�^�Z�b�g
           MOVE  JF010-DATA-KBN    TO  JF020-DATA-KBN.
           MOVE  JF010-JUCHU-NO-X  TO  JF020-JUCHU-NO-X.
           MOVE  JF010-JUCHU-DATE  TO  JF020-JUCHU-DATE6.
           MOVE  JF010-TOKU-COD    TO  JF020-TOKU-COD.
           MOVE  JF010-SHOHIN-NO   TO  JF020-SHOHIN-NO.
           MOVE  JF010-SURYO-X     TO  JF020-SURYO-X.
           MOVE  SPACE             TO  JF020-TOKU-MEI.
      *
           PERFORM  WRITE-RTN.
           PERFORM  READ-RTN.
       EXT.
            EXIT.
      ********************************************************
      *    �o�͏���
      ********************************************************
       WRITE-RTN           SECTION.
           WRITE  OTF-REC.
           ADD  1  TO  OTF-CNT.
       EXT.
           EXIT.
      ********************************************************
      *    �I������
      ********************************************************
       TERM-RTN           SECTION.
           CLOSE  ITF-FILE.
           CLOSE  OTF-FILE.
           DISPLAY  "*** ITF = " ITF-CNT " ***".
           DISPLAY  "*** OTF = " OTF-CNT " ***".
           DISPLAY  "*** KJBM010 END ***".
       EXT.
           EXIT.