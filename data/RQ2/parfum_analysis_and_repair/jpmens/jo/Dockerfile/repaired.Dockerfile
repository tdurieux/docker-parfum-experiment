FROM alpine AS builder
RUN apk -U --no-cache add automake autoconf build-base make pkgconf
COPY . /src
WORKDIR /src
RUN autoreconf -i && ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && make check && make install

FROM alpine
COPY --from=builder /usr/local/bin/jo /bin/jo
ENTRYPOINT ["/bin/jo"]
