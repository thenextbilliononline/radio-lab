# sudo ./create-ap.sh
Turns onboard wireless module of the Raspberry Pi to an ACCESS POINT.
- SSID: mesh-mapper
- password: password
- Pi ip address 10.0.0.1/24 
- Internet available via nat over ethernet port

# sudo ./configure-gps.sh
- Enables and Configures raspberry pi UART port
- Installs GPS modules
- Activates it on boot

GPS connectionto Raspberry Pi GPIO

| GPS | Rasp Pi  | GPS |
|-----|:--------:|-----|
|     |   1 2    |     |
|     |   3 4    | VCC |
|     |   5 6    | GND |
|     |   6 8    | RX  |
|     |   9 10   | TX  |
