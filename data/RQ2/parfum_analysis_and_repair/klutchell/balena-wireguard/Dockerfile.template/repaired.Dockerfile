FROM golang:1.17.1-alpine3.14 AS wireguard-go

# hadolint ignore=DL3018
RUN apk add --no-cache curl build-base

WORKDIR /usr/src/app

ARG WG_GO_TAG=0.0.20210212

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN curl -fsSL https://git.zx2c4.com/wireguard-go/snapshot/wireguard-go-${WG_GO_TAG}.tar.xz | tar xJ && \
    make -C wireguard-go-${WG_GO_TAG} -j"$(nproc)" && \
    make -C wireguard-go-${WG_GO_TAG} install

FROM alpine:3.14

COPY --from=wireguard-go /usr/bin/wireguard-go /usr/bin/

# hadolint ignore=DL3018
RUN apk add --no-cache \
    bash \
    build-base \
    curl \
    libmnl-dev \
    iptables \
    flex \
    bison \
    bc \
    python3 \
    kmod \
    openresolv \
    iproute2 \
    kmod \
    libqrencode \
    gettext \
    ipcalc \
    openssl-dev \
    perl

WORKDIR /usr/src/app

ARG WITH_WGQUICK=yes
ARG WG_TOOLS_TAG=v1.0.20210424
ARG WG_LINUX_TAG=v1.0.20210606

SHELL ["/bin/ash", "-eo", "pipefail", "-c"]

RUN curl -fsSL https://git.zx2c4.com/wireguard-tools/snapshot/wireguard-tools-${WG_TOOLS_TAG}.tar.xz | tar xJ && \
    curl -fsSL https://git.zx2c4.com/wireguard-linux-compat/snapshot/wireguard-linux-compat-${WG_LINUX_TAG}.tar.xz | tar xJ

# build and install wireguard-tools
RUN make -C wireguard-tools-${WG_TOOLS_TAG}/src -j"$(nproc)" && \
    make -C wireguard-tools-${WG_TOOLS_TAG}/src install

# strip the kernel version check
# https://forums.balena.io/t/using-wireguard-with-new-os-releases/344047/8
# https://gist.github.com/mattmacleod/c6589fadeaaf83f2c7d75321d9172bbe
COPY wireguard-linux-compat.patch ./
RUN patch -d /usr/src/app/wireguard-linux-compat-${WG_LINUX_TAG}/ -p0 < wireguard-linux-compat.patch

# Set both of these to match your target device to pre-build modules
# Leave at least one of them unset to postpone module building to app start
ARG BALENA_DEVICE_TYPE=%%BALENA_MACHINE_NAME%%
ARG BALENA_HOST_OS_VERSION

COPY buildmod.sh ./
RUN chmod +x ./buildmod.sh && ./buildmod.sh

WORKDIR /usr/src/app/templates

COPY server.conf peer.conf ./

WORKDIR /usr/src/app

RUN curl -fsSL https://raw.githubusercontent.com/honzahommer/prips.sh/8bfab5e17539b37f1d21584da19e79f8751d6846/libexec/prips.sh -O && \
    chmod +x prips.sh

COPY run.sh ./

COPY show-peer /usr/bin/

RUN chmod +x run.sh /usr/bin/show-peer

CMD [ "/usr/src/app/run.sh" ]

# set defaults for wireguard server
ENV SERVER_HOST "auto"
ENV SERVER_PORT "51820"
ENV CIDR "10.13.13.0/24"
ENV ALLOWEDIPS "0.0.0.0/0, ::/0"
ENV PEER_DNS "1.1.1.1"
ENV PEERS "4"

# set log level for userspace module
ENV LOG_LEVEL "verbose"