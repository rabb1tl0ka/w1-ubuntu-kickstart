#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $0 <font-zip-or-font-file-URL>"
  echo "Example:"
  echo "  $0 https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/JetBrainsMono.zip"
  exit 1
}

[[ $# -lt 1 ]] && usage

URL="$1"
FONT_DIR="${HOME}/.local/share/fonts"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

# --- dependencies ---
need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "Error: '$1' is required." >&2; exit 1; }; }
# Prefer curl, fallback to wget
if command -v curl >/dev/null 2>&1; then
  DOWNLOADER="curl -L --fail -o"
elif command -v wget >/dev/null 2>&1; then
  DOWNLOADER="wget -O"
else
  echo "Error: need 'curl' or 'wget' to download files." >&2
  exit 1
fi

need_cmd fc-cache

mkdir -p "$FONT_DIR"

# --- download ---
cd "$TMPDIR"
FILENAME="$(basename "${URL%%\?*}")"
$DOWNLOADER "$FILENAME" "$URL"

# --- extract / collect font files ---
WORKDIR="$TMPDIR/work"
mkdir -p "$WORKDIR"

case "$FILENAME" in
  *.zip|*.ZIP)
    need_cmd unzip
    unzip -q "$FILENAME" -d "$WORKDIR"
    ;;
  *.tar.gz|*.tgz)
    tar -xzf "$FILENAME" -C "$WORKDIR"
    ;;
  *.tar.bz2|*.tbz2)
    tar -xjf "$FILENAME" -C "$WORKDIR"
    ;;
  *.tar.xz|*.txz)
    tar -xJf "$FILENAME" -C "$WORKDIR"
    ;;
  *.ttf|*.otf|*.TTF|*.OTF)
    # single font file case
    cp -f "$FILENAME" "$WORKDIR/"
    ;;
  *)
    # Try to handle unknown container by unzipping; if fails, assume raw font
    if unzip -q "$FILENAME" -d "$WORKDIR" 2>/dev/null; then
      :
    else
      cp -f "$FILENAME" "$WORKDIR/" || {
        echo "Error: unsupported file type '$FILENAME'." >&2
        exit 1
      }
    fi
    ;;
esac

# Find fonts (ttf/otf) and install
mapfile -d '' FONT_FILES < <(find "$WORKDIR" -type f \( -iname '*.ttf' -o -iname '*.otf' \) -print0)

if [[ ${#FONT_FILES[@]} -eq 0 ]]; then
  echo "Error: no .ttf or .otf files found in archive." >&2
  exit 1
fi

# Create a subfolder for cleanliness (optional but nice)
SUBDIR_NAME="nerdfonts-$(date +%Y%m%d-%H%M%S)"
TARGET_DIR="${FONT_DIR}/${SUBDIR_NAME}"
mkdir -p "$TARGET_DIR"

for f in "${FONT_FILES[@]}"; do
  cp -f "$f" "$TARGET_DIR/"
done

# Refresh font cache (only the user font dir for speed)
fc-cache -fv "$FONT_DIR" >/dev/null

echo "✅ Installed $((${#FONT_FILES[@]})) font file(s) to: $TARGET_DIR"
echo "➡  In GNOME Terminal: Preferences → Profile → Text → enable 'Custom font' → pick your Nerd Font (e.g., 'JetBrainsMono Nerd Font Mono')."
