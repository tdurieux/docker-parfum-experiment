FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# Enable deb-src APT sources and get build tools
RUN sed -e '/^#\sdeb-src /s/^# *//;t;d' "/etc/apt/sources.list" \
    >> "/etc/apt/sources.list.d/ubuntu-sources.list"
RUN apt-get update
RUN apt-get -y --no-install-recommends install software-properties-common gpg-agent && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install \
    build-essential devscripts lsb-release dput wget git golang nvi && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:tonimelisma/ppa
RUN add-apt-repository -y ppa:strukturag/libheif
RUN add-apt-repository -y ppa:strukturag/libde265
RUN apt-get -y install --no-install-recommends libvips-dev && rm -rf /var/lib/apt/lists/*;
RUN go get golang.org/dl/go1.15.4
RUN ~/go/bin/go1.15.4 download
RUN mkdir -p ~/go/src/github.com/davidbyttow
RUN cd ~/go/src/github.com/davidbyttow  && git clone -v https://github.com/davidbyttow/govips.git
RUN cd ~/go/src/github.com/davidbyttow/govips && ~/go/bin/go1.15.4 get ./...
RUN cd ~/go/src/github.com/davidbyttow/govips && ~/go/bin/go1.15.4 test -v ./...


ENV DEBFULLNAME="Toni Melisma"
ENV DEBEMAIL="toni.melisma@iki.fi"
ENV PPANAME="tonimelisma"
ENV DISTRIBUTION="focal"
ENV DISTVERSION="20.04"
ENV PACKAGE="vips"
