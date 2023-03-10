FROM marcelmaatkamp/alpine-build-base

ENV TOR_MAJOR_VERSION 0.2.7
ENV TOR_MINOR_VERSION 6

RUN apk add --no-cache --update git
RUN git clone -b release-$TOR_MAJOR_VERSION https://github.com/marcelmaatkamp/tor.git

WORKDIR tor
RUN git checkout tor-$TOR_MAJOR_VERSION.$TOR_MINOR_VERSION

RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-asciidoc && make && make install && make dist-gzip
EXPOSE 9001 9002
CMD tor -f /etc/tor/torrc
