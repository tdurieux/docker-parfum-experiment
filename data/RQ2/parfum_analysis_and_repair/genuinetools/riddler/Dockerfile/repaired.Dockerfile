FROM golang:alpine as builder
MAINTAINER Jessica Frazelle <jess@linux.com>

ENV PATH /go/bin:/usr/local/go/bin:$PATH
ENV GOPATH /go

RUN	apk add --no-cache \
	bash \
	ca-certificates

COPY . /go/src/github.com/genuinetools/riddler

RUN set -x \
	&& apk add --no-cache --virtual .build-deps \
		git \
		gcc \
		libc-dev \
		libgcc \
		linux-headers \
		make \
	&& cd /go/src/github.com/genuinetools/riddler \
	&& make static \
	&& mv riddler /usr/bin/riddler \
	&& apk del .build-deps \
	&& rm -rf /go \
	&& echo "Build complete."

FROM alpine:latest

COPY --from=builder /usr/bin/riddler /usr/bin/riddler
COPY --from=builder /etc/ssl/certs/ /etc/ssl/certs

ENTRYPOINT [ "riddler" ]
CMD [ "--help" ]