       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         KUBM030A.
      ************************************************
      * �V�X�e����    �F���C
      * �T�u�V�X�e�����F����
      * �v���O������  �F����X�V
      * �쐬���^�쐬�ҁF�Q�O�Q�R�N�P���Q�S��  �V�X�e���Z��
      * �ύX���^�ύX�ҁF
      *       �ύX���e�FGnuCOBOL + OpenCOBOL ESQL����
      *                 �������T�|�[�g���Ă��Ȃ��@�\���ցB
      ************************************************
      *
       ENVIRONMENT         DIVISION.
       INPUT-OUTPUT        SECTION.
       FILE-CONTROL.
      *
       SELECT ITF-FILE ASSIGN EXTERNAL ITF.
      *
       DATA                DIVISION.
       FILE                SECTION.
       FD ITF-FILE.
       01 ITF-REC.
         COPY KUCF020.

       WORKING-STORAGE     SECTION.
       01 WK-ITF-END-FLG   PIC  X VALUE "N".
       01 WK-ITF-CNT       PIC  9(9) PACKED-DECIMAL VALUE 0.
      *
       01 WK-DBERR-FLG     PIC  X VALUE "N".
       01 WK-DBUPDATE-CNT  PIC  9(9) PACKED-DECIMAL VALUE 0.
      *
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
      * ocesql�� COPY��̉�͂ɖ��Ή��̂��߁A�e�[�u���X�V�ɕK�v��
      * ��Ӗ��̒�`��COPY�t�@�C������q�؂��ė��p����B
      * COPY�傪���߂ł���v���v���Z�b�T�𗘗p���Ă���ꍇ�́A�K��
      * COPY����g�����ƁB
      *
      * COPY KCCMTOK.
       01 CMTOK-TOKU-COD     PIC  X(04).
       01 CMTOK-URIKAKE-YM   PIC  X(06).
       01 CMTOK-URIAGE-GAKU  PIC S9(09).
       01 WK-DB-DUMMY        PIC  X(4).
      *
       01 DBNAME           PIC  X(32) VALUE "$$DBNAME$$@$$SERVER$$".    *> �y�v�ύX�z�f�[�^�x�[�X@�ڑ���T�[�o��
       01 USERNAME         PIC  X(32) VALUE "$$USERNAME$$".             *> �y�v�ύX�z���[�U��
       01 PASSWORD         PIC  X(32) VALUE "$$PASSWORD$$".             *> �y�v�ύX�z�p�X���[�h
       EXEC SQL END DECLARE SECTION END-EXEC.
      *
       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE           DIVISION.
           PERFORM INIT-RTN.
           PERFORM MAIN-RTN UNTIL WK-ITF-END-FLG = "Y".
           PERFORM SUCCESSFUL-TERM-RTN.
      *
       INIT-RTN            SECTION.
           DISPLAY  "*** KUBM030 START ***".
      *
           OPEN INPUT ITF-FILE.
      *
           EXEC SQL
             CONNECT :USERNAME
             IDENTIFIED BY :PASSWORD
             USING :DBNAME
           END-EXEC.
           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.
      *
           PERFORM READ-RTN.
       EXT.
           EXIT.

       MAIN-RTN            SECTION.
      * ocesql �v���v���Z�b�T��WHENEVER�����T�|�[�g���Ă��Ȃ��ׁA
      * ��ֈĂƂ��āA���O�ɃL�[���ڂ����f�[�^�����݂��邩SELECT���A
      * �m�F������@(1)���Ƃ�B
      *
      * �Ȃ��AUPDATE���ߎ��s���ɍX�V�ΏۂƂȂ郌�R�[�h��0����������
      * ���ꂪ�ANOT FOUND �����ɓ��Ă͂܂邩�ǂ����́ARDBMS�̎�����
      * ����ĈقȂ邽�߁A���p����ꍇ�͎��O�Ƀ}�j���A�������`�F�b�N
      * ���Ă������ƁB
      *    EXEC SQL
      *      WHENEVER NOT FOUND GO TO :DBERR-TERM-RTN
      *    END-EXEC.

           MOVE UF020-TOKU-COD TO CMTOK-TOKU-COD.
           MOVE UF020-JUCHU-DATE TO CMTOK-URIKAKE-YM.
           MOVE UF020-KINGAKU TO CMTOK-URIAGE-GAKU.
      * (1) �������� ----
           EXEC SQL
             SELECT CMTOK_TOKU_COD INTO :WK-DB-DUMMY
               FROM KCCMTOK
               WHERE CMTOK_TOKU_COD = :CMTOK-TOKU-COD AND
                     CMTOK_URIKAKE_YM = :CMTOK-URIKAKE-YM
           END-EXEC.
           PERFORM DISPLAY-SQLCA-RTN.
           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.
      * (1) �����܂� ---
           EXEC SQL
             UPDATE KCCMTOK
             SET
               CMTOK_URIAGE_GAKU =
                   CMTOK_URIAGE_GAKU + :CMTOK-URIAGE-GAKU,
               CMTOK_URIKAKE_ZAN =
                   CMTOK_URIKAKE_ZAN + :CMTOK-URIAGE-GAKU
             WHERE
               CMTOK_TOKU_COD = :CMTOK-TOKU-COD AND
               CMTOK_URIKAKE_YM = :CMTOK-URIKAKE-YM
           END-EXEC.
           ADD +1 TO WK-DBUPDATE-CNT.
      *
           PERFORM READ-RTN.
       EXT.
           EXIT.

       READ-RTN            SECTION.
           READ ITF-FILE
             AT END
               MOVE "Y" TO WK-ITF-END-FLG
             NOT AT END
               ADD +1 TO WK-ITF-CNT
           END-READ.
       EXT.
           EXIT.

       DISPLAY-SQLCA-RTN    SECTION.
           DISPLAY "SQLCA:CODE=" SQLCODE
                   ", STATE=" SQLSTATE
                   ",ERRM=" SQLERRM.
       EXT.
           EXIT.

       SUCCESSFUL-TERM-RTN  SECTION.
           EXEC SQL
             COMMIT
           END-EXEC.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       DBERR-TERM-RTN      SECTION.
           EXEC SQL
             ROLLBACK
           END-EXEC.
           DISPLAY "!!! KUBM030 ABEND !!! TCODE=" CMTOK-TOKU-COD
                   ",YM=" CMTOK-URIKAKE-YM ",GAKU=" CMTOK-URIAGE-GAKU.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       TERM-RTN            SECTION.
           EXEC SQL
               DISCONNECT ALL
           END-EXEC.
      *
           CLOSE ITF-FILE.
      *
           DISPLAY "   ITF=" WK-ITF-CNT.
           DISPLAY "UPDATE=" WK-DBUPDATE-CNT.
           DISPLAY "*** KUBM030 END ***".
       EXT.
           STOP RUN.