      ******************************************************************
      *    KJCF011 : 受注データ(ヘッダ・トレーラあり)          LRECL=50
      ******************************************************************
         03  JF011-DATA-KBN                PIC  X(01).
         03  FILLER                        PIC  X(01).
      * データ部
         03  JF011-DATA.
           05  FILLER                      PIC  X(48).
      * 受注情報(データ部を再定義)
         03  JF011-JUCHU-DATA     REDEFINES  JF011-DATA.
           05  JF011-JUCHU-NO-X.
             07  JF011-JUCHU-NO            PIC  9(04).
           05  FILLER                      PIC  X(01).
           05  JF011-JUCHU-DATE.
             07  JF011-JUCHU-YY            PIC  9(02).
             07  JF011-JUCHU-MM            PIC  9(02).
             07  JF011-JUCHU-DD            PIC  9(02).
           05  FILLER                      PIC  X(01).
           05  JF011-TOKU-COD              PIC  X(04).
           05  FILLER                      PIC  X(01).
           05  JF011-SHOHIN-NO             PIC  X(05).
           05  FILLER                      PIC  X(01).
           05  JF011-SURYO-X.
             07  JF011-SURYO               PIC  9(05).
           05  FILLER                      PIC  X(20).
      * ヘッダ情報(データ部を再定義)
         03  JF011-HEADER      REDEFINES  JF011-DATA.
           05  JF011-SAKUSEI-DATE.
             07  JF011-SAKUSEI-YY          PIC  9(04).
             07  JF011-SAKUSEI-MM          PIC  9(02).
             07  JF011-SAKUSEI-DD          PIC  9(02).
           05  FILLER                      PIC  X(40).
      * トレイラー情報(データ部を再定義)
         03  JF011-TRAILER     REDEFINES  JF011-DATA.
           05  JF011-JUCHU-KENSU           PIC  9(09).
           05  FILLER                      PIC  X(39).
