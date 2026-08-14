#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v cobdt >/dev/null 2>&1; then
    curl -fsSL https://raw.githubusercontent.com/yukkeorg/cobdt/refs/heads/main/install.sh | sh
fi
