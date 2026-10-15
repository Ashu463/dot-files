# dot-files (Ubuntu 24.04, GNOME)

- `./backup.sh` — copy this machine's configs into the repo. Run after changing settings, then `git commit`.
- `./install.sh` — restore everything onto a fresh Ubuntu (old files kept as `*.bak-<date>`).

What's here:
- `home/` — shell, git, ssh config (no keys), VS Code + Cursor settings, Neovim, monitor layout
- `gnome/` — theme, keyboard shortcuts, dock, extensions, terminal profiles (`dconf` dumps)
- `packages/` — lists of apt/snap packages and editor extensions, to reinstall from
- `bin/tv-scale` — shrinks the Panasonic TV (HDMI-1) to ~67%. Needs the **Ubuntu on Xorg** login session.
  `tv-scale --off` for 100%; `TV_SCALE=2 tv-scale` for 50%. Runs automatically at login.

Not here on purpose: SSH keys, `.aws`, `.git-credentials`, `.npmrc`, `.netrc` — back those up separately (e.g. password manager).
