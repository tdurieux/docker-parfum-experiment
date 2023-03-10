FROM golang:1.13-alpine AS builder

LABEL stage=gobuilder

ENV CGO_ENABLED 0
ENV GOOS linux
ENV GOPROXY https://goproxy.cn,direct

WORKDIR $GOPATH/src/zero
COPY . .
RUN go build -ldflags="-s -w" -o /app/sub example/etcd/sub/sub.go


FROM alpine

RUN apk add --no-cache tzdata
ENV TZ Asia/Shanghai

WORKDIR /app
COPY --from=builder /app/sub /app/sub

CMD ["./sub"]