#!/bin/bash
echo "Enter the reciever's latitude: "
read LAT
echo "Enter the reciever's longitude: "
read LON
echo "Enter the reciecver's altitude: "
read ALT
echo "Enter the reciever's name: "
read USER

sed -i "s/\(--lat\s\)[[:digit:]]\+\.[[:digit:]]\+/\1${LAT}/" mlat-client.service
sed -i "s/\(--lon\s\)-\{0,1\}[[:digit:]]\+\.[[:digit:]]\+/\1${LON}/" mlat-client.service
sed -i "s/\(--alt\s\)[[:digit:]]\+/\1${ALT}/" mlat-client.service
sed -i "s/\(--user\s\)\w\+/\1${USER}/" mlat-client.service
