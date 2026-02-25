#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ ! -f "$ROOT_DIR/rpc_endpoint.txt" ]; then
  echo "Missing rpc_endpoint.txt in repo root. Create it from rpc_endpoint.txt.example." >&2
  exit 1
fi

export PYTHONPATH="$ROOT_DIR/api"

cd "$ROOT_DIR"
exec jupyter notebook
