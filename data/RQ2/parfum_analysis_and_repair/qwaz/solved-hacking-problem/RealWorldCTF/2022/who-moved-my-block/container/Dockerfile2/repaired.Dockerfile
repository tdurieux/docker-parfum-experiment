FROM ubuntu:20.04

RUN sed -i "s/http:\/\/archive.ubuntu.com/http:\/\/mirrors.aliyun.com/g" /etc/apt/sources.list && \
        sed -i "s/http:\/\/security.ubuntu.com/http:\/\/mirrors.aliyun.com/g" /etc/apt/sources.list

RUN  apt-get update && \
        apt-get -y dist-upgrade

RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install ca-certificates gcc make bison wget libglib2.0-dev -y && rm -rf /var/lib/apt/lists/*;

COPY nbd-server /usr/bin/
COPY rootfs.ext2 /
COPY start.sh /

EXPOSE 10809

CMD ["/start.sh"]
