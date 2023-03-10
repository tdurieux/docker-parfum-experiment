# This Dockerfile extracts the source code and headers from a kernel package,
# builds the perf utility, and places it into a scratch image
ARG IMAGE
FROM ${IMAGE} AS ksrc

FROM linuxkit/alpine:e2391e0b164c57db9f6c4ae110ee84f766edc430 AS build
RUN apk add --no-cache \
    argp-standalone \
    bash \
    bc \
    binutils-dev \
    bison \
    build-base \
    diffutils \
    flex \
    gmp-dev \
    installkernel \
    kmod \
    elfutils-dev \
    findutils \
    mpc1-dev \
    mpfr-dev \
    python3 \
    sed \
    tar \
    xz \
    xz-dev \
    zlib-dev \
    zlib-static

COPY --from=ksrc /linux.tar.xz /kernel-headers.tar /
RUN tar xf linux.tar.xz && \
    tar xf kernel-headers.tar && rm linux.tar.xz

WORKDIR /linux

RUN mkdir -p /out && \
    make -C tools/perf LDFLAGS=-static V=1 && \
    strip tools/perf/perf && \
    cp tools/perf/perf /out

FROM scratch
ENTRYPOINT []
CMD []
WORKDIR /
COPY --from=build /out/perf /usr/bin/perf
