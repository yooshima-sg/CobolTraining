000010******************************************************************
000020*    KCCFSHO : 商品マスタ                        LRECL=50
000030******************************************************************
000040     03  CFSHO-SHOHIN-NO             PIC  X(05).
000050     03  CFSHO-SHOHIN-MEI            PIC  X(20).
000060     03  CFSHO-TANKA                 PIC S9(05)V9(2)
000070                                                PACKED-DECIMAL.
000080     03  CFSHO-ZAIKO-INF.
000090       05  CFSHO-ZENGETU-ZAIKO       PIC S9(07) PACKED-DECIMAL.
000100       05  CFSHO-TOUGETU-NYUKO       PIC S9(07) PACKED-DECIMAL.
000110       05  CFSHO-TOUGETU-SYUKO       PIC S9(07) PACKED-DECIMAL.
000120     03  FILLER                      PIC  X(09).
