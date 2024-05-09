       IDENTIFICATION             DIVISION.
       PROGRAM-ID.                KJBM060.
      ********************************************************
      * システム名    ：研修
      * サブシステム名：受注
      * プログラム名  ：受注エラーリスト作成
      * 作成日／作成者：２０１３年４月３０日  システム技研
      * 変更日／変更者：
      *       変更内容：
      ********************************************************
       ENVIRONMENT                 DIVISION.
       INPUT-OUTPUT                SECTION.
       FILE-CONTROL.
           SELECT  ITF-FILE  ASSIGN  TO  EXTERNAL  ITF.
           SELECT  OEF-FILE  ASSIGN  TO  EXTERNAL  OEF.
      *
       DATA                        DIVISION.
       FILE                        SECTION.
       FD  ITF-FILE.
       01  ITF-REC.
           COPY  KJCF020.
       FD  OEF-FILE.
       01  OEF-REC                 PIC   X(135).
      *
       WORKING-STORAGE             SECTION.
       01  ITF-CNT                 PIC  S9(9)  COMP-3  VALUE  +0.
       01  OEF-CNT                 PIC  S9(9)  COMP-3  VALUE  +0.
       01  LINE-CNT                PIC  S9(3)  COMP-3  VALUE  +0.
       01  PAGE-CNT                PIC  S9(5)  COMP-3  VALUE  +0.
       01  ITF-END-FLG             PIC   X(1)          VALUE  "0".
       01  WK-PC-DATE.
         02  WK-PC-NEN             PIC   X(2).
         02  WK-PC-TUKI            PIC   X(2).
         02  WK-PC-NITI            PIC   X(2).
      *  大見出し
       01  WK-OOMIDASHI.
         02  FILLER                PIC  X(10)  VALUE  SPACE.
         02  FILLER                PIC  X(6)   VALUE  "＊＊＊".
         02  FILLER                PIC  X(2)   VALUE  SPACE.
         02  FILLER                PIC  X(16)  VALUE  
                                        "受注エラーリスト".
         02  FILLER                PIC  X(2)   VALUE  SPACE.
         02  FILLER                PIC  X(6)   VALUE  "＊＊＊".
         02  FILLER                PIC  X(11)  VALUE  SPACE.
         02  FILLER                PIC  X(4)   VALUE  "DATE".
         02  FILLER                PIC  X(1)   VALUE  SPACE.
         02  WK-TODAYS-DATE.
           03  WK-NEN              PIC  X(2).
           03  FILLER              PIC  X(1)   VALUE  ".".
           03  WK-TUKI             PIC  X(2).
           03  FILLER              PIC  X(1)   VALUE  ".".
           03  WK-NITI             PIC  X(2).
         02  FILLER                PIC  X(3)   VALUE  SPACE.
         02  FILLER                PIC  X(4)   VALUE  "PAGE".
         02  FILLER                PIC  X(1)   VALUE  SPACE.
         02  WK-PAGE-NO            PIC  Z,ZZ9.
         02  FILLER                PIC  X(56)  VALUE  SPACE.
      *  小見出し
       01  WK-KOMIDASI1.
         02  FILLER                PIC  X(6)   VALUE  "データ".
         02  FILLER                PIC  X(28)  VALUE  SPACE.
         02  FILLER                PIC  X(6)   VALUE  "得意先".
         02  FILLER                PIC  X(96)  VALUE  SPACE.
       01  WK-KOMIDASI2.
         02  FILLER                PIC  X(2)   VALUE  SPACE.
         02  FILLER                PIC  X(4)   VALUE  "区分".
         02  FILLER                PIC  X(4)   VALUE  SPACE.
         02  FILLER                PIC  X(8)   VALUE  "受注番号".
         02  FILLER                PIC  X(4)   VALUE  SPACE.
         02  FILLER                PIC  X(8)   VALUE  "受注日付".
         02  FILLER                PIC  X(4)   VALUE  SPACE.
         02  FILLER                PIC  X(6)   VALUE  "コード".
         02  FILLER                PIC  X(4)   VALUE  SPACE.
         02  FILLER                PIC  X(8)   VALUE  "商品番号".
         02  FILLER                PIC  X(6)   VALUE  SPACE.
         02  FILLER                PIC  X(6)   VALUE  "数  量".
         02  FILLER                PIC  X(5)   VALUE  SPACE.
         02  FILLER                PIC  X(6)   VALUE  "備  考".
         02  FILLER                PIC  X(60)  VALUE  SPACE.
      *  明細
       01  WK-MEISAI.
         02  FILLER                PIC  X(2)   VALUE  SPACE.
         02  WK-DATA-KBN-ERR       PIC  X(1)   VALUE  SPACE.
         02  FILLER                PIC  X(1)   VALUE  SPACE.
         02  WK-DATA-KBN           PIC  X(1)   VALUE  SPACE.
         02  FILLER                PIC  X(6)   VALUE  SPACE.
         02  WK-JUCHU-NO-ERR       PIC  X(1)   VALUE  SPACE.
         02  FILLER                PIC  X(1)   VALUE  SPACE.
         02  WK-JUCHU-NO           PIC  X(4)   VALUE  SPACE.
         02  FILLER                PIC  X(5)   VALUE  SPACE.
         02  WK-JUCHU-DATE-ERR     PIC  X(1)   VALUE  SPACE.
         02  FILLER                PIC  X(1)   VALUE  SPACE.
         02  WK-JUCHU-DATE         PIC  X(6)   VALUE  SPACE.
         02  FILLER                PIC  X(4)   VALUE  SPACE.
         02  WK-TOKU-COD-ERR       PIC  X(1)   VALUE  SPACE.
         02  FILLER                PIC  X(1)   VALUE  SPACE.
         02  WK-TOKU-COD           PIC  X(4)   VALUE  SPACE.
         02  FILLER                PIC  X(4)   VALUE  SPACE.
         02  WK-SHOHIN-NO-ERR      PIC  X(1)   VALUE  SPACE.
         02  FILLER                PIC  X(1)   VALUE  SPACE.
         02  WK-SHOHIN-NO          PIC  X(5)   VALUE  SPACE.
         02  FILLER                PIC  X(5)   VALUE  SPACE.
         02  WK-SURYO-ERR          PIC  X(1)   VALUE  SPACE.
         02  FILLER                PIC  X(1)   VALUE  SPACE.
         02  WK-SURYO              PIC  X(5)   VALUE  SPACE.
         02  FILLER                PIC  X(4)   VALUE  SPACE.
         02  WK-BIKO               PIC  X(12)  VALUE  SPACE.
         02  FILLER                PIC  X(56)  VALUE  SPACE.
      *
      ********************************************************
      * 受注エラーリスト作成
      ********************************************************
       PROCEDURE                   DIVISION.
           PERFORM  INIT-RTN.
           PERFORM  INSATU-RTN  UNTIL  ITF-END-FLG  = "1".
           PERFORM  TERM-RTN.
           STOP  RUN.
      ********************************************************
      * 開始処理
      ********************************************************
       INIT-RTN                    SECTION.
           DISPLAY  "*** KJBM060 START ***".
           OPEN  INPUT   ITF-FILE.
           OPEN  OUTPUT  OEF-FILE.
           ACCEPT  WK-PC-DATE  FROM  DATE.
           MOVE  WK-PC-NEN   TO  WK-NEN.
           MOVE  WK-PC-TUKI  TO  WK-TUKI.
           MOVE  WK-PC-NITI  TO  WK-NITI.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      ********************************************************
      * 入力処理
      ********************************************************
       READ-RTN                    SECTION.
           READ  ITF-FILE
             AT  END
               MOVE  "1"  TO  ITF-END-FLG
             NOT  AT  END
               ADD  +1  TO  ITF-CNT
           END-READ.
       EXT.
           EXIT.
      ********************************************************
      * 印刷処理
      ********************************************************
       INSATU-RTN                  SECTION.
           IF  LINE-CNT  >=  +25  OR  ITF-CNT  =  +1
             PERFORM  HEADING-INSATU-RTN
           END-IF.
           PERFORM  MEISAI-INSATU-RTN.
           PERFORM  READ-RTN.
       EXT.
           EXIT.
      ********************************************************
      * 見出し印刷処理
      ********************************************************
       HEADING-INSATU-RTN          SECTION.
           MOVE  +0  TO  LINE-CNT.
           ADD   +1  TO  PAGE-CNT.
           MOVE  PAGE-CNT  TO  WK-PAGE-NO.
           MOVE  WK-OOMIDASHI   TO  OEF-REC.
           WRITE  OEF-REC  AFTER  PAGE.
           MOVE  WK-KOMIDASI1  TO  OEF-REC.
           WRITE  OEF-REC  AFTER  2.
           MOVE  WK-KOMIDASI2  TO  OEF-REC.
           WRITE  OEF-REC  AFTER  1.
       EXT.
           EXIT.
      ********************************************************
      * 明細印刷処理
      ********************************************************
       MEISAI-INSATU-RTN           SECTION.
           MOVE  SPACE  TO  WK-MEISAI.
           MOVE  JF020-DATA-KBN     TO  WK-DATA-KBN.
           MOVE  JF020-JUCHU-NO     TO  WK-JUCHU-NO.
           MOVE  JF020-JUCHU-DATE6  TO  WK-JUCHU-DATE.
           MOVE  JF020-TOKU-COD     TO  WK-TOKU-COD.
           MOVE  JF020-SHOHIN-NO    TO  WK-SHOHIN-NO.
           MOVE  JF020-SURYO        TO  WK-SURYO.
      *
           PERFORM  ERR-HYOUKA-RTN.
      *
           MOVE  WK-MEISAI  TO  OEF-REC.
           WRITE  OEF-REC  AFTER  2.
           ADD  +1  TO  OEF-CNT.
           ADD  +1  TO  LINE-CNT.
       EXT.
           EXIT.
      ********************************************************
      * エラー評価処理
      ********************************************************
       ERR-HYOUKA-RTN              SECTION.
           IF  JF020-ERR-KBN  (1)  NOT  =  SPACE
             MOVE  "*"  TO  WK-DATA-KBN-ERR
           END-IF.
           IF  JF020-ERR-KBN  (2)  NOT  =  SPACE
             MOVE  "*"  TO  WK-JUCHU-NO-ERR
           END-IF.
           IF  JF020-ERR-KBN  (3)  NOT  =  SPACE
             MOVE  "*"  TO  WK-JUCHU-DATE-ERR
           END-IF.
           IF  JF020-ERR-KBN  (6)  NOT  =  SPACE
             MOVE  "*"  TO  WK-SURYO-ERR
           END-IF.
      *
           IF  JF020-ERR-KBN  (4)  NOT  =  SPACE
             MOVE  "*"  TO  WK-TOKU-COD-ERR
             IF  JF020-ERR-KBN  (4)  =  "2"
               MOVE  "マスタ無し"  TO  WK-BIKO
             END-IF
           END-IF.
      *
           IF  JF020-ERR-KBN  (5)  NOT  =  SPACE
             MOVE  "*"  TO  WK-SHOHIN-NO-ERR
             IF  JF020-ERR-KBN  (5)  =  "2"
               MOVE  "マスタ無し"  TO  WK-BIKO
             END-IF
           END-IF.
       EXT.
           EXIT.
      ********************************************************
      * 終了処理
      ********************************************************
       TERM-RTN                    SECTION.
           CLOSE  ITF-FILE  OEF-FILE.
           DISPLAY  "*** ITF-CNT="  ITF-CNT.
           DISPLAY  "*** OEF-CNT="  OEF-CNT.
           DISPLAY  "***  KJBM060 END  ***".
       EXT.
           EXIT.
