FROM debian:8.0

RUN apt-get update && apt-get install --no-install-recommends rsyslog ca-certificates -y && rm -rf /var/lib/apt/lists/*;
COPY objects/hologram-server.deb /tmp/hologram-server.deb
RUN dpkg -i /tmp/hologram-server.deb
ONBUILD COPY config.json /etc/hologram/server.json

COPY start.sh /start.sh

EXPOSE 3100

ENTRYPOINT ["/start.sh"]
