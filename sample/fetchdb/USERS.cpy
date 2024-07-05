      * アクセスするテーブルの情報(任意、なくてもよい)
      * DB2では、データ型のチェックを行っていて、異なると警告を出す。
       EXEC SQL 
           DECLARE USERINFO TABLE (
               USERID      CHAR(5)  NOT NULL,
               USERNAME    CHAR(32) NOT NULL,
               USERAGE     CHAR(5)  NOT NULL 
           )
       END-EXEC.
      
      * DBの情報を格納するための集団項目
       01 USERINFO.
           03  USERID      PIC X(5).
           03  USERNAME    PIC X(32).
           03  USERAGE     PIC X(5).
           