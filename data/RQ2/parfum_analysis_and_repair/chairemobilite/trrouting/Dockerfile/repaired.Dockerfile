FROM debian:buster-slim
WORKDIR /source
# Install dependencies in an intermediate image
RUN apt-get update && \
    apt-get -y --no-install-recommends install build-essential autoconf automake autoconf-archive pkg-config capnproto libcapnp-dev \
    libboost-all-dev libtool libspdlog-dev && rm -rf /var/lib/apt/lists/*;

# Copy and build source   
COPY . /source   
RUN autoreconf -i && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j5 && \
    make install

# This CMD will run trRouting with default options
CMD trRouting

