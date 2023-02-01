#
# szepeviktor/stretch-build
#
# VERSION       :0.1.0
# BUILD         :docker build -t szepeviktor/stretch-build .
# RUN           :docker run --rm -i -t -v /opt/results:/opt/results szepeviktor/stretch-build

FROM debian:stretch

ENV LC_ALL C
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install --no-install-recommends -y apt-utils \
    && apt-get install --no-install-recommends -y dirmngr sudo dialog wget nano devscripts git && rm -rf /var/lib/apt/lists/*;

RUN apt-get --purge -y autoremove \
    && apt-get clean \
    && find /var/lib/apt/lists -type f -delete

RUN adduser --disabled-password --gecos "" debian
RUN printf 'debian\tALL=(ALL:ALL) NOPASSWD: ALL\n' >> /etc/sudoers

USER debian
WORKDIR /home/debian
VOLUME ["/opt/results"]
