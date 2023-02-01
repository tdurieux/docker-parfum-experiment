# FROM kalilinux/kali-linux-docker
FROM ubuntu

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get dist-upgrade -yf
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -yu ppa:wireshark-dev/stable
RUN apt-get install --no-install-recommends -y \
    pciutils usbutils unzip telnet wget axel amqp-tools tshark npm nodejs aircrack-ng curl nodejs libpcap-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y nodejs-legacy git subversion vim && rm -rf /var/lib/apt/lists/*;

WORKDIR wifi
RUN npm install -g amqp-ts && npm cache clean --force;

CMD [ "nodejs", "js/all.js" ]
