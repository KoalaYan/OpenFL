#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
RPC_ENDPOINT_FILE="$ROOT_DIR/rpc_endpoint.txt"
FORK_RPC_FILE="$ROOT_DIR/rpc_fork_url.txt"

if ! command -v anvil >/dev/null 2>&1; then
  echo "anvil not found. Install Foundry first (https://book.getfoundry.sh/getting-started/installation)." >&2
  exit 1
fi

if [ ! -f "$RPC_ENDPOINT_FILE" ]; then
  echo "Missing rpc_endpoint.txt in repo root. Create it from rpc_endpoint.txt.example." >&2
  exit 1
fi

RPC_ENDPOINT="$(tr -d '[:space:]' < "$RPC_ENDPOINT_FILE")"
if [ "$RPC_ENDPOINT" != "http://127.0.0.1:8545" ] && [ "$RPC_ENDPOINT" != "http://localhost:8545" ]; then
  echo "rpc_endpoint.txt should point to local Anvil when FORK=True (recommended): http://127.0.0.1:8545" >&2
  exit 1
fi

if [ -f "$FORK_RPC_FILE" ]; then
  FORK_URL="$(tr -d '[:space:]' < "$FORK_RPC_FILE")"
  if [ -n "$FORK_URL" ]; then
    exec anvil --fork-url "$FORK_URL" --host 127.0.0.1 --port 8545 --accounts 10 --block-time 10
  fi
fi

exec anvil --host 127.0.0.1 --port 8545 --accounts 10 --block-time 10
