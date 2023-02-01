FROM golang:1.13 AS builder

ENV CGO_ENABLED 0
ENV GOOS linux

RUN apt-get update && apt-get install --no-install-recommends -y apt-utils upx && rm -rf /var/lib/apt/lists/*;

WORKDIR $GOPATH/src/zero
COPY . .
RUN go build -ldflags="-s -w" -o /app/graceful example/graceful/dns/api/graceful.go
RUN upx /app/graceful


FROM alpine

RUN apk update --no-cache
RUN apk add --no-cache ca-certificates
RUN apk add --no-cache tzdata
ENV TZ Asia/Shanghai

WORKDIR /app
COPY --from=builder /app/graceful /app/graceful
COPY example/graceful/dns/api/etc/graceful-api.json /app/etc/config.json

CMD ["./graceful", "-f", "etc/config.json"]
