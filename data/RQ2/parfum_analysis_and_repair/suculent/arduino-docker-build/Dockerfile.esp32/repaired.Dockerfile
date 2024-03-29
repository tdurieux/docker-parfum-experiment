FROM debian:bullseye-slim

ARG GIT_TAG

ENV ARDUINO_VERSION="1.8.19"
ENV GIT_TAG=${GIT_TAG}
ENV DEBIAN_FRONTEND=noninteractive

ENV ESP32_VERSION="2.0.2"

RUN apt -y -qq update && \
  apt -y -qq --no-install-recommends --allow-change-held-packages install \
  software-properties-common \
  wget \
  zip \
  git \
  make \
  srecord \
  bc \
  xz-utils \
  gcc \
  curl \
  xvfb \
  python3 \
  python3-dev \
  python3-pip \
  build-essential \
  libncurses-dev \
  flex \
  bison \
  gperf \
  libxrender1 \
  libxtst6 \
  libxi6 \
  jq \
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt

# Get pinned version of Arduino IDE
RUN curl -f https://downloads.arduino.cc/arduino-$ARDUINO_VERSION-linux64.tar.xz > ./arduino-$ARDUINO_VERSION-linux64.tar.xz \
 && unxz -q ./arduino-$ARDUINO_VERSION-linux64.tar.xz \
 && tar -xvf arduino-$ARDUINO_VERSION-linux64.tar \
 && rm -rf arduino-$ARDUINO_VERSION-linux64.tar \
 && mv ./arduino-$ARDUINO_VERSION ./arduino \
 && cd ./arduino \
 && ./install.sh

# Get latest ESP32 Arduino framework
WORKDIR /opt/arduino/hardware/espressif
RUN git clone --branch $ESP32_VERSION https://github.com/espressif/arduino-esp32.git esp32
WORKDIR /opt/arduino/hardware/espressif/esp32
RUN git submodule update --init --recursive \
 && rm -rf ./**/examples/** ./.git

# Get ESP32 tools
WORKDIR /opt/arduino/hardware/espressif/esp32/tools
RUN ls -la && python3 --version && python3 get.py

# Hardening and optimization: clean apt lists
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /opt/workspace
WORKDIR /opt/workspace
COPY cmd.sh /opt/
CMD [ "/opt/cmd.sh" ]
