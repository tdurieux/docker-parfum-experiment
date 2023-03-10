FROM ubuntu:20.04

RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get --no-install-recommends install -y libpam0g-dev libssl-dev zlib1g-dev pkg-config xxd cmake \
    libgtest-dev libgmock-dev ninja-build python3 autoconf-archive autoconf \
    build-essential git libsystemd-dev systemd libtinyxml2-dev python3-wheel python3-pip \
    python3-yaml python3-mako python3-inflection python3-setuptools && \
    pip3 install --no-cache-dir meson && rm -rf /var/lib/apt/lists/*;

ADD . /source

RUN cd source && meson setup build && \
    meson compile -C build

WORKDIR /build
