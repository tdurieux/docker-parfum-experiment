FROM dhealth/dev-eddl-base

COPY third_party/eddl /eddl
WORKDIR /eddl

RUN mkdir build && \
    cd build && \
    cmake -D BUILD_TARGET=CPU -D BUILD_SHARED_LIBS=ON -D BUILD_HPC=OFF -D BUILD_PROTOBUF=ON -D BUILD_TESTS=OFF -D BUILD_EXAMPLES=ON .. && \
    make -j$(nproc) && \
    make install