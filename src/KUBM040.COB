       IDENTIFICATION             DIVISION.
       PROGRAM-ID.                KUBM040.
      *****************************************************
      * �V�X�e����    �F���C
      * �T�u�V�X�e�����F����
      * �v���O������  �F���㖾�׃��X�g�쐬
      * �쐬���^�쐬�ҁF�Q�O�P�R�N�S���R�O��  �V�X�e���Z��
      * �ύX���^�ύX�ҁF
      *       �ύX���e�F
      *****************************************************
       ENVIRONMENT                DIVISION.
       INPUT-OUTPUT               SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN  TO  ITF.
           SELECT  OEF-FILE  ASSIGN  TO  OEF.
      *
       DATA                       DIVISION.
       FILE                       SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KUCF010.
       FD  OEF-FILE.
       01  OEF-REC                PIC  X(135).
       WORKING-STORAGE            SECTION.
       01  ITF-CNT                PIC  S9(9)          VALUE  +0.
       01  OEF-CNT                PIC  S9(9)          VALUE  +0.
       01  LINE-CNT               PIC  S9(3)  COMP-3  VALUE  +99.
       01  PAGE-CNT1              PIC  S9(3)  COMP-3  VALUE  +0.
       01  PAGE-CNT2              PIC  S9(5)  COMP-3  VALUE  +0.
       01  WK-SKIP-LINE           PIC  S9(1)          VALUE  +0.
       01  WK-ITF-COD             PIC   X(4)          VALUE  LOW-VALUE.
       01  WK-ITF-DATE            PIC   X(8)          VALUE  LOW-VALUE.
       01  WK-OLD-COD             PIC   X(4)          VALUE  LOW-VALUE.
       01  WK-OLD-DATE            PIC   X(8)          VALUE  LOW-VALUE.
       01  WK-PC-DATE.
         02  WK-PC-NEN            PIC   X(2).
         02  WK-PC-TUKI           PIC   X(2).
         02  WK-PC-NITI           PIC   X(2).
       01  WK-COMP-KINGAKU        PIC  S9(9)  COMP-3  VALUE  +0.
       01  WK-COMP-GOKEI          PIC  S9(9)  COMP-3  VALUE  +0.
       01  WK-JUCHU-DATE.
           03  WK-JUCHU-YY        PIC   X(4).
           03  FILLER             PIC   X(1)   VALUE  ".".
           03  WK-JUCHU-MM        PIC   X(2).
           03  FILLER             PIC   X(1)   VALUE  ".".
           03  WK-JUCHU-DD        PIC   X(2).
      * �匩�o��
       01  H1-OOMIDASHI.
         02  FILLER               PIC   X(10)  VALUE  SPACE.
         02  FILLER               PIC   X(6)   VALUE  "������".
         02  FILLER               PIC   X(2)   VALUE  SPACE.
         02  FILLER               PIC   X(14)  VALUE  "���㖾�׃��X�g".
         02  FILLER               PIC   X(2)   VALUE  SPACE.
         02  FILLER               PIC   X(6)   VALUE  "������".
         02  FILLER               PIC   X(10)  VALUE  SPACE.
         02  FILLER               PIC   X(4)   VALUE  "DATE".
         02  FILLER               PIC   X(1)   VALUE  SPACE.
         02  H1-TODAYS-DATE.
           03  H1-NEN             PIC   X(2).
           03  FILLER             PIC   X(1)   VALUE  ".".
           03  H1-TUKI            PIC   X(2).
           03  FILLER             PIC   X(1)   VALUE  ".".
           03  H1-NITI            PIC   X(2).
         02  FILLER               PIC   X(2)   VALUE  SPACE.
         02  FILLER               PIC   X(4)   VALUE  "PAGE".
         02  FILLER               PIC   X(1)   VALUE  SPACE.
         02  H1-PAGE-NO1          PIC   ZZ9.
         02  FILLER               PIC   X(1)   VALUE  "/".
         02  H1-PAGE-NO2          PIC   Z,ZZ9.
         02  FILLER               PIC   X(56)  VALUE  SPACE.
       01  H2-OOMIDASHI.
         02  FILLER               PIC   X(8)   VALUE  "���Ӑ�F".
         02  FILLER               PIC   X(1)   VALUE  SPACE.
         02  H2-TOKU-COD          PIC   X(4).
         02  FILLER               PIC   X(1)   VALUE  SPACE.
         02  H2-TOKU-MEI          PIC   X(20)  VALUE  SPACE.
         02  FILLER               PIC   X(101) VALUE  SPACE.
      * �����o��
       01  H3-KOMIDASHI.
         02  FILLER               PIC   X(8)   VALUE  "�󒍓��t".
         02  FILLER               PIC   X(4)   VALUE  SPACE.
         02  FILLER               PIC   X(8)   VALUE  "�󒍔ԍ�".
         02  FILLER               PIC   X(2)   VALUE  SPACE.
         02  FILLER               PIC   X(8)   VALUE  "���i�ԍ�".
         02  FILLER               PIC   X(2)   VALUE  SPACE.
         02  FILLER               PIC   X(6)   VALUE  "���i��".
         02  FILLER               PIC   X(16)  VALUE  SPACE.
         02  FILLER               PIC   X(6)   VALUE  "�P  ��".
         02  FILLER               PIC   X(3)   VALUE  SPACE.
         02  FILLER               PIC   X(4)   VALUE  "����".
         02  FILLER               PIC   X(6)   VALUE  SPACE.
         02  FILLER               PIC   X(6)   VALUE  "��  �z".
         02  FILLER               PIC   X(56)  VALUE  SPACE.
      * ����
       01  D1-MEISAI.
         02  D1-JUCHU-DATE        PIC   X(10).
         02  FILLER               PIC   X(4)   VALUE  SPACE.
         02  D1-JUCHU-NO          PIC   9(4).
         02  FILLER               PIC   X(4)   VALUE  SPACE.
         02  D1-SHOHIN-NO         PIC   X(5).
         02  FILLER               PIC   X(3)   VALUE  SPACE.
         02  D1-SHOHIN-MEI        PIC   X(20).
         02  FILLER               PIC   X(1)   VALUE  SPACE.
         02  D1-TANKA             PIC   ZZ,ZZ9.99.
         02  FILLER               PIC   X(1)   VALUE  SPACE.
         02  D1-SURYO             PIC   ZZ,ZZ9.
         02  FILLER               PIC   X(1)   VALUE  SPACE.
         02  D1-KINGAKU           PIC   ---,---,--9.
         02  FILLER               PIC   X(56)  VALUE  SPACE.
      * �r��
       01  F1-TOKU-KEI.
         02  FILLER               PIC   X(50)  VALUE  SPACE.
         02  FILLER               PIC   X(14)  VALUE  "�����Ӑ捇�v��".
         02  FILLER               PIC   X(4)   VALUE  SPACE.
         02  F1-KINGAKU-GOKEI     PIC   ---,---,--9.
         02  FILLER               PIC   X(56)  VALUE  SPACE.
      *****************************************************
      * ���㖾�׃��X�g�쐬
      *****************************************************
       PROCEDURE                  DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  PRINT-RTN
             UNTIL  WK-ITF-COD  =  HIGH-VALUE.
           PERFORM  TERM-RTN.
           STOP  RUN.
      *****************************************************
      * �J�n����
      *****************************************************
       INIT-RTN                   SECTION.
           DISPLAY  "*** KUBM040  START ***".
           OPEN  INPUT   ITF-FILE.
           OPEN  OUTPUT  OEF-FILE.
           ACCEPT  WK-PC-DATE  FROM  DATE.
           MOVE  WK-PC-NEN  TO  H1-NEN.
           MOVE  WK-PC-TUKI TO  H1-TUKI.
           MOVE  WK-PC-NITI TO  H1-NITI.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      *****************************************************
      * ���͏���
      *****************************************************
       READ-RTN                   SECTION.
           READ  ITF-FILE
           AT  END
             MOVE  HIGH-VALUE  TO  WK-ITF-COD
           NOT  AT  END
             ADD  +1  TO  ITF-CNT
             MOVE  UF010-TOKU-COD   TO  WK-ITF-COD
             MOVE  UF010-JUCHU-DATE TO  WK-ITF-DATE
           END-READ.
       EXT.
           EXIT.
      *****************************************************
      * �������
      *****************************************************
       PRINT-RTN                   SECTION.
           PERFORM  KINGAKU-SYOKI-RTN.
           PERFORM  UNTIL  WK-ITF-COD  NOT  =  WK-OLD-COD
             IF  LINE-CNT  >=  50
               PERFORM  MIDASHI-RTN
               MOVE  LOW-VALUE  TO  WK-OLD-DATE
             END-IF
             PERFORM  MEISAI-RTN
             PERFORM  READ-RTN
           END-PERFORM.
           MOVE  WK-COMP-GOKEI  TO  F1-KINGAKU-GOKEI.
           MOVE  F1-TOKU-KEI    TO  OEF-REC.
           WRITE  OEF-REC  AFTER  2.
       EXT.
           EXIT.
      *****************************************************
      * ���z��������
      *****************************************************
       KINGAKU-SYOKI-RTN          SECTION.
           MOVE  +99  TO  LINE-CNT.
           MOVE  WK-ITF-COD  TO  WK-OLD-COD.
           MOVE  +0  TO  WK-COMP-GOKEI.
           MOVE  +0  TO  PAGE-CNT1.
       EXT.
           EXIT.
      *****************************************************
      * ���׈������
      *****************************************************
       MEISAI-RTN                 SECTION.
           MOVE  UF010-JUCHU-YY      TO  WK-JUCHU-YY.
           MOVE  UF010-JUCHU-MM      TO  WK-JUCHU-MM.
           MOVE  UF010-JUCHU-DD      TO  WK-JUCHU-DD.
           MOVE  WK-JUCHU-DATE       TO  D1-JUCHU-DATE.
           MOVE  UF010-JUCHU-NO      TO  D1-JUCHU-NO.
           MOVE  UF010-SHOHIN-NO     TO  D1-SHOHIN-NO.
           MOVE  UF010-SHOHIN-MEI    TO  D1-SHOHIN-MEI.
           MOVE  UF010-TANKA         TO  D1-TANKA.
           MOVE  UF010-SURYO         TO  D1-SURYO.
           MOVE  UF010-KINGAKU       TO  WK-COMP-KINGAKU.
           PERFORM  COMP-KINGAKU-RTN.
           MOVE  WK-COMP-KINGAKU  TO  D1-KINGAKU.
           IF  WK-ITF-DATE  NOT  =  WK-OLD-DATE
             MOVE  +2  TO  WK-SKIP-LINE
             MOVE  WK-ITF-DATE  TO  WK-OLD-DATE
           ELSE
             MOVE  +1  TO  WK-SKIP-LINE
             MOVE  SPACE  TO  D1-JUCHU-DATE
           END-IF.
           MOVE  D1-MEISAI  TO  OEF-REC.
           WRITE  OEF-REC  AFTER  ADVANCING  WK-SKIP-LINE.
           ADD  +1  TO  OEF-CNT.
           ADD  WK-SKIP-LINE  TO  LINE-CNT.
           COMPUTE  WK-COMP-GOKEI  = 
                    WK-COMP-GOKEI  +  WK-COMP-KINGAKU.
       EXT.
           EXIT.
      *******************************************************
      * ���o���������
      *******************************************************
       MIDASHI-RTN                SECTION.
           ADD   +1  TO  PAGE-CNT2.
           ADD   +1  TO  PAGE-CNT1.
           MOVE  PAGE-CNT1       TO  H1-PAGE-NO1.
           MOVE  PAGE-CNT2       TO  H1-PAGE-NO2.
           MOVE  UF010-TOKU-COD  TO  H2-TOKU-COD.
           MOVE  UF010-TOKU-MEI  TO  H2-TOKU-MEI.
           MOVE  H1-OOMIDASHI    TO  OEF-REC.
           WRITE  OEF-REC  AFTER  PAGE.
           MOVE  H2-OOMIDASHI    TO  OEF-REC.
           WRITE  OEF-REC  AFTER  2.
           MOVE  H3-KOMIDASHI    TO  OEF-REC.
           WRITE  OEF-REC  AFTER  2.
           MOVE  +0  TO  LINE-CNT.
       EXT.
           EXIT.
      ********************************************************
      * ���z�v�Z����
      ********************************************************
       COMP-KINGAKU-RTN                   SECTION.
           IF  UF010-DATA-KBN  NOT  =  1
             COMPUTE  WK-COMP-KINGAKU  =  -1  *  WK-COMP-KINGAKU
           END-IF.
       EXT.
           EXIT.
      ********************************************************
      * �I������
      ********************************************************
       TERM-RTN                   SECTION.
           CLOSE  ITF-FILE  OEF-FILE.
           DISPLAY  "*** ITF-CNT="  ITF-CNT.
           DISPLAY  "*** OEF-CNT="  OEF-CNT.
           DISPLAY  "*** KUBM040   END ***".
       EXT.
           EXIT.