FROM golang:1.15.15 as builder
WORKDIR /builder-service
ADD . /builder-service
ENV GOPROXY https://goproxy.cn
ENV CGO_ENABLED=0
RUN go mod download
RUN go generate
RUN go build server/main.go


FROM alpine:3.14.2
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories
# 获取 需要的依赖项。
RUN apk add --no-cache openssl openssl-dev nghttp2-dev ca-certificates tzdata

ENV TZ=Asia/Shanghai

COPY --from=builder /builder-service /cdp-service
WORKDIR /cdp-service

EXPOSE 443
ENTRYPOINT ["./main"]