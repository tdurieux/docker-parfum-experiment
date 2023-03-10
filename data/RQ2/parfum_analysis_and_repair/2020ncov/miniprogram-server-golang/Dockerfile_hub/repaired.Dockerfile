FROM alpine:3.7

ENV MYSQL_DSN=""
ENV GIN_MODE="release"
ENV PORT=8080

RUN apk update && \
    apk add --no-cache ca-certificates && \
    echo "hosts:files dns" > /etc/nsswitch.conf && \
    mkdir -p /www/conf

WORKDIR /www

ADD ./Miniprogram-server-Golang /usr/bin/ncov_golang
ADD ./conf /www/conf

RUN chmod +x /usr/bin/ncov_golang

ENTRYPOINT ["ncov_golang"]