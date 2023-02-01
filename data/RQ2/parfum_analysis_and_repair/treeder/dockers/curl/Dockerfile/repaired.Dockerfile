FROM alpine

RUN apk update && apk upgrade
RUN apk add --no-cache curl
RUN rm -rf /var/cache/apk/*

ENTRYPOINT ["curl"]
