#!/usr/bin/env bash
# Put the repo's configs back onto this machine. Existing files are saved as *.bak-<date> first.
set -euo pipefail
cd "$(dirname "$0")"
stamp=$(date +%Y%m%d-%H%M%S)

# Configs under home/ → $HOME
( cd home && find . -type f ) | while read -r f; do
  f=${f#./}
  dest="$HOME/$f"
  mkdir -p "$(dirname "$dest")"
  if [ -f "$dest" ] && ! cmp -s "home/$f" "$dest"; then cp "$dest" "$dest.bak-$stamp"; fi
  cp "home/$f" "$dest"
done
chmod 600 "$HOME/.ssh/config" 2>/dev/null || true
[ -f gitignore-global ] && cp gitignore-global "$HOME/.gitignore"

# Scripts → ~/.local/bin (symlinked, so edits in the repo apply immediately)
mkdir -p "$HOME/.local/bin"
for s in bin/*; do ln -sf "$PWD/$s" "$HOME/.local/bin/$(basename "$s")"; done

# GNOME settings
for ini in gnome/*.ini; do
  p=$(basename "$ini" .ini | tr - /)
  dconf load "/org/gnome/$p/" < "$ini"
done
while read -r ext; do gnome-extensions enable "$ext" 2>/dev/null || echo "  install extension manually: $ext"; done < gnome/extensions-enabled.txt

# Editor extensions
[ -f packages/vscode-extensions.txt ] && command -v code >/dev/null && xargs -n1 code --install-extension < packages/vscode-extensions.txt || true
[ -f packages/cursor-extensions.txt ] && command -v cursor >/dev/null && xargs -n1 cursor --install-extension < packages/cursor-extensions.txt || true

echo "Done. Log out/in for GNOME + TV scale to take effect."
echo "apt/snap package lists are in packages/ — install what you need from there."
