FROM i386/golang:alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk update && \
    apk add --no-cache bash git openssh ca-certificates tzdata && \
    rm -rf /var/cache/apk/*

ENV CGO_ENABLED=0 \
    GOPROXY="https://goproxy.cn"

WORKDIR /usr/src/myapp

CMD ["bash"]