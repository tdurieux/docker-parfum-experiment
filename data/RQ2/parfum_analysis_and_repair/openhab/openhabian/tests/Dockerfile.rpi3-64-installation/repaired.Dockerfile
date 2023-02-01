# Note RPi3 base (first RPi to have aarch64 available) WITH 64bit OS
FROM balenalib/raspberrypi3-64-debian:bullseye-build

ENV DOCKER=1
ENV UDEV=1
ENV INITSYSTEM=1

# Install systemd
RUN apt-get update -qq && \
    apt-get install --yes -qq --no-install-recommends systemd systemd-sysv && \
    rm -rf /var/lib/apt/lists/*

RUN systemctl mask \
    dev-hugepages.mount \
    sys-fs-fuse-connections.mount \
    sys-kernel-config.mount \
    display-manager.service \
    getty@.service \
    systemd-logind.service \
    systemd-remount-fs.service \
    getty.target \
    graphical.target \
    kmod-static-nodes.service

COPY ./tests/balena.service /etc/systemd/system/balena.service
RUN systemctl enable /etc/systemd/system/balena.service

STOPSIGNAL 37
ENTRYPOINT ["./tests/entry.sh"]

# Setup openHABian environment