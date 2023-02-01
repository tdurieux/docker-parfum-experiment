ARG GO_VERSION=1.11.2

FROM golang:${GO_VERSION} AS builder

RUN apt-get update && apt-get install --yes libcap2-bin

WORKDIR /src

COPY ./ ./
RUN go build -mod=vendor -o /udig ./cmd/udigd

RUN setcap 'cap_net_bind_service+eip' /udig

# distroless with busybox
FROM gcr.io/distroless/base@sha256:9ec63deea5466b74effdf17186589a647fb1757856c15ae6eae7d878affa675d

COPY --from=builder /udig /udig

COPY --from=builder /sbin/getcap /sbin
COPY --from=builder /sbin/setcap /sbin
COPY --from=builder /lib/x86_64-linux-gnu/libcap.so.2 /lib

RUN ["/sbin/setcap", "cap_net_bind_service=+ep", "/udig"]

EXPOSE 8053/udp

USER 1000:1000

ENTRYPOINT ["/udig"]
