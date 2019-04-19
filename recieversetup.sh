#!/bin/bash
echo "Enter the reciever's latitude: "
read LAT
echo "Enter the reciever's longitude: "
read LON
echo "Enter the reciecver's altitude: "
read ALT
echo "Enter the reciever's name: "
read USER

sed -i "s/\(--lat\s\)[[:digit:]]\+\.[[:digit:]]\+/\1${LAT}/" /etc/systemd/system/mlat-client.service
sed -i "s/\(--lat\s\)[[:digit:]]\+\.[[:digit:]]\+/\1${LAT}/" /etc/systemd/system/dump1090.service
sed -i "s/\(--lon\s\)-\{0,1\}[[:digit:]]\+\.[[:digit:]]\+/\1${LON}/" /etc/systemd/system/mlat-client.service
sed -i "s/\(--lon\s\)-\{0,1\}[[:digit:]]\+\.[[:digit:]]\+/\1${LON}/" /etc/systemd/system/dump1090.service
sed -i "s/\(--alt\s\)[[:digit:]]\+/\1${ALT}/" /etc/systemd/system/mlat-client.service
sed -i "s/\(--user\s\)\w\+/\1${USER}/" /etc/systemd/system/mlat-client.service
