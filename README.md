# Rapberry pi setup script and files

These script and files are used to set up a raspberry pi with the necessary software to recieve and feed air traffic data to eplasp.

### Using The Scripts

Runn the following commands to run the setup, when the setup is finished the raspberry pi will reboot.

    cd raspi-setup
    chmod +x setup.sh
    chmod +x recieversetup.sh
    sudo ./setup.sh

After reboot run the following commands to enter the reciever's geocoordinates and name.

    cd raspi-setup
    sudo ./recieversetup.sh

Finally enable the services using the following commands.

    sudo systemctl enable dump1090.service
    sudo systemctl enable mlat-client.service
    sudo systemctl enable socat.service