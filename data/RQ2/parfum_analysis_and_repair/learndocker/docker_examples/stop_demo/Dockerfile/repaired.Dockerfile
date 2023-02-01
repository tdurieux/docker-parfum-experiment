FROM alpine:latest

RUN apk update && apk add --no-cache bash
COPY traptest.sh /

CMD ["/traptest.sh"]
