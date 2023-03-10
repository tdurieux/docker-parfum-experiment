ARG IMAGE
FROM ${IMAGE} as ksrc

FROM linuxkit/alpine:e2391e0b164c57db9f6c4ae110ee84f766edc430 AS build
RUN apk update && apk upgrade -a && \
  apk add --no-cache \
  argp-standalone \
  autoconf \
  automake \
  bison \
  build-base \
  clang \
  clang-dev \
  clang-static \
  cmake \
  curl \
  flex-dev \
  fts-dev \
  gettext-dev \
  git \
  iperf3 \
  libedit-dev \
  libtool \
  llvm \
  llvm-dev \
  llvm-static \
  luajit-dev \
  m4 \
  python \
  zlib-dev \
  && true

RUN ln -s /usr/lib/cmake/llvm5/ /usr/lib/cmake/llvm && \
    ln -s /usr/include/llvm5/llvm-c/ /usr/include/llvm-c && \
    ln -s /usr/include/llvm5/llvm/ /usr/include/llvm

WORKDIR /build

COPY ./bcc.patches/ ./
RUN mv error.h /usr/include/ && \
    mv cdefs.h /usr/include/sys/

ENV ELFUTILS_VERSION=0.165
ENV ELFUTILS_SHA256="a7fc9277192caaa5f30b47e8c0518dbcfd8c4a19c6493a63d511d804290ce972"
RUN curl -f -sSL -O https://fedorahosted.org/releases/e/l/elfutils/0.165/elfutils-$ELFUTILS_VERSION.tar.bz2 && \
    echo "${ELFUTILS_SHA256}  /build/elfutils-$ELFUTILS_VERSION.tar.bz2" | sha256sum -c - && \
    tar xjf elfutils-$ELFUTILS_VERSION.tar.bz2 && \
    cd elfutils-$ELFUTILS_VERSION && \
    patch -p1 < ../100-musl-compat.patch && \
    patch -p0 < ../decl.patch && \
    patch -p0 < ../intl.patch && rm elfutils-$ELFUTILS_VERSION.tar.bz2

ENV BCC_COMMIT=0fa419a64e71984d42f107c210d3d3f0cc82d59a
RUN git clone https://github.com/iovisor/bcc.git && \
    cd bcc && \
    git checkout $BCC_COMMIT

ENV LJSYSCALL_COMMIT=e587f8c55aad3955dddab3a4fa6c1968037b5c6e
RUN git clone https://github.com/justincormack/ljsyscall.git && \
    cd ljsyscall && \
    git checkout $LJSYSCALL_COMMIT

COPY --from=ksrc /kernel-headers.tar /build
COPY --from=ksrc /kernel-dev.tar /build
COPY --from=ksrc /kernel.tar /build
RUN tar xf /build/kernel-headers.tar && \
    tar xf /build/kernel-dev.tar && \
    tar xf /build/kernel.tar && rm /build/kernel-headers.tar

RUN cd elfutils-$ELFUTILS_VERSION && \
    aclocal && \
    automake && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix=/usr CFLAGS="-Wno-strict-aliasing -Wno-error" && \
    make -C libelf && make -C libelf install

RUN mkdir -p bcc/build && cd bcc/build && \
    cmake .. -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
             -DCMAKE_C_FLAGS="-I/build/usr/include" \
             -DCMAKE_CXX_FLAGS="-I/build/usr/include" \
             -DCMAKE_INSTALL_PREFIX=/usr \
             -DLUAJIT_INCLUDE_DIR=/usr/include/luajit-2.1 && \
    make && \
    make install

RUN mkdir -p /usr/local/share/lua/5.1/ && \
    cd ljsyscall && \
    cp -a *.lua syscall /usr/local/share/lua/5.1/
RUN mkdir -p /out/usr/ && \
    cp -a /build/usr/src /out/usr/ && \
    cp -a /build/usr/include /out/usr
RUN mkdir -p /out/usr/lib && \
    cp -a /usr/lib/libelf* /out/usr/lib/ && \
    cp -a /usr/lib/libstdc* /out/usr/lib/ && \
    cp -a /usr/lib/libintl* /out/usr/lib/ && \
    cp -a /usr/lib64/* /out/usr/lib/
RUN mkdir -p /out/usr/lib/python2.7 && \
    cp -a /usr/lib/python2.7/site-packages /out/usr/lib/python2.7/
RUN mkdir -p /out/usr/share && \
    cp -a /usr/share/bcc /out/usr/share/
RUN mkdir -p /out/usr/bin && \
    cp -a /usr/bin/bcc-lua /out/usr/bin/
RUN mkdir -p /out/usr/local/share/ && \
    cp -a /usr/local/share/lua /out/usr/local/share/

FROM linuxkit/alpine:e2391e0b164c57db9f6c4ae110ee84f766edc430 as mirror
RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk update && apk upgrade -a && \
  apk add --no-cache --initdb -p /out \
  busybox \
  luajit \
  python \
  zlib \
  && true

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lib64
COPY --from=mirror /out /
COPY --from=build /out /
