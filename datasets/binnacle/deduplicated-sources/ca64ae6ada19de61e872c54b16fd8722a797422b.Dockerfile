FROM golang:1.12.0-alpine3.9 AS builder

ENV GO111MODULE on
ENV GOPROXY https://athens.azurefd.net

COPY . /go/src/github.com/finb/bark-server

WORKDIR /go/src/github.com/finb/bark-server

RUN go install -ldflags "-w -s"

FROM alpine:3.9

LABEL maintainer="mritd <mritd1234@gmail.com>"

RUN apk upgrade --no-cache \
    && apk add ca-certificates

COPY --from=builder /go/bin/bark-server /usr/bin/bark-server

VOLUME /data

EXPOSE 8080

CMD ["bark-server"]
