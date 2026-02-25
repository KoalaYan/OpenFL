#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$ROOT_DIR/build"
CONTRACTS_DIR="$ROOT_DIR/contracts"

if ! command -v forge >/dev/null 2>&1; then
  echo "forge not found. Install Foundry first (https://book.getfoundry.sh/getting-started/installation)." >&2
  exit 1
fi

mkdir -p "$BUILD_DIR"

# Compile with Foundry
cd "$ROOT_DIR"
forge build

# Extract ABI and bytecode from Foundry artifacts
ROOT_DIR="$ROOT_DIR" python3 - <<'PY'
import json
from pathlib import Path
import os

root = Path(os.environ["ROOT_DIR"])
out = root / "out"
build = root / "build"

def load_artifact(contract_name):
    # Foundry outputs: out/Contract.sol/Contract.json
    path = out / f"{contract_name}.sol" / f"{contract_name}.json"
    if not path.exists():
        raise FileNotFoundError(f"Artifact not found: {path}")
    with path.open() as f:
        return json.load(f)

def write_text(path, text):
    path.write_text(text, encoding="utf-8")

manager = load_artifact("OpenFLManager")
model = load_artifact("OpenFLModel")

write_text(build / "abi.txt", json.dumps(manager["abi"]))
write_text(build / "bytecode.txt", manager["bytecode"]["object"])
write_text(build / "abi_model.txt", json.dumps(model["abi"]))
write_text(build / "bytecode_model.txt", model["bytecode"]["object"])

print(f"Build artifacts written to {build}")
PY
