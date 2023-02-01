# Full elbencho deb install of latest github master on Ubuntu 18.04
#
# Run docker build from elbencho repository root dir like this:
# docker build -t elbencho-local -f build_helpers/docker/Dockerfile.ubuntu1804.local .

FROM ubuntu:18.04 as builder

COPY ./ /root/elbencho

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt -y upgrade && \
    apt install --no-install-recommends -y build-essential debhelper devscripts fakeroot git libaio-dev libboost-filesystem-dev libboost-program-options-dev libboost-thread-dev libncurses-dev libnuma-dev lintian && \
    cd /root/elbencho && \
    make -j "$(nproc)" && \
    make deb && rm -rf /var/lib/apt/lists/*;

FROM ubuntu:18.04

COPY --from=builder /root/elbencho/packaging/elbencho*.deb /tmp/

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt install --no-install-recommends -y /tmp/elbencho*.deb && \
    rm -f /tmp/elbencho*.deb && \
    apt clean all && \
    /usr/bin/elbencho --version && rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/usr/bin/elbencho"]
