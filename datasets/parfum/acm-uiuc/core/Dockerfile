FROM golang:1.14.0 AS builder
WORKDIR /opt/acm/core
COPY . .
RUN go build -o bin/core github.com/acm-uiuc/core

FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y ca-certificates
WORKDIR /opt/acm/core
COPY --from=builder /opt/acm/core/bin/core .
COPY --from=builder /opt/acm/core/static/ static/
COPY --from=builder /opt/acm/core/template/ template/
CMD ["./core", "-server"]

