# COBOL実習課題回答一例

システム技研COBOL言語実習課題回答の一例です。

* KJBM010
* KJBM020
* KJBM030
* KJBM040
* KJBM050
* KJBM060
* KUBM010
* KUBM020
* KUBM030
  * KUBM030A: OpenCOBOL ESQLプリプロセッサを利用したバージョン
  * KUBM030B: esqlOCプリプロセッサを利用したバージョン
* KUBM040

## 使用できるツール

* [GnuCOBOL 3.2](https://sourceforge.net/projects/gnucobol/)
  * COBOL言語コンパイラ
* [OpenCobol ESQL 1.3](https://github.com/opensourcecobol/Open-COBOL-ESQL)
  * PostgreSQL 9.0+接続をサポートしたSQLプリプロセッサ
* [esqlOC](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/esql/) in [GnuCOBOL Contributions](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/)
  * ODBCによる接続をサポートしたSQLプリプロセッサ
* [GCSORT](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/tools/GCSORT/) in [GnuCOBOL Contributions](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/)
  * MFSORTのような機能を持つソートユーティリティ

## 必要なアプリ

* [Visual Studio Code](https://code.visualstudio.com/)
  * [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) 拡張もインストールしてください。
* Docker
  * Windows/Macをご利用の方は、[Docker Desktop](https://www.docker.com/products/docker-desktop/)をインストールしてください。
* Git
  * Windowsをご利用の方は、[Git for Windows](https://gitforwindows.org/)をインストールしてください。

## 使い方

1. 本リポジトリを適当なフォルダにクローンします。
2. VSCodeを開きクローンしたフォルダを開きます。
3. コマンドパレット(Ctrl + Shift + p)から「開発コンテナ―: コンテナ―で再度開く」を選択
4. エクスプローラにファイルが表示され、操作できるようになったら準備完了です。

