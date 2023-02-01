# Production dockerfile

# Build image
FROM alpine:3.7 as builder
RUN apk update
RUN apk add --no-cache automake autoconf g++ make libtool cmake
RUN apk add --no-cache json-c-dev
RUN addgroup -S src ; adduser -S build -D -G src
COPY --chown=build:src . /usr/src/twamp-client-c/
WORKDIR /usr/src/twamp-client-c/twamp-src
USER build:src
RUN ./autogen.sh && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make
USER root
RUN make install

# Exec image
FROM alpine:3.7
RUN apk update --no-cache ; apk add --no-cache json-c
COPY --from=builder /usr/local/bin/* /opt/simet/
WORKDIR /opt/simet
ENTRYPOINT ["/opt/simet/twampc"]
CMD ["-h localhost"]

