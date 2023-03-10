FROM crs4/cmake:3.14

RUN apt-get -y update && apt-get -y install --no-install-recommends \
    build-essential \
    ca-certificates \
    wget \
    zlib1g-dev \
    git && rm -rf /var/lib/apt/lists/*;

COPY third_party/eddl /eddl
WORKDIR /eddl

RUN mkdir build && \
    cd build && \
    cmake -D BUILD_SUPERBUILD=ON .. && \
    make -j$(nproc) && \
    make install
