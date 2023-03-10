FROM alpine
MAINTAINER Frederic Branczyk <fbranczyk@gmail.com>

RUN apk --update --no-cache add bash socat && \
    rm -rf /var/cache/apk/*

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

