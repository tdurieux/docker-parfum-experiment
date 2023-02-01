FROM debian:latest
MAINTAINER Anton Vilhelm Ásgeirsson, ava7@hi.is

# Install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    build-essential \
    libboost-all-dev \
    libdb5.3++-dev \
    libssl-dev \
    libtool \
    pkg-config && \
    rm -rf /var/lib/apt/lists/*

# Add source tree to docker image
WORKDIR /smileycoin
COPY . /smileycoin
RUN useradd -m -u 1000 -U -s /usr/bin/bash -d /smileycoin smileycoin

# Build
RUN ./autogen.sh
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --with-gui=no
RUN make -j $(nproc)
RUN make install
RUN rm -rf /smileycoin/* && chown -R 1000:1000 /smileycoin

USER smileycoin
RUN mkdir /smileycoin/.smileycoin

CMD ["smileycoind"]
