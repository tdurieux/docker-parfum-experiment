FROM ubuntu:latest

MAINTAINER "Donncha O'Cearbhaill <donncha@donncha.is>"

RUN apt-get -y update && apt-get install --no-install-recommends -y build-essential automake libssl-dev libevent-dev git && rm -rf /var/lib/apt/lists/*;

RUN git clone https://git.torproject.org/tor.git -b release-0.2.9
WORKDIR tor

RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-asciidoc --enable-tor2web-mode --enable-static-libevent --enable-static-zlib --with-libevent-dir=/usr/local/ --with-zlib-dir=/usr/local/
RUN make
COPY src/or/tor /build

#ENTRYPOINT ["/bin/sh"]
