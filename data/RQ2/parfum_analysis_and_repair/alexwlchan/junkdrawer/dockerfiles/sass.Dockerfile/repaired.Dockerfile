FROM alpine

RUN apk add --no-cache --update sassc

VOLUME ["/data"]
WORKDIR /data

ENTRYPOINT ["sassc"]
