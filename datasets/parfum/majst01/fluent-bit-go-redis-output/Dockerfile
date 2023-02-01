FROM golang:1.15 AS builder

WORKDIR /go/src/github.com/majst01/fluent-bit-go-redis-output/

COPY .git Makefile go.* *.go /go/src/github.com/majst01/fluent-bit-go-redis-output/
RUN make

FROM fluent/fluent-bit:1.5.5

COPY --from=builder /go/src/github.com/majst01/fluent-bit-go-redis-output/out_redis.so /fluent-bit/bin/
COPY *.conf /fluent-bit/etc/

CMD ["/fluent-bit/bin/fluent-bit", "-c", "/fluent-bit/etc/fluent-bit.conf", "-e", "/fluent-bit/bin/out_redis.so"]
