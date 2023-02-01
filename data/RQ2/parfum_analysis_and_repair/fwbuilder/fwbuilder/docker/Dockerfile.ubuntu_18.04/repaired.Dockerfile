FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y \
    autoconf \
    automake \
    clang \
    g++ \
    libtool \
    libsnmp-dev \
    libxml2-dev \
    libxslt1-dev \
    make \
    nsis \
    cmake \
    git \
    qt5-default \
    ccache && rm -rf /var/lib/apt/lists/*;

WORKDIR /
CMD ["bash"]
