ARG BUILDBOX_VERSION
FROM quay.io/gravitational/teleport-buildbox-fips:$BUILDBOX_VERSION

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install gcc-arm-linux-gnueabihf gcc-aarch64-linux-gnu && \
    apt-get -y autoclean && apt-get -y clean && rm -rf /var/lib/apt/lists/*;
