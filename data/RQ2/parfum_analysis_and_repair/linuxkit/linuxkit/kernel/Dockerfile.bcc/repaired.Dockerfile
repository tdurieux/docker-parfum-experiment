ARG IMAGE
ARG BUILD_IMAGE

FROM ${IMAGE} as ksrc

FROM ${BUILD_IMAGE} AS build
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
  elfutils-dev \
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
  python3 \
  zlib-dev \
  && true

RUN ln -s /usr/lib/cmake/llvm10/ /usr/lib/cmake/llvm && \
    ln -s /usr/include/llvm10/llvm-c/ /usr/include/llvm-c && \
    ln -s /usr/include/llvm10/llvm/ /usr/include/llvm

WORKDIR /build

ENV BCC_COMMIT=14278bf1a52dd76ff66eed02cc9db7c7ec240da6
RUN git clone https://github.com/iovisor/bcc.git && \
    cd bcc && \
    git checkout $BCC_COMMIT && \
    sed -i 's/<error.h>/<errno.h>/' examples/cpp/KModRetExample.cc

COPY --from=ksrc /kernel-headers.tar /build
COPY --from=ksrc /kernel-dev.tar /build
COPY --from=ksrc /kernel.tar /build
RUN tar xf /build/kernel-headers.tar && \
    tar xf /build/kernel-dev.tar && \
    tar xf /build/kernel.tar && rm /build/kernel-headers.tar

RUN mkdir -p bcc/build && cd bcc/build && \
    cmake .. -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON \
             -DCMAKE_C_FLAGS="-I/build/usr/include" \
             -DPYTHON_CMD=python3 \
             -DCMAKE_CXX_FLAGS="-I/build/usr/include" \
             -DCMAKE_INSTALL_PREFIX=/usr && \
    make && \
    make install

RUN mkdir -p /out/usr/ && \
    cp -a /build/usr/src /out/usr/ && \
    cp -a /build/usr/include /out/usr
RUN mkdir -p /out/usr/lib && \
    cp -a /usr/lib/libelf* /out/usr/lib/ && \
    cp -a /usr/lib/libstdc* /out/usr/lib/ && \
    cp -a /usr/lib/libintl* /out/usr/lib/ && \
    cp -a /usr/lib64/* /out/usr/lib/
RUN mkdir -p /out/usr/lib/python3.8 && \
    cp -a /usr/lib/python3.8/site-packages /out/usr/lib/python3.8/
RUN mkdir -p /out/usr/share && \
    cp -a /usr/share/bcc /out/usr/share/
RUN mkdir -p /out/usr/bin && \
    cp -a /usr/bin/bcc-lua /out/usr/bin/

FROM ${BUILD_IMAGE} as mirror
RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk update && apk upgrade -a && \
  apk add --no-cache --initdb -p /out \
  busybox \
  luajit \
  python3 \
  zlib \
  && true

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:/usr/lib64
COPY --from=mirror /out /
COPY --from=build /out /
