FROM balenalib/rpi-raspbian:latest

ARG ARCH=armv6l
ARG NODE_VERSION=8.17.0

RUN apt-get update \
 && apt-get install --no-install-recommends -y bluetooth \
                       bluez \
                       libbluetooth-dev \
                       libudev-dev \
                       mosquitto-clients \
                       build-essential \
                       python3 \
                       ca-certificates \
 && apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN update-ca-certificates --fresh

RUN curl -f -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.gz" \
 && tar -xzf "node-v$NODE_VERSION-linux-$ARCH.tar.gz" -C /usr/local --strip-components=1 \
 && rm "node-v$NODE_VERSION-linux-$ARCH.tar.gz"

ADD / /EspruinoHub

WORKDIR /EspruinoHub

RUN npm install \
 && npm cache clean --force

VOLUME ["/EspruinoHub/log"]

ENTRYPOINT ["node", "index.js"]
