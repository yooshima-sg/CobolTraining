000010******************************************************************
000020*    KCCFTOK : ìæà”êÊÉ}ÉXÉ^                      LRECL=200
000030******************************************************************
000040     03  CFTOK-TOKU-COD              PIC  X(04).
000050     03  CFTOK-TOKU-MEI              PIC  X(20).
000060     03  CFTOK-URIKAKE-ZAN           PIC S9(09) PACKED-DECIMAL.
000070     03  CFTOK-URIAGE-INF.
000080       05  CFTOK-URIAGE-GAKU         PIC S9(09) PACKED-DECIMAL
000090                                     OCCURS 12 TIMES.
000100     03  CFTOK-NYUKIN-INF.
000110       05  CFTOK-NYUKIN-GAKU         PIC S9(09) PACKED-DECIMAL
000120                                     OCCURS 12 TIMES.
000130     03  FILLER                      PIC  X(51).
