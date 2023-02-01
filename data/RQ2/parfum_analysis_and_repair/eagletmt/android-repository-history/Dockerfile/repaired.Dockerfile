FROM golang:1.10-stretch as builder

RUN mkdir -p /build
COPY update.go /build/
WORKDIR /build
RUN go build update.go

FROM debian:stretch-slim
RUN apt update && apt install --no-install-recommends -y ca-certificates git && rm -rf /var/lib/apt/lists/*;
COPY --from=builder /build/update /root/
COPY auto.sh /root/
CMD ["/root/auto.sh"]
