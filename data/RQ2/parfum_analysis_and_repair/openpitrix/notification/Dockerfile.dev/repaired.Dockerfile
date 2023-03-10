FROM alpine:3.7
RUN apk add --no-cache --update ca-certificates && update-ca-certificates

# modify pod (container) timezone
RUN apk add --no-cache -U tzdata && ls /usr/share/zoneinfo && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && apk del tzdata

COPY ./* /usr/local/bin/

CMD ["sh"]
