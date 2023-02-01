# devicedevex.azurecr.io/public/iot-device-cube:1.0.2-azure-c-sdk-public-preview-cross-toolchain-arm64
# Usage example:
# docker build -t devicedevex.azurecr.io/public/iot-device-cube:1.0.2-azure-c-sdk-public-preview-cross-toolchain-arm64 . --build-arg base_image_tag=1.0.0-ubuntu-arm64
ARG base_image_tag=1.0.0-ubuntu-arm64
FROM devicedevex.azurecr.io/internal/iot-device-cube:${base_image_tag}

ARG lib_openssl_uri=https://www.openssl.org/source/openssl-1.0.2o.tar.gz
ARG lib_openssl_name=openssl-1.0.2o
ARG lib_curl_uri=http://curl.haxx.se/download/curl-7.60.0.tar.gz
ARG lib_curl_name=curl-7.60.0
ARG lib_util_uri=https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32-rc2.tar.gz
ARG lib_util_name=util-linux-2.32-rc2
ARG c_sdk_branch=public-preview

RUN mkdir /work
WORKDIR /work

# Build openssl, curl, Linux utils and build Azure IoT C SDK
RUN apt-get update && \
    apt-get install -y --no-install-recommends ca-certificates wget perl make cmake git && \
    wget ${lib_openssl_uri} && \
    tar -xvf ${lib_openssl_name}.tar.gz && \
    cd ${lib_openssl_name} && \
    ./Configure linux-generic32 shared --prefix=${QEMU_LD_PREFIX}/usr --openssldir=${QEMU_LD_PREFIX}/usr && \
    make && \
    make install && \
    cd .. && \
    wget ${lib_curl_uri} && \
    tar -xvf ${lib_curl_name}.tar.gz && \
    cd ${lib_curl_name} && \
    ./configure --with-sysroot=${QEMU_LD_PREFIX} --prefix=${QEMU_LD_PREFIX}/usr --target=${CROSS_TRIPLE} --with-ssl --with-zlib --host=${CROSS_TRIPLE} --build=x86_64-pc-linux-uclibc && \
    make && \
    make install && \
    cd .. && \
    wget ${lib_util_uri} && \
    tar -xvf ${lib_util_name}.tar.gz && \
    cd ${lib_util_name} && \
    ./configure --prefix=${QEMU_LD_PREFIX}/usr --with-sysroot=${QEMU_LD_PREFIX} --target=${CROSS_TRIPLE} --host=${CROSS_TRIPLE} --disable-all-programs  --disable-bash-completion --enable-libuuid && \
    make && \
    make install && \
    cd .. && \
    rm -rf /work/* &&\
    git clone --single-branch --branch ${c_sdk_branch} --recursive https://github.com/azure/azure-iot-sdk-c.git && \
    cd azure-iot-sdk-c && \
    mkdir cmake && \
    cd cmake && \
    cmake -DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE} -Duse_prov_client=ON -Dhsm_type_symm_key:BOOL=ON .. && \
    make && \
    apt-get remove -y ca-certificates wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*