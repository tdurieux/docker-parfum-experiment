FROM alpine:latest
RUN apk add --no-cache --update ca-certificates

ADD ./digitalocean_exporter /usr/bin/digitalocean_exporter

EXPOSE 9212

ENTRYPOINT ["/usr/bin/digitalocean_exporter"]
