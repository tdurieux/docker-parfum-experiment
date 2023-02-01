FROM debian:buster AS build

# Disable apt/dpkg interactive mode
ENV DEBIAN_FRONTEND=noninteractive

# Install all build dependencies
COPY packaging/installer/install-required-packages.sh /tmp/install-required-packages.sh
RUN /tmp/install-required-packages.sh --dont-wait --non-interactive netdata-all

# Install Clang and set as default CC
RUN apt-get install --no-install-recommends -y clang && \
    update-alternatives --install /usr/bin/cc cc /usr/bin/clang 100 && rm -rf /var/lib/apt/lists/*;

WORKDIR /netdata
COPY . .

# Build Netdata
RUN ./netdata-installer.sh --dont-wait --dont-start-it --disable-go --require-cloud
