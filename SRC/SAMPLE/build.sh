#!/bin/sh
set -eu

BINDIR="../../BIN"
COPYLIBDIR="../../COPYLIB"
SCRIPTDIR=$(cd $(dirname $0); pwd);
DIRNAME=$(basename "${SCRIPTDIR}")

cd "$SCRIPTDIR"
[ ! -d "${BINDIR}" ] && mkdir "${BINDIR}" 
cobc -x -o "${BINDIR}/${DIRNAME}" -I"${COPYLIBDIR}" MAIN.COB
