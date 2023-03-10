FROM golang:alpine

ENV YARA_VER=v4.0.2 \
    LIBPACP_VER=libpcap-1.9.1 \
    PF_RING_VER=7.6.0

RUN apk add --no-cache \
    musl \
    musl-dev \
    musl-utils \
    linux-headers \
    gcc \
    mingw-w64-gcc \
    mingw-w64-binutils \
    mingw-w64-headers \
    mingw-w64-winpthreads \
    mingw-w64-crt \
    pkgconfig \
    flex \
    bison \
    autoconf \
    libtool \
    automake \
    make \
    libpcap-dev \
    git

ENV MOLE_HOME=/go/src/github.com/mole-ids/mole \
    YARA_SRC_DIR=/usr/src/yara \
    YARA_NIX_PREFIX=/usr/local/yara \
    YARA_WIN_PREFIX=/usr/local/yara-win \
    LIBPCAP_SRC_DIR=/usr/src/libpcap \
    LIBPCAP_PREFIX=/usr/local/libpcap \
    PF_RING_SRC_DIR=/usr/src/pf_ring \
    PF_RING_LIB_DIR=/usr/src/pf_ring/userland/lib \
    PF_RING_LIB_PREFIX=/usr/local/pf_ring_lib \
    PF_RING_PREFIX=/usr/local/pf_ring

RUN git clone https://github.com/VirusTotal/yara ${YARA_SRC_DIR} \
    && cd ${YARA_SRC_DIR} \
    && git checkout ${YARA_VER}

RUN git clone https://github.com/the-tcpdump-group/libpcap ${LIBPCAP_SRC_DIR} \
    && cd ${LIBPCAP_SRC_DIR} \
    && git checkout ${LIBPACP_VER}

RUN git clone https://github.com/ntop/PF_RING.git ${PF_RING_SRC_DIR} \
    && cd ${PF_RING_SRC_DIR} \
    && git checkout ${PF_RING_VER}

VOLUME /go/src/github.com/mole-ids/mole
ADD . /go/src/github.com/mole-ids/mole

WORKDIR /go/src/github.com/mole-ids/mole

ENTRYPOINT [ "/bin/ash", "./script/mole-docker-builder.sh" ]