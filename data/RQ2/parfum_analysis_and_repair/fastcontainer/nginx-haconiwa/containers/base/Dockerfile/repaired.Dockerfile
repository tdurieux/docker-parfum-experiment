FROM buildpack-deps:xenial

ENV HACONIWA_ROOT /var/lib/haconiwa

ADD haconiwa $HACONIWA_ROOT
RUN mkdir /usr/local/libexec && \
    mkdir -p $HACONIWA_ROOT/rootfs/var/log/container && \
    chown www-data:www-data $HACONIWA_ROOT/rootfs/var/log/container && \
    chmod 750 $HACONIWA_ROOT/rootfs/var/log/container

RUN apt -yy update && \
    apt upgrade -yy bash && \
    apt install --no-install-recommends -yy net-tools bridge-utils iproute2 iputils-ping vim && rm -rf /var/lib/apt/lists/*;
