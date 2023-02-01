FROM nginx:1.13.5-alpine

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

RUN apk update && apk upgrade

RUN apk add --no-cache bash curl ipvsadm iproute2 openrc keepalived && \
    rm -f /var/cache/apk/* /tmp/*

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]