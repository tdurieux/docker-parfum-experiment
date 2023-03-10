FROM alpine:3.12

WORKDIR /opt
ARG VERSION=v0.5.3
ARG TZ="Asia/Shanghai"

COPY gonelist /bin/gonelist

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add curl wget tzdata bind-tools busybox-extras ca-certificates bash strace && \
    ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo ${TZ} > /etc/timezone && \
    cd /opt && curl -f -sL https://github.com/gonelist/gonelist-web/releases/download/${VERSION}/dist.tar.gz | tar -zxvf - && \
    rm -rf /var/cache/apk/*

EXPOSE 8000

ENTRYPOINT ["/bin/gonelist"]