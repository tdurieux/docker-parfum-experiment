FROM hypriot/rpi-alpine:3.6
MAINTAINER Nicolas Steinmetz <public+docker@steinmetz.fr>
RUN apk update &&\
    apk upgrade &&\
    apk add ca-certificates &&\
    rm -rf /var/cache/apk/*
ADD https://github.com/containous/traefik/releases/download/v1.4.0-rc2/traefik_linux-arm /traefik
RUN chmod +x /traefik
EXPOSE 80 8080 443
ENTRYPOINT ["/traefik"]
