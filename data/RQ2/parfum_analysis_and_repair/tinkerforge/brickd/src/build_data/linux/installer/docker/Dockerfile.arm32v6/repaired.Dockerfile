FROM arm32v7/debian:stretch

# apt
RUN echo "deb http://raspbian.raspberrypi.org/raspbian/ stretch main contrib non-free rpi" > /etc/apt/sources.list
RUN echo "deb http://archive.raspberrypi.org/debian/ stretch main" >> /etc/apt/sources.list
COPY raspbian.gpg /etc/apt/trusted.gpg.d/raspbian.gpg
RUN DEBIAN_FRONTEND=noninteractive apt-get clean
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y apt-utils debconf-utils && rm -rf /var/lib/apt/lists/*;
COPY debconf.conf debconf.conf
RUN debconf-set-selections < debconf.conf

# locales
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y locales locales-all && rm -rf /var/lib/apt/lists/*;
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# brickd
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y --allow-downgrades build-essential libnettle6=3.3-1 libhogweed4 libgnutls30 libldap-2.4-2 librtmp1 libcurl3-gnutls git debhelper dh-systemd lintian pkg-config libusb-1.0-0-dev libudev-dev python3 systemd && rm -rf /var/lib/apt/lists/*;

# user
RUN adduser --disabled-password --gecos '' foobar
USER foobar
