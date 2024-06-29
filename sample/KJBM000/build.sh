#!/bin/bash
set -euo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)
BINDIR="${SCRIPTDIR}"
COPYLIBDIR="${SCRIPTDIR}/../../copylib"
DIRNAME=$(basename "${SCRIPTDIR}")

for SRCFILE in "$@"; do
    SRCFILENAME=$(basename -s .COB $SRCFILE)
    cobc -x -o "${BINDIR}/${SRCFILENAME}" -I"${COPYLIBDIR}" "${SRCFILE}"
done