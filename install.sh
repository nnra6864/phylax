#!/bin/sh
# Installs phylax for the current user. No sudo. Safe to run again: it never overwrites your config.
# Scheduling and Matrix alerts come from sema's `scan` module, see README.
set -eu
cd "$(dirname "$(realpath "$0")")"
[ "$(id -u)" != 0 ] || { echo "Run as your user, not root" >&2; exit 1; }

CONF="$HOME/.config/phylax"
mkdir -p "$HOME/.local/bin" "$CONF"
chmod +x phylax
ln -sf "$PWD/phylax" "$HOME/.local/bin/phylax"
[ -e "$CONF/config.toml" ] || { cp config.example.toml "$CONF/config.toml"; echo "Created $CONF/config.toml"; }

for tool in trivy arch-audit; do
    command -v "$tool" >/dev/null || echo "Missing: sudo pacman -S $tool"
done
echo "Installed. Try: phylax --no-llm --skip-images"
