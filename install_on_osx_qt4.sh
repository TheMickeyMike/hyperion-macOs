#!/bin/bash
BUILD_DIRECTORY="./build"

cd ~/
git clone --recursive git@github.com:TheMickeyMike/hyperion.git ~/hyperion_osx
cd ~/hyperion_osx

if [ -d "$BUILD_DIRECTORY" ]; then
  rm -rf $BUILD_DIRECTORY
fi
mkdir $BUILD_DIRECTORY
cd $BUILD_DIRECTORY
cmake -DENABLE_DISPMANX=OFF \
-DENABLE_SPIDEV=OFF \
-DENABLE_V4L2=OFF \
-DENABLE_OSX=ON \
-DENABLE_PROTOBUF=OFF ..

make

mkdir -p ~/hyperion/bin
cp bin/hyperiond ~/hyperion/bin
cp -r ../effects ~/hyperion/
cd ~/hyperion