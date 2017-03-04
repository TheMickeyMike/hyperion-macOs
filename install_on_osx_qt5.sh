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
command -v brew >/dev/null 2>&1 || { printf "${RED}[FAIL]${NC}\tHomebrew\nI require Homebrew but it's not installed.\nDownload from: https://brew.sh/\nAborting.\n";
 exit 1; }
printf "${GREEN}[OK]${NC}\tHomebrew\n";


if [[ $(brew list) != *qt5* ]] 
then
	printf "${RED}[FAIL]${NC}\tQt5\nI require Qt5 but it's not installed.\nTo install: brew install qt5\nAborting.\n";
	exit 1;
else
	printf "${GREEN}[OK]${NC}\tQT5\n";
fi

if [[ $(qmake -v) =~ "5" ]]
then
	printf "${GREEN}[OK]${NC}\tQt5 PATH\n";
else
	printf "${RED}[FAIL]${NC}\tQt5 PATH is not set\n";
	printf 'Try appending ~/.bash_profile with: /usr/local/opt/qt5/bin:$PATH\n'
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
	printf "[INFO]\tCloning hyperion repo...\n"
	git clone --recursive https://github.com/TheMickeyMike/hyperion.git $REPO_DIRECTORY
fi

cd $REPO_DIRECTORY || exit 1;
printf "${GREEN}[OK]${NC}\tHyperion repo\n";
mkdir $BUILD_DIRECTORY
cd $BUILD_DIRECTORY || exit 1;

printf "[INFO]\tExecuting: cmake\n"
cmake -Wno-dev \
-DENABLE_DISPMANX=OFF \
-DENABLE_SPIDEV=OFF \
-DENABLE_V4L2=OFF \
-DENABLE_OSX=ON \
-DENABLE_QT5=ON ..
printf "${GREEN}[OK]${NC}\tcmake\n";

printf "[INFO]\tExecuting: make\n"
make -j $(sysctl -n hw.ncpu)
printf "${GREEN}[OK]${NC}\tmake\n";

printf "[INFO]\tStarting installation...\n"
if [ -d "$HYPERION_INSTALLATION_MAIN_DIRECTORY" ]; then
  rm -rf $HYPERION_INSTALLATION_MAIN_DIRECTORY
fi
sudo mkdir $HYPERION_INSTALLATION_MAIN_DIRECTORY
sudo chown $(whoami):admin $HYPERION_INSTALLATION_MAIN_DIRECTORY

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
cd ../effects && cp * $HYPERION_INSTALLATION_EFFECTS_DIRECTORY
ln -s $HYPERION_INSTALLATION_BIN_DIRECTORY/$HYPERION_DAEMON $HYPERION_BIN_DIRECTORY/$HYPERION_DAEMON
printf "${GREEN}[OK]${NC}\tInstallation\n";

printf "[INFO]\tPerforming post installation checks...\n"
if ! type "$HYPERION_DAEMON" > /dev/null; then
	printf "${RED}[FAIL]${NC}\tCan't launch hyperiond\n";
	exit 1;
fi
printf "${GREEN}[OK]${NC}\tInstallation\n";
printf "Success! Now you can use hyperion with command: hyperiond\nExample: hyperiond config.json\n"
exit 0;

