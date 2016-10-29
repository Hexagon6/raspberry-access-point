#!/bin/bash

# stop this script if there was an error
set -e

ID=`id -u`

if [ "$ID" -ne 0 ]; then
	echo "Please start this script with sudo:\n\tsudo $0"
	exit 1
fi

echo "[ap-installer]  updating package list.."
apt update
echo "[ap-installer]  installing hostapd and dnsmasq"
apt install -y dnsmasq hostapd iptables iptables-persistent #dhcpcd

if [ $? -ne 0 ]; then
	echo "Something did not work with apt, have you connected your raspi to an ethernet cable?"
	exit 1
fi

# Install files from . to system configuration
function sys_copy() {
	[ -f /$1 ] && mv /$1{,.orig}
	mkdir -p /`dirname $1`
	cp $1 /$1
}

echo "Copying config to your system" 
ls etc
sys_copy etc/dhcpcd.conf
sys_copy etc/dnsmasq.conf
sys_copy etc/network/interfaces
sys_copy etc/default/hostapd
sys_copy etc/hostapd/hostapd.conf
sys_copy etc/wpa_supplicant/wpa_supplicant.conf
sys_copy etc/iptables.ipv4.nat

echo "enable IP forwarding"
sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf

echo "changing WiFi-passphrase to '`hostname`_ (needs to be at least 8 characters long)'"
sed -i 's/PASSPHRASE/'`hostname`'_/g' /etc/hostapd/hostapd.conf

ONFAILURE = `grep 'Restart=on-failure' | wc -l`
if [ $ONFAILURE -eq 0 ]; then
	echo "patching dnsmasq.service to restart on failure"
	sed -i 's/[Install]/Restart=on-failure\nRestartSec=5\n[Install]' /etc/systemd/system/multi-user.target.wants/dnsmasq.service
fi

for s in hostapd dnsmasq dhcpcd; do service $s start; done
