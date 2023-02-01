# FROM kalilinux/kali-linux-docker
FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get dist-upgrade -yf && apt-get install --no-install-recommends -y \
    pciutils usbutils unzip telnet wget axel amqp-tools tshark npm nodejs aircrack-ng curl nodejs libpcap-dev && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends -y nodejs-legacy git subversion vim && rm -rf /var/lib/apt/lists/*;

WORKDIR wifi
# RUN git clone git://github.com/mranney/node_pcap.git
RUN echo
RUN git clone https://github.com/marcelmaatkamp/node_pcap.git
WORKDIR node_pcap
RUN npm install nan socketwatcher && npm cache clean --force;
RUN npm install . -g && npm cache clean --force;
RUN node-gyp configure build install
WORKDIR ..
RUN npm install amqp-ts && npm cache clean --force;

COPY js js
COPY bin bin

ENV LOCATION_NAME NAME
ENV LOCATION_LAT 0
ENV LOCATION_LON 0

CMD [ "nodejs", "js/all.js" ]
