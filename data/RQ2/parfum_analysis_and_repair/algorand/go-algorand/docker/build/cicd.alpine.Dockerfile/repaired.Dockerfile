ARG GOLANG_VERSION
FROM arm32v6/golang:${GOLANG_VERSION}-alpine
RUN apk update && \
    apk add --no-cache make && \
    apk add --no-cache bash && \
    apk add --no-cache git && \
    apk add --no-cache python3 && \
    apk add --no-cache boost-dev && \
    apk add --no-cache expect && \
    apk add --no-cache jq && \
    apk add --no-cache autoconf && \
    apk add --no-cache --update alpine-sdk && \
    apk add --no-cache libtool && \
    apk add --no-cache automake && \
    apk add --no-cache fmt && \
    apk add --no-cache build-base && \
    apk add --no-cache musl-dev && \
    apk add --no-cache sqlite

RUN apk add --no-cache dpkg && \
    wget https://deb.debian.org/debian/pool/main/s/shellcheck/shellcheck_0.5.0-3_armhf.deb && \
    dpkg-deb -R shellcheck_0.5.0-3_armhf.deb shellcheck && \
    cd shellcheck && \
    mv usr/bin/shellcheck /usr/bin/
COPY . $GOPATH/src/github.com/algorand/go-algorand
WORKDIR $GOPATH/src/github.com/algorand/go-algorand
ENV GCC_CONFIG="--with-arch=armv6" \
    GOPROXY=https://proxy.golang.org,https://pkg.go.dev,https://goproxy.io,direct
RUN make clean
RUN rm -rf $GOPATH/src/github.com/algorand/go-algorand && \
    mkdir -p $GOPATH/src/github.com/algorand/go-algorand
CMD ["/bin/bash"]
