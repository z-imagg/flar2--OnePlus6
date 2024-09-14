#!/bin/bash
set -e
USER_AGENT="WireGuard-AndroidROMBuild/0.2 ($(uname -a))"

exec 9>.wireguard-fetch-lock
flock -n 9 || exit 0


#https://download.wireguard.com/monolithic-historical/
#https://download.wireguard.com/monolithic-historical/WireGuard-0.0.20191219.tar.xz
VERSION="0.0.20191219"

rm -rf net/wireguard
mkdir -p net/wireguard
proxychains4 -q curl -A "$USER_AGENT" -LsS "https://git.zx2c4.com/WireGuard/snapshot/WireGuard-$VERSION.tar.xz" | tar -C "net/wireguard" -xJf - --strip-components=2 "WireGuard-$VERSION/src"
sed -i 's/tristate/bool/;s/default m/default y/;' net/wireguard/Kconfig
touch net/wireguard/.check
