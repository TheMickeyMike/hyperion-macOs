# hyperion-MacOS

[![Build Status](https://travis-ci.org/TheMickeyMike/hyperion-macOs.svg?branch=master)](https://travis-ci.org/TheMickeyMike/hyperion-macOs)

Hyperion installation script for macOS. Tested with OS X El Capitan & macOS Sierra.

### About
Simple bash script wrapping hyperion build & installation under macOS. Script is building forked repository containing fix created by [Danimal4326](https://github.com/Danimal4326/hyperion/commit/d1ee432ba3e48749900cf0083278dbe1e65891ee)

### Before you start
:warning: During installation process script is **deleting** directories from `/usr/local/hyperion/*`, so make sure you **back up** all your configs (`/usr/local/hyperion/config`) and effects (`/usr/local/hyperion/effects`) files.

### How to use
1. Clone repo `git clone https://github.com/TheMickeyMike/hyperion-macOs.git`
2. Navigate to repo `cd hyperion-macOs/`
3. Execute installation script `./install_on_osx_qt5.sh`. **Before installation, please back up** all your configs and effects! __More in [Before you start](#before-you-start).__

### Problem solver
+ Im getting `-bash: ./install_on_osx_qt5.sh: Permission denied` after executing command `./install_on_osx_qt5.sh`.

   *To solve this problem you need made the file `install_on_osx_qt5.sh` executable. Navigate to repo directory `cd hyperion-macOs/`. Execute `chmod +x install_on_osx_qt5.sh`. Now you should be able to execute commmand from point 3.*

### Q&A
1. Why script is asking me for my password? :frowning:

   Script require password **only** during installation process, to copy compiled binaries into macOS directory  `/usr/local/hyperion`.

### Requirements
* Installed [Homebrew](https://brew.sh/)
* Qt5 (Installed by script)
* libusb (Installed by script)
