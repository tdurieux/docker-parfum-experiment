FROM hypriot/rpi-python

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y -q transmission-daemon && rm -rf /var/lib/apt/lists/*;

VOLUME /var/lib/transmission-daemon/downloads

EXPOSE 9091
EXPOSE 51413
EXPOSE 51413/udp

COPY etc/transmission-daemon /etc/transmission-daemon

CMD ["/usr/bin/transmission-daemon", "-f", "-g", "/etc/transmission-daemon"]
