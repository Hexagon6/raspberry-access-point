Raspberry Pi Setup als AccessPoint
=====

0. `./install.sh` ausführen
1. Mit WiFi von Raspberry Pi verbinden
   Beispiel: ESSID `sfpi-99`, WPA2-Passphrase: `sfpi-99_`
2. Mit SSH auf 172.24.1.1 einloggen
   Beispiel unter Linux: `ssh pi@172.24.1.1`, default-pw `raspberry`
3. Optional: NAT einrichten mit `iptables-restore < /etc/iptables.ipv4.nat`
   Um dies permanent einzurichten die obere Zeile in /etc/rc.local einfügen.

Basiert auf der Anleitung -> [Raspberry Pi as wifi access point](https://frillip.com/using-your-raspberry-pi-3-as-a-wifi-access-point-with-hostapd/)



Troubleshooting und Tipps:
- dnsmasq "failure"-Nachrichten beim Aufstarten:
    dnsmasq started mehrfach neu beim booten.
      Dies ist unproblematisch und kann mit Setzen einer statischen IP für wlan0 behoben werden, jedoch setzt hostapd/dhcpcd diese IP beim starten, weshalb dnsmasq erst auf DNS anfragen hören kann, wenn diese IP-Adresse gesetzt ist. Siehe `/etc/network/interfaces`.
    Detail:
    ```
    Restart in dnsmasq unit-file (/etc/systemd/system/multi-user.target.wants/dnsmasq.service) due to late ip-address assignment (dnsmasq runs with --bind-interface, we only want to provide dns-caching for wireless clients from iface wlan0, but since dhcpcd initiates its own static ip very late in the boot process and dnsmasq is set to type=fork, we are unable to set the dependency right)
	```
- SSH absichern, wenn der Raspberry ans Internet gehängt wird:
    Um SSH abzusichern und Root Login nicht zu ermöglichen folgendes in der `/etc/ssh/sshd_config` setzen:
      Set PermitRootLogin to "no".
	DSA ist unsicher und ECDSA hat nicht vertrauenswürdige crypto, daher empfielt es sich ECDSA- und DSA-host keys und Referenzen in der config zu entfernen
