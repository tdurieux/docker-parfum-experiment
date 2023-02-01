FROM golang:1.12-alpine3.9

# trust, but verify
RUN [ -z "$(ls -A1 /go/bin || :)" ]

# disable CGO for ALL THE THINGS (to help ensure no libc)
ENV CGO_ENABLED 0

ENV GOFLAGS="-v -a -tags=netgo -installsuffix=netgo -mod=vendor"
# https://go-review.googlesource.com/c/go/+/126656#message-7c4d6ca064ec7fa35ce68e057bbb29a62186b714
ENV BUILD_FLAGS="-ldflags '-d -s -w'"

COPY . /usr/local/src/rawdns
WORKDIR /usr/local/src/rawdns/cmd/rawdns

# rawdns-$(dpkg --print-architecture)
RUN set -x \
	&& eval "GOARCH=386 go build $BUILD_FLAGS -o /go/bin/rawdns-i386"
RUN set -x \
	&& eval "GOARCH=amd64 go build $BUILD_FLAGS -o /go/bin/rawdns-amd64"
RUN set -x \
	&& eval "GOARCH=arm GOARM=5 go build $BUILD_FLAGS -o /go/bin/rawdns-armel"
RUN set -x \
	&& eval "GOARCH=arm GOARM=6 go build $BUILD_FLAGS -o /go/bin/rawdns-armhf"
# boo Raspberry Pi, making life hard
#RUN set -x \
#	&& eval "GOARCH=arm GOARM=7 go build $BUILD_FLAGS -o /go/bin/rawdns-armhf"
RUN set -x \
	&& eval "GOARCH=arm64 go build $BUILD_FLAGS -o /go/bin/rawdns-arm64"
RUN set -x \
	&& eval "GOARCH=ppc64 go build $BUILD_FLAGS -o /go/bin/rawdns-ppc64"
RUN set -x \
	&& eval "GOARCH=ppc64le go build $BUILD_FLAGS -o /go/bin/rawdns-ppc64el"
RUN set -x \
	&& eval "GOARCH=s390x go build $BUILD_FLAGS -o /go/bin/rawdns-s390x"

RUN set -x \
	&& apk add --no-cache file \
	&& file /go/bin/rawdns-*
