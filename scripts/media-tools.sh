#!/usr/bin/env bash
set -euo pipefail

# Free local media utilities. This installs software on the computer where it is run,
# not on GitHub or ChatGPT. Media files stay local unless the user uploads them.
usage() {
  cat <<'EOF'
FilmCraft media tools

  ./scripts/media-tools.sh check    Check for ffmpeg, ffprobe, yt-dlp
  ./scripts/media-tools.sh install  Install tools on Debian/Ubuntu or macOS with Homebrew

Supported installers:
  Debian/Ubuntu: apt
  macOS:         Homebrew

No AI-video subscription or API key is installed by this script.
EOF
}

check_tools() {
  local missing=0
  for tool in ffmpeg ffprobe yt-dlp; do
    if command -v "$tool" >/dev/null 2>&1; then
      printf 'OK   %-8s %s\n' "$tool" "$(command -v "$tool")"
    else
      printf 'MISS %-8s\n' "$tool"
      missing=1
    fi
  done
  return "$missing"
}

case "${1:-check}" in
  check)
    check_tools
    ;;
  install)
    if command -v apt-get >/dev/null 2>&1; then
      sudo apt-get update
      sudo apt-get install -y ffmpeg yt-dlp
    elif command -v brew >/dev/null 2>&1; then
      brew install ffmpeg yt-dlp
    else
      echo "Unsupported package manager. Install FFmpeg and yt-dlp manually, then run this script with 'check'." >&2
      exit 2
    fi
    check_tools
    ;;
  *)
    usage
    exit 2
    ;;
esac
