FROM golang:alpine AS builder
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories && apk update && apk --no-cache add build-base
WORKDIR /go/src/github.com/linsongze/liveRedirect/
COPY . .
RUN GOPROXY="https://goproxy.io" GO111MODULE=on go build -o lr .

FROM alpine:latest
RUN apk --no-cache add libc6-compat libgcc libstdc++
WORKDIR /root
COPY --from=builder /go/src/github.com/linsongze/liveRedirect/lr .
EXPOSE 5000
VOLUME ["/root/data"]
CMD ["./lr"]