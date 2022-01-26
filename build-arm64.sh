#!/bin/bash

set -e

export DEBIAN_FRONTEND="noninteractive"

cd /github/workspace

function error {
  echo -e "\\e[91m$1\\e[39m"
  exit 1
}

apt-get update
apt-get upgrade -y --with-new-pkgs
apt-get install zip unzip git build-essential clang cmake libgl1-mesa-dev libsdl2-dev libvulkan-dev -y

rm -rf ./build*/
mkdir -p build-arm64
cd build-arm64

git clone --recursive https://github.com/hrydgard/ppsspp src
cd src
mkdir ppsspp && cd ppsspp
cmake -DCMAKE_TOOLCHAIN_FILE=../cmake/Toolchains/raspberry.armv8.cmake .. || error "Failed to run cmake"
make -j4 || error "Failed to run make"

VERSION=`./ppsspp --version`

cd ../
zip -r ppsspp-${VERSION}-arm64.zip ppsspp/ || error "Failed to create zip"

cd ../../

mv ./build-arm64/src/ppsspp-${VERSION}-arm64.zip ./
rm -rf ./build*/
