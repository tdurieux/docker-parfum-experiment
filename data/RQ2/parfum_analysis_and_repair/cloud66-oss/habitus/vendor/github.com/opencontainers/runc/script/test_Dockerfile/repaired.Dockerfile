FROM golang:1.5.3

RUN echo "deb http://ftp.us.debian.org/debian testing main contrib" >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    iptables \
    libaio-dev \
    libcap-dev \
    libprotobuf-dev \
    libprotobuf-c0-dev \
    libseccomp2 \
    libseccomp-dev \
    protobuf-c-compiler \
    protobuf-compiler \
    python-minimal \
    --no-install-recommends && rm -rf /var/lib/apt/lists/*;

# install criu
ENV CRIU_VERSION 1.7
RUN mkdir -p /usr/src/criu \
        && curl -f -sSL https://github.com/xemul/criu/archive/v${CRIU_VERSION}.tar.gz | tar -v -C /usr/src/criu/ -xz --strip-components=1 \
        && cd /usr/src/criu \
        && make install-criu && rm -rf /usr/src/criu

# setup a playground for us to spawn containers in
RUN mkdir /busybox && \
    curl -f -sSL 'https://github.com/jpetazzo/docker-busybox/raw/buildroot-2014.11/rootfs.tar' | tar -xC /busybox

COPY script/tmpmount /
WORKDIR /go/src/github.com/opencontainers/runc
ENTRYPOINT ["/tmpmount"]
