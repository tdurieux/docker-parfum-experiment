FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache varnish

EXPOSE 8080

COPY default.vcl /etc/varnish
ADD varnish.sh /varnish.sh

CMD ["/varnish.sh"]
