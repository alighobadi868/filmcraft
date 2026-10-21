#!/usr/bin/env bash
set -euo pipefail

# Run from a local checkout; media files remain on the user's device.
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT_DIR"

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
    cargo xtask web --serve "$port"
    ;;
  mcp)
    cargo run --release -p filmcraft-cli -- mcp --bridge 127.0.0.1:9876
    ;;
  build)
    rustup target add wasm32-unknown-unknown
    cargo build --release -p filmcraft-cli
    cargo xtask web
    ;;
  *)
    usage
    exit 2
    ;;
esac
