#!/bin/bash
set -Eeuo pipefail

SCRIPTDIR=$(cd $(dirname $0); pwd)

PROGRAMNAME=$(basename "${SCRIPTDIR}")
BINDIR="${SCRIPTDIR}"
PROGRAM="${BINDIR}/${PROGRAMNAME}"

export ITF="${SCRIPTDIR}/../../data/TEMPLATEI.dat"
export OTF="${SCRIPTDIR}/../../data/TEMPLATEO.dat"

${PROGRAM} | iconv -f cp932
