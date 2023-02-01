FROM alpine AS build
RUN apk update && apk add --no-cache \
    musl-dev \
    autoconf \
    automake \
    make \
    gcc \
    tini
COPY . /build
WORKDIR /build
RUN autoreconf -fi && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make
RUN make DESTDIR=/opt install

FROM alpine
COPY --from=build /opt /
COPY --from=build /sbin/tini /sbin/tini
ENTRYPOINT ["/sbin/tini", "/usr/local/bin/ptunnel-ng"]