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

COPY ./polaris_console_package/polaris-console /root/polaris-console
COPY ./polaris_console_package/tool /root/tool
COPY ./polaris_console_package/web /root/web
COPY ./polaris_console_package/polaris-console.yaml /root/polaris-console.yaml

EXPOSE 8080

WORKDIR /root

CMD ["/root/polaris-console"]
