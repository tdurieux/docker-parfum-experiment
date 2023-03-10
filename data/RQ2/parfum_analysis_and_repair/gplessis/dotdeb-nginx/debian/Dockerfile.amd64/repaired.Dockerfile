# Usage:
#  docker build --pull -t build-jessie-amd64 -f debian/Dockerfile.amd64 .
#  docker run build-jessie-amd64
#  ID=$(docker ps -l -q)
#  docker cp $ID:/usr/src ~/Downloads/
#  docker rm $ID

FROM debian:jessie

RUN export DEBIAN_FRONTEND noninteractive \
    && apt-get update \
    && apt-get dist-upgrade -y \
    && apt-get install --no-install-recommends -y build-essential devscripts equivs libwww-perl && rm -rf /var/lib/apt/lists/*;

ADD debian/control /root/
RUN mk-build-deps --install --tool 'apt-get -y' --remove /root/control && rm -f /root/control

ADD . /usr/src/builddir
WORKDIR /usr/src/builddir
RUN find debian/ -name '\.git*' -exec rm -rf {} \; &>/dev/null \
    && rm -r debian/modules/nginx-upload-progress/test/ \
    && rm -r debian/modules/nginx-rtmp-module/test/ \
    && uscan --download-current-version

RUN dpkg-buildpackage

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/src/builddir
