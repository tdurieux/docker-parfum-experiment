FROM golang:1.14.1-alpine3.11@sha256:244a736db4a1d2611d257e7403c729663ce2eb08d4628868f9d9ef2735496659 as builder

WORKDIR /workdir
COPY . /workdir

RUN set -x && \
	apk --no-cache add git gcc libc-dev make

RUN git clone https://github.com/cloudflare/cfssl_trust.git /etc/cfssl && \
    make clean && \
    make bin/rice && ./bin/rice embed-go -i=./cli/serve && \
    make all

FROM alpine:3.11
COPY --from=builder /etc/cfssl /etc/cfssl
COPY --from=builder /workdir/bin/ /usr/bin

EXPOSE 8888

ENTRYPOINT ["cfssl"]
CMD ["--help"]