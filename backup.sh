#!/usr/bin/env bash
# Copy this machine's configs INTO the repo. Run whenever you change something, then commit.
set -euo pipefail
cd "$(dirname "$0")"

# Plain files: <path relative to $HOME>
FILES=(
  .bashrc .zshrc .profile .zprofile
  .gitconfig .gitignore
  .ssh/config
  .config/monitors.xml
  .config/mimeapps.list
  .config/user-dirs.dirs
  .config/Code/User/settings.json
  .config/Code/User/keybindings.json
  .config/Cursor/User/settings.json
  .config/Cursor/User/keybindings.json
  .config/htop/htoprc
  .config/autostart/tv-scale.desktop
)
# Whole folders
DIRS=(
  .config/nvim
  .config/Code/User/snippets
  .config/Cursor/User/snippets
  .config/gtk-3.0
)

for f in "${FILES[@]}"; do
  [ -f "$HOME/$f" ] || continue
  mkdir -p "home/$(dirname "$f")"
  cp "$HOME/$f" "home/$f"
done
for d in "${DIRS[@]}"; do
  [ -d "$HOME/$d" ] || continue
  mkdir -p "home/$d"
  rsync -a --delete --exclude .git "$HOME/$d/" "home/$d/"
done

# GNOME settings (theme, shortcuts, extensions, dock, terminal profiles)
mkdir -p gnome
for p in desktop/interface desktop/wm/keybindings desktop/wm/preferences \
         settings-daemon/plugins/media-keys shell mutter terminal; do
  dconf dump "/org/gnome/$p/" > "gnome/$(echo "$p" | tr / -).ini"
done
gnome-extensions list --enabled > gnome/extensions-enabled.txt

# What's installed (for reinstalling by hand later)
mkdir -p packages
apt-mark showmanual | sort > packages/apt.txt
snap list 2>/dev/null | awk 'NR>1{print $1}' > packages/snap.txt || true
command -v code   >/dev/null && code --list-extensions   > packages/vscode-extensions.txt || true
command -v cursor >/dev/null && cursor --list-extensions > packages/cursor-extensions.txt 2>/dev/null || true

echo "Backed up. Review with 'git status' / 'git diff', then commit."
