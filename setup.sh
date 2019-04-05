#!/bin/bash

#####################################################################################
#                        ADS-B EXCHANGE SETUP SCRIPT FORKED                         #
#####################################################################################
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#                                                                                   #
# Copyright (c) 2018 ADSBx                                    #
#                                                                                   #
# Permission is hereby granted, free of charge, to any person obtaining a copy      #
# of this software and associated documentation files (the "Software"), to deal     #
# in the Software without restriction, including without limitation the rights      #
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell         #
# copies of the Software, and to permit persons to whom the Software is             #
# furnished to do so, subject to the following conditions:                          #
#                                                                                   #
# The above copyright notice and this permission notice shall be included in all    #
# copies or substantial portions of the Software.                                   #
#                                                                                   #
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR        #
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,          #
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE       #
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER            #
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,     #
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE     #
# SOFTWARE.                                                                         #
#                                                                                   #
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #


## CHECK IF SCRIPT WAS RAN USING SUDO

if [ "$(id -u)" != "0" ]; then
    echo -e "\033[33m"
    echo "This script must be ran using sudo or as root."
    echo -e "\033[37m"
    exit 1
fi

## CHECK FOR PACKAGES NEEDED BY THIS SCRIPT

echo -e "\033[33m"
echo "Checking for packages needed to run this script..."

if [ $(dpkg-query -W -f='${STATUS}' curl 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y curl
fi
echo -e "\033[37m"

# Check that the prerequisite packages needed to build and install mlat-client are installed.
if [ $(dpkg-query -W -f='${STATUS}' build-essential 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y build-essential 
fi

sleep 0.25

if [ $(dpkg-query -W -f='${STATUS}' git 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y git 
fi

sleep 0.25

if [ $(dpkg-query -W -f='${STATUS}' cmake 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y cmake 
fi

sleep 0.25

if [ $(dpkg-query -W -f='${STATUS}' libusb-1.0-0-dev 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y libusb-1.0-0-dev
fi

sleep 0.25

if [ $(dpkg-query -W -f='${STATUS}' debhelper 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y debhelper
fi

sleep 0.25

if [ $(dpkg-query -W -f='${STATUS}' python 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y python
fi

sleep 0.25

if [ $(dpkg-query -W -f='${STATUS}' python3-dev 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y python3-dev
fi

sleep 0.25

if [ $(dpkg-query -W -f='${STATUS}' socat 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y socat
fi

sleep 0.25

if [ $(dpkg-query -W -f='${STATUS}' libncurses5-dev 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y libncurses5-dev
fi

sleep 0.25

if [ $(dpkg-query -W -f='${STATUS}' nginx 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y nginx
fi

sleep 0.25

sudo chown -R pi /home/pi/raspi-setup/mvfiles

sleep 0.25

echo " BUILD AND INSTALL RTL-SDR" 
echo "-----------------------------------"

# Check if the rtl-sdr git repository already exists.
cd /home/pi
if [ -d rtl-sdr ] && [ -d rtl-sdr/.git ]; then
    # If the rtl-sdr repository exists update the source code contained within it.
    cd rtl-sdr
    git pull 
    git checkout
else
    # Download a copy of the rtl-sdr repository since the repository does not exist locally.
    git clone git://git.osmocom.org/rtl-sdr.git
    cd rtl-sdr
fi

# Make-install rtl-sdr
mkdir build
cd build
cmake ../ -DINSTALL_UDEV_RULES=ON
make
sudo make install
sudo ldconfig
sudo mv ../rtl-sdr.rules /etc/udev/rules.deal
sudo mv /home/pi/raspi-setup/mvfiles/blacklist-rtl.conf /etc/modprobe.d

if [ $(dpkg-query -W -f='${STATUS}' librtlsdr-dev 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    sudo apt-get install -y librtlsdr-dev
fi

sleep 0.25

echo " BUILD AND INSTALL DUMP1090" 
echo "-----------------------------------"

# Check if the dump1090 git repository already exists.
cd /home/pi
if [ -d dump1090 ] && [ -d dump1090/.git ]; then
    # If the dump1090 repository exists update the source code contained within it.
    cd dump1090
    git pull 
    git checkout
else
    # Download a copy of the mlat-client repository since the repository does not exist locally.
    git clone https://github.com/flightaware/dump1090.git
    cd dump1090
fi

sleep 0.25

# Make install dump1090
make BLADERF=no
sudo mv /home/pi/raspi-setup/mvfiles/default /etc/nginx/sites-available/
sudo mv /home/pi/raspi-setup/mvfiles/dump1090-helper.service /etc/systemd/system/
sudo systemctl enable dump1090-helper

sleep 0.25

echo " BUILD AND INSTALL MLAT-CLIENT" 
echo "-----------------------------------"

# Check if the mlat-client git repository already exists.
cd /home/pi
if [ -d mlat-client ] && [ -d mlat-client/.git ]; then
    # If the mlat-client repository exists update the source code contained within it.
    cd mlat-client 
    git pull 
    git checkout
else
    # Download a copy of the mlat-client repository since the repository does not exist locally.
    git clone https://github.com/mutability/mlat-client.git
    cd mlat-client 
fi

sleep 0.25

# Build and install the mlat-client package.
dpkg-buildpackage -b -uc
sudo dpkg -i ../mlat-client_*.deb
sudo ./setup.py install
sudo mv /home/pi/raspi-setup/mvfiles/dump1090.service /etc/systemd/system/
sudo mv /home/pi/raspi-setup/mvfiles/mlat-client.service /etc/systemd/system/
sudo mv /home/pi/raspi-setup/mvfiles/socat.service /etc/systemd/system/
sudo mv /home/pi/raspi-setup/socat.sh /usr/local/bin/

sleep 0.25

echo "Setup Reciever"

sudo /home/pi/raspi-setup/recieversetup.sh

sleep 0.25

echo "Done rebooting..."
echo "-----------------------------------"

sleep 1

reboot

exit 0
