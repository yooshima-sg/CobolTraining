# COBOL Language Training Environment

This is a template repository for a COBOL language training environment using DevContainers.

## Available Tools

* [GnuCOBOL 3.2 OSSCONS Patch.2](https://github.com/opensourcecobol/gnucobol-osscons-patch.git)
  * COBOL language compiler
  * The original GnuCOBOL can be found [here](https://sourceforge.net/projects/gnucobol/)
* [esqlOC](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/esql/) in [GnuCOBOL Contributions](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/)
  * A SQL preprocessor that uses ODBC connections
* [GCSORT](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/tools/GCSORT/) in [GnuCOBOL Contributions](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/)
  * A sort utility similar to MFSORT

## Required Applications

* [Visual Studio Code](https://code.visualstudio.com/)
  * Please also install the [Dev Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension.
* Docker
  * If you are using Windows/Mac, please install [Docker Desktop](https://www.docker.com/products/docker-desktop/).
* Git
  * If you are using Windows, please install [Git for Windows](https://gitforwindows.org/).

## How to Use

1. Clone this repository to a suitable folder.
2. Open the cloned folder in VSCode.
3. From the Command Palette (Ctrl + Shift + p), select "Dev Containers: Reopen in Container".
4. You are ready when the files are displayed in the explorer and you can interact with them.

## License

- GnuCOBOL is licensed under `GPLv3`. See [COPYING](https://sourceforge.net/p/gnucobol/code/HEAD/tree/trunk/COPYING).
- esqlOC is licensed under `GPLv3`. See the [COPYING](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/esql/COPYING) file.
  - The runtime library ocsql is licensed under `LGPLv3`. See [COPYING.LESSER](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/esql/COPYING.LESSER).
- GCSORT is licensed under `GPLv3`. See [COPYING](https://sourceforge.net/p/gnucobol/contrib/HEAD/tree/trunk/tools/GCSORT/COPYING).
- Other than the above, configuration files, environment construction scripts (in the .devcontainer folder), sample programs (in the sample folder), etc. are licensed under the `MIT License`.
