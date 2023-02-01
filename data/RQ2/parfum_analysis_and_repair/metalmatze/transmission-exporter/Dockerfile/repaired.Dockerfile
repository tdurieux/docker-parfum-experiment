FROM alpine:latest
RUN apk add --no-cache --update ca-certificates

ADD ./transmission-exporter /usr/bin/transmission-exporter

EXPOSE 19091

ENTRYPOINT ["/usr/bin/transmission-exporter"]
