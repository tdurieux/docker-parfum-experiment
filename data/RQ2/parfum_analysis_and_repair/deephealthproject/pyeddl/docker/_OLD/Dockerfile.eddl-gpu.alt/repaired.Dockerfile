FROM crs4/cmake:3.14

RUN apt-get -y update && apt-get -y install --no-install-recommends \
    build-essential \
    ca-certificates \
    nvidia-cuda-toolkit \
    wget && rm -rf /var/lib/apt/lists/*;

COPY third_party/eddl /eddl
WORKDIR /eddl

RUN mkdir build && \
    cd build && \
    cmake -D BUILD_TARGET=gpu -D BUILD_TESTS=ON .. && \
    make -j$(grep -c ^processor /proc/cpuinfo)

RUN cd build && make install && \
    cp -rf install/include/eddl /usr/local/include/ && \
    cp -rf install/include/third_party/eigen/Eigen /usr/local/include/ && \
    cp install/lib/libeddl.a /usr/local/lib
