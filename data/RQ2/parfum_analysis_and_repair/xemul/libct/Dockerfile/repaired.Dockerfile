FROM debian:jessie

RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    pkg-config \
    libtool \
    autoconf \
    git-core \
    bison \
    flex \
    libselinux1-dev \
    libapparmor-dev \
    libdbus-1-dev && rm -rf /var/lib/apt/lists/*;

COPY . /libct
WORKDIR /libct

# build libnl
RUN git submodule update --init && \
    cd .shipped/libnl && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make -j $(nproc)

RUN make clean && make -j $(nproc)
