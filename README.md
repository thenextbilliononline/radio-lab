# radio-lab
raspi radio-lab for wifi heatmap

## Installation
```
git clone https://github.com/thenextbilliononline/radio-lab.git
cd radio-labs/scripts
sudo ./create-ap.sh
sudo ./configure-gps.sh
```

## create-ap.sh
Turns onboard wireless module of the Raspberry Pi to an ACCESS POINT.
- SSID: mesh-mapper
- password: password
- Pi ip address 10.0.0.1/24 
- Internet available via nat over ethernet port

## configure-gps.sh
- Enables and Configures raspberry pi UART port
- Installs GPS software (gpsd with both legacy and python gpsd-clients)
- Activates it on boot with systemd

## GPS connection to Raspberry Pi GPIO

| GPS | Rasp Pi  | GPS |
|-----|:--------:|-----|
|     |   1 2    |     |
|     |   3 4    | VCC |
|     |   5 6    | GND |
|     |   6 8    | RX  |
|     |   9 10   | TX  |


### GPS Daemon - View: NMEA to JSON
Command: `gpspipe -r localhost:2947 | gpsdecode`

```JSON
{
    "class": "TPV",
    "device": "stdin",
    "mode": 3,
    "time": "2018-08-16T04:20:00.000Z",
    "ept": 0.005,
    "lat": 40.7440853,
    "lon": -74.0087865,
    "alt": 14.8,
    "speed": 0.062,
    "climb": 0.0,
}
```

### GPS Daemon - View: Console
Command: `cgps -s`

```
┌───────────────────────────────────────────┐
│    Time:       2018-08-16T04:20:00.000Z   │
│    Latitude:   40.7440853 N               │
│    Longitude:  74.0087865 W               │
│    Altitude:   14.8 m                     │
│    Speed:      0.3 kph                    │
│    Status:     3D FIX (8 secs)            │
└───────────────────────────────────────────┘
```

