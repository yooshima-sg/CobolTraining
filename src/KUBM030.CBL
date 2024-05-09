       IDENTIFICATION             DIVISION.
       PROGRAM-ID.                KUBM030.
      ************************************************
      * �V�X�e����    �F���C
      * �T�u�V�X�e�����F����
      * �v���O������  �F����X�V
      * �쐬���^�쐬�ҁF�Q�O�P�R�N�S���R�O��  �V�X�e���Z��
      * �ύX���^�ύX�ҁF�Q�O�Q�R�N�T���X��
      *       �ύX���e�FoceSQL�v���R���p�C���p�ɋL�q��ύX�B
      *                 �������A���s�t�@�C���͍쐬�ł�����̂̓��삵�Ȃ��̂Œ��ӁB
      ************************************************
       ENVIRONMENT                DIVISION.
       INPUT-OUTPUT               SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN  TO  ITF.
      *
       DATA                       DIVISION.
       FILE                       SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KUCF020.
      *
       WORKING-STORAGE            SECTION.
       01  ITF-CNT                PIC  S9(9)  COMP-3  VALUE  +0.
       01  KOSHIN-CNT             PIC  S9(9)  COMP-3  VALUE  +0.
       01  ITF-END-FLG            PIC   X(1)          VALUE  "0".
           EXEC  SQL  BEGIN  DECLARE  SECTION  END-EXEC.
       COPY  KCCMTOK.
       01  DBNAME              PIC  X(64) VALUE "$$DBNAME$$@$$SERVER$$".        *> �y�v�ύX�z�f�[�^�א{��@�T�[�o��
       01  USERNAME            PIC  X(32) VALUE "$$USERNAME$$".                 *> �y�v�ύX�z���[�U��
       01  PASSWORD            PIC  X(32) VALUE "$$PASSWORD$$".                 *> �y�v�ύX�z�p�X���[�h
       01  SQLSTATE               PIC   X(5).
           EXEC  SQL  END  DECLARE  SECTION  END-EXEC.

           EXEC SQL INCLUDE SQLCA END-EXEC.

      *
      *****************************************************
      * ����X�V
      *****************************************************
       PROCEDURE                  DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  MAIN-RTN
             UNTIL  ITF-END-FLG  =  "1".
           PERFORM  TERM-RTN.
           STOP  RUN.
      *****************************************************
      * �J�n����
      *****************************************************
       INIT-RTN                   SECTION.
           DISPLAY  "*** KUBM030  START ***".
           OPEN  INPUT  ITF-FILE.
           EXEC  SQL
             CONNECT  :USER-NAME
               IDENTIFIED  BY  :PASSWORD
               USING  :DBNAME
           END-EXEC.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      *****************************************************
      * ���͏���
      *****************************************************
       READ-RTN                   SECTION.
           READ  ITF-FILE
             AT  END
               MOVE  "1"  TO  ITF-END-FLG
             NOT  AT  END
               ADD  +1  TO  ITF-CNT
           END-READ.
       EXT.
           EXIT.
      *****************************************************
      * �X�V����
      *****************************************************
       MAIN-RTN                   SECTION.
           EXEC  SQL
             WHENEVER  NOT  FOUND  GO  TO  :KYOUSEI-END-RTN
           END-EXEC.
           MOVE  UF020-TOKU-COD    TO  CMTOK-TOKU-COD.
           MOVE  UF020-JUCHU-DATE  TO  CMTOK-URIKAKE-YM.
           MOVE  UF020-KINGAKU     TO  CMTOK-URIAGE-GAKU.
           EXEC  SQL
             UPDATE  ktbltok
               SET  urikake_zan  =  urikake_zan  +  :CMTOK-URIAGE-GAKU ,
                    uriage_gaku  =  uriage_gaku  +  :CMTOK-URIAGE-GAKU
               WHERE   toku_cod  =  :CMTOK-TOKU-COD
               AND   urikake_ym  =  :CMTOK-URIKAKE-YM
           END-EXEC.
           ADD  +1  TO  KOSHIN-CNT.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      *****************************************************
      * �����I������
      *****************************************************
       KYOUSEI-END-RTN            SECTION.
           CLOSE  ITF-FILE.
           EXEC  SQL
             ROLLBACK  WORK
           END-EXEC.
           EXEC  SQL
             DISCONNECT  ALL
           END-EXEC.
           DISPLAY  "!!! KUBM030 ABEND!!! TCODE=" UF020-TOKU-COD
                   ", YM=" UF020-JUCHU-DATE  ", GAKU=" UF020-KINGAKU.
           STOP  RUN.
      ******************************************************
      * �I������
      *****************************************************
       TERM-RTN                   SECTION.
           CLOSE  ITF-FILE.
           EXEC  SQL
             COMMIT  WORK
           END-EXEC.
           EXEC  SQL
             DISCONNECT  ALL
           END-EXEC.
           DISPLAY  "***    ITF-CNT=" ITF-CNT.
           DISPLAY  "*** KOSHIN-CNT=" KOSHIN-CNT.
           DISPLAY  "*** KUBM030   END  ***".
       EXT.
           EXIT.