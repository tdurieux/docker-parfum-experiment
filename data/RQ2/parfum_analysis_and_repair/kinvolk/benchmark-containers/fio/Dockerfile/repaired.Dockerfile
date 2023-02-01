FROM alpine as builder
WORKDIR /fio
ENV FIO_VER=3.15
ADD https://github.com/axboe/fio/archive/fio-${FIO_VER}.tar.gz .
RUN apk add --no-cache --update alpine-sdk libaio-dev zlib-dev linux-headers coreutils
RUN tar xzf fio-${FIO_VER}.tar.gz && \
    cd fio-fio-${FIO_VER} && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
    make -j && \
    strip fio && \
    mv fio /fio/ && rm fio-${FIO_VER}.tar.gz


FROM alpine
MAINTAINER Kinvolk
# dstat
RUN apk add --update --no-cache py2-six
COPY --from=dstat-builder /dstat/dstat /usr/local/bin
COPY --from=dstat-builder /dstat/plugins /usr/local/bin/
# fio
RUN apk add --update --no-cache util-linux libaio zlib so:libgcc_s.so.1
COPY --from=builder /fio/fio /usr/local/bin
