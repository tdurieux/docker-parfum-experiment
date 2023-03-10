FROM balenalib/%%BALENA_MACHINE_NAME%%-node:8-run

# Install Systemd
ENV container docker
RUN apt-get update && apt-get install -y --no-install-recommends \
		systemd-sysv \
	&& rm -rf /var/lib/apt/lists/*

# We never want these to run in a container
# Feel free to edit the list but this is the one we used
RUN systemctl mask \
    dev-hugepages.mount \
    sys-fs-fuse-connections.mount \
    sys-kernel-config.mount \

    display-manager.service \
    getty@.service \
    systemd-logind.service \
    systemd-remount-fs.service \

    getty.target \
    graphical.target

COPY systemd/entry.sh /usr/bin/entry.sh
COPY systemd/balena.service /etc/systemd/system/balena.service

RUN systemctl enable /etc/systemd/system/balena.service

STOPSIGNAL 37
ENTRYPOINT ["/usr/bin/entry.sh"]
ENV INITSYSTEM on
# Finish setup systemd

# Move to app dir
RUN mkdir -p /usr/src/app/ && rm -rf /usr/src/app/
WORKDIR /usr/src/app
COPY ./app/package.json ./

RUN apt-get update && apt-get install -yq --no-install-recommends \
  build-essential \
  apt-transport-https \
  python-dev \
  xmltoman \
  git \
  curl \
  wget \
  autoconf \
  automake \
  libtool \
  libssl-dev \
  libdaemon-dev \
  libasound2-dev \
  libpopt-dev \
  libconfig-dev \
  libavahi-client-dev \
  avahi-daemon \
  libnss-mdns \
  libsoxr-dev \
  alsa-utils \
  && git clone https://github.com/mikebrady/shairport-sync.git shairport-sync --depth 1  --branch 3.3.1 \
  && cd shairport-sync && autoreconf -i -f \
  && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-alsa --with-avahi --with-ssl=openssl --with-metadata --with-systemd \
  && make install && cp ./scripts/shairport-sync.conf /usr/local/etc/shairport-sync.conf && cd ../ && rm -rf shairport-sync \
  && JOBS=MAX npm install --unsafe-perm --production && npm cache clean --force && rm -rf /tmp/* \
  && apt-get purge -y \
    build-essential \
    python-dev \
    xmltoman \
    git \
    curl \
    apt-transport-https \
    autoconf \
    automake \
    libtool \
    libssl-dev \
    libdaemon-dev \
    libasound2-dev \
    libpopt-dev \
    libconfig-dev \
    libsoxr-dev \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure DAC
COPY ./Dockerbin/asound.conf /etc/asound.conf

# Move app to filesystem
COPY ./app ./

# Configure shairport-sync
COPY ./Dockerbin/shairport-sync.conf /usr/local/etc/shairport-sync.conf

# Start app
CMD ["bash", "/usr/src/app/start.sh"]
