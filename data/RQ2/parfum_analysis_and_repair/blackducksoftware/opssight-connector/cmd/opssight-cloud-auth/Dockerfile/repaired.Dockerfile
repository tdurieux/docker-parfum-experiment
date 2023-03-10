FROM alpine:3.4

RUN apk add --no-cache --update ca-certificates && rm -rf /var/cache/apk/*

COPY opssight-cloud-auth .

CMD .opssight-cloud-auth
