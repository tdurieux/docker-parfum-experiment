# This is a generic Dockerfile to ease Debian packaging
#
# Requirements:
#   * Docker >= 1.5
# Usage:
#   # docker build -t build-wheezy-amd64-mysql56 -f debian/Dockerfile.amd64 .
#   # docker run build-wheezy-amd64-mysql56
#   # ID=$(docker ps -l -q)
#   # docker cp $ID:/usr/src ~/Downloads/
#   # docker rm $ID

FROM dotdeb/debian:wheezy-amd64
MAINTAINER Guillaume Plessis "gui@dotdeb.org"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install --no-install-recommends -y build-essential devscripts equivs libwww-perl && rm -rf /var/lib/apt/lists/*;
RUN apt-get dist-upgrade -y



ADD debian/control /root/
RUN mk-build-deps --install --tool 'apt-get -y' --remove /root/control && rm -f /root/control

ADD . /usr/src/builddir
WORKDIR /usr/src/builddir

RUN uscan --download-current-version
RUN dpkg-buildpackage

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/src/builddir
