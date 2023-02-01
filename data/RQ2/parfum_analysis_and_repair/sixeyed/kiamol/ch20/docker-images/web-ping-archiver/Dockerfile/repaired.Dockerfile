FROM alpine:3.12

RUN apk add --no-cache \
    curl

ENV WEB_PING_URL="http://web-ping-api:8080/archive"

CMD [ curl -f -s $WEB_PING_URL]