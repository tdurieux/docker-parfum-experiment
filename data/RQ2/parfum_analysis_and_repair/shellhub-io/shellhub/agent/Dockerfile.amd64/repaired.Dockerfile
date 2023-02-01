FROM golang:1.18.2-alpine3.14

ARG SHELLHUB_VERSION=latest

RUN apk add --no-cache --update git ca-certificates util-linux build-base bash setpriv perl xz

# We are using libxcrypt to support yescrypt password hashing method
# Since libxcrypt package is not available in Alpine, so we need to build libxcrypt from source code
RUN wget -q https://github.com/besser82/libxcrypt/releases/download/v4.4.27/libxcrypt-4.4.27.tar.xz && \
    tar xvf libxcrypt-4.4.27.tar.xz && cd libxcrypt-4.4.27 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --prefix /usr && make -j$(nproc) && make install && \
    cd .. && rm -rf libxcrypt-4.4.27* && rm libxcrypt-4.4.27.tar.xz

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub

COPY ./go.mod ./

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub/agent

COPY ./agent/go.mod ./agent/go.sum ./

RUN go mod download

COPY ./pkg $GOPATH/src/github.com/shellhub-io/shellhub/pkg
COPY ./agent .

RUN go mod download

WORKDIR $GOPATH/src/github.com/shellhub-io/shellhub/agent

RUN GOOS=linux GOARCH=amd64 go build -tags docker -ldflags "-X main.AgentVersion=${SHELLHUB_VERSION}"

FROM scratch

COPY --from=0 /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=0 /usr/bin/nsenter /usr/bin/
COPY --from=0 /usr/bin/setpriv /usr/bin/
COPY --from=0 /usr/lib/libcap-ng.so.* /usr/lib/
COPY --from=0 /lib/ld-musl-x86_64.so.1 /lib/
COPY --from=0 /usr/lib/libcrypt.so* /usr/lib/
COPY --from=0 /go/src/github.com/shellhub-io/shellhub/agent/agent /bin/agent

ENTRYPOINT ["/bin/agent"]
