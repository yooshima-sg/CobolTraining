       IDENTIFICATION        DIVISION.
       PROGRAM-ID.           KJBM000.
      ********************************************************
      * �V�X�e�����@�@�@�F���C
      * �T�u�V�X�e�����@�F
      * �v���O�������@�@�F�t�@�C���̓]�L����
      * �쐬�ҁ^�쐬�ҁ@�F�Q�O�Q�Q�N�P�Q���Q��  �V�X�e���Z��
      * �ύX���^�ύX�ҁ@�F
      * �@�@�@�ύX���e�@�F
      ********************************************************
       ENVIRONMENT           DIVISION.
       INPUT-OUTPUT          SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN  TO  EXTERNAL  ITF
                   ORGANIZATION  LINE  SEQUENTIAL.

           SELECT  OTF-FILE  ASSIGN  TO  EXTERNAL  OTF
                   ORGANIZATION  LINE  SEQUENTIAL.
      *
       DATA                  DIVISION.
       FILE                  SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           03  JF010-DATA             PIC   X(10).
      *
       FD  OTF-FILE.
       01  OTF-REC.
           03  JF020-DATA             PIC   X(10).
      *
       WORKING-STORAGE       SECTION.
       01   ITF-END-FLG               PIC   X(1)  VALUE ZERO.
       01   ITF-CNT                   PIC   9(9)  COMP-3  VALUE 0.
       01   OTF-CNT                   PIC   9(9)  COMP-3  VALUE 0.
      *
      ********************************************************
      *    �t�@�C���̓]�L
      ********************************************************
       PROCEDURE             DIVISION.
            PERFORM   MAIN-RTN.

      ********************************************************
      *    �又��(�G���g���[)
      ********************************************************
       MAIN-RTN              SECTION.
            DISPLAY  "*** KJBM000 START ***".
      *    �ΏۂƂȂ�t�@�C�����J��
            OPEN  INPUT   ITF-FILE.
            OPEN  OUTPUT  OTF-FILE.

      *    �]�L����
            PERFORM  TENKI-RTN  UNTIL  ITF-END-FLG = "1".

      *    �J�����t�@�C�������
            CLOSE  ITF-FILE.
            CLOSE  OTF-FILE.

      *    �ǂݍ��񂾃��R�[�h���A�o�͂������R�[�h����\��
            DISPLAY  "*** ITF = " ITF-CNT " ***".
            DISPLAY  "*** OTF = " OTF-CNT " ***".
            DISPLAY  "*** KJBM000 END ***".
            STOP RUN.

      ********************************************************
      *    �t�@�C���]�L����
      ********************************************************
       TENKI-RTN             SECTION.
      *    ������
            MOVE  SPACE  TO  OTF-REC.

      *    ���̓t�@�C������P���R�[�h��ǂݍ���
            READ  ITF-FILE
                 AT  END
                   MOVE  "1"  TO  ITF-END-FLG
                   GO TO  EXT
                 NOT  AT  END
                   ADD  1  TO  ITF-CNT
            END-READ.

      *    ���R�[�h�̓]�L
            MOVE  JF010-DATA  TO  JF020-DATA.
      
      *    �]�L�������R�[�h���o�͐�t�@�C���֏o��
            WRITE  OTF-REC.
            ADD  1  TO  OTF-CNT.
       EXT.
            EXIT.