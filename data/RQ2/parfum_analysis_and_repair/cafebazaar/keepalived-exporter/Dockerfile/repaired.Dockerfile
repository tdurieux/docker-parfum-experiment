ARG GOVERSION=1.15

FROM golang:${GOVERSION}-alpine as builder

WORKDIR /build

RUN apk add --no-cache make git bash

ADD . .

RUN make build

FROM alpine:3.12

COPY --from=builder /build/keepalived-exporter . 

EXPOSE 9165

ENTRYPOINT [ "./keepalived-exporter" ]