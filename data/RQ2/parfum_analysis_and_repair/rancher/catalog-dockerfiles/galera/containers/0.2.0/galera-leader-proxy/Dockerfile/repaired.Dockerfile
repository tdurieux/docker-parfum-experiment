FROM alpine:3.2

RUN apk add --no-cache --update bash socat && rm -rf /var/cache/apk/*
ADD ./run.sh /

entrypoint ["/run.sh"]
