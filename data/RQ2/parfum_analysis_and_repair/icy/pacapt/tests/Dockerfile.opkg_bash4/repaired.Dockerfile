FROM oofnik/openwrt:19.07.7-x86-64
RUN opkg update && opkg install bash