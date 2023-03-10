ARG BASE_IMAGE=scratch

FROM golang:1.17.6-alpine3.14 as builder

RUN mkdir -p /build

COPY . /build

WORKDIR /build

RUN CGO_ENABLED=0 go build -o tunnel-server ./cmd/server/main.go

FROM $BASE_IMAGE

COPY --from=builder /build/tunnel-server /tunnel-server

ENTRYPOINT [ "/tunnel-server" ]

EXPOSE 80 10080