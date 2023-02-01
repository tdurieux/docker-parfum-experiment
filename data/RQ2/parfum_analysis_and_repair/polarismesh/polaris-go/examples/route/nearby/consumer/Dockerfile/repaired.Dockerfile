FROM alpine:3.13.6

RUN sed -i 's!http://dl-cdn.alpinelinux.org/!https://mirrors.tencent.com/!g' /etc/apk/repositories

RUN set -eux && \
    apk add --no-cache tcpdump && \
    apk add --no-cache tzdata && \
    apk add --no-cache busybox-extras && \
    apk add --no-cache curl && \
    apk add --no-cache bash && \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    echo "Asia/Shanghai" > /etc/timezone && \
    date

COPY consumer /root/consumer

WORKDIR /root

CMD ["/root/consumer"]