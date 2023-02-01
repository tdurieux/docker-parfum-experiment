FROM kernsuite/base:4

RUN export DEBIAN_FRONTEND=noninteractive && apt-get update && \
    apt-get install --no-install-recommends -y \
    casacore-data casacore-dev \
    libboost-test-dev libboost-system-dev libboost-filesystem-dev \
    cmake \
    build-essential \
    libgsl-dev pkg-config && rm -rf /var/lib/apt/lists/*;

ADD . /src
WORKDIR /src

RUN mkdir /build && cd /build && cmake ../src

RUN cd /build && make -j2 && make install && make check -j2
