#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v cobdt >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/yukkeorg/cobdt/refs/heads/main/install.sh | sh
fi

# 追加のセットアップスクリプト(setup.d/*.sh)があれば名前順に実行する
SCRIPTDIR=$(cd "$(dirname "$0")"; pwd)
for SETUPFILE in "${SCRIPTDIR}"/setup.d/*.sh; do
    [ -e "${SETUPFILE}" ] || continue
    bash "${SETUPFILE}"
done
