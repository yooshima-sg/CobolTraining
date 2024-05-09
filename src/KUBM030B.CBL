       IDENTIFICATION      DIVISION.
       PROGRAM-ID.         KUBM030B.
      ******************************************************************
      * �V�X�e����    �F���C
      * �T�u�V�X�e�����F����
      * �v���O������  �F����X�V
      * �쐬���^�쐬�ҁF�Q�O�Q�R�N�P���Q�S��  �V�X�e���Z��
      * �ύX���^�ύX�ҁF
      *       �ύX���e�FGnuCOBOL + esqlOC ����
      ******************************************************************
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
       EXEC SQL INCLUDE KCCMTOK END-EXEC.
      *
       01 DSN                PIC  X(256).
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
      * ESQLOC��ODBC�o�R��DB�֐ڑ�����R�[�h�𐶐����邽�߁A�f�[�^�x�[�X
      * �ւ̐ڑ���ODBC�ڑ���������쐬����K�v������B�ڍׂ͉��LURL�Q�ƁB
      * https://www.microfocus.co.jp/manuals/ED60/VS2017/GUID-2B444A32-4991-4396-B9F1-68AB643B5EBA.html
      *
      * �Ȃ��A����SQL����������v���v���Z�b�T�ɂ���āA�f�[�^�x�[�X�ւ�
      * �ڑ����@���قȂ�̂ŁA���̏ꏊ�ŗ��p���Ă���v���v���Z�b�T��
      * �h�L�������g���m�F���邱�ƁB
      *
      * Ubuntu 22.04�ł́Aodbc-postgresql�p�b�P�[�W�̃C���X�g�[�����K�v�B
      *
      * ����SQL�𗘗p����ꍇ�́ACOBOL���̕����R�[�h�ɍ��킹�ăf�[�^��
      * ��������K�v������B���C�̊���'SJIS'�̂��߁A�f�[�^�擾����
      * �����G���R�[�h��'SJIS'�ɐݒ肷��B(���Ȃ��ƕ�����������������)
      * �����G���R�[�h��ݒ肷��ɂ́A
      *   CONNSETTINGS=SET CLIENT_ENCODING TO 'SJIS'
      * ��ڑ�������ɒǉ�����B
           STRING
             "DRIVER={Postgresql Unicode};"                             *> Postgresql ODBC�h���C�o
             "SERVER=$$SERVER$$;"                                       *> �y�v�ύX�z�T�[�o������IP�A�h���X
             "DATABASE=$$DATABSE$$"                                     *> �y�v�ύX�z�f�[�^�x�[�X��
             "USER=$$USER$$;"                                           *> �y�v�ύX�z���[�U��
             "PASSWORD=$$PASSWORD$$;"                                   *> �y�v�ύX�z�p�X���[�h
             "CONNSETTINGS=SET CLIENT_ENCODING to 'SJIS';"              *> �N���C�A���g�����R�[�h
             INTO DSN
           END-STRING.
      
           EXEC SQL CONNECT TO :DSN END-EXEC.
           IF SQLCODE NOT = ZERO
             PERFORM DBERR-TERM-RTN
           END-IF.
      *
           PERFORM READ-RTN.
       EXT.
           EXIT.

       MAIN-RTN            SECTION.
      * UPDATE���ߎ��s���ɍX�V�ΏۂƂȂ郌�R�[�h��0����������
      * ���ꂪ�ANOT FOUND �����ɓ��Ă͂܂邩�ǂ����́ARDBMS�̎�����
      * ����ĈقȂ邽�߁A���p����ꍇ�͎��O��RDBMS�̃}�j���A������
      * �`�F�b�N���Ă������ƁB
      *
           EXEC SQL
             WHENEVER NOT FOUND PERFORM DBERR-TERM-RTN
           END-EXEC.
      *
           MOVE UF020-TOKU-COD TO CMTOK-TOKU-COD.
           MOVE UF020-JUCHU-DATE TO CMTOK-URIKAKE-YM.
           MOVE UF020-KINGAKU TO CMTOK-URIAGE-GAKU.

           EXEC SQL
             UPDATE KCCMTOK
             SET
               CMTOK_URIAGE_GAKU =
                   CMTOK_URIAGE_GAKU + :CMTOK-URIAGE-GAKU,
               CMTOK_URIKAKE_ZAN =
                   CMTOK_URIKAKE_ZAN + :CMTOK-URIAGE-GAKU,
               CMTOK_TOKU_MEI = '�X�V����'
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
           EXEC SQL COMMIT END-EXEC.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       DBERR-TERM-RTN      SECTION.
           EXEC SQL ROLLBACK END-EXEC.
           DISPLAY "!!! KUBM030 ABEND !!! TCODE=" CMTOK-TOKU-COD
                   ",YM=" CMTOK-URIKAKE-YM ",GAKU=" CMTOK-URIAGE-GAKU.
           PERFORM TERM-RTN.
       EXT.
           EXIT.

       TERM-RTN            SECTION.
           EXEC SQL DISCONNECT ALL END-EXEC.
      *
           CLOSE ITF-FILE.
      *
           DISPLAY "   ITF=" WK-ITF-CNT.
           DISPLAY "UPDATE=" WK-DBUPDATE-CNT.
           DISPLAY "*** KUBM030 END ***".
       EXT.
           STOP RUN.