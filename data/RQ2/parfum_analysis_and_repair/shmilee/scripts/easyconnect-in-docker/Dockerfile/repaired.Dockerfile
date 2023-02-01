# debian 10 buster
# https://hub.docker.com/_/debian/

FROM debian:buster-slim

LABEL maintainer="shmilee.zju@gmail.com" \
      release.version="buster" \
      ec.versions="7.6.3 7.6.7 etc." \
      description="buster with EasyConnect run prerequisites"

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 \
    DEBIAN_CODENAME=buster \
    DEBIAN_MIRROR=http://mirrors.163.com/debian \
    EasyConnectDir=/usr/share/sangfor/EasyConnect

#    DEBIAN_SECURITY_MIRROR=http://mirrors.163.com/debian-security \
#    && echo "deb $DEBIAN_SECURITY_MIRROR $DEBIAN_CODENAME/updates main contrib" >> /etc/apt/sources.list \