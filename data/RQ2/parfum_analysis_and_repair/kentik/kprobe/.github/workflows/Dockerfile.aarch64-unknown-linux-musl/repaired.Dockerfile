FROM ghcr.io/kentik/cross:aarch64-unknown-linux-musl

ARG LIBPCAP=libpcap-1.10.0

RUN apt-get update && apt-get install --no-install-recommends -y bison flex capnproto && rm -rf /var/lib/apt/lists/*;

RUN mkdir /work && cd /work
RUN curl -f -L -O https://www.tcpdump.org/release/$LIBPCAP.tar.gz
RUN tar xzf $LIBPCAP.tar.gz && rm $LIBPCAP.tar.gz
RUN cd $LIBPCAP && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --host aarch64-linux-musl && make install
