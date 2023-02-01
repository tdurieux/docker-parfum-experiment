# BUILD redisfab/redistimeseries-${OSNICK}:M.m.b-${ARCH}

# xenial|bionic|bullseye|centos7|centos8
ARG OSNICK=bullseye

# ARCH=arm64v8|arm32v7
ARG ARCH=arm64v8

#----------------------------------------------------------------------------------------------
FROM redisfab/redis-${ARCH}-${OSNICK}-xbuild:6.2.5 as builder

RUN [ "cross-build-start" ]

ADD ./ /build
WORKDIR /build

RUN ./deps/readies/bin/getpy3
RUN ./system-setup.py
RUN make fetch

ENV X_NPROC "cat /proc/cpuinfo|grep processor|wc -l"
RUN echo nproc=$(nproc); echo NPROC=$(eval "$X_NPROC")
RUN make build

RUN [ "cross-build-end" ]

#----------------------------------------------------------------------------------------------