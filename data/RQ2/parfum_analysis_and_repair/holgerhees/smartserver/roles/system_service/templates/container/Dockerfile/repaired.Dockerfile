FROM alpine:{{alpine_version}}

COPY entrypoint.sh /entrypoint.sh

RUN chmod 755 /entrypoint.sh \
    && apk update \
    && apk upgrade \
    && apk --update --no-cache add python3 py3-inotify py3-paho-mqtt py3-pip coreutils tcpdump arping nmap nmap-scripts tzdata \
    && pip3 install --no-cache-dir --upgrade pip \
    && pip3 install --no-cache-dir flask flask-socketio simple-websocket fritzconnection \
    && apk --update --no-cache add git autoconf automake make gcc g++ libpcap-dev \
    && git clone https://github.com/royhills/arp-scan.git \
    && cd arp-scan/ \
    && autoreconf --install \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    && make \
    && make install

#ENTRYPOINT ["/bin/sleep","3000000"]
ENTRYPOINT ["/entrypoint.sh"]

