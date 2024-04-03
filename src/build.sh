#!/bin/sh
set -eu

SCRIPTDIR=$(cd $(dirname $0); pwd);
BINDIR="${SCRIPTDIR}/../bin"
COPYLIBDIR="${SCRIPTDIR}/../copylib"
DIRNAME=$(basename "${SCRIPTDIR}")

[ ! -d "${BINDIR}" ] && mkdir "${BINDIR}" 

for SRCFILE in "$@"; do
    SRCFILENAME=$(basename -s .COB $SRCFILE)
    cobc -x -o "${BINDIR}/${SRCFILENAME}" -I"${COPYLIBDIR}" "${SRCFILE}"
done