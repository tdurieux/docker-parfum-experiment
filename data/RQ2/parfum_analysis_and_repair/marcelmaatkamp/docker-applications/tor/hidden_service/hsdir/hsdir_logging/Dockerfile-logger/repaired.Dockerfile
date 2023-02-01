FROM marcelmaatkamp/alpine-build-base
RUN apk add --no-cache --update git
RUN git clone https://github.com/DonnchaC/tor-hsdir-research.git
WORKDIR tor-hsdir-research
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --disable-asciidoc && make && make install && make dist-gzip
EXPOSE 9001 9002
CMD tor -f /etc/tor/torrc
