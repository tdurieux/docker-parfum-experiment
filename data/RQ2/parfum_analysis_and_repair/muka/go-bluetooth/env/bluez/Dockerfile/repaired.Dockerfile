FROM ubuntu:19.10
ARG BLUEZ_VERSION=5.54
WORKDIR /bluez
RUN apt update -qq && apt remove --purge -y bluetooth  && apt install -y && \
  DEBIAN_FRONTEND=noninteractive apt --no-install-recommends install -y \
    git libdbus-1-dev libudev-dev libical-dev libreadline-dev \
    autotools-dev automake libtool libglib2.0-dev udev && rm -rf /var/lib/apt/lists/*;

ENV BLUEZ_VERSION=$BLUEZ_VERSION
RUN cd / && git clone https://git.kernel.org/pub/scm/bluetooth/bluez.git && cd bluez && git checkout $BLUEZ_VERSION && \
      ./bootstrap && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-systemd && make && make install
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["sh", "/entrypoint.sh"]
