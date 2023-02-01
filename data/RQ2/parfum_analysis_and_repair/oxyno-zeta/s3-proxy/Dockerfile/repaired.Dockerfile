FROM alpine:3.16

ENV USER=proxy
ENV UID=1000
ENV GID=1000

RUN apk add --no-cache --update ca-certificates && rm -rf /var/cache/apk/* && \
    addgroup -g $GID $USER && \
    adduser -D -g "" -h "/proxy" -G "$USER" "$USER" -H -u "$UID"

WORKDIR /proxy

COPY s3-proxy /proxy/s3-proxy
COPY templates/ /proxy/templates/

RUN chown -R 1000:1000 /proxy

USER proxy

ENTRYPOINT [ "/proxy/s3-proxy" ]
