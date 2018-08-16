#!/usr/bin/env bash

## Nuke serial-getty service on serial0
sudo systemctl stop serial-getty@ttyS0.service
sudo systemctl disable serial-getty@ttyS0.service

## Install gps-daemon and all gpsd-clients
sudo apt-get update 
sudo apt-get install -y gpsd gpsd-clients python-gps

## Pass gps-device '/dev/ttyS0' to gps-daemon
sudo sed -i "s/^\(GPSD_OPTIONS\)=.*/GPSD_OPTIONS=\"\/dev\/ttyS0\"/g" /etc/default/gpsd

## Restart gps-daemon
for x in enable restart; do sudo systemctl $x gpsd.socket; done

## Append UART in boot config if missing, else enable if found
grep -q "enable_uart=1" /boot/config.txt
if [ $? -eq 1 ]; then
  echo enable_uart=1 | sudo tee -a /boot/config.txt
else
  sudo sed -i "s/^\(enable_uart\)=.*/enable_uart=1/g" /boot/config.txt
fi

## Alternative UART/Serial method via: raspi-config
### interfaces options
###  Serial
###   No
###    Yes

sync && exit 0

