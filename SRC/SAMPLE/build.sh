#!/bin/sh
set -eu

SCRIPTDIR=$(cd $(dirname $0); pwd);
BINDIR="${SCRIPTDIR}/../../bin"
COPYLIBDIR="${SCRIPTDIR}/../../copylib"
DIRNAME=$(basename "${SCRIPTDIR}")

cd "$SCRIPTDIR"
[ ! -d "${BINDIR}" ] && mkdir "${BINDIR}" 
cobc -x -o "${BINDIR}/${DIRNAME}" -I"${COPYLIBDIR}" MAIN.COB
