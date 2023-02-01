FROM fedora:32 as builder
RUN echo "fastestmirror=True">>/etc/dnf/dnf.conf && \
    dnf install -y git swig cmake gcc-c++ zlib-devel libzstd-devel ninja-build hdf5-devel python3-devel python3-numpy ImageMagick-c++-devel blosc-devel && \
    dnf clean all
RUN git clone https://github.com/LLNL/zfp /src/zfp && \
    git clone https://github.com/disheng222/sz /src/sz && \
    git clone https://github.com/CODARcode/MGARD /src/mgard && \
    git clone https://github.com/llnl/fpzip /src/fpzip && \
    cd /src/sz && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -G Ninja && \
    cmake --build . && \
    ninja install && \
    \
    cd /src/zfp && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTING=OFF -G Ninja && \
    cmake --build . && \
    ninja install && \
    \
    cd /src/mgard && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=lib64 -DBUILD_TESTING=OFF -G Ninja && \
    cmake --build . && \
    ninja install && \
    \
    cd /src/fpzip && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTING=OFF -G Ninja && \
    cmake --build . && \
    ninja install
COPY . /src/libpressio
RUN cd /src/libpressio && \
    rm -rf build && \
    mkdir build && \
    cd build && \
    cmake .. -DCMAKE_INSTALL_PREFIX=/usr -DBUILD_TESTING=ON \
      -DLIBPRESSIO_HAS_SZ=ON \
      -DLIBPRESSIO_HAS_ZFP=ON \
      -DLIBPRESSIO_HAS_MGARD=ON \
      -DLIBPRESSIO_HAS_MGARD=ON \
      -DLIBPRESSIO_HAS_BLOSC=ON \
      -DLIBPRESSIO_HAS_MAGICK=ON \
      -DLIBPRESSIO_HAS_HDF=ON \
      -DBUILD_PYTHON_WRAPPER=ON -G Ninja && \
    cmake --build . && \
    ninja install && \
    CTEST_OUTPUT_ON_FAILURE=1 ctest .

FROM fedora:32
RUN echo "fastestmirror=True">>/etc/dnf/dnf.conf && \
    dnf install -y zlib hdf5 libzstd fftw python3-numpy ImageMagick-c++ blosc \
    && \
    dnf clean all
COPY --from=builder /usr/lib64/libSZ.so* \
                    /usr/lib64/liblibpressio.so* \
                    /usr/lib64/libzfp.so*  \
                    /usr/lib64/libmgard.so* \
                    /usr/lib64/libfpzip.so* \
                    /usr/lib64/
COPY --from=builder /usr/include/libpressio \
                    /usr/include/sz \
                    /usr/include/zfp* \
                    /usr/include/mgard* \
                    /usr/include/fpzip* \
                    /usr/include/
COPY --from=builder /usr/bin/sz /usr/bin/
COPY --from=builder /usr/lib/python3.8/site-packages/*pressio* /usr/lib64/python3.7/site-packages/