FROM centos:7 as builder
RUN yum install -y epel-release && \
    yum install -y git swig3 cmake3 gcc-c++ zlib-devel libzstd-devel ninja-build hdf5-devel python3-devel python3-numpy blosc-devel boost-devel && \
    yum clean all && rm -rf /var/cache/yum
RUN git clone https://github.com/LLNL/zfp /src/zfp && \
    git clone https://github.com/disheng222/sz /src/sz && \
    git clone https://github.com/llnl/fpzip /src/fpzip && \
    \
    cd /src/sz && \
    mkdir build && \
    cd build && \
    cmake3 .. -DCMAKE_INSTALL_PREFIX=/usr -G Ninja && \
    cmake3 --build . && \
    ninja-build install && \
    \
    cd /src/zfp && \
    mkdir build && \
    cd build && \
    cmake3 .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTING=OFF -G Ninja && \
    cmake3 --build . && \
    ninja-build install && \
    \
    cd /src/fpzip && \
    mkdir build && \
    cd build && \
    cmake3 .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTING=OFF -G Ninja && \
    cmake3 --build . && \
    ninja-build install
COPY . /src/libpressio
RUN cd /src/libpressio && \
    rm -rf build && \
    mkdir build && \
    cd build && \
    cmake3 .. -DCMAKE_INSTALL_PREFIX=/usr \
      -DBUILD_TESTING=ON \
      -DLIBPRESSIO_HAS_ZFP=ON \
      -DLIBPRESSIO_HAS_SZ=ON \
      -DLIBPRESSIO_HAS_FPZIP=ON \
      -DLIBPRESSIO_HAS_BLOSC=ON \
      -DLIBPRESSIO_HAS_MAGICK=OFF \
      -DLIBPRESSIO_HAS_MGARD=OFF \
      -DLIBPRESSIO_HAS_HDF=ON \
      -DBUILD_PYTHON_WRAPPER=ON \
      -DLIBPRESSIO_CXX_VERSION=11 \
      -G Ninja && \
    cmake3 --build . && \
    ninja-build install && \
    CTEST_OUTPUT_ON_FAILURE=1 ctest3 .


FROM centos:7
RUN yum install -y epel-release && \
    yum install -y zlib hdf5 libzstd fftw python3-numpy blosc boost \
    && \
    yum clean all && rm -rf /var/cache/yum
COPY --from=builder /usr/lib64/libSZ.so* \
                    /usr/lib64/liblibpressio.so* \
                    /usr/lib64/libzfp.so*  \
                    /usr/lib64/libmgard.so* \
                    /usr/lib64/fpzip.so* \
                    /usr/lib64/
COPY --from=builder /usr/include/libpressio \
                    /usr/include/sz \
                    /usr/include/zfp* \
                    /usr/include/mgard* \
                    /usr/local/include/fpzip* \
                    /usr/include/
COPY --from=builder /usr/bin/sz /usr/bin/
COPY --from=builder /usr/lib/python3.6/site-packages/*pressio* /usr/lib64/python3.6/site-packages/

