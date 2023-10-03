# UNIX-COBOL研修環境構築スクリプト

システム技研におけるUNIX-COBOL研修環境サーバを自動で構築する為のスクリプトです。

## 使い方

このフォルダに入っているファイルを全て、対象となるサーバにアップロードします。
その後対象となるサーバにログインして、「build.sh」を管理者権限で実行します。


## 動作確認済みの環境

* [Ubuntu 22.04](https://jp.ubuntu.com/) ([ダウンロードミラー](http://ftp.jaist.ac.jp/pub/Linux/ubuntu-releases/))

## インストールされるソフトウエア

* [GnuCOBOL 3.2-pre](https://sourceforge.net/projects/gnucobol/)
* [OpenCobol ESQL 1.2](https://github.com/opensourcecobol/Open-COBOL-ESQL)
* [esqlOC](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/)
* [GCSORT](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/)
