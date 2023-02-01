FROM golang:1.12.1-alpine3.9 as builder

# 更新安装源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

WORKDIR /go/src/app

RUN apk add --no-cache git && apk add --no-cache make && apk add --no-cache gcc && apk add --no-cache libc-dev \
  && apk add --no-cache --update gcc musl-dev

ENV GOPROXY=https://goproxy.io
ADD . .

RUN make



FROM alpine:latest

COPY --from=builder /go/src/app/bin/wallet-keeper /

EXPOSE 8000
WORKDIR /

CMD ["/wallet-keeper", "run"]
