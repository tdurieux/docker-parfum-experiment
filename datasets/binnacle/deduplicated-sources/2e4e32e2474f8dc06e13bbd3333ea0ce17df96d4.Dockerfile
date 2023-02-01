FROM alpine

LABEL maintainer="Max Schmitt <max@schmitt.mx>"
LABEL readme.md="https://github.com/mxschmitt/golang-url-shortener/blob/master/README.md"
LABEL description="This Dockerfile will install the Golang URL Shortener."

RUN apk update && apk add ca-certificates curl

EXPOSE 8080

COPY docker_releases/golang-url-shortener_linux_arm/golang-url-shortener /

VOLUME ["/data"]

HEALTHCHECK --interval=30s CMD curl -f http://127.0.0.1:8080/api/v1/info || exit 1

CMD ["/golang-url-shortener"]
