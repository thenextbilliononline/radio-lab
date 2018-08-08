#!/bin/sh

sudo bash
apt-get update

# Install packages to run IEEE 802.11 Access Point
sudo apt-get install hostapd dnsmasq iptables -y

cat <<"EOF">> /etc/network/interfaces 

auto lo
iface lo inet loopback

allow hotplug wlan-ap
iface wlan-ap inet static
    address 10.0.0.0.1
    netmask 255.255.255.0
    network 10.0.0.0
    broadcast 10.0.0.0.255

allow-hotplug eth0
iface eth0 inet dhcp
EOF

# Enable packet forwarding
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sed -i 's/#net.ipv6.conf.all.forwarding=1/net.ipv6.conf.all.forwarding=1/' /etc/sysctl.conf

# Configure network with hostapd
cat <<"EOF"> /etc/hostapd/nat.sh
#!/bin/sh

# MSS clamp to circumvent issues with Path MTU Discovery
iptables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
ip6tables -A FORWARD -p tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu

# Forward all IPv4 traffic from the internal network to the eth0 device and mask with the eth0 external IP address
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

# Forward all IPv6 traffic from the internal network to the tun0 device and mask with the tun0 external IP address
EOF
chmod +x /etc/hostapd/nat.sh

cat <<"EOF"> /etc/hostapd/hostapd.conf
interface=wlan-ap
hw_mode=g
channel=11
auth_algs=1
wpa=2
wpa_key_mgmt=WPA-PSK
wpa_pairwise=CCMP
rsn_pairwise=CCMP
ssid=mesh-mapper
wpa_passphrase=password
EOF

cat <<"EOF"> /etc/dnsmasq.conf
dhcp-range=10.0.0.2,10.0.0.254,255.255.255.0,4h
bind-interfaces
EOF

echo "denyinterfaces wlan-ap" >> /etc/dhcpcd.conf 

# Enable hostapd service
if [ -f /etc/default/hostapd ]; then
    sed '\?^DAEMON_CONF?d' /etc/default/hostapd | sudo tee /etc/default/hostapd > /dev/null
    sudo echo DAEMON_CONF="/etc/hostapd.conf" | sudo tee --append /etc/default/hostapd > /dev/null
fi

cat <<"EOF">  /etc/systemd/system/hostapd.service
[Unit]
Description=hostapd IEEE 802.11 Access Point
##TODO## Not sure why this does not work
#After=sys-subsystem-net-devices-wlan\x2dap.device
#BindsTo=sys-subsystem-net-devices-wlan\x2ap.device

[Service]
Type=forking
PIDFile=/var/run/hostapd.pid
ExecStart=/usr/sbin/hostapd -B /etc/hostapd/hostapd.conf -P /var/run/hostapd.pid
ExecStartPost=/bin/sh /etc/hostapd/nat.sh

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable hostapd.service

# Find onboard adapter by driver and lock to wlan-ap
for wlan in $(ls -1Atu /sys/class/net | grep wlan); do
    driver="$(basename $(readlink /sys/class/net/$wlan/device/driver))"
    mac="$(cat /sys/class/net/$wlan/address)"
    if [[ "$driver" == "xradio_wlan" || "$driver" == "brcm80211" || "$driver" == "brcmfmac" ]]; then
        echo SUBSYSTEM==\"net\", ACTION==\"add\", DRIVERS==\"$driver\", ATTR{dev_id}==\"0x0\", ATTR{type}==\"1\", KERNEL==\"wlan*\", NAME=\"wlan-ap\" |
                sudo tee /etc/udev/rules.d/70-persistent-net.rules
    fi
done
