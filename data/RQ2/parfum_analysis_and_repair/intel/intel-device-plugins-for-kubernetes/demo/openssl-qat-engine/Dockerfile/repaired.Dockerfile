FROM ubuntu:20.04 as builder

ARG QATLIB_VERSION="21.11.0"
ARG QAT_ENGINE_VERSION="v0.6.12"
ARG ASYNC_NGINX_VERSION="v0.4.7"
ARG IPSEC_MB_VERSION="v1.2"
ARG IPP_CRYPTO_VERSION="ippcp_2021.5"

RUN apt update && \
    env DEBIAN_FRONTEND=noninteractive apt install -y \
    libudev-dev \
    make \
    gcc \
    g++ \
    nasm \
    pkg-config \
    libssl-dev \
    zlib1g-dev \
    wget \
    git \
    yasm \
    autoconf \
    cmake \
    libtool && \
    git clone --depth 1 -b $ASYNC_NGINX_VERSION https://github.com/intel/asynch_mode_nginx.git && \
    git clone --depth 1 -b $QAT_ENGINE_VERSION https://github.com/intel/QAT_Engine && \
    git clone --depth 1 -b $IPP_CRYPTO_VERSION https://github.com/intel/ipp-crypto && \
    git clone --depth 1 -b $IPSEC_MB_VERSION https://github.com/intel/intel-ipsec-mb && \
    git clone --depth 1 -b $QATLIB_VERSION https://github.com/intel/qatlib

RUN cd /qatlib && \
    sed -i -e '79,87d' configure.ac && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr && \
    make -j && \
    make install samples-install

RUN cd /ipp-crypto/sources/ippcp/crypto_mb && \
    cmake . -B"../build" \
    -DOPENSSL_INCLUDE_DIR=/usr/include/openssl \
    -DOPENSSL_LIBRARIES=/usr/lib64 \
    -DOPENSSL_ROOT_DIR=/usr/bin/openssl && \
    cd ../build && \
    make crypto_mb && make install

RUN cd /intel-ipsec-mb && \
    make && make install LIB_INSTALL_DIR=/usr/lib64

RUN cd /QAT_Engine && \
    sed -i -e '258,258 {s/ -a.*//}' configure.ac && \
    ./autogen.sh && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --enable-qat_sw \
    --with-qat_sw_install_dir=/usr/local && \
    make && make install

RUN cd /asynch_mode_nginx && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
    --prefix=/var/www \
    --conf-path=/usr/share/nginx/conf/nginx.conf \
    --sbin-path=/usr/bin/nginx \
    --pid-path=/run/nginx.pid \
    --lock-path=/run/lock/nginx.lock \
    --modules-path=/usr/lib64/nginx \
    --without-http_rewrite_module \
    --with-http_ssl_module \
    --add-dynamic-module=modules/nginx_qat_module/ \
    --with-cc-opt="-DNGX_SECURE_MEM -I/include -Wno-error=deprecated-declarations" \
    --with-ld-opt="-L/src" && \
    make && make install

FROM ubuntu:20.04

COPY --from=builder /usr/bin/*_sample* /usr/bin/
COPY --from=builder /usr/lib/libqat.so.2.0.0 /usr/lib/
COPY --from=builder /usr/lib/libusdm.so.0.0.1 /usr/lib/
COPY --from=builder /usr/lib64/libIPSec_MB.so.1 /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/local/lib/libcrypto_mb.so.11.3 /usr/lib/x86_64-linux-gnu/
COPY --from=builder /usr/lib/x86_64-linux-gnu/engines-1.1/qatengine.so /usr/lib/x86_64-linux-gnu/engines-1.1/qatengine.so
COPY --from=builder /var/www/ /var/www/
COPY --from=builder /usr/lib64/nginx/* /usr/lib64/nginx/
COPY --from=builder /usr/bin/nginx /usr/bin
COPY --from=builder /usr/share/nginx/conf/* /usr/share/nginx/conf/
COPY --from=builder /qatlib/LICENSE /usr/share/package-licenses/qatlib/LICENSE
COPY --from=builder /QAT_Engine/LICENSE /usr/share/package-licenses/QAT_Engine/LICENSE
COPY --from=builder /ipp-crypto/LICENSE /usr/share/package-licenses/ipp-crypto/LICENSE
COPY --from=builder /asynch_mode_nginx/LICENSE /usr/share/package-licenses/asynch_mode_nginx/LICENSE
COPY --from=builder /intel-ipsec-mb/LICENSE /usr/share/package-licenses/intel-ipsec-mb/LICENSE
RUN ldconfig && apt update && env DEBIAN_FRONTEND=noninteractive apt install -y openssl haproxy
