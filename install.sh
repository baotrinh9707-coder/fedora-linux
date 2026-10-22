#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
theme_dir="/usr/share/sddm/themes/simple_sddm_2"
stamp="$(date +%Y%m%d-%H%M%S)"

if [[ "${EUID}" -eq 0 ]]; then
  echo "Run as your regular user; this script uses sudo only for system files." >&2
  exit 1
fi

if [[ ! -r /etc/os-release ]] || ! grep -q '^ID=fedora$' /etc/os-release; then
  echo "This installer is intended for Fedora Linux." >&2
  exit 1
fi

backup_file() {
  local target="$1"
  if [[ -e "$target" || -L "$target" ]]; then
    cp -a -- "$target" "$target.bak.$stamp"
    echo "Backed up $target"
  fi
}

backup_system_file() {
  local target="$1"
  if sudo test -e "$target"; then
    sudo cp -a -- "$target" "$target.bak.$stamp"
    echo "Backed up $target"
  fi
}

sudo -v
sudo dnf install -y sddm kitty git qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia

work_dir="$(mktemp -d)"
trap 'rm -rf -- "$work_dir"' EXIT
git clone --depth 1 https://github.com/JaKooLit/simple-sddm-2.git "$work_dir/theme"
rm -rf -- "$work_dir/theme/.git"

if sudo test -e "$theme_dir"; then
  sudo mv -- "$theme_dir" "$theme_dir.bak.$stamp"
  echo "Backed up $theme_dir"
fi
sudo cp -a -- "$work_dir/theme" "$theme_dir"
sudo chown -R root:root "$theme_dir"
sudo install -m 0644 "$repo_dir/config/theme.conf.user" "$theme_dir/theme.conf.user"

backup_system_file /etc/sddm.conf
sudo install -m 0644 "$repo_dir/config/sddm.conf" /etc/sddm.conf

mkdir -p -- "$HOME/.config/kitty"
backup_file "$HOME/.config/kitty/kitty.conf"
install -m 0644 "$repo_dir/config/kitty.conf" "$HOME/.config/kitty/kitty.conf"

sudo systemctl enable --force sddm.service

if ! fc-match -f '%{family}\n' 'JetBrainsMono Nerd Font' | grep -Fq 'JetBrainsMono Nerd Font'; then
  echo "Install JetBrainsMono Nerd Font to match the Kitty font exactly."
fi

echo "Done. Reboot when ready to use SDDM; open Kitty to see the terminal theme."
