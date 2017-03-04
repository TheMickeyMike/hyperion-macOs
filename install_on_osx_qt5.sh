#!/bin/bash
BUILD_DIRECTORY="./build"

# Requiremnts

command -v bre >/dev/null 2>&1 || { echo >&2 "I require Homebrew but it's not installed. 
Download from: https://brew.sh/ 
Aborting."; exit 1; }



cd ~/
git clone --recursive git@github.com:TheMickeyMike/hyperion.git ~/hyperion_osx
cd ~/hyperion_osx

if [ -d "$BUILD_DIRECTORY" ]; then
  rm -rf $BUILD_DIRECTORY
fi
mkdir $BUILD_DIRECTORY
cd $BUILD_DIRECTORY
cmake -Wno-dev \
-DENABLE_DISPMANX=OFF \
-DENABLE_SPIDEV=OFF \
-DENABLE_V4L2=OFF \
-DENABLE_OSX=ON \
-DENABLE_QT5=ON ..

make

mkdir -p ~/hyperion/bin
cp bin/hyperiond ~/hyperion/bin
cp -r ../effects ~/hyperion/
cd ~/hyperion



# brew install qt
# echo 'export PATH="/usr/local/opt/qt5/bin:$PATH"' >> ~/.bash_profile
source ~/.bash_profile
