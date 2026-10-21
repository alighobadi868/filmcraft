#!/usr/bin/env bash
set -euo pipefail

# Run from a local checkout; media files remain on the user's device.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

WASM_BINDGEN_VERSION="0.2.129"

ensure_wasm_bindgen() {
  if command -v wasm-bindgen >/dev/null 2>&1 && wasm-bindgen --version 2>/dev/null | grep -Fq "$WASM_BINDGEN_VERSION"; then
    return
  fi
  echo "Installing wasm-bindgen-cli $WASM_BINDGEN_VERSION (required by this checkout)..."
  cargo install wasm-bindgen-cli --version "$WASM_BINDGEN_VERSION" --locked
}

usage() {
  cat <<'EOF'
FilmCraft local studio helper

Usage:
  ./scripts/local-studio.sh web [port]  Build and serve the browser editor locally
  ./scripts/local-studio.sh mcp          Run the local FilmCraft MCP bridge
  ./scripts/local-studio.sh build        Build the CLI and browser editor
EOF
}

command_name="${1:-}"
case "$command_name" in
  web)
    port="${2:-8080}"
    rustup target add wasm32-unknown-unknown
    ensure_wasm_bindgen
    cargo xtask web --serve "$port"
    ;;
  mcp)
    cargo run --release -p filmcraft-cli -- mcp --bridge 127.0.0.1:9876
    ;;
  build)
    rustup target add wasm32-unknown-unknown
    ensure_wasm_bindgen
    cargo build --release -p filmcraft-cli
    cargo xtask web
    ;;
  *)
    usage
    exit 2
    ;;
esac
