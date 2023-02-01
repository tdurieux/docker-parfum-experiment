FROM alpine:latest

RUN apk update && apk add --no-cache collectd

CMD [ "collectd", "-f" ]
