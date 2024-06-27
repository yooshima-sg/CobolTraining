#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
PROGRAMNAME="PICTURES.COB"
BINDIR="${SCRIPTDIR}"
COPYLIBDIR="${SCRIPTDIR}/../../copylib"
DIRNAME=$(basename "${SCRIPTDIR}")
BINNAME=$(basename -s .COB $PROGRAMNAME)

cobc -x -o "${BINDIR}/${BINNAME}" -I"${COPYLIBDIR}" "${PROGRAMNAME}"

export OTF=result.txt
${BINDIR}/${BINNAME}

cat <<__EOF__  > report.txt
==============
プログラム
==============
$(cat ${PROGRAMNAME})

==============
ファイルの出力結果
==============

cat $OTF
----------------------------------------------
$(cat $OTF)
----------------------------------------------

hexdump -C $OTF
----------------------------------------------
$(hexdump -C $OTF)
----------------------------------------------
__EOF__
