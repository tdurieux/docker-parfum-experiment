FROM golang:1.16-alpine3.14

# trust, but verify
RUN [ -z "$(ls -A1 /go/bin || :)" ]

# disable CGO for ALL THE THINGS (to help ensure no libc)
ENV CGO_ENABLED 0

ENV GOFLAGS="-v -a -tags=netgo -installsuffix=netgo"
# https://golang.org/issue/26849
ENV BUILD_FLAGS="-ldflags '-d -s -w' ./cmd/rawdns"

WORKDIR /usr/local/src/rawdns

COPY go.mod go.sum ./
RUN set -eux; \
	go mod download; \
	go mod verify

COPY . .

# rawdns-$(dpkg --print-architecture)
RUN set -eux; \
	eval "GOARCH=386 go build -o /go/bin/rawdns-i386 $BUILD_FLAGS"
RUN set -eux; \
	eval "GOARCH=amd64 go build -o /go/bin/rawdns-amd64 $BUILD_FLAGS"
RUN set -eux; \
	eval "GOARCH=arm GOARM=5 go build -o /go/bin/rawdns-armel $BUILD_FLAGS"
RUN set -eux; \
	eval "GOARCH=arm GOARM=6 go build -o /go/bin/rawdns-armhf $BUILD_FLAGS"
# boo Raspberry Pi, making life hard
#RUN set -eux; \
#	eval "GOARCH=arm GOARM=7 go build -o /go/bin/rawdns-armhf $BUILD_FLAGS"
RUN set -eux; \
	eval "GOARCH=arm64 go build -o /go/bin/rawdns-arm64 $BUILD_FLAGS"
RUN set -eux; \
	eval "GOARCH=mips64le go build -o /go/bin/rawdns-mips64el $BUILD_FLAGS"
RUN set -eux; \
	eval "GOARCH=ppc64le go build -o /go/bin/rawdns-ppc64el $BUILD_FLAGS"
RUN set -eux; \
	eval "GOARCH=riscv64 go build -o /go/bin/rawdns-riscv64 $BUILD_FLAGS"
RUN set -eux; \
	eval "GOARCH=s390x go build -o /go/bin/rawdns-s390x $BUILD_FLAGS"

RUN set -eux; \
	apk add --no-cache file; \
	file /go/bin/rawdns-*