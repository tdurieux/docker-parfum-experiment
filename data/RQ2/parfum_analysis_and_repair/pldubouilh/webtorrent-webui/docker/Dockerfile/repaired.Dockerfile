# BUILD:  docker build --tag wt  .
# RUN: docker run -d --cap-add=NET_ADMIN --device=/dev/net/tun -p 127.0.0.1:9081:9081 -v ~/Downloads:/data -v ~/.torrent_folder:/tf wt

FROM node:8

# Install openvpn
RUN apt-get -y update && apt-get -y --no-install-recommends install curl openvpn && rm -rf /var/lib/apt/lists/*;

# Make file where we live
RUN mkdir -p /usr/src/vpn-conf && rm -rf /usr/src/vpn-conf

# Copy vpn-conf file
COPY vpn-conf/ /usr/src/vpn-conf/
WORKDIR /usr/src/vpn-conf

# Install webtorrent-webui
RUN npm i -g --unsafe webtorrent-webui && npm cache clean --force;

# Copy init script
COPY init.sh /usr/src/vpn-conf

EXPOSE 9081
CMD ["/bin/sh", "/usr/src/vpn-conf/init.sh"]
