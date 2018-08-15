# radio-lab
raspi radio-lab for wifi heatmap

## Installation
```
git clone https://github.com/thenextbilliononline/radio-lab.git
cd radio-labs/scripts
./meshmap_ap+script.sh
./configure-gps.sh
```
## create-ap.sh
Turns onboard wireless module of the Raspberry Pi to an ACCESS POINT.
- SSID: mesh-mapper
- password: password
- Pi ip address 10.0.0.1/24 
- Internet available via nat over ethernet port

## configure-gps.sh
- Enables and Configures raspberry pi UART port
- Installs GPS modules
- Activates it on boot

## GPS connectionto Raspberry Pi GPIO

| GPS | Rasp Pi  | GPS |
|-----|:--------:|-----|
|     |   1 2    |     |
|     |   3 4    | VCC |
|     |   5 6    | GND |
|     |   6 8    | RX  |
|     |   9 10   | TX  |
