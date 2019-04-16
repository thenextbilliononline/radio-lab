#Some snippets useful for linux kernel wifi dev

## IW

To view the output from a wireless card called wlan0.

```
sudo iwlsit wlan0 scan | less 
```
To read other data for all interfaces.
```
cat /prof/net/dev

## iperf

iperf will saturate a network connection with noisy connections following many different paramters. It requires a static server/client relationship and must be used hierarchically. 

## TC

```
To add 100ms latency using tc
```
tc qdisc add dev eth0 root netem delay 100ms
```
To remove it
```
tc qdisc del dev eth0 root netem
```
