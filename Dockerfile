FROM debian

ENV foo /ap

RUN mkdir $foo
WORKDIR $foo
RUN mkdir -p etc/network etc/hostapd etc/default etc/wpa_supplicant
ADD etc/dhcpcd.conf $foo/etc/
ADD etc/network/interfaces $foo/etc/network/
ADD etc/hostapd/hostapd.conf $foo/etc/hostapd/
ADD etc/default/hostapd $foo/etc/default/
ADD etc/wpa_supplicant/wpa_supplicant.conf $foo/etc/wpa_supplicant/
ADD etc/iptables.ipv4.nat $foo/etc/
ADD install.sh $foo/
RUN bash -x install.sh
