FROM debian:stretch

RUN dpkg --add-architecture i386  && \
    apt-get update && \
    apt-get install --no-install-recommends -y build-essential \
    cpio \
    libc6:i386 \
    libstdc++6:i386 \
    libxml2-dev \
    libxml2-utils \
    libssl1.0-dev \
    zlib1g-dev && rm -rf /var/lib/apt/lists/*;

WORKDIR "/xarsrc"
ADD installers/xar/xar-1.5.2.tar.gz .
WORKDIR "/xarsrc/xar-1.5.2"
RUN CFLAGS=-w CPPFLAGS=-w CXXFLAGS=-w LDFLAGS=-w ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make && make install

