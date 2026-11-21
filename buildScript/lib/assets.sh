#!/bin/bash
set -euo pipefail

asset_dir=app/src/main/assets/sing-box
mkdir -p "$asset_dir"
scratch="$(mktemp -d)"
trap 'rm -rf -- "$scratch"' EXIT

fetch_rules() {
  local name="$1" version="$2" digest="$3"
  curl --fail --location --silent --show-error --retry 3 \
    --output "$scratch/$name.db" \
    "https://github.com/SagerNet/sing-$name/releases/download/$version/$name.db"
  printf '%s  %s\n' "$digest" "$scratch/$name.db" | sha256sum --check
  xz -9 "$scratch/$name.db"
  printf '%s' "$version" > "$scratch/$name.version.txt"
}

fetch_rules geoip 20261112 0da32148f688ba65c0c6b2e2e0b1e6261802534819545d6fd2e3c8e71322825e
fetch_rules geosite 20261118141523 c4b1a17003dbe8e5326ecfcd036528740c07e5c776d138f8b034080be81b660e
mv -- "$scratch/"*.db.xz "$scratch/"*.version.txt "$asset_dir/"
