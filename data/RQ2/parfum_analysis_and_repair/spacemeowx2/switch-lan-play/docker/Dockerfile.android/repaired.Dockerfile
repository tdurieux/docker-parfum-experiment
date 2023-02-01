FROM lakoo/android-ndk

RUN apt update && apt install --no-install-recommends -y automake libtool make cmake flex bison && rm -rf /var/lib/apt/lists/*;

# or 'arm64'
ARG ARCH=arm
ARG ANDROID_API=21
# or 'aarch64-linux-android'
ARG COMPILER_PREFIX=arm-linux-androideabi

ENV INSTALL_PREFIX=/opt/android-toolchain
ENV TOOLCHAIN=${INSTALL_PREFIX}-${ARCH}
ENV PATH="${TOOLCHAIN}/bin:${PATH}"

RUN $ANDROID_NDK/build/tools/make_standalone_toolchain.py \
        --arch ${ARCH} \
        --api ${ANDROID_API} \
        --install-dir ${TOOLCHAIN}

ENV HOST=${COMPILER_PREFIX}
ENV SYSROOT=/opt/android-ndk-linux/sysroot
ENV PREFIX=${SYSROOT}/usr/local

RUN curl -f -L -o /tmp/libev-v1.24.1.tar.gz https://github.com/libuv/libuv/archive/v1.24.1.tar.gz \
    && curl -f -L -o /tmp/libpcap-1.9.0.tar.gz https://github.com/the-tcpdump-group/libpcap/archive/libpcap-1.9.0.tar.gz

RUN tar xvf /tmp/libev-v1.24.1.tar.gz -C /tmp \
    && tar xvf /tmp/libpcap-1.9.0.tar.gz -C /tmp && rm /tmp/libev-v1.24.1.tar.gz

RUN cd /tmp/libuv-1.24.1 \
    && ./autogen.sh \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
         --host=$HOST \
         --prefix=$PREFIX \
         --disable-shared \
         --enable-static \
    && make -j$(nproc) \
    && make install

RUN cd /tmp/libpcap-libpcap-1.9.0 \
    && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
         --host=$HOST \
         --prefix=$PREFIX \
         --disable-shared \
    && make -j$(nproc) \
    && make install
