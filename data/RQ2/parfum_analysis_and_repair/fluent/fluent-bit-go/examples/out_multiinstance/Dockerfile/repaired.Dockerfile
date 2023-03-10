FROM golang:1.14 as gobuilder

WORKDIR /root

ENV GOOS=linux\
    GOARCH=amd64

COPY / /root/

RUN go mod edit -replace github.com/fluent/fluent-bit-go=github.com/fluent/fluent-bit-go@master
RUN go mod download & make all

FROM fluent/fluent-bit:1.4

COPY --from=gobuilder /root/out_multiinstance.so /fluent-bit/bin/
COPY --from=gobuilder /root/fluent-bit.conf /fluent-bit/etc/
COPY --from=gobuilder /root/plugins.conf /fluent-bit/etc/

EXPOSE 2020

# CMD ["/fluent-bit/bin/fluent-bit", "--plugin", "/fluent-bit/bin/out_multiinstance.so", "--config", "/fluent-bit/etc/fluent-bit.conf"]
CMD ["/fluent-bit/bin/fluent-bit", "--config", "/fluent-bit/etc/fluent-bit.conf"]