#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

BUILD_DIRECTORY=./build
REPO_DIRECTORY=~/hyperion_osx
HYPERION_BIN_DIRECTORY=/usr/local/bin
HYPERION_INSTALLATION_MAIN_DIRECTORY=/usr/local/hyperion
HYPERION_INSTALLATION_BIN_DIRECTORY=/usr/local/hyperion/bin
HYPERION_INSTALLATION_EFFECTS_DIRECTORY=/usr/local/hyperion/effects
HYPERION_INSTALLATION_CONFIG_DIRECTORY=/usr/local/hyperion/config

HYPERION_DAEMON=hyperiond


# Requiremnts Check
command -v brew >/dev/null 2>&1 || { echo -e "${RED}[FAIL]${NC}\tHomebrew\nI require Homebrew but it's not installed.\nDownload from: https://brew.sh/\nAborting.";
 exit 1; }
echo -e "${GREEN}[OK]${NC}\tHomebrew";


if [[ $(brew list) != *qt5* ]]; then
	echo -e "[INFO]\tI require Qt5 but it's not installed.\nInstalling Qt5...";
	brew install qt5
	export PATH=$PATH:/usr/local/opt/qt5/bin
fi
echo -e "${GREEN}[OK]${NC}\tQt5";

if [[ $(brew list) != *libusb* ]]; then
	echo -e "[INFO]\tI require libusb but it's not installed.\nInstalling libusb...";
	brew install libusb
fi
echo -e "${GREEN}[OK]${NC}\tlibusb";

if [[ $(qmake -v) =~ "5" ]]
then
	echo -e "${GREEN}[OK]${NC}\tQt5 PATH";
else
	echo -e "${RED}[FAIL]${NC}\tQt5 PATH is not set";
	echo -e "Try appending ~/.bash_profile with: /usr/local/opt/qt5/bin:\$PATH"
	exit 1;
fi
# End Requiremnts Check

# Repo Cloning & Building Hyperion with Qt5
if [ -d "$REPO_DIRECTORY" ] 
then
	cd "$REPO_DIRECTORY" || exit 1;
	if [ -d "$BUILD_DIRECTORY" ]; then 
		rm -rf $BUILD_DIRECTORY
	fi
	if ! git diff-index --quiet HEAD --; then
    	rm -rf $REPO_DIRECTORY
	fi
else
	echo -e "[INFO]\tCloning hyperion repo..."
	git clone --recursive https://github.com/TheMickeyMike/hyperion.git $REPO_DIRECTORY
fi

cd $REPO_DIRECTORY || exit 1;
echo -e "${GREEN}[OK]${NC}\tHyperion repo";
mkdir $BUILD_DIRECTORY
cd $BUILD_DIRECTORY || exit 1;

echo -e "[INFO]\tExecuting: cmake"
cmake -Wno-dev \
-DENABLE_DISPMANX=OFF \
-DENABLE_SPIDEV=OFF \
-DENABLE_V4L2=OFF \
-DENABLE_OSX=ON \
-DENABLE_QT5=ON ..
echo -e "${GREEN}[OK]${NC}\tcmake";

echo -e "[INFO]\tExecuting: make"
make -j "$(sysctl -n hw.ncpu)"
echo -e "${GREEN}[OK]${NC}\tmake";

echo -e "[INFO]\tStarting installation..."
if [ -d "$HYPERION_INSTALLATION_MAIN_DIRECTORY" ]; then
  sudo rm -rf $HYPERION_INSTALLATION_MAIN_DIRECTORY
fi
sudo mkdir $HYPERION_INSTALLATION_MAIN_DIRECTORY
sudo chown "$(whoami)":admin $HYPERION_INSTALLATION_MAIN_DIRECTORY

if [ -d "$HYPERION_INSTALLATION_BIN_DIRECTORY" ]; then
  rm -rf $HYPERION_INSTALLATION_BIN_DIRECTORY
fi
mkdir $HYPERION_INSTALLATION_BIN_DIRECTORY

if [ -d "$HYPERION_INSTALLATION_EFFECTS_DIRECTORY" ]; then
  rm -rf $HYPERION_INSTALLATION_EFFECTS_DIRECTORY
fi
mkdir $HYPERION_INSTALLATION_EFFECTS_DIRECTORY

if [ -d "$HYPERION_INSTALLATION_CONFIG_DIRECTORY" ]; then
  rm -rf $HYPERION_INSTALLATION_CONFIG_DIRECTORY
fi
mkdir $HYPERION_INSTALLATION_CONFIG_DIRECTORY

cp ./bin/$HYPERION_DAEMON $HYPERION_INSTALLATION_BIN_DIRECTORY
cp ./bin/hyperion-remote $HYPERION_INSTALLATION_BIN_DIRECTORY
cp ./bin/hyperion-osx $HYPERION_INSTALLATION_BIN_DIRECTORY
cd ../effects && cp ./* $HYPERION_INSTALLATION_EFFECTS_DIRECTORY
ln -s $HYPERION_INSTALLATION_BIN_DIRECTORY/$HYPERION_DAEMON $HYPERION_BIN_DIRECTORY/$HYPERION_DAEMON

echo -e "[INFO]\tPerforming post installation checks..."
if ! type "$HYPERION_DAEMON" > /dev/null; then
	echo -e "${RED}[FAIL]${NC}\tCan't launch hyperiond";
	exit 1;
fi
echo -e "${GREEN}[OK]${NC}\tInstallation";
echo -e "Success! Now you can use hyperion with command: hyperiond\nExample: hyperiond config.json"
exit 0;