Raspberry Pi Setup als AccessPoint
=====

1. `./install.sh` ausführen
2. Profit!

Basiert auf der Anleitung -> [Raspberry Pi as wifi access point](https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/)



Changes:
- dnsmasq:
    Restart in dnsmasq unit-file (/etc/systemd/system/multi-user.target.wants/dnsmasq.service) due to late ip-address assignment (dnsmasq runs with --bind-interface, we only want to provide dns-caching for wireless clients from iface wlan0, but since dhcpcd initiates its own static ip very late in the boot process and dnsmasq is set to type=fork, we are unable to set the dependency right)
- SSH:
    Set PermitRootLogin to "no" and remove ecdsa and dsa host keys and references in config
