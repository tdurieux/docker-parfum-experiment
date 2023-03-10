FROM golang:1.14

WORKDIR /

COPY . .

ADD https://github.com/upx/upx/releases/download/v3.95/upx-3.95-amd64_linux.tar.xz /usr/local

RUN set -x && \
    apt update && \
    apt install --no-install-recommends -y xz-utils && \
    xz -d -c /usr/local/upx-3.95-amd64_linux.tar.xz | \
    tar -xOf - upx-3.95-amd64_linux/upx > /bin/upx && \
    chmod a+x /bin/upx && \
    go get -d -v . && \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -installsuffix cgo -o app . && \
    strip --strip-unneeded app && \
    upx app && rm -rf /var/lib/apt/lists/*;

FROM scratch

LABEL maintainer="stephane.beuret@gmail.com"

COPY --from=0 app /

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/

ENTRYPOINT ["/app"]
