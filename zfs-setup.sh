#!/usr/bin/env bash
# zfs-setup.sh — tworzy zpool rpool na wskazanej partycji
# Użycie: sudo ./zfs-setup.sh /dev/nvme0n1p2

set -euo pipefail

RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
die()  { echo -e "${RED}BŁĄD: $*${NC}" >&2; exit 1; }
info() { echo -e "${GREEN}==>${NC} $*"; }
warn() { echo -e "${YELLOW}UWAGA: $*${NC}"; }

# ─── WALIDACJA ───────────────────────────────────────────────────────────────

[[ $EUID -eq 0 ]] || die "Uruchom jako root."

PART="${1:-}"
if [[ -z "$PART" ]]; then
    echo "Dostępne partycje:"
    lsblk -o NAME,SIZE,FSTYPE,MOUNTPOINT | grep -v loop
    echo
    read -rp "Podaj partycję (np. /dev/nvme0n1p2): " PART
fi

[[ -b "$PART" ]] || die "Partycja '$PART' nie istnieje."

# ─── HASŁO ───────────────────────────────────────────────────────────────────

read -rsp "Hasło szyfrowania ZFS: " PASSPHRASE; echo
read -rsp "Powtórz hasło: "          PASSPHRASE2; echo
[[ "$PASSPHRASE" == "$PASSPHRASE2" ]] || die "Hasła się nie zgadzają."
[[ ${#PASSPHRASE} -ge 8 ]]            || die "Hasło musi mieć co najmniej 8 znaków."

# ─── POTWIERDZENIE ───────────────────────────────────────────────────────────

echo
warn "Partycja $PART zostanie użyta jako zpool rpool (dane zostaną nadpisane)."
lsblk "$PART"
echo
read -rp "Wpisz 'tak' żeby kontynuować: " CONFIRM
[[ "$CONFIRM" == "tak" ]] || { echo "Anulowano."; exit 0; }


# ─── ZPOOL ───────────────────────────────────────────────────────────────────

zpool destroy rpool 2>/dev/null || true
wipefs -af "$PART"

info "Tworzenie zpool rpool..."
zpool create \
    -f \
    -o ashift=12 \
    -o autotrim=on \
    -O acltype=posixacl \
    -O canmount=off \
    -O compression=zstd \
    -O dnodesize=auto \
    -O encryption=aes-256-gcm \
    -O keylocation=prompt \
    -O keyformat=passphrase \
    -O mountpoint=none \
    -O normalization=formD \
    -O relatime=on \
    -O xattr=sa \
    rpool "$PART" <<< "$PASSPHRASE"

# ─── DATASETY ────────────────────────────────────────────────────────────────

info "Tworzenie datasetu rpool/nixos..."
zfs create -o canmount=off -o mountpoint=none rpool/nixos

info "rpool/nixos/root  → /"
zfs create -o canmount=on -o mountpoint=legacy rpool/nixos/root

info "rpool/nixos/nix   → /nix"
zfs create -o canmount=on -o mountpoint=legacy -o atime=off rpool/nixos/nix

info "rpool/nixos/home  → /home"
zfs create -o canmount=on -o mountpoint=legacy rpool/nixos/home

echo
info "Datasety:"
zfs list -r rpool

cat << NIXCFG

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Fragment do configuration.nix
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;
  boot.initrd.systemd.enable = true;
  networking.hostId = "${HOST_ID}";

  fileSystems."/"     = { device = "rpool/nixos/root"; fsType = "zfs"; };
  fileSystems."/nix"  = { device = "rpool/nixos/nix";  fsType = "zfs"; };
  fileSystems."/home" = { device = "rpool/nixos/home"; fsType = "zfs"; };

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
NIXCFG
