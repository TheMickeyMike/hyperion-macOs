# hyperion-MacOS

[![Build Status](https://travis-ci.org/TheMickeyMike/hyperion-MacOS.svg?branch=master)](https://travis-ci.org/TheMickeyMike/hyperion-MacOS)

Hyperion installation script for macOS. Tested with OS X El Capitan & macOS Sierra.

### About
Simple bash script wrapping hyperion build & installation under macOS. Script is building forked repository containing fix created by [Danimal4326](https://github.com/Danimal4326/hyperion/commit/d1ee432ba3e48749900cf0083278dbe1e65891ee)

### How to use
1. Clone repo `git clone https://github.com/TheMickeyMike/hyperion-macOs.git`
2. Navigate to repo `cd hyperion-macOs/`
3. Execute installation script `./install_on_osx_qt5.sh`

### Problem solver
+ Im getting `-bash: ./install_on_osx_qt5.sh: Permission denied` after executing command `./install_on_osx_qt5.sh`.

   *To solve this problem you need made the file `install_on_osx_qt5.sh` executable. Navigate to repo directory `cd hyperion-macOs/`. 
   Execute `chmod +x install_on_osx_qt5.sh`. Now you should be able to execute commmand from point 3.*



### Requirements
* Installed [Homebrew](https://brew.sh/)
* Qt5 (Installed by script)
* libusb (Installed by script)
