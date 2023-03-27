#!/bin/sh
set -e
. /etc/os-release

set -x

# The first line for each distro installs a build dependency.
# The second line installs extra packages for unittests.
#
# Feel free to send me a PR if your OS is not on this list.

case "$ID-$VERSION_ID" in
ubuntu-20.* | pop-20.*)
  apt-get update
  apt-get install -y cmake libssl-dev zlib1g-dev gcc g++ g++-10
  apt-get install -y file
  ;;
ubuntu-* | pop-* | linuxmint-* | debian-* | raspbian-*)
  apt-get update
  apt-get install -y cmake libssl-dev zlib1g-dev gcc g++
  apt-get install -y file
  ;;
fedora-*)
  dnf install -y gcc-g++ cmake openssl-devel zlib-devel
  dnf install -y glibc-static file libstdc++-static diffutils util-linux
  ;;
opensuse-leap-*)
  zypper install -y make cmake zlib-devel libopenssl-devel gcc-c++ gcc11-c++
  zypper install -y glibc-devel-static tar diffutils util-linux
  ;;
opensuse-tumbleweed-*)
  zypper install -y make cmake zlib-devel libopenssl-devel gcc-c++
  zypper install -y glibc-devel-static tar diffutils util-linux
  ;;
gentoo-*)
  emerge-webrsync
  emerge dev-util/cmake sys-libs/zlib
  ;;
arch-*)
  pacman -Sy
  pacman -S --needed --noconfirm base-devel zlib openssl cmake util-linux
  ;;
void-*)
  xbps-install -Sy xbps
  xbps-install -Sy bash make cmake openssl-devel zlib-devel gcc
  xbps-install -Sy tar diffutils util-linux
  ;;
helios-*)
  # pkg(1) uses exit code 4 to indicate no changes needed.
  # Treat that as success.
  function pkg {
    command pkg "$@" || {
      [ "$?" -eq 4 ] || exit $?
    }
  }
  pkg update
  pkg install developer/build-essential ooce/developer/cmake
  pkg install library/security/openssl library/zlib
  ;;
*)
  echo "Error: don't know anything about build dependencies on $ID-$VERSION_ID"
  exit 1
esac
