# devicedevex.azurecr.io/public/iot-device-cube:1.0.3-azure-c-sdk-public-preview-cross-toolchain-arm32
FROM devicedevex.azurecr.io/internal/iot-device-cube:1.0.0-ubuntu-cross-toolchain-arm32

ARG lib_openssl_uri=https://www.openssl.org/source/openssl-1.1.1c.tar.gz
ARG lib_openssl_name=openssl-1.1.1c
ARG lib_curl_uri=http://curl.haxx.se/download/curl-7.65.1.tar.gz
ARG lib_curl_name=curl-7.65.1
ARG lib_util_uri=https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.32/util-linux-2.32.1.tar.gz
ARG lib_util_name=util-linux-2.32.1

WORKDIR /work
COPY Toolchain.cmake /work/temp/Toolchain.cmake
COPY arm-linux-custom.cmake /work/temp/arm-linux-custom.cmake

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget ca-certificates xz-utils cmake make git curl unzip tar && \
    wget ${lib_openssl_uri} && \
    tar -xvf ${lib_openssl_name}.tar.gz && \
    cd ${lib_openssl_name} && \
    ./Configure linux-generic32 shared --prefix=${LIBC_PREFIX}/usr --openssldir=${LIBC_PREFIX}/usr && \
    make && \
    make install && \
    cd .. && \
    wget ${lib_curl_uri} && \
    tar -xvf ${lib_curl_name}.tar.gz && \
    cd ${lib_curl_name} && \
    ./configure --with-sysroot=${LIBC_PREFIX} --prefix=${LIBC_PREFIX}/usr --target=${CROSS_TRIPLE} --with-ssl --with-zlib --host=${CROSS_TRIPLE} --build=x86_64-pc-linux-uclibc && \
    make && \
    make install && \
    cd .. && \
    wget ${lib_util_uri} && \
    tar -xvf ${lib_util_name}.tar.gz && \
    cd ${lib_util_name} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=${LIBC_PREFIX}/usr --with-sysroot=${LIBC_PREFIX} --target=${CROSS_TRIPLE} --host=${CROSS_TRIPLE} --disable-all-programs --disable-bash-completion --enable-libuuid && \
    make && \
    make install && \
    cd .. && \
    ls | grep -v temp | xargs rm -rf && \
    git clone https://github.com/microsoft/vcpkg && \
    cd vcpkg && \
    cp /work/temp/Toolchain.cmake /work/vcpkg/scripts/toolchains/Toolchain.cmake && \
    cp /work/temp/arm-linux-custom.cmake /work/vcpkg/triplets/arm-linux-custom.cmake && \
    ln -s /usr/xcc/arm-linux-gnueabihf/arm-linux-gnueabihf/libc/lib/ld-linux-armhf.so.3 /lib/ld-linux-armhf.so.3 && \
    export LD_LIBRARY_PATH="${LIBC_PREFIX}:${LIBC_PREFIX}/lib" && \
    ./bootstrap-vcpkg.sh && \
    ./vcpkg install azure-iot-sdk-c[public-preview,use_prov_client]:arm-linux-custom && \
    apt-get remove -y wget ca-certificates xz-utils git curl unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && rm ${lib_openssl_name}.tar.gz