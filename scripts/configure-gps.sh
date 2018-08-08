#!/bin/sh

sudo systemctl stop serial-getty@ttyS0.service
sudo systemctl disable serial-getty@ttyS0.service

sudo apt-get update 
sudo apt-get install -y gpsd gpsd-clients python-gps
sudo systemctl stop gpsd.socket
sudo systemctl disable gpsd.socket

sudo bash
echo     enable_uart=1 >> /boot/config.txt
exit

sudo sed -i "s#exit 0#gpsd /dev/ttyS0 -F /var/run/gpsd.sock\nexit 0#"  /etc/rc.local 


# if it does not work use
# raspi-config
### interfaces options
###  Serial
###   No
###    Yes