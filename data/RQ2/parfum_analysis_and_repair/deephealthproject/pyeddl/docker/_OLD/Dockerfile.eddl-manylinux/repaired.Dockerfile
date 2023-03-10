FROM quay.io/pypa/manylinux2010_x86_64

RUN yum -y remove cmake && \
    yum -y install wget zlib-devel && rm -rf /var/cache/yum

RUN wget -q https://cmake.org/files/v3.14/cmake-3.14.5-Linux-x86_64.tar.gz && \
    tar xf cmake-3.14.5-Linux-x86_64.tar.gz && \
    cp -rf cmake-3.14.5-Linux-x86_64/bin /usr/ && \
    cp -rf cmake-3.14.5-Linux-x86_64/share /usr/ && \
    rm -rf cmake-3.14.5-Linux-x86_64.tar.gz cmake-3.14.5-Linux-x86_64

# Install EDDL. Assumes recursive submodule update.
COPY third_party/eddl /eddl
WORKDIR /eddl

RUN mkdir build && \
    cd build && \
    cmake -D BUILD_SUPERBUILD=ON .. && \
    ln -s /eddl/build/cmake/third_party/protobuf/lib64 /eddl/build/cmake/third_party/protobuf/lib && \
    ln -s /eddl/build/cmake/third_party/googletest/lib64 /eddl/build/cmake/third_party/googletest/lib && \
    make -j$(nproc) && \
    make install
