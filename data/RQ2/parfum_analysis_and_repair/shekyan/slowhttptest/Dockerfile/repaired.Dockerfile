FROM alpine:3.9 as builder

RUN apk add --no-cache build-base git openssl-dev autoconf automake
WORKDIR /build
COPY . /build
RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make


FROM alpine:3.9
RUN apk add --no-cache libstdc++
COPY --from=builder /build/src/slowhttptest /usr/local/bin/
ENTRYPOINT ["slowhttptest"]
