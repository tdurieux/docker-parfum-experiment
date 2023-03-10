FROM debian:jessie

RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    wget \
    curl \
    vim \
    iptables-dev \
    libcurl4-gnutls-dev \
    libdbi0-dev \
    libesmtp-dev \
    libgcrypt11-dev \
    libglib2.0-dev \
    libltdl-dev \
    liblvm2-dev \
    libmemcached-dev \
    libmnl-dev \
    libmodbus-dev \
    libmysqlclient-dev \
    libopenipmi-dev \
    liboping-dev \
    libow-dev \
    libpcap-dev \
    libperl-dev \
    libpq-dev \
    libprotobuf-c-dev \
    librabbitmq-dev \
    librrd-dev \
    libsensors4-dev \
    libsnmp-dev \
    libtokyocabinet-dev \
    libtokyotyrant-dev \
    libtool \
    libupsclient-dev \
    libvirt-dev \
    libxml2-dev \
    libyajl-dev \
    linux-libc-dev \
    pkg-config \
    protobuf-c-compiler \
    python-dev && \
    rm -rf /usr/share/doc/* && \
    rm -rf /usr/share/info/* && \
    rm -rf /tmp/* && \
    rm -rf /var/tmp/* && rm -rf /var/lib/apt/lists/*;

ENV COLLECTD_VERSION collectd-5.5.0

WORKDIR /tmp/

RUN curl -f -L https://collectd.org/files/${COLLECTD_VERSION}.tar.bz2 | tar -jx

WORKDIR $COLLECTD_VERSION
RUN ls


RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make all && \
    make install && \
    make clean

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.16.0.2/s6-overlay-amd64.tar.gz /tmp/s6-overlay-amd64.tar.gz
ADD https://github.com/just-containers/s6-overlay/releases/download/v1.16.0.2/s6-overlay-amd64.tar.gz.sig /tmp/s6-overlay-amd64.tar.gz.sig
RUN \

    gpg --batch --keyserver pgp.mit.edu --recv-key 0x337EE704693C17EF \
    && gpg --batch --verify /tmp/s6-overlay-amd64.tar.gz.sig /tmp/s6-overlay-amd64.tar.gz \
    && rm -rf /root/.gnupg \

    # Install
    && tar xvfz /tmp/s6-overlay-amd64.tar.gz -C / && rm -rf /tmp/* && rm /tmp/s6-overlay-amd64.tar.gz
RUN apt-get install --no-install-recommends python-psutil python-numpy -y && rm -rf /var/lib/apt/lists/*;
ADD root /

ENTRYPOINT ["/init"]
