#
# szepeviktor/jessie-build
#
# VERSION       :0.2.6
# BUILD         :docker build --ulimit nofile=2048 -t szepeviktor/jessie-build .
# RUN           :docker run --rm -i -t --ulimit nofile=2048 -v /opt/results:/opt/results szepeviktor/jessie-build

FROM debian:jessie

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y apt-utils \
    && apt-get install --no-install-recommends -y sudo dialog wget nano devscripts git \
    && apt-get --purge -y autoremove \
    && apt-get clean \
    && find /var/lib/apt/lists -type f -delete && rm -rf /var/lib/apt/lists/*;

RUN adduser --disabled-password --gecos "" debian \
    && printf 'debian\tALL=(ALL:ALL) NOPASSWD: ALL\n' >>/etc/sudoers

USER debian
WORKDIR /home/debian
VOLUME ["/opt/results"]
